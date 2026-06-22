# Runbook — Reconfigurar GitHub Secrets tras reconstruir la infra

> **Para qué es este documento.** Cuando se **reconstruye la infraestructura desde cero**
> (`cdk deploy` sobre una cuenta limpia, o tras destruir y volver a crear stacks), algunos secretos
> **cambian de valor** porque CDK los genera **aleatoriamente** en cada despliegue. Los workflows de
> GitHub Actions que los usan dejan de funcionar (errores 401/403) hasta que se **re-sincronizan** los
> GitHub secrets que apuntan a esos valores. Este runbook explica qué secret va en qué repo, cuáles
> hay que regenerar, cómo obtener cada valor y en qué orden.

---

## 1. Tabla de secrets por repositorio

| Repo (`sward-UPC/...`) | Secret | Origen |
|------------------------|--------|--------|
| **sward-infra** | `AWS_ACCESS_KEY_ID` | Tú lo provees (IAM user CI) |
| | `AWS_SECRET_ACCESS_KEY` | Tú lo provees (IAM user CI) |
| | `AWS_REGION` | Tú lo provees (`us-east-1`) |
| **sward-ms-recomendacion** | `AWS_ACCESS_KEY_ID` | Tú lo provees (IAM user CI) |
| | `AWS_SECRET_ACCESS_KEY` | Tú lo provees (IAM user CI) |
| | `SWARD_API_URL` | **Output de CDK** (CloudFront) — cambia al reconstruir |
| | `TRAZABILIDAD_SERVICE_KEY` | **Secrets Manager** (CDK aleatorio) — cambia al reconstruir |
| **sward-model-training** | `SWARD_API_URL` | **Output de CDK** (CloudFront) — cambia al reconstruir |
| | `TRAZABILIDAD_SERVICE_KEY` | **Secrets Manager** (CDK aleatorio) — cambia al reconstruir |

---

## 2. La distinción clave: lo que TÚ provees vs lo que CDK genera

Esto es lo que hay que entender para no perder tiempo:

### Secrets que **TÚ provees** (estables entre despliegues)
No cambian al reconstruir la infra; los pones una vez y se quedan.
- **AWS IAM keys** (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`) de un **usuario de CI** dedicado.
- **Token de Moodle** (`wstoken`).
- **YouTube API key**.

### Secrets que **CDK genera con valor ALEATORIO** en cada deploy
Se **regeneran** cada vez que se reconstruye la infra → cualquier GitHub secret que los referencie
**queda desactualizado** y hay que re-sincronizarlo:
- `jwt-secret` (firma de los JWT de `ms-usuarios`).
- `service-key/<servicio>` (claves de autorización servicio-a-servicio).
- **passwords de RDS**.

> **Consecuencia práctica:** `SWARD_API_URL` (depende del dominio de CloudFront, que cambia) y
> `TRAZABILIDAD_SERVICE_KEY` (una `service-key` aleatoria) son los **dos** que hay que volver a
> obtener y re-setear en `sward-ms-recomendacion` y `sward-model-training` después de cada
> reconstrucción.

---

## 3. Cómo OBTENER cada valor (comandos exactos)

### 3.1 `SWARD_API_URL` (URL de CloudFront — output de CDK)

```bash
aws cloudformation describe-stacks \
  --stack-name SwardCloudfront \
  --region us-east-1 \
  --query "Stacks[0].Outputs[?OutputKey=='ApiUrl'].OutputValue" \
  --output text
```

### 3.2 `TRAZABILIDAD_SERVICE_KEY` (Secrets Manager)

Es la **service-key de un *caller* que `ms-trazabilidad` autoriza** (no es un secreto "de"
trazabilidad, sino la clave con la que un cliente se identifica ante él). Empieza por la de
`recomendacion`:

```bash
aws secretsmanager get-secret-value \
  --secret-id sward/service-key/recomendacion \
  --region us-east-1 \
  --query SecretString --output text | jq -r .service_key
```

> Si al usarla `ms-trazabilidad` devuelve **403**, probar con la service-key de otro caller que sí
> esté autorizado: `sward/service-key/integracion-lms` o `sward/service-key/usuarios`.

### 3.3 Otros secrets en Secrets Manager (referencia)

| Secret ID | Contenido |
|-----------|-----------|
| `sward/moodle-token` | `wstoken` de la REST API de Moodle |
| `sward/youtube-api-key` | API key de YouTube |
| `sward/jwt-secret` | Secreto de firma de JWT (**aleatorio**, cambia al reconstruir) |
| `sward/admin-seed` | Credenciales del admin inicial |
| `sward/service-key/<servicio>` | Service-keys S2S (**aleatorias**): `recomendacion`, `integracion-lms`, `usuarios`, ... |
| `sward/rds/shared` | Credenciales de la RDS compartida (**aleatorias**) |

Patrón general para leer cualquiera:

```bash
aws secretsmanager get-secret-value \
  --secret-id sward/<lo-que-sea> \
  --region us-east-1 \
  --query SecretString --output text | jq .
```

---

## 4. Setear los GitHub secrets

Para **secretos** (valor sensible, modo interactivo: no queda en el historial del shell):

```bash
gh secret set TRAZABILIDAD_SERVICE_KEY --repo sward-UPC/sward-ms-recomendacion
# (pega el valor cuando lo pida)
```

Para **valores no sensibles** (como una URL), se puede pasar en línea con `--body`:

```bash
gh secret set SWARD_API_URL --repo sward-UPC/sward-ms-recomendacion --body "https://dXXXX.cloudfront.net"
```

> **Recomendación:** para las service-keys y las AWS keys usa siempre el modo interactivo (sin
> `--body`) para que el valor no quede en el historial de la terminal.

---

## 5. Checklist de RECONSTRUCCIÓN

Después de reconstruir la infra desde cero, ejecutar en este orden:

1. **`cdk deploy`** en `sward-infra` (reconstruye todos los stacks; regenera secretos aleatorios).
2. **Re-obtener** los dos valores que cambian:
   - `SWARD_API_URL` → comando de [§3.1](#31-sward_api_url-url-de-cloudfront--output-de-cdk).
   - `TRAZABILIDAD_SERVICE_KEY` → comando de [§3.2](#32-trazabilidad_service_key-secrets-manager).
3. **Re-setear** esos GitHub secrets en los repos que los usan:
   - `sward-UPC/sward-ms-recomendacion` (`SWARD_API_URL`, `TRAZABILIDAD_SERVICE_KEY`).
   - `sward-UPC/sward-model-training` (`SWARD_API_URL`, `TRAZABILIDAD_SERVICE_KEY`).
4. **Verificar**: correr un workflow (p. ej. el de despliegue/entrenamiento) o hacer `curl` al
   `/health` a través de `SWARD_API_URL`:

   ```bash
   curl -fsS "$SWARD_API_URL/health" && echo "OK"
   ```

   Si un workflow falla con **401** revisa `jwt-secret`/keys; si falla con **403** revisa la
   `TRAZABILIDAD_SERVICE_KEY` (probablemente quedó la vieja o el caller no está autorizado).

> Las **AWS IAM keys**, el **token de Moodle** y la **YouTube key** normalmente **no** se tocan en
> una reconstrucción (las provees tú, son estables) — salvo que hayas rotado el usuario de CI.

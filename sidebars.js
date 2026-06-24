// @ts-check
// Navegación de la documentación de SWARD (orden y etiquetas en español).

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  docsSidebar: [
    {
      type: 'doc',
      id: 'index',
      label: 'Inicio',
    },
    {
      type: 'doc',
      id: 'arquitectura',
      label: 'Arquitectura',
    },
    {
      type: 'doc',
      id: 'operaciones',
      label: 'Operaciones',
    },
    {
      type: 'doc',
      id: 'migraciones',
      label: 'Migraciones (Alembic)',
    },
    {
      type: 'doc',
      id: 'secrets-runbook',
      label: 'Secrets',
    },
    {
      type: 'category',
      label: 'Diagramas',
      items: [
        {type: 'doc', id: 'diagramas', label: 'Resumen'},
        {type: 'doc', id: 'diagramas-dkt', label: 'DKT y pyKT'},
      ],
    },
  ],
};

export default sidebars;

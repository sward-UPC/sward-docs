// @ts-check
// Configuración de Docusaurus para la documentación de SWARD.
// Docs: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'SWARD · Documentación',
  tagline:
    'Tutor adaptativo y explicable (SAKT + pyKT) sobre microservicios hexagonales event-driven en AWS.',
  favicon: 'img/favicon.svg',

  // GitHub Pages: https://sward-upc.github.io/sward-docs/
  url: 'https://sward-upc.github.io',
  baseUrl: '/sward-docs/',
  organizationName: 'sward-UPC',
  projectName: 'sward-docs',
  trailingSlash: false,

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'es',
    locales: ['es'],
  },

  // Mermaid embebido en los .md
  markdown: {
    mermaid: true,
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },
  themes: ['@docusaurus/theme-mermaid'],

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: '/', // servir las docs en la raíz del sitio
          sidebarPath: './sidebars.js',
          editUrl: 'https://github.com/sward-UPC/sward-docs/tree/main/',
        },
        blog: false, // no usamos blog
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/social-card.svg',
      colorMode: {
        defaultMode: 'light',
        disableSwitch: false,
        respectPrefersColorScheme: true,
      },
      navbar: {
        title: 'SWARD · Documentación',
        logo: {
          alt: 'SWARD',
          src: 'img/logo.svg',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'docsSidebar',
            position: 'left',
            label: 'Documentación',
          },
          {
            href: 'https://github.com/sward-UPC/sward-docs',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Documentación',
            items: [
              {label: 'Arquitectura', to: '/arquitectura'},
              {label: 'Operaciones', to: '/operaciones'},
              {label: 'Diagramas', to: '/diagramas'},
            ],
          },
          {
            title: 'Proyecto',
            items: [
              {
                label: 'sward-UPC en GitHub',
                href: 'https://github.com/sward-UPC',
              },
              {
                label: 'sward-docs',
                href: 'https://github.com/sward-UPC/sward-docs',
              },
            ],
          },
        ],
        copyright:
          '© SWARD · sward-UPC — Sistema Web de Recomendación Adaptativa y Explicable.',
      },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
        additionalLanguages: ['bash', 'python', 'json', 'yaml', 'docker', 'latex'],
      },
      mermaid: {
        theme: {light: 'neutral', dark: 'dark'},
      },
    }),
};

export default config;

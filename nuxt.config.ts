export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  srcDir: "src/",
  nitro: {
    prerender: {
      autoSubfolderIndex: false,
    },
  },
  css: ["~/assets/css/main.css"],
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  colorMode: {
    classSuffix: "",
  },
  content: {
    documentDriven: true,
    highlight: {
      langs: ["py", "c", "bash"],
      theme: {
        dark: "github-dark",
        default: "github-light",
      },
    },
  },
  modules: ["@nuxt/content", "@nuxt/icon", "@nuxtjs/color-mode", "@nuxt/image"],
});

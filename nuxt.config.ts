export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: false },
  srcDir: "src/",
  nitro: {
    prerender: {
      autoSubfolderIndex: false,
    },
  },
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  css: ["~/assets/css/main.css"],
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

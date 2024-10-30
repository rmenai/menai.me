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
  css: ["~/assets/css/tailwind.css"],
  content: {
    documentDriven: true,
    highlight: {
      langs: ["py", "c", "bash"],
      theme: {
        default: "catppuccin-mocha",
      },
    },
  },
  modules: ["@nuxt/content", "@nuxt/icon"],
});

import type { Config } from "tailwindcss";

import colors from "tailwindcss/colors";
import typography from "@tailwindcss/typography";

export default {
  content: ["./src/components/**/*.{js,vue,ts}", "./src/layouts/**/*.vue", "./src/pages/**/*.vue", "./src/plugins/**/*.{js,ts}", "./src/app.vue", "./src/error.vue"],
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        primary: colors.emerald,
      },
    },
  },
  plugins: [
    typography(),
    require("@catppuccin/tailwindcss")({
      defaultFlavour: "mocha",
    }),
  ],
} satisfies Config;

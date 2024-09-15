<script setup lang="ts">
const { cover } = useAppConfig();
</script>

<template>
  <div class="sm:pt-6 sm:pb-10">
    <Html lang="en" />
    <NuxtLoadingIndicator />
    <AppNavbar />
    <slot />
  </div>
</template>

<style lang="postcss">
body {
  @apply bg-gray-50 text-black dark:bg-gray-900 dark:text-white;
}
</style>

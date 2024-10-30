<script setup lang="ts">
const appConfig = useAppConfig();
</script>

<template>
  <div class="sm:pt-6 sm:pb-10 mocha">
    <Head>
      <Title>{{ appConfig.name }}</Title>
      <Meta
        name="description"
        content="A minimalistic portfolio highlighting my
      projects, skills, and blog posts."
      />

      <Link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96" />
      <Link rel="icon" type="image/svg+xml" href="/favicon.svg" />
      <Link rel="shortcut icon" href="/favicon.ico" />
      <Link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
      <Link rel="manifest" href="/site.webmanifest" />
      <Meta name="apple-mobile-web-app-title" content="menai" />
    </Head>

    <NuxtLoadingIndicator />
    <AppNavbar />
    <NuxtPage />
  </div>
</template>

<style lang="postcss">
body {
  @apply bg-base text-text;
}
</style>

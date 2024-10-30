<script lang="ts" setup>
const { navigation } = useContent();
const appConfig = useAppConfig();
</script>

<template>
  <div class="flex justify-between max-w-2xl px-4 py-4 mx-auto sm:px-8">
    <!-- Navigation -->
    <div class="text-text">
      <NuxtLink v-for="link of navigation" :key="link._path" :to="link._path" active-class="font-bold" class="mr-6">
        {{ link.title }}
      </NuxtLink>
    </div>
    <!-- Social icons & Color Mode -->
    <div class="space-x-3 translate-y-1 transition">
      <a :href="`https://twitter.com/${appConfig.socials?.twitter}`" target="_blank" title="Twitter" class="text-text hover:text-lavender">
        <Icon name="simple-icons:twitter" class="w-5 h-5" />
      </a>
      <a :href="`https://github.com/${appConfig.socials?.github}`" target="_blank" title="GitHub" class="text-text hover:text-lavender">
        <Icon name="simple-icons:github" class="w-5 h-5" />
      </a>
      <a :href="`https://discordapp.com/users/${appConfig.socials?.discord}`" target="_blank" title="Discord" class="text-text hover:text-lavender">
        <Icon name="simple-icons:discord" class="w-5 h-5" />
      </a>
    </div>
  </div>
</template>

<template>
  <div class="max-w-2xl px-4 py-10 m-auto sm:px-8 sm:shadow ring-1 ring-surface0 sm:rounded-lgt" style="background-color: hsl(240, 21%, 16%)">
    <main class="max-w-none prose prose-invert prose-pre:bg-mantle prose-a:font-normal prose-a:no-underline prose-a:border-dashed prose-a:border-b hover:prose-a:border-solid">
      <slot />
    </main>
  </div>
</template>

<style lang="css">
.prose h1,
.prose h2,
.prose h3,
.prose h4,
.prose h5,
.prose h6 {
  color: var(--text-text);
}
</style>

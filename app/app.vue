<script setup lang="ts">
import { VueQueryDevtools } from '@tanstack/vue-query-devtools'

useHead({
  title: 'Cloudflare Nuxt',
  meta: [
    {
      name: 'description',
      content: 'Belajar Cloudflare Nuxt',
    },
  ],
})
</script>

<template>
  <div class="app-layout">
    <NuxtRouteAnnouncer />
    <AppNavbar />
    <main class="app-main">
      <NuxtPage />
    </main>
    <ClientOnly>
      <VueQueryDevtools />
    </ClientOnly>
  </div>
</template>

<style>
:root {
  --primary: #3b82f6;
  --secondary: #2dd4bf;
  --bg: #f8fafc;
  --text: #0f172a;
}

body {
  margin: 0;
  padding: 0;
  background-color: var(--bg);
  color: var(--text);
  font-family:
    'Inter',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    Roboto,
    Oxygen,
    Ubuntu,
    Cantarell,
    'Open Sans',
    'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
}

.app-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-main {
  flex: 1;
}

/* Global utility classes */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1.5rem;
}
</style>

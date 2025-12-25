<template>
  <div class="app-layout">
    <NuxtRouteAnnouncer />
    <NuxtPage />
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
}

.app-layout {
  min-height: 100vh;
}
</style>

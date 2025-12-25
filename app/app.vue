<script setup>
const supabase = useSupabaseClient()
const user = useSupabaseUser()

onMounted(async () => {
  let { data: notes, error } = await supabase.from('notes').select('*')
  console.log(notes, error)
})
</script>

<template>
  <div class="p-8">
    <NuxtRouteAnnouncer />
    <h1 class="text-2xl font-bold">Nuxt + Self-hosted Supabase</h1>
    <div v-if="user" class="mt-4">
      <p>Logged in as: {{ user.email }}</p>
    </div>
    <div v-else class="mt-4">
      <p>Not logged in. Supabase connection: {{ supabase ? 'Ready' : 'Not ready' }}</p>
    </div>
  </div>
</template>

<script setup>
const user = useSupabaseUser()
</script>

<template>
  <div class="container">
    <div class="content">
      <h1 class="title">Welcome to Nuxt + Supabase</h1>
      <div v-if="user" class="status-card">
        <p>
          Logged in as: <span class="email">{{ user.email }}</span>
        </p>
        <button @click="useSupabaseClient().auth.signOut()" class="btn btn-secondary">
          Sign Out
        </button>
      </div>
      <div v-else class="status-card">
        <p>You are not logged in.</p>
        <div class="actions">
          <NuxtLink to="/login" class="btn btn-primary">Login</NuxtLink>
          <NuxtLink to="/signup" class="btn btn-secondary">Sign Up</NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80vh;
  padding: 2rem;
  font-family:
    'Inter',
    system-ui,
    -apple-system,
    sans-serif;
}

.content {
  text-align: center;
  max-width: 500px;
  width: 100%;
}

.title {
  font-size: 2.5rem;
  font-weight: 800;
  margin-bottom: 2rem;
  background: linear-gradient(135deg, #3b82f6 0%, #2dd4bf 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.status-card {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow:
    0 10px 25px -5px rgba(0, 0, 0, 0.1),
    0 8px 10px -6px rgba(0, 0, 0, 0.1);
  border: 1px solid #f3f4f6;
}

.email {
  font-weight: 600;
  color: #3b82f6;
}

.actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-top: 1.5rem;
}

.btn {
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  text-decoration: none;
  font-size: 1rem;
  border: none;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-primary:hover {
  background: #2563eb;
  transform: translateY(-1px);
}

.btn-secondary {
  background: #f3f4f6;
  color: #374151;
}

.btn-secondary:hover {
  background: #e5e7eb;
  transform: translateY(-1px);
}
</style>

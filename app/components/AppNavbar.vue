<script setup>
const user = useSupabaseUser()
const supabase = useSupabaseClient()

const handleLogout = async () => {
  await supabase.auth.signOut()
  await navigateTo('/login')
}
</script>

<template>
  <nav class="navbar">
    <div class="nav-container">
      <NuxtLink to="/" class="nav-brand">NuxtNotes</NuxtLink>

      <div class="nav-links">
        <template v-if="user">
          <NuxtLink to="/notes" class="nav-link">My Notes</NuxtLink>
          <div class="user-info">
            <span class="user-email">{{ user.email }}</span>
            <button @click="handleLogout" class="btn-logout">Logout</button>
          </div>
        </template>
        <template v-else>
          <NuxtLink to="/login" class="nav-link">Login</NuxtLink>
          <NuxtLink to="/signup" class="btn-signup">Get Started</NuxtLink>
        </template>
      </div>
    </div>
  </nav>
</template>

<style scoped>
.navbar {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid #e2e8f0;
  position: sticky;
  top: 0;
  z-index: 50;
  padding: 0.75rem 0;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-brand {
  font-size: 1.5rem;
  font-weight: 800;
  color: #3b82f6;
  text-decoration: none;
  background: linear-gradient(135deg, #3b82f6 0%, #2dd4bf 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.nav-link {
  text-decoration: none;
  color: #475569;
  font-weight: 500;
  transition: color 0.2s;
}

.nav-link:hover {
  color: #3b82f6;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.user-email {
  font-size: 0.875rem;
  color: #64748b;
  font-weight: 500;
}

.btn-logout {
  padding: 0.5rem 1rem;
  border: 1px solid #e2e8f0;
  background: white;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-logout:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
}

.btn-signup {
  padding: 0.5rem 1.25rem;
  background: #3b82f6;
  color: white;
  border-radius: 0.5rem;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.875rem;
  transition: background 0.2s;
}

.btn-signup:hover {
  background: #2563eb;
}
</style>

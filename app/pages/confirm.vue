<script setup>
const user = useSupabaseUser()

watch(
  user,
  () => {
    if (user.value) {
      return navigateTo('/')
    }
  },
  { immediate: true },
)
</script>

<template>
  <div class="confirm-container">
    <div class="confirm-card">
      <div class="spinner"></div>
      <h1>Verifying your account...</h1>
      <p>Please wait a moment while we redirect you.</p>
    </div>
  </div>
</template>

<style scoped>
.confirm-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f8fafc;
}

.confirm-card {
  text-align: center;
  background: white;
  padding: 3rem;
  border-radius: 1.5rem;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f4f6;
  border-top: 4px solid #3b82f6;
  border-radius: 50%;
  margin: 0 auto 1.5rem;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

h1 {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

p {
  color: #64748b;
}
</style>

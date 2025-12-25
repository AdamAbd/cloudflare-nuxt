<script setup>
const supabase = useSupabaseClient()
const email = ref('')
const password = ref('')
const loading = ref(false)
const message = ref('')
const errorMsg = ref('')

const handleSignup = async () => {
  try {
    loading.value = true
    errorMsg.value = ''
    message.value = ''

    const { error } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
      options: {
        emailRedirectTo: `${window.location.origin}/confirm`,
      },
    })

    if (error) throw error

    message.value = 'Check your email for the confirmation link!'
  } catch (error) {
    errorMsg.value = error.message
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="auth-container">
    <div class="auth-card">
      <div class="auth-header">
        <h1 class="auth-title">Create Account</h1>
        <p class="auth-subtitle">Join us today to start your journey</p>
      </div>

      <form @submit.prevent="handleSignup" class="auth-form">
        <div class="form-group">
          <label for="email">Email address</label>
          <input id="email" v-model="email" type="email" placeholder="name@example.com" required />
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <input id="password" v-model="password" type="password" placeholder="••••••••" required />
        </div>

        <div v-if="errorMsg" class="error-message">
          {{ errorMsg }}
        </div>

        <div v-if="message" class="success-message">
          {{ message }}
        </div>

        <button type="submit" :disabled="loading" class="btn btn-primary btn-block">
          {{ loading ? 'Creating Account...' : 'Sign Up' }}
        </button>
      </form>

      <div class="auth-footer">
        <p>Already have an account? <NuxtLink to="/login">Sign in</NuxtLink></p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 1.5rem;
  background: radial-gradient(circle at bottom right, #f0fdfa 0%, #ffffff 50%, #eff6ff 100%);
}

.auth-card {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(12px);
  padding: 2.5rem;
  border-radius: 1.5rem;
  box-shadow:
    0 20px 25px -5px rgba(0, 0, 0, 0.05),
    0 10px 10px -5px rgba(0, 0, 0, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.3);
  max-width: 400px;
  width: 100%;
}

.auth-header {
  text-align: center;
  margin-bottom: 2rem;
}

.auth-title {
  font-size: 1.875rem;
  font-weight: 800;
  color: #111827;
  margin-bottom: 0.5rem;
}

.auth-subtitle {
  color: #6b7280;
  font-size: 0.875rem;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #374151;
}

.form-group input {
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  border: 1px solid #e5e7eb;
  font-size: 1rem;
  transition: all 0.2s;
  background: white;
}

.form-group input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
}

.btn {
  padding: 0.75rem 1.5rem;
  border-radius: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 1rem;
  border: none;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-primary:hover {
  background: #2563eb;
}

.btn-primary:disabled {
  background: #93c5fd;
  cursor: not-allowed;
}

.btn-block {
  width: 100%;
}

.error-message {
  padding: 0.75rem;
  background: #fef2f2;
  color: #dc2626;
  border-radius: 0.75rem;
  font-size: 0.875rem;
  border: 1px solid #fee2e2;
}

.success-message {
  padding: 0.75rem;
  background: #f0fdf4;
  color: #16a34a;
  border-radius: 0.75rem;
  font-size: 0.875rem;
  border: 1px solid #dcfce7;
}

.auth-footer {
  margin-top: 2rem;
  text-align: center;
  font-size: 0.875rem;
  color: #6b7280;
}

.auth-footer a {
  color: #3b82f6;
  text-decoration: none;
  font-weight: 600;
}

.auth-footer a:hover {
  text-decoration: underline;
}
</style>

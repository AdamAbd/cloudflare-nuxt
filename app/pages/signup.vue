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
const handleGoogleLogin = async () => {
  try {
    loading.value = true
    errorMsg.value = ''
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: {
        redirectTo: `${window.location.origin}/confirm`,
      },
    })
    if (error) throw error
    await navigateTo('/confirm')
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

      <div class="auth-divider">
        <span>or continue with</span>
      </div>

      <button
        @click="handleGoogleLogin"
        :disabled="loading"
        class="btn btn-outline btn-block btn-google"
      >
        <svg viewBox="0 0 24 24" class="google-icon">
          <path
            d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
            fill="#4285F4"
          />
          <path
            d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
            fill="#34A853"
          />
          <path
            d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
            fill="#FBBC05"
          />
          <path
            d="M12 5.38c1.62 0 3.06.56 4.21 1.66l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 12-4.53z"
            fill="#EA4335"
          />
        </svg>
        Google
      </button>

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
  min-height: calc(100vh - 3rem - 60px);
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

.auth-divider {
  margin: 1.5rem 0;
  display: flex;
  align-items: center;
  text-align: center;
  color: #9ca3af;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.auth-divider::before,
.auth-divider::after {
  content: '';
  flex: 1;
  border-bottom: 1px solid #e5e7eb;
}

.auth-divider span {
  padding: 0 1rem;
}

.btn-outline {
  background: white;
  border: 1px solid #e5e7eb;
  color: #374151;
}

.btn-outline:hover {
  background: #f9fafb;
  border-color: #d1d5db;
}

.btn-google {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
}

.google-icon {
  width: 1.25rem;
  height: 1.25rem;
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

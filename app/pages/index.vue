<script setup>
const user = useSupabaseUser()
</script>

<template>
  <div class="landing">
    <section class="hero">
      <div class="container hero-content">
        <h1 class="hero-title">Keep your thoughts <span class="gradient-text">organized</span></h1>
        <p class="hero-subtitle">
          A simple, fast, and secure way to manage your personal notes. Built with Nuxt 4 and
          Supabase for a seamless experience.
        </p>
        <div class="hero-actions">
          <NuxtLink v-if="user" to="/notes" class="btn btn-primary">Go to My Notes</NuxtLink>
          <template v-else>
            <NuxtLink to="/signup" class="btn btn-primary">Start Writing Now</NuxtLink>
            <NuxtLink to="/login" class="btn btn-outline">Sign In</NuxtLink>
          </template>
        </div>
      </div>
    </section>

    <section class="features">
      <div class="container grid">
        <div class="feature-card">
          <div class="icon">🚀</div>
          <h3>Lightning Fast</h3>
          <p>Instant synchronization across all your devices using Supabase Realtime.</p>
        </div>
        <div class="feature-card">
          <div class="icon">🔒</div>
          <h3>Secure by Default</h3>
          <p>Your notes are protected by industry-standard Row Level Security.</p>
        </div>
        <div class="feature-card">
          <div class="icon">📱</div>
          <h3>Responsive</h3>
          <p>Write notes comfortably on your phone, tablet, or desktop.</p>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.landing {
  padding-bottom: 5rem;
}

.hero {
  padding: 8rem 0 5rem;
  background: radial-gradient(circle at top right, #eff6ff 0%, #ffffff 40%, #f0fdfa 100%);
  text-align: center;
}

.hero-content {
  max-width: 800px;
}

.hero-title {
  font-size: 4rem;
  font-weight: 900;
  line-height: 1.1;
  color: #0f172a;
  margin-bottom: 1.5rem;
  letter-spacing: -0.02em;
}

.gradient-text {
  background: linear-gradient(135deg, #3b82f6 0%, #2dd4bf 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.hero-subtitle {
  font-size: 1.25rem;
  color: #475569;
  line-height: 1.6;
  margin-bottom: 2.5rem;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.btn {
  padding: 0.875rem 2rem;
  border-radius: 0.75rem;
  font-weight: 700;
  text-decoration: none;
  transition: all 0.2s;
  font-size: 1.125rem;
}

.btn-primary {
  background: #3b82f6;
  color: white;
  box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.3);
}

.btn-primary:hover {
  background: #2563eb;
  transform: translateY(-2px);
}

.btn-outline {
  border: 1px solid #e2e8f0;
  color: #475569;
  background: white;
}

.btn-outline:hover {
  background: #f8fafc;
  border-color: #cbd5e1;
}

.features {
  padding: 5rem 0;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
}

.feature-card {
  background: white;
  padding: 2.5rem;
  border-radius: 1.5rem;
  border: 1px solid #f1f5f9;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
  transition: transform 0.2s;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.feature-card .icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 0.75rem;
}

.feature-card p {
  color: #64748b;
  line-height: 1.5;
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2.75rem;
  }
}
</style>

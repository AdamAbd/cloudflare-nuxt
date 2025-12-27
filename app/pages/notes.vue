<script setup>
import { useQuery, useMutation, useQueryClient } from '@tanstack/vue-query'

const user = useSupabaseUser()
const supabase = useSupabaseClient()
const queryClient = useQueryClient()

// Form state
const isAdding = ref(false)
const newNote = ref({ title: '', content: '' })
const editingNote = ref(null)

// Queries
const {
  data: notes,
  isLoading: loading,
  error: fetchError,
} = useQuery({
  queryKey: ['notes'],
  queryFn: async () => {
    const { data, error } = await supabase
      .from('notes')
      .select('*')
      .order('created_at', { ascending: false })

    if (error) throw error
    return data
  },
})

// Mutations
const addNoteMutation = useMutation({
  mutationFn: async (note) => {
    if (!user.value) throw new Error('You must be logged in to add notes')
    const { data, error } = await supabase.from('notes').insert(note)
    if (error) throw error
    return data
  },
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['notes'] })
    newNote.value = { title: '', content: '' }
    isAdding.value = false
  },
  onError: (error) => {
    alert(error.message)
  },
})

const updateNoteMutation = useMutation({
  mutationFn: async (note) => {
    const { data, error } = await supabase
      .from('notes')
      .update({
        title: note.title,
        content: note.content,
      })
      .eq('id', note.id)
    if (error) throw error
    return data
  },
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['notes'] })
    editingNote.value = null
  },
  onError: (error) => {
    alert(error.message)
  },
})

const deleteNoteMutation = useMutation({
  mutationFn: async (id) => {
    const { error } = await supabase.from('notes').delete().eq('id', id)
    if (error) throw error
  },
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['notes'] })
  },
  onError: (error) => {
    alert(error.message)
  },
})

const addNote = () => {
  if (!newNote.value.title || !newNote.value.content) return
  addNoteMutation.mutate({
    title: newNote.value.title,
    content: newNote.value.content,
  })
}

const updateNote = () => {
  if (!editingNote.value.title || !editingNote.value.content) return
  updateNoteMutation.mutate(editingNote.value)
}

const deleteNote = (id) => {
  if (!confirm('Are you sure you want to delete this note?')) return
  deleteNoteMutation.mutate(id)
}

const isSaving = computed(
  () => addNoteMutation.isPending.value || updateNoteMutation.isPending.value,
)
</script>

<template>
  <div class="container py-12">
    <div class="page-header">
      <h1 class="text-3xl font-bold">My Notes</h1>
      <button @click="isAdding = true" v-if="!isAdding" class="btn btn-primary">+ New Note</button>
    </div>

    <!-- Add/Edit Form -->
    <div v-if="isAdding || editingNote" class="note-form-card mb-8">
      <h2 class="text-xl font-bold mb-4">{{ editingNote ? 'Edit Note' : 'Add New Note' }}</h2>
      <div class="form-group">
        <label>Title</label>
        <input v-model="(editingNote || newNote).title" type="text" placeholder="Note title..." />
      </div>
      <div class="form-group mt-4">
        <label>Content</label>
        <textarea
          v-model="(editingNote || newNote).content"
          rows="4"
          placeholder="Start writing..."
        ></textarea>
      </div>
      <div class="form-actions mt-6">
        <button
          @click="editingNote ? updateNote() : addNote()"
          class="btn btn-primary"
          :disabled="isSaving"
        >
          {{ isSaving ? 'Saving...' : editingNote ? 'Save Changes' : 'Create Note' }}
        </button>
        <button @click="((isAdding = false), (editingNote = null))" class="btn btn-secondary">
          Cancel
        </button>
      </div>
    </div>

    <!-- Error state -->
    <div v-if="fetchError" class="error-alert mb-8">
      Error loading notes: {{ fetchError.message }}
      <button @click="queryClient.invalidateQueries({ queryKey: ['notes'] })" class="btn-text">
        Retry
      </button>
    </div>

    <!-- Notes List -->
    <div v-if="loading && !notes?.length" class="text-center py-12">
      <div class="spinner"></div>
      <p class="mt-4 text-gray-500">Loading your notes...</p>
    </div>

    <div v-else-if="notes?.length" class="notes-grid">
      <div v-for="note in notes" :key="note.id" class="note-card">
        <div class="note-content">
          <h3 class="note-title">{{ note.title }}</h3>
          <p class="note-text">{{ note.content }}</p>
          <span class="note-date">{{ new Date(note.created_at).toLocaleDateString() }}</span>
        </div>
        <div class="note-actions">
          <button @click="editingNote = { ...note }" class="btn-icon">✏️</button>
          <button @click="deleteNote(note.id)" class="btn-icon">🗑️</button>
        </div>
      </div>
    </div>

    <div v-else class="empty-state text-center py-16">
      <div class="empty-icon">📝</div>
      <h3>No notes yet</h3>
      <p>Click the "New Note" button to create your first note.</p>
    </div>
  </div>
</template>

<style scoped>
.py-12 {
  padding-top: 3rem;
  padding-bottom: 3rem;
}
.mb-8 {
  margin-bottom: 2rem;
}
.text-3xl {
  font-size: 1.875rem;
  line-height: 2.25rem;
}
.text-xl {
  font-size: 1.25rem;
  line-height: 1.75rem;
}
.font-bold {
  font-weight: 700;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 3rem;
}

.note-form-card {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  border: 1px solid #e2e8f0;
}

.form-group label {
  display: block;
  font-size: 0.875rem;
  font-weight: 600;
  color: #475569;
  margin-bottom: 0.5rem;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 0.75rem;
  border-radius: 0.5rem;
  border: 1px solid #e2e8f0;
  font-family: inherit;
  font-size: 1rem;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-actions {
  display: flex;
  gap: 1rem;
}

.notes-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.note-card {
  background: white;
  border-radius: 1rem;
  border: 1px solid #e2e8f0;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  transition: all 0.2s;
}

.note-card:hover {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  border-color: #cbd5e1;
}

.note-title {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 0.75rem;
  color: #1e293b;
}

.note-text {
  color: #475569;
  font-size: 0.9375rem;
  line-height: 1.5;
  margin-bottom: 1.25rem;
  white-space: pre-wrap;
}

.note-date {
  font-size: 0.75rem;
  color: #94a3b8;
}

.note-actions {
  display: flex;
  gap: 0.5rem;
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid #f1f5f9;
}

.btn-icon {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-icon:hover {
  background: #e2e8f0;
}

.empty-state {
  color: #64748b;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.btn {
  padding: 0.625rem 1.25rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  border: none;
  font-size: 0.9375rem;
  transition: all 0.2s;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-secondary {
  background: #f1f5f9;
  color: #475569;
}

.error-alert {
  background: #fef2f2;
  border: 1px solid #fee2e2;
  color: #b91c1c;
  padding: 1rem;
  border-radius: 0.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.btn-text {
  background: none;
  border: none;
  color: #3b82f6;
  font-weight: 600;
  cursor: pointer;
  text-decoration: underline;
}

.spinner {
  width: 30px;
  height: 30px;
  border: 3px solid #f3f4f6;
  border-top: 3px solid #3b82f6;
  border-radius: 50%;
  margin: 0 auto;
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
</style>

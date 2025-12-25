-- 1. Buat tabel notes dengan kolom user_id
CREATE TABLE notes (
    -- Menggunakan UUID seringkali lebih disarankan untuk IDs yang bersifat publik
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title text NOT NULL,
    content text NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

-- 3. AKTIFKAN RLS (Sangat Penting!)
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

-- 4. Tambahkan Index pada user_id untuk performa query
CREATE INDEX idx_notes_user_id ON notes(user_id);

-- 5. Buat fungsi untuk mengupdate kolom updated_at otomatis
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 6. Buat Trigger
CREATE TRIGGER update_notes_updated_at
    BEFORE UPDATE ON notes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 7. Definisikan Policies
-- Policy: Publik bisa melihat (Hanya jika Anda ingin isi notes bersifat publik)
CREATE POLICY "Public can read notes"
    ON notes FOR SELECT
    TO anon
    USING (true);

-- Policy: User hanya bisa insert data milik sendiri
CREATE POLICY "Users can insert notes"
    ON notes FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- Policy: User hanya bisa update data milik sendiri
CREATE POLICY "Users can update their own notes"
    ON notes FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Policy: User hanya bisa delete data milik sendiri
CREATE POLICY "Users can delete their own notes"
    ON notes FOR DELETE
    TO authenticated
    USING (auth.uid() = user_id);

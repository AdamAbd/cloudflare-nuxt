-- Resolve "Function Search Path Mutable" security warning
-- See: https://supabase.com/docs/guides/database/database-advisors?query-advisor=security&lint=0002_function_search_path_mutable

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

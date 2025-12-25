-- 1. Create subscription_tiers table (Lookup Table)
-- Ini memungkinkan kita nambah tier tanpa migration di masa depan
CREATE TABLE public.subscription_tiers (
    id text PRIMARY KEY, -- 'free', 'pro', 'enterprise'
    name text NOT NULL,
    description text,
    features jsonb DEFAULT '[]'::jsonb,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- Masukkan data awal tier
INSERT INTO public.subscription_tiers (id, name, description) VALUES
('free', 'Free Tier', 'Basic features for everyone'),
('pro', 'Pro Plan', 'Advanced features for power users'),
('enterprise', 'Enterprise', 'Custom solutions for large teams');

-- 2. Create profiles table
CREATE TABLE public.profiles (
    id uuid REFERENCES auth.users ON DELETE CASCADE NOT NULL PRIMARY KEY,
    username text UNIQUE,
    avatar_url text,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

-- 3. Create subscriptions table
CREATE TABLE public.subscriptions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL UNIQUE,
    tier_id text REFERENCES public.subscription_tiers(id) DEFAULT 'free' NOT NULL,
    status text DEFAULT 'inactive' NOT NULL, -- 'active', 'inactive', 'past_due', dll
    current_period_end timestamptz,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

-- 4. Enable RLS
ALTER TABLE public.subscription_tiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

-- 5. Create Policies
-- Tiers: Siapa saja bisa melihat paket yang tersedia
CREATE POLICY "Subscription tiers are viewable by everyone" ON public.subscription_tiers
    FOR SELECT USING (true);

-- Profiles
CREATE POLICY "Profiles are viewable by everyone" ON public.profiles
    FOR SELECT USING (true);
CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE TO authenticated USING (auth.uid() = id);

-- Subscriptions
CREATE POLICY "Users can view their own subscription" ON public.subscriptions
    FOR SELECT TO authenticated USING (auth.uid() = user_id);

-- 6. Trigger for updated_at
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at
    BEFORE UPDATE ON public.subscriptions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 7. Trigger Logic for Signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
    INSERT INTO public.profiles (id, username, avatar_url)
    VALUES (
        new.id,
        new.raw_user_meta_data->>'username',
        new.raw_user_meta_data->>'avatar_url'
    );

    INSERT INTO public.subscriptions (user_id, tier_id, status)
    VALUES (new.id, 'free', 'active');

    RETURN new;
END;
$$;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

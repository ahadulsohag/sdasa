-- CLEAN SLATE SCRIPT FOR SDASA SUPABASE
-- This script will reset and recreate all tables for a structured inheritance model.

-- 1. DROP EXISTING OBJECTS (Cleanup)
-- Drop triggers and functions first
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS public.reports;
DROP TABLE IF EXISTS public.feedback;
DROP TABLE IF EXISTS public.volunteer_tasks;
DROP TABLE IF EXISTS public.sos_requests;
DROP TABLE IF EXISTS public.shelters;
DROP TABLE IF EXISTS public.alerts;
DROP TABLE IF EXISTS public.authorities;
DROP TABLE IF EXISTS public.volunteers;
DROP TABLE IF EXISTS public.citizens;
DROP TABLE IF EXISTS public.profiles;
DROP TABLE IF EXISTS public.disaster_types;
DROP TABLE IF EXISTS public.locations;

-- 2. SETUP EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 3. CORE UTILITY TABLES
CREATE TABLE public.locations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  address_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.disaster_types (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT
);

-- 4. STRUCTURED USER PROFILE TABLES
-- Base Profile
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT,
  phone_number TEXT,
  address TEXT,
  role TEXT DEFAULT 'citizen' CHECK (role IN ('citizen', 'volunteer', 'authority')),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Citizen specific
CREATE TABLE public.citizens (
  id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Volunteer specific
CREATE TABLE public.volunteers (
  id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
  availability_status BOOLEAN DEFAULT true,
  skills TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Authority specific
CREATE TABLE public.authorities (
  id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
  organization_name TEXT,
  authority_badge_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. FUNCTIONAL TABLES
CREATE TABLE public.alerts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'resolved', 'cancelled')),
  location_id UUID REFERENCES public.locations(id),
  disaster_type_id UUID REFERENCES public.disaster_types(id),
  created_by UUID REFERENCES auth.users(id),
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.shelters (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  capacity INTEGER NOT NULL DEFAULT 0,
  current_occupancy INTEGER NOT NULL DEFAULT 0,
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'full', 'closed')),
  location_id UUID REFERENCES public.locations(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.sos_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  location_id UUID REFERENCES public.locations(id),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'responding', 'resolved', 'cancelled')),
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.volunteer_tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  alert_id UUID REFERENCES public.alerts(id),
  volunteer_id UUID REFERENCES auth.users(id),
  shelter_id UUID REFERENCES public.shelters(id),
  location_id UUID REFERENCES public.locations(id),
  status TEXT DEFAULT 'assigned' CHECK (status IN ('assigned', 'in_progress', 'completed', 'cancelled')),
  assigned_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_time TIMESTAMP WITH TIME ZONE
);

CREATE TABLE public.feedback (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  message TEXT NOT NULL,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type TEXT NOT NULL,
  data JSONB,
  authority_id UUID REFERENCES auth.users(id),
  generated_date TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. SECURITY (RLS)
ALTER TABLE public.locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.disaster_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.citizens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.volunteers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.authorities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shelters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sos_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.volunteer_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

-- 7. BASIC POLICIES (Allow public reading for demo/baseline)
CREATE POLICY "Profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Volunteers viewable by everyone" ON public.volunteers FOR SELECT USING (true);
CREATE POLICY "Authorities viewable by everyone" ON public.authorities FOR SELECT USING (true);
CREATE POLICY "Alerts viewable by everyone" ON public.alerts FOR SELECT USING (true);
CREATE POLICY "Shelters viewable by everyone" ON public.shelters FOR SELECT USING (true);

-- 8. THE CORE TRIGGER FUNCTION
-- This handle both the base profile and the specific role tables.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
DECLARE
  user_role TEXT;
BEGIN
  -- Extract role from metadata, default to citizen
  user_role := COALESCE(new.raw_user_meta_data->>'role', 'citizen');

  -- 1. Create the BASE profile
  INSERT INTO public.profiles (id, full_name, email, phone_number, address, role)
  VALUES (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.email,
    new.raw_user_meta_data->>'phone_number',
    new.raw_user_meta_data->>'address',
    user_role
  );

  -- 2. Create the ROLE-SPECIFIC entry
  IF user_role = 'volunteer' THEN
    INSERT INTO public.volunteers (id, skills) 
    VALUES (new.id, ARRAY(SELECT jsonb_array_elements_text(COALESCE(new.raw_user_meta_data->'skills', '[]'::jsonb))));
  ELSIF user_role = 'authority' THEN
    INSERT INTO public.authorities (id, organization_name) 
    VALUES (new.id, new.raw_user_meta_data->>'organization_name');
  ELSE
    INSERT INTO public.citizens (id) VALUES (new.id);
  END IF;

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 9. ATTACH TRIGGER
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

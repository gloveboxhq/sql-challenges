--------------
---- Utils ---
--------------

-- Constraints
alter table public.policies drop constraint policies_carrier_id_fkey;
alter table public.policies drop constraint policies_user_id_fkey;
alter table public.policies drop constraint policies_type_id_check;

-- Dummy Data
DELETE FROM public.policies;
DELETE FROM public.users;
DELETE FROM public.carriers;
DELETE FROM public.carriers_temp;

-- schema
drop table if exists public.users cascade;
drop table if exists public.policies cascade;
drop table if exists public.carriers cascade;
drop table if exists public.carriers_temp cascade;

--------------
--- Create ---
--------------

--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
	id serial PRIMARY KEY,
	name text NOT NULL,
	created timestamp with time zone,
	updated timestamp with time zone
);

--
-- Name: policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policies (
	id serial PRIMARY KEY,
	user_id int NOT NULL REFERENCES users (id),
	type_id text NOT NULL CHECK(type_id IN ('auto', 'home')),
	policy_number text NOT NULL,
	created timestamp with time zone,
	updated timestamp with time zone
);

--
-- Name: carriers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carriers (
	id text PRIMARY KEY,
	full_name text NOT NULL,
	created timestamp with time zone,
	updated timestamp with time zone
);

--------------
-- Updates ---
--------------

-- Allow for the new "business" policy type to the type_id column

ALTER TABLE public.policies
DROP CONSTRAINT IF EXISTS policies_type_id_check;

ALTER TABLE public.policies
ADD CONSTRAINT policies_type_id_check CHECK(type_id IN ('auto', 'home', 'business'));

-- Change public.carriers(id) data type
--- Step 1: Add a new serial column
ALTER TABLE public.carriers
ADD COLUMN new_id serial;

--- Step 2: Populate the new serial column with unique values *****
UPDATE public.carriers
SET new_id = DEFAULT;

--- Step 3: Create a new temporary table with the new serial column as the primary key
CREATE TABLE public.carriers_temp (
    new_id serial PRIMARY KEY,
    full_name text NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone
);

--- Step 4: Copy data from the original table to the temporary table
INSERT INTO public.carriers_temp (full_name, created, updated)
SELECT full_name, created, updated
FROM public.carriers;

--- Step 5: Rename the new serial column to 'id'
ALTER TABLE public.carriers_temp
RENAME COLUMN new_id TO id;

--- Step 6: Drop the existing foreign key constraint
ALTER TABLE public.policies
DROP CONSTRAINT IF EXISTS policies_carrier_id_fk;

--- Step 7: Drop the original table
DROP TABLE public.carriers;

--- Step 8: Rename the temporary table to the original table name
ALTER TABLE public.carriers_temp
RENAME TO carriers;

-- Add a foreign key reference from the policies table to the carriers table
ALTER TABLE public.policies
ADD COLUMN carrier_id serial REFERENCES public.carriers(id);


--------------
-- Indexes ---
--------------

-- index on  public.policies(user_id)
CREATE INDEX idx_policies_user_id ON public.policies(user_id);

-- index on public.policies(type_id)
CREATE INDEX idx_policies_type_id ON public.policies(type_id);

-- index on public.policies(carrier_id)
CREATE INDEX idx_policies_carrier_id ON public.policies(carrier_id);

--------------
-- Scripts ---
--------------

-- Insert 10 carriers
INSERT INTO public.carriers (full_name, created, updated)
SELECT
    'Carrier ' || generate_series(1, 10) AS full_name,
    NOW() AS created,
    NOW() AS updated
FROM generate_series(1,1);

-- Insert 1k users
INSERT INTO public.users (name, created, updated)
SELECT
    'User ' || generate_series(1, 1000) AS name,
    NOW() AS created,
    NOW() AS updated
FROM generate_series(1, 1);

-- Insert 5k policies with random assignment to users and carriers
INSERT INTO public.policies (user_id, type_id, policy_number, carrier_id, created, updated)
SELECT
    floor(random() * 1000) + 1 AS user_id,
    CASE floor(random() * 3)
        WHEN 0 THEN 'auto'
        WHEN 1 THEN 'home'
        ELSE 'business'
    END AS type_id,
    'Policy ' || generate_series(1, 5000) AS policy_number,
    floor(random() * 10) + 1 AS carrier_id,
    NOW() AS created,
    NOW() AS updated
FROM generate_series(1, 1);

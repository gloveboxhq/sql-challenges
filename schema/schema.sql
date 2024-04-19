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


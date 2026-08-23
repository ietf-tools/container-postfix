BEGIN;

CREATE TABLE IF NOT EXISTS domain (
    mail_host character varying(255),
    created timestamp with time zone DEFAULT now(),
    updated timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS virtual (
    email character varying(255) NOT NULL,
    destination text NOT NULL,
    transport character varying(255) DEFAULT 'relay:'::character varying,
    created timestamp with time zone DEFAULT now(),
    updated timestamp with time zone DEFAULT now(),
    source character varying(50) DEFAULT 'system'::character varying,
    CONSTRAINT virtual_pkey PRIMARY KEY (email)
);

CREATE TABLE IF NOT EXISTS ombudsteam (
    email character varying(255) NOT NULL,
    allowed character varying(255) NOT NULL,
    created timestamp with time zone DEFAULT now(),
    updated timestamp with time zone DEFAULT now(),
    source character varying(50) DEFAULT 'system'::character varying
);

CREATE TABLE IF NOT EXISTS restricted_senders (
    email character varying(255) NOT NULL,
    restriction_class character varying(255) NOT NULL,
    created timestamp with time zone DEFAULT now(),
    updated timestamp with time zone DEFAULT now(),
    source character varying(50) DEFAULT 'system'::character varying
);

CREATE TABLE IF NOT EXISTS spammers (
    email character varying(255) NOT NULL,
    allowed character varying(255) NOT NULL,
    created timestamp with time zone DEFAULT now(),
    updated timestamp with time zone DEFAULT now(),
    source character varying(50) DEFAULT 'system'::character varying
);

CREATE TABLE IF NOT EXISTS smtp_users (
    id serial,
    username character varying(256),
    password character varying(256),
    CONSTRAINT smtp_users_pkey PRIMARY KEY (id)
);

COMMIT;

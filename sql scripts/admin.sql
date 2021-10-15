CREATE TABLE administration.parameters
(
    name character varying COLLATE pg_catalog."default" NOT NULL,
    parent character varying COLLATE pg_catalog."default" DEFAULT ''::character varying,
    value character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    type character varying(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'T'::character varying,
    minval character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    maxval character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    lookupvalues character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    "default" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    explanation character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    sort integer NOT NULL DEFAULT 1,
    checkable "char" NOT NULL DEFAULT ' '::"char",
    CONSTRAINT parameters_pkey PRIMARY KEY (name)
)

TABLESPACE pg_default;

ALTER TABLE administration.parameters
    OWNER to postgres;

CREATE INDEX fki_fk_parameters_parent_parameters_name
    ON administration.parameters USING btree
    (parent COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
--
-- PostgreSQL database cluster dump
--
SET default_transaction_read_only = off;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Extensions
--
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--
-- Tables
--
CREATE TABLE IF NOT EXISTS addresses (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP,
	street VARCHAR(128) NOT NULL,
	postal_code VARCHAR(16) NOT NULL,
	city VARCHAR(128) NOT NULL,
	region VARCHAR(64) NOT NULL,
	country_name VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS place_categories (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP,
	category_name VARCHAR(64) NOT NULL,
	category_key VARCHAR(64) NOT NULL,
	icon_url VARCHAR(256) NOT NULL,

	CONSTRAINT name_key_icon_unique UNIQUE (category_name, category_key, icon_url)
);

CREATE TABLE IF NOT EXISTS places (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP,
	title VARCHAR(128) NOT NULL,
	category_id uuid NOT NULL,
	address_id uuid NOT NULL,
	latitude float4 NOT NULL,
	longitude float4 NOT NULL,
	accessible_by VARCHAR(32),
	archived_at TIMESTAMP,

	CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES place_categories (id),
	CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES addresses (id)
);

CREATE TABLE IF NOT EXISTS users (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP,
	nickname VARCHAR(64) NOT NULL,
	gender VARCHAR(6) NOT NULL,
	email VARCHAR(128) NOT NULL,
	phone_number VARCHAR(64) NOT NULL,
	address_id uuid NOT NULL,
	role VARCHAR(50) NOT NULL,
	external_id VARCHAR(50) NOT NULL,

	CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES addresses (id),
	CONSTRAINT email_phone_unique UNIQUE (email, phone_number)
);

CREATE TABLE IF NOT EXISTS share_places (
	id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP,
	user_id uuid NOT NULL,
	place_id uuid NOT NULL,

	CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users (id),
	CONSTRAINT fk_place FOREIGN KEY (place_id) REFERENCES places (id)
);

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
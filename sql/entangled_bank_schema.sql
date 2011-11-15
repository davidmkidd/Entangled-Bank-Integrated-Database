--
-- PostgreSQL database dump
--

-- Dumped from database version 8.4.7
-- Dumped by pg_dump version 9.0.1
-- Started on 2011-11-15 15:09:37

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 6 (class 2615 OID 42722)
-- Name: biosql; Type: SCHEMA; Schema: -; Owner: entangled_bank_user
--

CREATE SCHEMA biosql;


ALTER SCHEMA biosql OWNER TO entangled_bank_user;

--
-- TOC entry 8 (class 2615 OID 42723)
-- Name: funct; Type: SCHEMA; Schema: -; Owner: entangled_bank_user
--

CREATE SCHEMA funct;


ALTER SCHEMA funct OWNER TO entangled_bank_user;

--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA funct; Type: COMMENT; Schema: -; Owner: entangled_bank_user
--

COMMENT ON SCHEMA funct IS 'Extra functions';


--
-- TOC entry 9 (class 2615 OID 42724)
-- Name: gpdd; Type: SCHEMA; Schema: -; Owner: entangled_bank_user
--

CREATE SCHEMA gpdd;


ALTER SCHEMA gpdd OWNER TO entangled_bank_user;

--
-- TOC entry 10 (class 2615 OID 42725)
-- Name: msw05; Type: SCHEMA; Schema: -; Owner: entangled_bank_user
--

CREATE SCHEMA msw05;


ALTER SCHEMA msw05 OWNER TO entangled_bank_user;

--
-- TOC entry 11 (class 2615 OID 42726)
-- Name: source; Type: SCHEMA; Schema: -; Owner: entangled_bank_user
--

CREATE SCHEMA source;


ALTER SCHEMA source OWNER TO entangled_bank_user;

--
-- TOC entry 12 (class 2615 OID 42727)
-- Name: worldclim; Type: SCHEMA; Schema: -; Owner: entangled_bank_user
--

CREATE SCHEMA worldclim;


ALTER SCHEMA worldclim OWNER TO entangled_bank_user;

--
-- TOC entry 1424 (class 2612 OID 21265)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = biosql, pg_catalog;

--
-- TOC entry 1192 (class 1247 OID 42730)
-- Dependencies: 6 2668
-- Name: int_count; Type: TYPE; Schema: biosql; Owner: entangled_bank_user
--

CREATE TYPE int_count AS (
	f1 integer,
	f2 bigint
);


ALTER TYPE biosql.int_count OWNER TO entangled_bank_user;

--
-- TOC entry 1303 (class 1247 OID 65565)
-- Dependencies: 6 2782
-- Name: pdb_node_children_dist_type; Type: TYPE; Schema: biosql; Owner: entangled_bank_user
--

CREATE TYPE pdb_node_children_dist_type AS (
	node_id integer,
	label text,
	distance numeric
);


ALTER TYPE biosql.pdb_node_children_dist_type OWNER TO entangled_bank_user;

SET search_path = public, pg_catalog;

--
-- TOC entry 1168 (class 0 OID 0)
-- Name: box2d; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE box2d;


--
-- TOC entry 90 (class 1255 OID 21342)
-- Dependencies: 3 1168
-- Name: box2d_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box2d_in(cstring) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_in';


ALTER FUNCTION public.box2d_in(cstring) OWNER TO postgres;

--
-- TOC entry 91 (class 1255 OID 21343)
-- Dependencies: 3 1168
-- Name: box2d_out(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box2d_out(box2d) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_out';


ALTER FUNCTION public.box2d_out(box2d) OWNER TO postgres;

--
-- TOC entry 1167 (class 1247 OID 21319)
-- Dependencies: 3 91 90
-- Name: box2d; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE box2d (
    INTERNALLENGTH = 16,
    INPUT = box2d_in,
    OUTPUT = box2d_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.box2d OWNER TO postgres;

--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 1167
-- Name: TYPE box2d; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE box2d IS 'postgis type: A box composed of x min, ymin, xmax, ymax. Often used to return the 2d enclosing box of a geometry.';


--
-- TOC entry 1162 (class 0 OID 0)
-- Name: box3d; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE box3d;


--
-- TOC entry 65 (class 1255 OID 21311)
-- Dependencies: 3 1162
-- Name: box3d_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3d_in(cstring) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_in';


ALTER FUNCTION public.box3d_in(cstring) OWNER TO postgres;

--
-- TOC entry 66 (class 1255 OID 21312)
-- Dependencies: 3 1162
-- Name: box3d_out(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3d_out(box3d) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_out';


ALTER FUNCTION public.box3d_out(box3d) OWNER TO postgres;

--
-- TOC entry 1161 (class 1247 OID 21308)
-- Dependencies: 3 65 66
-- Name: box3d; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE box3d (
    INTERNALLENGTH = 48,
    INPUT = box3d_in,
    OUTPUT = box3d_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.box3d OWNER TO postgres;

--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 1161
-- Name: TYPE box3d; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE box3d IS 'postgis type: A box composed of x min, ymin, zmin, xmax, ymax, zmax. Often used to return the 3d extent of a geometry or collection of geometries.';


--
-- TOC entry 1165 (class 0 OID 0)
-- Name: box3d_extent; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE box3d_extent;


--
-- TOC entry 67 (class 1255 OID 21315)
-- Dependencies: 3 1165
-- Name: box3d_extent_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3d_extent_in(cstring) RETURNS box3d_extent
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_in';


ALTER FUNCTION public.box3d_extent_in(cstring) OWNER TO postgres;

--
-- TOC entry 68 (class 1255 OID 21316)
-- Dependencies: 3 1165
-- Name: box3d_extent_out(box3d_extent); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3d_extent_out(box3d_extent) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_extent_out';


ALTER FUNCTION public.box3d_extent_out(box3d_extent) OWNER TO postgres;

--
-- TOC entry 1164 (class 1247 OID 21314)
-- Dependencies: 3 67 68
-- Name: box3d_extent; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE box3d_extent (
    INTERNALLENGTH = 48,
    INPUT = box3d_extent_in,
    OUTPUT = box3d_extent_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.box3d_extent OWNER TO postgres;

--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 1164
-- Name: TYPE box3d_extent; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE box3d_extent IS 'postgis type: A box composed of x min, ymin, zmin, xmax, ymax, zmax. Often used to return the extent of a geometry.';


--
-- TOC entry 1170 (class 0 OID 0)
-- Name: chip; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE chip;


--
-- TOC entry 84 (class 1255 OID 21335)
-- Dependencies: 3 1170
-- Name: chip_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION chip_in(cstring) RETURNS chip
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_in';


ALTER FUNCTION public.chip_in(cstring) OWNER TO postgres;

--
-- TOC entry 85 (class 1255 OID 21336)
-- Dependencies: 3 1170
-- Name: chip_out(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION chip_out(chip) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_out';


ALTER FUNCTION public.chip_out(chip) OWNER TO postgres;

--
-- TOC entry 1169 (class 1247 OID 21334)
-- Dependencies: 85 3 84
-- Name: chip; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE chip (
    INTERNALLENGTH = variable,
    INPUT = chip_in,
    OUTPUT = chip_out,
    ALIGNMENT = double,
    STORAGE = extended
);


ALTER TYPE public.chip OWNER TO postgres;

--
-- TOC entry 1185 (class 0 OID 0)
-- Name: geography; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE geography;


--
-- TOC entry 715 (class 1255 OID 22069)
-- Dependencies: 3
-- Name: geography_analyze(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_analyze(internal) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/postgis-1.5', 'geography_analyze';


ALTER FUNCTION public.geography_analyze(internal) OWNER TO postgres;

--
-- TOC entry 713 (class 1255 OID 22067)
-- Dependencies: 3 1185
-- Name: geography_in(cstring, oid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_in(cstring, oid, integer) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_in';


ALTER FUNCTION public.geography_in(cstring, oid, integer) OWNER TO postgres;

--
-- TOC entry 714 (class 1255 OID 22068)
-- Dependencies: 3 1185
-- Name: geography_out(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_out(geography) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_out';


ALTER FUNCTION public.geography_out(geography) OWNER TO postgres;

--
-- TOC entry 711 (class 1255 OID 22064)
-- Dependencies: 3
-- Name: geography_typmod_in(cstring[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_typmod_in(cstring[]) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_typmod_in';


ALTER FUNCTION public.geography_typmod_in(cstring[]) OWNER TO postgres;

--
-- TOC entry 712 (class 1255 OID 22065)
-- Dependencies: 3
-- Name: geography_typmod_out(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_typmod_out(integer) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_typmod_out';


ALTER FUNCTION public.geography_typmod_out(integer) OWNER TO postgres;

--
-- TOC entry 1184 (class 1247 OID 22066)
-- Dependencies: 713 715 712 711 714 3
-- Name: geography; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE geography (
    INTERNALLENGTH = variable,
    INPUT = geography_in,
    OUTPUT = geography_out,
    TYPMOD_IN = geography_typmod_in,
    TYPMOD_OUT = geography_typmod_out,
    ANALYZE = geography_analyze,
    ALIGNMENT = double,
    STORAGE = main
);


ALTER TYPE public.geography OWNER TO postgres;

--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 1184
-- Name: TYPE geography; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE geography IS 'postgis type: Ellipsoidal spatial data type.';


--
-- TOC entry 1158 (class 0 OID 0)
-- Name: geometry; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE geometry;


--
-- TOC entry 36 (class 1255 OID 21280)
-- Dependencies: 3
-- Name: geometry_analyze(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_analyze(internal) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_analyze';


ALTER FUNCTION public.geometry_analyze(internal) OWNER TO postgres;

--
-- TOC entry 34 (class 1255 OID 21278)
-- Dependencies: 3 1158
-- Name: geometry_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_in(cstring) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_in';


ALTER FUNCTION public.geometry_in(cstring) OWNER TO postgres;

--
-- TOC entry 35 (class 1255 OID 21279)
-- Dependencies: 3 1158
-- Name: geometry_out(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_out(geometry) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_out';


ALTER FUNCTION public.geometry_out(geometry) OWNER TO postgres;

--
-- TOC entry 37 (class 1255 OID 21281)
-- Dependencies: 3 1158
-- Name: geometry_recv(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_recv(internal) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_recv';


ALTER FUNCTION public.geometry_recv(internal) OWNER TO postgres;

--
-- TOC entry 38 (class 1255 OID 21282)
-- Dependencies: 3 1158
-- Name: geometry_send(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_send(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_send';


ALTER FUNCTION public.geometry_send(geometry) OWNER TO postgres;

--
-- TOC entry 1157 (class 1247 OID 21272)
-- Dependencies: 34 3 35 37 38 36
-- Name: geometry; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE geometry (
    INTERNALLENGTH = variable,
    INPUT = geometry_in,
    OUTPUT = geometry_out,
    RECEIVE = geometry_recv,
    SEND = geometry_send,
    ANALYZE = geometry_analyze,
    DELIMITER = ':',
    ALIGNMENT = int4,
    STORAGE = main
);


ALTER TYPE public.geometry OWNER TO postgres;

--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 1157
-- Name: TYPE geometry; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE geometry IS 'postgis type: Planar spatial data type.';


--
-- TOC entry 1173 (class 1247 OID 21594)
-- Dependencies: 3 2664
-- Name: geometry_dump; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE geometry_dump AS (
	path integer[],
	geom geometry
);


ALTER TYPE public.geometry_dump OWNER TO postgres;

--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 1173
-- Name: TYPE geometry_dump; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE geometry_dump IS 'postgis type: A spatial datatype with two fields - geom (holding a geometry object) and path[] (a 1-d array holding the position of the geometry within the dumped object.)';


--
-- TOC entry 1188 (class 0 OID 0)
-- Name: gidx; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gidx;


--
-- TOC entry 716 (class 1255 OID 22072)
-- Dependencies: 3 1188
-- Name: gidx_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gidx_in(cstring) RETURNS gidx
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'gidx_in';


ALTER FUNCTION public.gidx_in(cstring) OWNER TO postgres;

--
-- TOC entry 717 (class 1255 OID 22073)
-- Dependencies: 3 1188
-- Name: gidx_out(gidx); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gidx_out(gidx) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'gidx_out';


ALTER FUNCTION public.gidx_out(gidx) OWNER TO postgres;

--
-- TOC entry 1187 (class 1247 OID 22071)
-- Dependencies: 3 716 717
-- Name: gidx; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE gidx (
    INTERNALLENGTH = variable,
    INPUT = gidx_in,
    OUTPUT = gidx_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.gidx OWNER TO postgres;

--
-- TOC entry 1182 (class 0 OID 0)
-- Name: pgis_abs; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE pgis_abs;


--
-- TOC entry 429 (class 1255 OID 21773)
-- Dependencies: 3 1182
-- Name: pgis_abs_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_abs_in(cstring) RETURNS pgis_abs
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'pgis_abs_in';


ALTER FUNCTION public.pgis_abs_in(cstring) OWNER TO postgres;

--
-- TOC entry 430 (class 1255 OID 21774)
-- Dependencies: 3 1182
-- Name: pgis_abs_out(pgis_abs); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_abs_out(pgis_abs) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'pgis_abs_out';


ALTER FUNCTION public.pgis_abs_out(pgis_abs) OWNER TO postgres;

--
-- TOC entry 1181 (class 1247 OID 21772)
-- Dependencies: 429 430 3
-- Name: pgis_abs; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE pgis_abs (
    INTERNALLENGTH = 8,
    INPUT = pgis_abs_in,
    OUTPUT = pgis_abs_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.pgis_abs OWNER TO postgres;

--
-- TOC entry 1154 (class 0 OID 0)
-- Name: spheroid; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE spheroid;


--
-- TOC entry 27 (class 1255 OID 21269)
-- Dependencies: 3 1154
-- Name: spheroid_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION spheroid_in(cstring) RETURNS spheroid
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ellipsoid_in';


ALTER FUNCTION public.spheroid_in(cstring) OWNER TO postgres;

--
-- TOC entry 28 (class 1255 OID 21270)
-- Dependencies: 3 1154
-- Name: spheroid_out(spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION spheroid_out(spheroid) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ellipsoid_out';


ALTER FUNCTION public.spheroid_out(spheroid) OWNER TO postgres;

--
-- TOC entry 1153 (class 1247 OID 21266)
-- Dependencies: 3 27 28
-- Name: spheroid; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE spheroid (
    INTERNALLENGTH = 65,
    INPUT = spheroid_in,
    OUTPUT = spheroid_out,
    ALIGNMENT = double,
    STORAGE = plain
);


ALTER TYPE public.spheroid OWNER TO postgres;

SET search_path = biosql, pg_catalog;

--
-- TOC entry 814 (class 1255 OID 82134)
-- Dependencies: 6 1424
-- Name: _pdb_as_newick_label(integer, integer[], text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION _pdb_as_newick_label(node integer, nodes integer[], nwkstr text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	-- Returns newick string of subtree defined by node

	DECLARE
	d INTEGER;          	-- number of descendants in nodes
	c INTEGER;	  	-- number of descendants for child
	cd INTEGER;           -- number of children with descendant or in array
	l INTEGER;            -- node in nodes?
	str TEXT;
	child INTEGER;
	parent INTEGER;

	BEGIN
		--RAISE NOTICE 'node is %', node;
		SELECT INTO l node_id FROM biosql.node WHERE node_id = ANY(nodes) AND node_id = node;
		--RAISE NOTICE 'node is in nodes? %', l;
		SELECT INTO d COUNT (*) FROM biosql.pdb_node_descendants(node, nodes);
		--RAISE NOTICE 'node has % descendants', d;
		str := nwkstr;

		CASE
			WHEN (l IS NULL AND d = 0) THEN
				BEGIN
				--RAISE NOTICE 'not in nodes, no descendents';
				END;
			WHEN (l IS NOT NULL AND d = 0) THEN
				--RAISE NOTICE 'in nodes, no descendents';
				BEGIN
				IF (substr(str,length(str)) <> '(') THEN
					str := str || ',';
				END IF;
				str := str || '''' || replace(biosql.pdb_node_id_to_label(node),' ','_') || '''';
				END;
			 WHEN (d > 0) THEN
				-- descendants
				BEGIN
				-- number of descendants from child
				cd := 0;
				FOR child IN SELECT biosql.pdb_node_children(node)
				LOOP
					SELECT INTO c COUNT (*) FROM biosql.pdb_node_descendants(child, nodes);
					-- Check if in array
					IF (c = 0) THEN
						SELECT INTO c COUNT(*) FROM biosql.node WHERE node_id = ANY(nodes) AND node_id = child;
					END IF;
					IF c > 0 THEN
						cd := cd + 1;
					END IF;
				END LOOP;

				--RAISE NOTICE 'passdist = %', passdist;

				IF (cd = 1) THEN
					--RAISE NOTICE 'descendents from 1 child only';
					FOR child IN SELECT biosql.pdb_node_children(node)
					LOOP
						str := biosql._pdb_as_newick_label(child::integer, nodes::integer[], str::text);
					END LOOP;
				ELSE
					--RAISE NOTICE 'descendents from > 1 children';
					IF (substr(str,length(str)) <> '(') THEN
						str := str || ',';
					END IF;
					str := str || '(';
					FOR child IN SELECT biosql.pdb_node_children(node)
					LOOP
						str := biosql._pdb_as_newick_label(child::integer, nodes::integer[], str::text);
					END LOOP;
					str := str || ')''' || replace(biosql.pdb_node_id_to_label(node),' ','_') || '''';
				END IF;   
				END;
			  ELSE
		  END CASE;
	RETURN str;
	END;

	$$;


ALTER FUNCTION biosql._pdb_as_newick_label(node integer, nodes integer[], nwkstr text) OWNER TO postgres;

--
-- TOC entry 860 (class 1255 OID 73929)
-- Dependencies: 6 1424
-- Name: _pdb_as_newick_label(integer, integer[], text, numeric, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION _pdb_as_newick_label(node integer, nodes integer[], attrib text, passdist numeric, nwkstr text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	-- Returns newick string of subtree defined by node

	DECLARE
	d INTEGER;          	-- number of descendants in nodes
	c INTEGER;	  	-- number of descendants for child
	cd INTEGER;           -- number of children with descendant or in array
	l INTEGER;            -- node in nodes?
	str TEXT;
	child INTEGER;
	ndist NUMERIC;
	val TEXT;
	parent INTEGER;

	BEGIN
		--RAISE NOTICE 'node is %', node;
		SELECT INTO l node_id FROM biosql.node WHERE node_id = ANY(nodes) AND node_id = node;
		--RAISE NOTICE 'node is in nodes? %', l;
		SELECT INTO d COUNT (*) FROM biosql.pdb_node_descendants(node, nodes);
		--RAISE NOTICE 'node has % descendants', d;
		str := nwkstr;

		CASE
			WHEN (l IS NULL AND d = 0) THEN
				BEGIN
				--RAISE NOTICE 'not in nodes, no descendents';
				END;
			WHEN (l IS NOT NULL AND d = 0) THEN
				--RAISE NOTICE 'in nodes, no descendents';
				BEGIN
				IF (substr(str,length(str)) <> '(') THEN
					str := str || ',';
				END IF;
				val := biosql.pdb_node_qualifier(node, attrib);
				--RAISE NOTICE 'val = %', val;
				ndist :=  val::numeric + passdist;
				--RAISE NOTICE 'ndist = %', ndist;
				str := str || '''' || replace(biosql.pdb_node_id_to_label(node),' ','_') || ''':' || ndist;
				--RETURN str;
				END;
			 WHEN (d > 0) THEN
				-- descendants
				BEGIN
				-- number of descendants from child
				--RAISE NOTICE '% descendents', d;
				cd := 0;
				FOR child IN SELECT biosql.pdb_node_children(node)
				LOOP
					SELECT INTO c COUNT (*) FROM biosql.pdb_node_descendants(child, nodes);
					-- Check if in array
					IF (c = 0) THEN
						SELECT INTO c COUNT(*) FROM biosql.node WHERE node_id = ANY(nodes) AND node_id = child;
					END IF;
					IF c > 0 THEN
						cd := cd + 1;
					END IF;
				END LOOP;

				--RAISE NOTICE 'passdist = %', passdist;

				IF (cd = 1) THEN
					--RAISE NOTICE 'descendents from 1 child only';
					FOR child IN SELECT biosql.pdb_node_children(node)
					LOOP
						val := biosql.pdb_node_qualifier(node, attrib);
						ndist :=  val::numeric + passdist;
						str := biosql._pdb_as_newick_label(child::integer, nodes::integer[], attrib::text, ndist::numeric, str::text);
					END LOOP;
				ELSE
					--RAISE NOTICE 'descendents from > 1 children';
					IF (substr(str,length(str)) <> '(') THEN
						str := str || ',';
					END IF;
					str := str || '(';
					FOR child IN SELECT biosql.pdb_node_children(node)
					LOOP
						str := biosql._pdb_as_newick_label(child::integer, nodes::integer[], attrib::text, 0, str::text);
					END LOOP;
					val := biosql.pdb_node_qualifier(node, attrib);
					ndist :=  val::numeric + passdist;
					str := str || ')''' || replace(biosql.pdb_node_id_to_label(node),' ','_') || ''':' || ndist;
				END IF;   
				END;
			  ELSE
		  END CASE;
	RETURN str;
	END;

	$$;


ALTER FUNCTION biosql._pdb_as_newick_label(node integer, nodes integer[], attrib text, passdist numeric, nwkstr text) OWNER TO postgres;

--
-- TOC entry 808 (class 1255 OID 82133)
-- Dependencies: 1424 6
-- Name: pdb_as_newick_label(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_as_newick_label(tree integer, nodes text[]) RETURNS text
    LANGUAGE plpgsql
    AS $$

	-- Returns newick string of subtree defined by node

	DECLARE
	  i INTEGER;
	  lca INTEGER;
	  str TEXT;
	  child INTEGER;
	  node_ids INTEGER[];


	BEGIN

	    BEGIN
	      -- RAISE NOTICE '!';
	      SELECT INTO node_ids array(SELECT biosql.pdb_node_label_to_id(tree, nodes));
	      -- RAISE NOTICE '!!';
	      lca := biosql.pdb_lca(tree, nodes);
	      --RAISE NOTICE 'lca %', lca;
	      IF array_length(nodes, 1) = 1 THEN
	      	      str := '(';
	      ELSE
		str := '((';
	      END IF;
	      
	      -- loop through children
	      FOR child IN SELECT biosql.pdb_node_children(lca)
	        LOOP
		  str := biosql._pdb_as_newick_label(child::integer, node_ids::integer[], str::text);
	        END LOOP;
	      IF array_length(nodes, 1) > 1 THEN
		str := str || ')';
	      END IF;
	      str := str || '''' || replace(biosql.pdb_node_id_to_label(lca),' ','_') || '''' || ');';
	      RETURN str;
	    END;
	END;

	$$;


ALTER FUNCTION biosql.pdb_as_newick_label(tree integer, nodes text[]) OWNER TO postgres;

--
-- TOC entry 813 (class 1255 OID 82138)
-- Dependencies: 6 1424
-- Name: pdb_as_newick_label(integer, text[], integer, boolean); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_as_newick_label(tree integer, nodes text[], attrib integer, rootdepth boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$

	-- Returns newick string of subtree defined by node

	DECLARE
	  i INTEGER;
	  lca INTEGER;
	  str TEXT;
	  child INTEGER;
	  dist NUMERIC;
	  node_ids INTEGER[];
	  txtattrib TEXT;


	BEGIN

	    BEGIN
	      SELECT INTO node_ids array(SELECT biosql.pdb_node_label_to_id(tree, nodes));
	      lca := biosql.pdb_lca(tree, nodes);
	      txtattrib := biosql.pdb_attrib_id_to_label(attrib);
	      dist := biosql.pdb_node_qualifier(lca, attrib);
	      --RAISE NOTICE 'lca %', lca;
	      IF array_length(nodes, 1) = 1 THEN
	      	      str := '(';
	      ELSE
		str := '((';
	      END IF;
	      
	      -- loop through children
	      FOR child IN SELECT biosql.pdb_node_children(lca)
	        LOOP
		  str := biosql._pdb_as_newick_label(child::integer, node_ids::integer[], txtattrib::text, 0::numeric, str::text);
	        END LOOP;
	      IF array_length(nodes, 1) > 1 THEN
		str := str || ')';
	      END IF;
	      str := str || '''' || replace(biosql.pdb_node_id_to_label(lca),' ','_') || '''';
	      IF rootdepth = true THEN
	          BEGIN
	          str := str || ':' || dist;
	          END;
	      END IF;
	      str := str || ');';
	      RETURN str;
	    END;
	END;

	$$;


ALTER FUNCTION biosql.pdb_as_newick_label(tree integer, nodes text[], attrib integer, rootdepth boolean) OWNER TO postgres;

--
-- TOC entry 842 (class 1255 OID 82135)
-- Dependencies: 6
-- Name: pdb_attrib_id_to_label(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_attrib_id_to_label(integer) RETURNS text
    LANGUAGE sql
    AS $_$

	SELECT t.name FROM biosql.term t WHERE t.term_id = $1;

$_$;


ALTER FUNCTION biosql.pdb_attrib_id_to_label(integer) OWNER TO postgres;

--
-- TOC entry 847 (class 1255 OID 82137)
-- Dependencies: 6
-- Name: pdb_attrib_label_to_id(text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_attrib_label_to_id(text) RETURNS integer
    LANGUAGE sql
    AS $_$

	SELECT t.term_id FROM biosql.term t WHERE t.name = $1;

$_$;


ALTER FUNCTION biosql.pdb_attrib_label_to_id(text) OWNER TO postgres;

--
-- TOC entry 823 (class 1255 OID 73936)
-- Dependencies: 6
-- Name: pdb_labels_in_tree(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: entangled_bank_user
--

CREATE FUNCTION pdb_labels_in_tree(integer, text[]) RETURNS SETOF text
    LANGUAGE sql
    AS $_$
	SELECT n.label
	FROM biosql.node n
	WHERE n.label = ANY($2)
	AND n.tree_id = $1;
$_$;


ALTER FUNCTION biosql.pdb_labels_in_tree(integer, text[]) OWNER TO entangled_bank_user;

--
-- TOC entry 837 (class 1255 OID 42749)
-- Dependencies: 6
-- Name: pdb_lca(integer, integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca(integer, integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	
	SELECT lca.node_id
	FROM biosql.node lca, biosql.node_path pA, biosql.node_path pB
	WHERE pA.parent_node_id = pB.parent_node_id
	AND lca.node_id = pA.parent_node_id
	AND pA.child_node_id = $1
	AND pB.child_node_id = $2
	AND biosql.pdb_node_tree($1) = biosql.pdb_node_tree($2)
	ORDER BY pA.distance
	LIMIT 1;$_$;


ALTER FUNCTION biosql.pdb_lca(integer, integer) OWNER TO postgres;

--
-- TOC entry 827 (class 1255 OID 65583)
-- Dependencies: 6 1424
-- Name: pdb_lca(integer, integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca(tree_id integer, nodes integer[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$

	DECLARE
	min_idx INTEGER;
	max_idx INTEGER;
	lca INTEGER;


	BEGIN
	IF biosql.pdb_node_in_tree(tree_id, nodes) = FALSE THEN
	  RETURN NULL;
	ELSE
	  BEGIN
	  SELECT INTO min_idx MIN(n.left_idx) FROM biosql.node n WHERE n.node_id = ANY(nodes);
	  SELECT INTO max_idx MAX(n.right_idx) FROM biosql.node n WHERE n.node_id = ANY(nodes);

	  SELECT INTO lca n.node_id
	    FROM biosql.node n
	    WHERE n.left_idx <= min_idx
	    AND n.right_idx >= max_idx
	    AND n.tree_id = tree_id
	    ORDER BY n.right_idx - n.left_idx ASC
	    LIMIT 1;

	    RETURN lca;
	  END;
	END IF;
	END;
	
	$$;


ALTER FUNCTION biosql.pdb_lca(tree_id integer, nodes integer[]) OWNER TO postgres;

--
-- TOC entry 845 (class 1255 OID 65586)
-- Dependencies: 1424 6
-- Name: pdb_lca(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca(tree integer, nodes text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$

	DECLARE
	min_idx INTEGER;
	max_idx INTEGER;
	lca INTEGER;

	BEGIN
	SELECT INTO min_idx MIN(n.left_idx) FROM biosql.node n WHERE n.label = ANY(nodes) AND n.tree_id = tree;
	SELECT INTO max_idx MAX(n.right_idx) FROM biosql.node n WHERE n.label = ANY(nodes) AND n.tree_id = tree;

	SELECT INTO lca n.node_id
	FROM biosql.node n
	WHERE n.left_idx <= min_idx
	AND   n.right_idx >= max_idx
	ORDER BY n.right_idx - n.left_idx ASC
	LIMIT 1;

	RETURN lca;
	END;
	$$;


ALTER FUNCTION biosql.pdb_lca(tree integer, nodes text[]) OWNER TO postgres;

--
-- TOC entry 843 (class 1255 OID 65585)
-- Dependencies: 6
-- Name: pdb_lca(integer, text, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca(integer, text, text) RETURNS integer
    LANGUAGE sql
    AS $_$
	-- $1	node A
	-- $2	node B
	-- $3   tree id
	SELECT n.node_id
	FROM biosql.node n, biosql.node_path pA, biosql.node_path pB
	WHERE pA.parent_node_id = pB.parent_node_id
	AND   n.node_id = pA.parent_node_id
	AND   pA.child_node_id IN (SELECT biosql.pdb_label_to_id($1,$2))
	AND   pB.child_node_id IN (SELECT biosql.pdb_label_to_id($1,$3))
	AND   n.tree_id = $1
	ORDER BY pA.distance
	LIMIT 1;
	$_$;


ALTER FUNCTION biosql.pdb_lca(integer, text, text) OWNER TO postgres;

--
-- TOC entry 820 (class 1255 OID 42752)
-- Dependencies: 6
-- Name: pdb_lca_a_exclude_b(integer, integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_a_exclude_b(integer, integer) RETURNS integer
    LANGUAGE sql
    AS $_$

	SELECT dca.node_id
	FROM biosql.node dca, biosql.node_path pA
	WHERE
	     dca.node_id = pA.parent_node_id
	AND  pA.child_node_id = $1
	AND NOT EXISTS (
	       SELECT 1 FROM biosql.node_path pB
	       WHERE pB.parent_node_id = pA.parent_node_id
	       AND   pB.child_node_id = $2
	)
	ORDER BY pA.distance DESC
	LIMIT 1;
	$_$;


ALTER FUNCTION biosql.pdb_lca_a_exclude_b(integer, integer) OWNER TO postgres;

--
-- TOC entry 824 (class 1255 OID 42758)
-- Dependencies: 6
-- Name: pdb_lca_subtree(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT p.child_node_id
	FROM biosql.node_path p
	WHERE p.parent_node_id = $1
	UNION
	SELECT $1
	$_$;


ALTER FUNCTION biosql.pdb_lca_subtree(integer) OWNER TO postgres;

--
-- TOC entry 868 (class 1255 OID 65591)
-- Dependencies: 6 1424
-- Name: pdb_lca_subtree(integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree(nodes integer[]) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$

	DECLARE
		mylca 	INTEGER;
		mynode	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.pdb_lca(nodes);
	
		FOR mynode IN
		
			SELECT p.child_node_id as lca
			FROM biosql.node_path p
			WHERE p.parent_node_id = mylca
			UNION
			SELECT mylca

		LOOP
		RETURN NEXT mynode;
		END LOOP;
	END;
	$$;


ALTER FUNCTION biosql.pdb_lca_subtree(nodes integer[]) OWNER TO postgres;

--
-- TOC entry 869 (class 1255 OID 65592)
-- Dependencies: 6 1424
-- Name: pdb_lca_subtree(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree(tree integer, nodes text[]) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$

	DECLARE
		lca 	INTEGER;
		mynode	INTEGER;

	BEGIN
		lca := biosql.pdb_lca(tree, nodes);
	
		FOR mynode IN
		
			SELECT p.child_node_id as node_id
			FROM biosql.node_path p
			WHERE p.parent_node_id = lca
			UNION
			SELECT biosql.pdb_lca(tree, nodes)

		LOOP
		RETURN NEXT mynode;
		END LOOP;
	END;
	$$;


ALTER FUNCTION biosql.pdb_lca_subtree(tree integer, nodes text[]) OWNER TO postgres;

--
-- TOC entry 834 (class 1255 OID 42767)
-- Dependencies: 6
-- Name: pdb_lca_subtree_edge(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_edge(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	SELECT e.edge_id 
	FROM biosql.node_path p, biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    e.child_node_id = p.child_node_id
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	AND p.parent_node_id = $1
$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_edge(integer) OWNER TO postgres;

--
-- TOC entry 822 (class 1255 OID 42754)
-- Dependencies: 6
-- Name: pdb_lca_subtree_edge(integer, integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_edge(integer, integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	SELECT e.edge_id 
	FROM biosql.node_path p, biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    e.child_node_id = p.child_node_id
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	AND pt.tree_id = ch.tree_id
	AND p.parent_node_id IN (
	      SELECT pA.parent_node_id
	      FROM   biosql.node_path pA, biosql.node_path pB
	      WHERE pA.parent_node_id = pB.parent_node_id
	      AND   pA.child_node_id = $1 
	      AND   pB.child_node_id = $2
	      ORDER BY pA.distance
	      LIMIT 1
	)$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_edge(integer, integer) OWNER TO postgres;

--
-- TOC entry 831 (class 1255 OID 65597)
-- Dependencies: 6
-- Name: pdb_lca_subtree_edge(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_edge(integer, text[]) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	SELECT e.edge_id 
	FROM biosql.node_path p, biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    e.child_node_id = p.child_node_id
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	AND p.parent_node_id = biosql.pdb_lca($1,$2)
	$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_edge(integer, text[]) OWNER TO postgres;

--
-- TOC entry 815 (class 1255 OID 65605)
-- Dependencies: 1424 6
-- Name: pdb_lca_subtree_edge(integer, integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_edge(tree_id integer, nodes integer[]) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$

	DECLARE
		--myedge 		biosql.edge.edge_id%TYPE;
		myedge		INTEGER;
		mylca 		INTEGER;
		lca_left	INTEGER;
		lca_right	INTEGER;

	BEGIN
	  IF biosql.pdb_node_in_tree(tree_id, nodes) = FALSE THEN
		RETURN NEXT NULL;
	  ELSE
		SELECT INTO mylca biosql.pdb_lca(tree_id, nodes);
		SELECT INTO lca_left n.left_idx FROM biosql.node n WHERE n.node_id = mylca;
		SELECT INTO lca_right n.right_idx FROM biosql.node n WHERE n.node_id = mylca;

		FOR myedge IN
		SELECT e.edge_id
		FROM biosql.node_path np, biosql.edge e
		WHERE np.parent_node_id = mylca
		AND np.child_node_id = e.child_node_id
		AND np.child_node_id IN (SELECT n.node_id 
			FROM biosql.node n
			WHERE n.left_idx BETWEEN lca_left AND lca_right)
		LOOP
		RETURN NEXT myedge;
		END LOOP;
	  END IF;
	END
	$$;


ALTER FUNCTION biosql.pdb_lca_subtree_edge(tree_id integer, nodes integer[]) OWNER TO postgres;

--
-- TOC entry 844 (class 1255 OID 65588)
-- Dependencies: 6 1424
-- Name: pdb_lca_subtree_internal(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_internal(integer, text[]) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$

	DECLARE
		mylca 	INTEGER;
		mynodes	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.pdb_lca($1,$2);
	
		FOR mynodes IN
		
			SELECT p.child_node_id
			FROM biosql.node_path p, biosql.node n
			WHERE p.parent_node_id = mylca
			AND n.node_id = p.child_node_id
			AND (n.right_idx - n.left_idx) != 1
			UNION
			SELECT biosql.pdb_lca($1,$2)

		LOOP
		RETURN NEXT mynodes;
		END LOOP;
	END;
	$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_internal(integer, text[]) OWNER TO postgres;

--
-- TOC entry 866 (class 1255 OID 65589)
-- Dependencies: 1424 6
-- Name: pdb_lca_subtree_internal_label(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_internal_label(integer, text[]) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $_$

	DECLARE
		mylca 	INTEGER;
		mylab	TEXT;

	BEGIN
		SELECT INTO mylca biosql.pdb_lca($1,$2);
	
		FOR mylab IN
		
			SELECT n.label
			FROM biosql.node_path p, biosql.node n
			WHERE p.parent_node_id = mylca
			AND n.left_idx <> n.right_idx - 1
			AND n.node_id = p.child_node_id
			

		LOOP
		RETURN NEXT mylab;
		END LOOP;
	END;
	$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_internal_label(integer, text[]) OWNER TO postgres;

--
-- TOC entry 867 (class 1255 OID 65590)
-- Dependencies: 6 1424
-- Name: pdb_lca_subtree_label(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_label(integer, text[]) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $_$

	DECLARE
		mylca 	INTEGER;
		mynode	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.pdb_lca($1,$2);
	
		FOR mynode IN
		
			SELECT p.child_node_id as lca
			FROM biosql.node_path p
			WHERE p.parent_node_id = mylca
			UNION
			SELECT biosql.pdb_lca($1,$2)

		LOOP
		RETURN NEXT biosql.pdb_node_id_to_label(mynode);
		END LOOP;
	END;
	$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_label(integer, text[]) OWNER TO postgres;

--
-- TOC entry 836 (class 1255 OID 65594)
-- Dependencies: 1424 6
-- Name: pdb_lca_subtree_tip(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_tip(integer, text[]) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$

	DECLARE
		mylca 	INTEGER;
		mynodes	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.pdb_lca($1,$2);
	
		FOR mynodes IN
		
			SELECT p.child_node_id
			FROM biosql.node_path p, biosql.node n
			WHERE p.parent_node_id = mylca
			AND (n.right_idx - n.left_idx) = 1
			AND n.node_id = p.child_node_id
			

		LOOP
		RETURN NEXT mynodes;
		END LOOP;
	END;
	$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_tip(integer, text[]) OWNER TO postgres;

--
-- TOC entry 835 (class 1255 OID 65593)
-- Dependencies: 6 1424
-- Name: pdb_lca_subtree_tip_label(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_lca_subtree_tip_label(integer, text[]) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $_$

	DECLARE
		mylca 	INTEGER;
		mylab	TEXT;

	BEGIN
		SELECT INTO mylca biosql.pdb_lca($1,$2);
	
		FOR mylab IN
		
			SELECT n.label
			FROM biosql.node_path p, biosql.node n
			WHERE p.parent_node_id = mylca
			AND (n.right_idx - n.left_idx) = 1
			AND n.node_id = p.child_node_id
			

		LOOP
		RETURN NEXT mylab;
		END LOOP;
	END;
	$_$;


ALTER FUNCTION biosql.pdb_lca_subtree_tip_label(integer, text[]) OWNER TO postgres;

--
-- TOC entry 841 (class 1255 OID 65543)
-- Dependencies: 6
-- Name: pdb_node_children(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_children(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT np.child_node_id
	FROM biosql.node_path np
	WHERE np.parent_node_id = $1
	AND np.distance = 1;
$_$;


ALTER FUNCTION biosql.pdb_node_children(integer) OWNER TO postgres;

--
-- TOC entry 853 (class 1255 OID 42741)
-- Dependencies: 6
-- Name: pdb_node_children(integer, integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_children(integer, integer[]) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT np.child_node_id
	FROM biosql.node_path np
	WHERE np.parent_node_id = $1
	AND np.child_node_id = ANY($2)
	AND np.distance = 1;
$_$;


ALTER FUNCTION biosql.pdb_node_children(integer, integer[]) OWNER TO postgres;

--
-- TOC entry 809 (class 1255 OID 65620)
-- Dependencies: 1303 6
-- Name: pdb_node_children_dist(integer, text, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_children_dist(integer, text, text) RETURNS SETOF pdb_node_children_dist_type
    LANGUAGE sql
    AS $_$

	  SELECT e.child_node_id, nc.label, eq.value::numeric
	  FROM biosql.node np,
	  biosql.node nc,
	  biosql.edge e,
	  biosql.edge_qualifier_value eq,
	  biosql.term t
	  WHERE eq.term_id = t.term_id
	  AND e.edge_id = eq.edge_id
	  AND e.parent_node_id = np.node_id
	  AND e.child_node_id = nc.node_id
	  AND t.name = $3
	  AND e.parent_node_id = biosql.pdb_node_label_to_id($1, $2)

	
$_$;


ALTER FUNCTION biosql.pdb_node_children_dist(integer, text, text) OWNER TO postgres;

--
-- TOC entry 863 (class 1255 OID 73904)
-- Dependencies: 6
-- Name: pdb_node_descendants(integer, integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_descendants(integer, integer[]) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT np.child_node_id
	FROM biosql.node_path np
	WHERE np.parent_node_id = $1
	AND np.child_node_id = ANY($2);
$_$;


ALTER FUNCTION biosql.pdb_node_descendants(integer, integer[]) OWNER TO postgres;

--
-- TOC entry 811 (class 1255 OID 42745)
-- Dependencies: 6
-- Name: pdb_node_id_to_label(integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_id_to_label(integer[]) RETURNS SETOF text
    LANGUAGE sql
    AS $_$
	--$1 node id
	SELECT n.label
	FROM biosql.node n
	WHERE n.node_id = ANY($1)
	ORDER BY n.node_id;
$_$;


ALTER FUNCTION biosql.pdb_node_id_to_label(integer[]) OWNER TO postgres;

--
-- TOC entry 652 (class 1255 OID 65544)
-- Dependencies: 6
-- Name: pdb_node_id_to_label(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_id_to_label(integer) RETURNS text
    LANGUAGE sql
    AS $_$
	
	SELECT n.label
	FROM biosql.node n
	WHERE n.node_id = $1
	ORDER BY n.node_id
	LIMIT 1;
$_$;


ALTER FUNCTION biosql.pdb_node_id_to_label(integer) OWNER TO postgres;

--
-- TOC entry 816 (class 1255 OID 65600)
-- Dependencies: 6
-- Name: pdb_node_in_tree(integer, integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_in_tree(integer, integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
	SELECT
	CAST((CASE WHEN COUNT(n.node_id) = 0 THEN FALSE ELSE TRUE END) AS BOOLEAN) AS IsTip
	FROM biosql.node n
	WHERE n.node_id = $2
	AND n.tree_id = $1;
$_$;


ALTER FUNCTION biosql.pdb_node_in_tree(integer, integer) OWNER TO postgres;

--
-- TOC entry 818 (class 1255 OID 65603)
-- Dependencies: 6
-- Name: pdb_node_in_tree(integer, integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_in_tree(integer, integer[]) RETURNS boolean
    LANGUAGE sql
    AS $_$
	SELECT
	CAST((CASE WHEN COUNT(n.node_id) <> array_upper($2, 1) THEN FALSE ELSE TRUE END) AS BOOLEAN) AS IsTip
	FROM biosql.node n
	WHERE n.node_id = ANY($2)
	AND n.tree_id = $1;
$_$;


ALTER FUNCTION biosql.pdb_node_in_tree(integer, integer[]) OWNER TO postgres;

--
-- TOC entry 840 (class 1255 OID 42769)
-- Dependencies: 6
-- Name: pdb_node_istip(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_istip(integer) RETURNS boolean
    LANGUAGE sql
    AS $_$


	SELECT
	CAST((CASE WHEN n.node_id IS NULL THEN FALSE ELSE TRUE END) AS BOOLEAN) AS IsTip
	FROM biosql.node n
	WHERE n.node_id = $1
	AND n.left_idx = (n.right_idx - 1)
	;
$_$;


ALTER FUNCTION biosql.pdb_node_istip(integer) OWNER TO postgres;

--
-- TOC entry 833 (class 1255 OID 65598)
-- Dependencies: 6
-- Name: pdb_node_istip(integer, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_istip(integer, text) RETURNS boolean
    LANGUAGE sql
    AS $_$

	SELECT
	CAST((CASE WHEN n.node_id IS NULL THEN FALSE ELSE TRUE END) AS BOOLEAN) AS IsTip
	FROM biosql.node n
	WHERE n.label = $2
	AND n.tree_id = $1
	AND n.left_idx = (n.right_idx - 1)
	;
$_$;


ALTER FUNCTION biosql.pdb_node_istip(integer, text) OWNER TO postgres;

--
-- TOC entry 819 (class 1255 OID 65581)
-- Dependencies: 6
-- Name: pdb_node_label_to_id(integer, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_label_to_id(integer, text) RETURNS integer
    LANGUAGE sql
    AS $_$
	--$1 node label
	--$2 tree id	
	SELECT n.node_id
	FROM biosql.node n
	WHERE n.label = $2
	AND   n.tree_id = $1
	ORDER BY n.node_id
	LIMIT 1;
$_$;


ALTER FUNCTION biosql.pdb_node_label_to_id(integer, text) OWNER TO postgres;

--
-- TOC entry 821 (class 1255 OID 65582)
-- Dependencies: 6
-- Name: pdb_node_label_to_id(integer, text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_label_to_id(integer, text[]) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	--$1 node label
	--$2 tree id	
	SELECT n.node_id
	FROM biosql.node n
	WHERE n.label = ANY($2)
	AND   n.tree_id = $1
	ORDER BY n.node_id;
$_$;


ALTER FUNCTION biosql.pdb_node_label_to_id(integer, text[]) OWNER TO postgres;

--
-- TOC entry 855 (class 1255 OID 65578)
-- Dependencies: 6
-- Name: pdb_node_qualifier(integer, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_qualifier(integer, text) RETURNS text
    LANGUAGE sql
    AS $_$

	SELECT eq.value
	FROM biosql.node np,
	biosql.node nc,
	biosql.edge e,
	biosql.edge_qualifier_value eq,
	biosql.term t
	WHERE eq.term_id = t.term_id
	AND e.edge_id = eq.edge_id
	AND e.parent_node_id = np.node_id
	AND e.child_node_id = nc.node_id
	AND e.child_node_id = $1
	AND t.name = $2
	LIMIT 1;
	
$_$;


ALTER FUNCTION biosql.pdb_node_qualifier(integer, text) OWNER TO postgres;

--
-- TOC entry 862 (class 1255 OID 65687)
-- Dependencies: 6
-- Name: pdb_node_qualifier(integer, integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_qualifier(integer, integer) RETURNS text
    LANGUAGE sql
    AS $_$

	SELECT eq.value
	FROM biosql.node np,
	biosql.node nc,
	biosql.edge e,
	biosql.edge_qualifier_value eq,
	biosql.term t
	WHERE eq.term_id = t.term_id
	AND e.edge_id = eq.edge_id
	AND e.parent_node_id = np.node_id
	AND e.child_node_id = nc.node_id
	AND e.child_node_id = $1
	AND t.term_id = $2
	LIMIT 1;
	
$_$;


ALTER FUNCTION biosql.pdb_node_qualifier(integer, integer) OWNER TO postgres;

--
-- TOC entry 817 (class 1255 OID 65601)
-- Dependencies: 6
-- Name: pdb_node_tree(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_node_tree(integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	SELECT tree_id 
	FROM biosql.node n 
	WHERE n.node_id = $1

$_$;


ALTER FUNCTION biosql.pdb_node_tree(integer) OWNER TO postgres;

--
-- TOC entry 864 (class 1255 OID 73890)
-- Dependencies: 6
-- Name: pdb_nodes_in_n_trees(integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_nodes_in_n_trees(integer[]) RETURNS bigint
    LANGUAGE sql STABLE
    AS $_$
	
	SELECT COUNT(*) FROM 
	  (SELECT DISTINCT n.tree_id
	  FROM biosql.node n
	  WHERE n.node_id = ANY($1)) AS foo;
$_$;


ALTER FUNCTION biosql.pdb_nodes_in_n_trees(integer[]) OWNER TO postgres;

--
-- TOC entry 861 (class 1255 OID 73931)
-- Dependencies: 6
-- Name: pdb_nodes_in_tree(integer, integer[]); Type: FUNCTION; Schema: biosql; Owner: entangled_bank_user
--

CREATE FUNCTION pdb_nodes_in_tree(integer, integer[]) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	SELECT n.node_id
	FROM biosql.node n
	WHERE n.node_id = ANY($2)
	AND n.tree_id = $1;
$_$;


ALTER FUNCTION biosql.pdb_nodes_in_tree(integer, integer[]) OWNER TO entangled_bank_user;

--
-- TOC entry 846 (class 1255 OID 73883)
-- Dependencies: 6
-- Name: pdb_nodes_in_trees(integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_nodes_in_trees(integer[]) RETURNS SETOF integer
    LANGUAGE sql STABLE
    AS $_$
	
	SELECT DISTINCT n.tree_id
	FROM biosql.node n
	WHERE n.node_id = ANY($1);
$_$;


ALTER FUNCTION biosql.pdb_nodes_in_trees(integer[]) OWNER TO postgres;

--
-- TOC entry 865 (class 1255 OID 73934)
-- Dependencies: 6
-- Name: pdb_nodes_istip(integer[]); Type: FUNCTION; Schema: biosql; Owner: entangled_bank_user
--

CREATE FUNCTION pdb_nodes_istip(integer[]) RETURNS SETOF boolean
    LANGUAGE sql
    AS $_$
	SELECT
	CAST((CASE WHEN n.node_id IS NULL THEN FALSE ELSE TRUE END) AS BOOLEAN) AS IsTip
	FROM biosql.node n
	WHERE n.node_id = ANY($1)
	AND n.left_idx = (n.right_idx - 1)
	;
$_$;


ALTER FUNCTION biosql.pdb_nodes_istip(integer[]) OWNER TO entangled_bank_user;

--
-- TOC entry 828 (class 1255 OID 65595)
-- Dependencies: 6
-- Name: pdb_num_childern(integer, text, integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_num_childern(integer, text, integer[]) RETURNS bigint
    LANGUAGE sql
    AS $_$
	
	SELECT COUNT(*)
	FROM biosql.node_path np, biosql.node n
	WHERE np.parent_node_id = n.node_id
	AND n.label = $2
	AND np.child_node_id = ANY($3)
	AND np.distance = 1
	AND n.tree_id = $1;
$_$;


ALTER FUNCTION biosql.pdb_num_childern(integer, text, integer[]) OWNER TO postgres;

--
-- TOC entry 829 (class 1255 OID 65596)
-- Dependencies: 6
-- Name: pdb_num_children(integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_num_children(integer[]) RETURNS SETOF record
    LANGUAGE sql
    AS $_$
	
	SELECT n.node_id, COUNT(e.child_node_id)
	FROM biosql.node n, biosql.edge e
	WHERE n.node_id = e.parent_node_id
	AND e.child_node_id = ANY($1)
	GROUP BY n.node_id;
$_$;


ALTER FUNCTION biosql.pdb_num_children(integer[]) OWNER TO postgres;

--
-- TOC entry 832 (class 1255 OID 42765)
-- Dependencies: 6
-- Name: pdb_num_children(integer, integer[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_num_children(integer, integer[]) RETURNS bigint
    LANGUAGE sql
    AS $_$
	
	SELECT COUNT(*)
	FROM biosql.node_path np
	WHERE np.parent_node_id = $1
	AND np.child_node_id = ANY($2)
	AND np.distance = 1;
$_$;


ALTER FUNCTION biosql.pdb_num_children(integer, integer[]) OWNER TO postgres;

--
-- TOC entry 830 (class 1255 OID 42763)
-- Dependencies: 6
-- Name: pdb_subtree_ab_exclude_c(integer, integer, integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_subtree_ab_exclude_c(integer, integer, integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	SELECT e.edge_id 
	FROM biosql.node_path p, biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    e.child_node_id = p.child_node_id
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	AND p.parent_node_id IN (
	      SELECT pA.parent_node_id
	      FROM   biosql.node_path pA, biosql.node_path pB
	      WHERE pA.parent_node_id = pB.parent_node_id
	      AND   pA.child_node_id = $1 
	      AND   pB.child_node_id = $2
	)
	AND NOT EXISTS (
	    SELECT 1 FROM biosql.node_path np
	    WHERE 
		np.child_node_id  = $3
	    AND np.parent_node_id = p.parent_node_id
	)
	$_$;


ALTER FUNCTION biosql.pdb_subtree_ab_exclude_c(integer, integer, integer) OWNER TO postgres;

--
-- TOC entry 839 (class 1255 OID 42779)
-- Dependencies: 6
-- Name: pdb_tree_ab_exclude_c(text, text, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_tree_ab_exclude_c(text, text, text) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	SELECT DISTINCT t.tree_id
	FROM biosql.tree t, biosql.node_path p, biosql.node lca
	WHERE
	    p.parent_node_id = lca.node_id
	AND lca.tree_id = t.tree_id
	AND lca.node_id = (
	      SELECT pA.parent_node_id
	      FROM   biosql.node_path pA, biosql.node_path pB, biosql.node A, biosql.node B
	      WHERE pA.parent_node_id = pB.parent_node_id
	      AND   pA.child_node_id = A.node_id
	      AND   pB.child_node_id = B.node_id
	      AND   A.label = $1
	      AND   B.label = $2
	      AND   A.tree_id = t.tree_id
	      AND   B.tree_id = t.tree_id
	      ORDER BY pA.distance
	      LIMIT 1
	)
	AND NOT EXISTS (
	    SELECT 1 FROM biosql.node C, biosql.node_path np
	    WHERE 
		np.child_node_id = C.node_id
	    AND np.parent_node_id = p.parent_node_id
	    AND C.label = $3
	);$_$;


ALTER FUNCTION biosql.pdb_tree_ab_exclude_c(text, text, text) OWNER TO postgres;

--
-- TOC entry 838 (class 1255 OID 42773)
-- Dependencies: 6
-- Name: pdb_tree_ab_include_c(text, text, text); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_tree_ab_include_c(text, text, text) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	SELECT t.tree_id
	FROM biosql.tree t, biosql.node_path p, biosql.node C
	WHERE
	    p.child_node_id = C.node_id
	AND C.tree_id = t.tree_id
	AND p.parent_node_id = (
	      SELECT pA.parent_node_id
	      FROM   biosql.node_path pA, biosql.node_path pB, biosql.node A, biosql.node B
	      WHERE pA.parent_node_id = pB.parent_node_id
	      AND   pA.child_node_id = A.node_id
	      AND   pB.child_node_id = B.node_id
	      AND   A.label = $1
	      AND   B.label = $2
	      AND   A.tree_id = t.tree_id
	      AND   B.tree_id = t.tree_id
	      ORDER BY pA.distance
	      LIMIT 1
	)
	AND C.label = $3
	;$_$;


ALTER FUNCTION biosql.pdb_tree_ab_include_c(text, text, text) OWNER TO postgres;

--
-- TOC entry 812 (class 1255 OID 42742)
-- Dependencies: 6 1424
-- Name: pdb_tree_delete(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_tree_delete(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

	BEGIN

	DELETE
	FROM biosql.edge_qualifier_value eq
	WHERE eq.edge_id
	IN (
	SELECT biosql.tree_edges($1)
	);

	DELETE
	FROM biosql.edge e
	WHERE e.edge_id
	IN (
	SELECT biosql.tree_edges($1)
	);

	DELETE
	FROM biosql.node_qualifier_value nq
	WHERE nq.node_id
	IN (
	SELECT n.node_id
	FROM biosql.node n
	WHERE n.tree_id = $1
	);

	DELETE
	FROM node_path np
	WHERE np.child_node_id
	IN (
	SELECT n.node_id
	FROM biosql.node n
	WHERE n.tree_id = $1
	UNION
	SELECT t.node_id
	FROM biosql.tree t
	WHERE t.tree_id = $1	
	);
	
	DELETE FROM biosql.node WHERE tree_id = $1;

	DELETE FROM biosql.tree WHERE tree_id = $1;

	END;
	
$_$;


ALTER FUNCTION biosql.pdb_tree_delete(integer) OWNER TO postgres;

--
-- TOC entry 825 (class 1255 OID 42777)
-- Dependencies: 6
-- Name: pdb_tree_edge(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_tree_edge(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT e.edge_id 
	FROM biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    pt.tree_id = $1
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	
	$_$;


ALTER FUNCTION biosql.pdb_tree_edge(integer) OWNER TO postgres;

--
-- TOC entry 810 (class 1255 OID 42743)
-- Dependencies: 6
-- Name: pdb_tree_edge_qualifier(integer); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_tree_edge_qualifier(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT DISTINCT t.term_id
	FROM biosql.term t, biosql.node n, biosql.edge e, biosql.edge_qualifier_value eq
	WHERE eq.term_id = t.term_id
	AND e.edge_id = eq.edge_id
	AND (e.parent_node_id = n.node_id
	OR e.child_node_id = n.node_id)
	AND n.tree_id = $1;
$_$;


ALTER FUNCTION biosql.pdb_tree_edge_qualifier(integer) OWNER TO postgres;

--
-- TOC entry 826 (class 1255 OID 42778)
-- Dependencies: 6 1424
-- Name: pdb_tree_include_label(text[]); Type: FUNCTION; Schema: biosql; Owner: postgres
--

CREATE FUNCTION pdb_tree_include_label(text[]) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$

	DECLARE
		trees	INTEGER;
	BEGIN
		FOR trees in 
		SELECT t.tree_id
		FROM biosql.tree t, biosql.node q
		WHERE q.label = ANY($1) 
		AND q.tree_id = t.tree_id
		GROUP BY t.tree_id
		LOOP
		RETURN NEXT trees;
		END LOOP;
	END;

$_$;


ALTER FUNCTION biosql.pdb_tree_include_label(text[]) OWNER TO postgres;

--
-- TOC entry 859 (class 1255 OID 65692)
-- Dependencies: 6
-- Name: pdb_tree_type(integer); Type: FUNCTION; Schema: biosql; Owner: entangled_bank_user
--

CREATE FUNCTION pdb_tree_type(integer) RETURNS text
    LANGUAGE sql
    AS $_$
	
	SELECT tm.name
	FROM biosql.tree_qualifier_value trqv, biosql.term tm
	WHERE 
	    trqv.tree_id = $1
	AND trqv.term_id = tm.term_id
	
	$_$;


ALTER FUNCTION biosql.pdb_tree_type(integer) OWNER TO entangled_bank_user;

SET search_path = funct, pg_catalog;

--
-- TOC entry 848 (class 1255 OID 42780)
-- Dependencies: 8
-- Name: _final_lowerquartile(numeric[]); Type: FUNCTION; Schema: funct; Owner: entangled_bank_user
--

CREATE FUNCTION _final_lowerquartile(numeric[]) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM funct.unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) * 1/4) - 1
   ) sub;
$_$;


ALTER FUNCTION funct._final_lowerquartile(numeric[]) OWNER TO entangled_bank_user;

--
-- TOC entry 849 (class 1255 OID 42781)
-- Dependencies: 8
-- Name: _final_lowervigintile(numeric[]); Type: FUNCTION; Schema: funct; Owner: entangled_bank_user
--

CREATE FUNCTION _final_lowervigintile(numeric[]) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM funct.unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) * 1/20) - 1
   ) sub;
$_$;


ALTER FUNCTION funct._final_lowervigintile(numeric[]) OWNER TO entangled_bank_user;

--
-- TOC entry 850 (class 1255 OID 42782)
-- Dependencies: 8
-- Name: _final_median(numeric[]); Type: FUNCTION; Schema: funct; Owner: entangled_bank_user
--

CREATE FUNCTION _final_median(numeric[]) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM funct.unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$_$;


ALTER FUNCTION funct._final_median(numeric[]) OWNER TO entangled_bank_user;

--
-- TOC entry 851 (class 1255 OID 42783)
-- Dependencies: 8
-- Name: _final_upperquartile(numeric[]); Type: FUNCTION; Schema: funct; Owner: entangled_bank_user
--

CREATE FUNCTION _final_upperquartile(numeric[]) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM funct.unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) * 3/4) - 1
   ) sub;
$_$;


ALTER FUNCTION funct._final_upperquartile(numeric[]) OWNER TO entangled_bank_user;

--
-- TOC entry 852 (class 1255 OID 42784)
-- Dependencies: 8
-- Name: _final_uppervigintile(numeric[]); Type: FUNCTION; Schema: funct; Owner: entangled_bank_user
--

CREATE FUNCTION _final_uppervigintile(numeric[]) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM funct.unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) * 19/20) - 1
   ) sub;
$_$;


ALTER FUNCTION funct._final_uppervigintile(numeric[]) OWNER TO entangled_bank_user;

--
-- TOC entry 854 (class 1255 OID 42785)
-- Dependencies: 8
-- Name: unnest(anyarray); Type: FUNCTION; Schema: funct; Owner: entangled_bank_user
--

CREATE FUNCTION unnest(anyarray) RETURNS SETOF anyelement
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT $1[i] FROM
    generate_series(array_lower($1,1),
                    array_upper($1,1)) i;
$_$;


ALTER FUNCTION funct.unnest(anyarray) OWNER TO entangled_bank_user;

SET search_path = public, pg_catalog;

--
-- TOC entry 511 (class 1255 OID 21865)
-- Dependencies: 3 1157
-- Name: _st_asgeojson(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_asgeojson(integer, geometry, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asGeoJson';


ALTER FUNCTION public._st_asgeojson(integer, geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 765 (class 1255 OID 22154)
-- Dependencies: 1184 3
-- Name: _st_asgeojson(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_asgeojson(integer, geography, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_geojson';


ALTER FUNCTION public._st_asgeojson(integer, geography, integer, integer) OWNER TO postgres;

--
-- TOC entry 494 (class 1255 OID 21848)
-- Dependencies: 3 1157
-- Name: _st_asgml(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_asgml(integer, geometry, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asGML';


ALTER FUNCTION public._st_asgml(integer, geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 751 (class 1255 OID 22140)
-- Dependencies: 3 1184
-- Name: _st_asgml(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_asgml(integer, geography, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_gml';


ALTER FUNCTION public._st_asgml(integer, geography, integer, integer) OWNER TO postgres;

--
-- TOC entry 503 (class 1255 OID 21857)
-- Dependencies: 3 1157
-- Name: _st_askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_askml(integer, geometry, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asKML';


ALTER FUNCTION public._st_askml(integer, geometry, integer) OWNER TO postgres;

--
-- TOC entry 759 (class 1255 OID 22148)
-- Dependencies: 3 1184
-- Name: _st_askml(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_askml(integer, geography, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_kml';


ALTER FUNCTION public._st_askml(integer, geography, integer) OWNER TO postgres;

--
-- TOC entry 797 (class 1255 OID 22186)
-- Dependencies: 1184 3
-- Name: _st_bestsrid(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_bestsrid(geography) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_BestSRID($1,$1)$_$;


ALTER FUNCTION public._st_bestsrid(geography) OWNER TO postgres;

--
-- TOC entry 796 (class 1255 OID 22185)
-- Dependencies: 1184 1184 3
-- Name: _st_bestsrid(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_bestsrid(geography, geography) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_bestsrid';


ALTER FUNCTION public._st_bestsrid(geography, geography) OWNER TO postgres;

--
-- TOC entry 403 (class 1255 OID 21742)
-- Dependencies: 3 1157 1157
-- Name: _st_buffer(geometry, double precision, cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_buffer(geometry, double precision, cstring) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'buffer';


ALTER FUNCTION public._st_buffer(geometry, double precision, cstring) OWNER TO postgres;

--
-- TOC entry 461 (class 1255 OID 21815)
-- Dependencies: 3 1157 1157
-- Name: _st_contains(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_contains(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'contains';


ALTER FUNCTION public._st_contains(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 467 (class 1255 OID 21821)
-- Dependencies: 3 1157 1157
-- Name: _st_containsproperly(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_containsproperly(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'containsproperly';


ALTER FUNCTION public._st_containsproperly(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 463 (class 1255 OID 21817)
-- Dependencies: 3 1157 1157
-- Name: _st_coveredby(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_coveredby(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'coveredby';


ALTER FUNCTION public._st_coveredby(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 465 (class 1255 OID 21819)
-- Dependencies: 3 1157 1157
-- Name: _st_covers(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_covers(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'covers';


ALTER FUNCTION public._st_covers(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 789 (class 1255 OID 22178)
-- Dependencies: 1184 1184 3
-- Name: _st_covers(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_covers(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'geography_covers';


ALTER FUNCTION public._st_covers(geography, geography) OWNER TO postgres;

--
-- TOC entry 455 (class 1255 OID 21809)
-- Dependencies: 3 1157 1157
-- Name: _st_crosses(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_crosses(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'crosses';


ALTER FUNCTION public._st_crosses(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 679 (class 1255 OID 22031)
-- Dependencies: 3 1157 1157
-- Name: _st_dfullywithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_dfullywithin(geometry, geometry, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dfullywithin';


ALTER FUNCTION public._st_dfullywithin(geometry, geometry, double precision) OWNER TO postgres;

--
-- TOC entry 773 (class 1255 OID 22162)
-- Dependencies: 3 1184 1184
-- Name: _st_distance(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_distance(geography, geography, double precision, boolean) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'geography_distance';


ALTER FUNCTION public._st_distance(geography, geography, double precision, boolean) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 21599)
-- Dependencies: 3 1424 1173 1157
-- Name: _st_dumppoints(geometry, integer[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_dumppoints(the_geom geometry, cur_path integer[]) RETURNS SETOF geometry_dump
    LANGUAGE plpgsql
    AS $$
DECLARE
  tmp geometry_dump;
  tmp2 geometry_dump;
  nb_points integer;
  nb_geom integer;
  i integer;
  j integer;
  g geometry;
  
BEGIN
  
  RAISE DEBUG '%,%', cur_path, ST_GeometryType(the_geom);

  -- Special case (MULTI* OR GEOMETRYCOLLECTION) : iterate and return the DumpPoints of the geometries
  SELECT ST_NumGeometries(the_geom) INTO nb_geom;

  IF (nb_geom IS NOT NULL) THEN
    
    i = 1;
    FOR tmp2 IN SELECT (ST_Dump(the_geom)).* LOOP

      FOR tmp IN SELECT * FROM _ST_DumpPoints(tmp2.geom, cur_path || tmp2.path) LOOP
	    RETURN NEXT tmp;
      END LOOP;
      i = i + 1;
      
    END LOOP;

    RETURN;
  END IF;
  

  -- Special case (POLYGON) : return the points of the rings of a polygon
  IF (ST_GeometryType(the_geom) = 'ST_Polygon') THEN

    FOR tmp IN SELECT * FROM _ST_DumpPoints(ST_ExteriorRing(the_geom), cur_path || ARRAY[1]) LOOP
      RETURN NEXT tmp;
    END LOOP;
    
    j := ST_NumInteriorRings(the_geom);
    FOR i IN 1..j LOOP
        FOR tmp IN SELECT * FROM _ST_DumpPoints(ST_InteriorRingN(the_geom, i), cur_path || ARRAY[i+1]) LOOP
          RETURN NEXT tmp;
        END LOOP;
    END LOOP;
    
    RETURN;
  END IF;

    
  -- Special case (POINT) : return the point
  IF (ST_GeometryType(the_geom) = 'ST_Point') THEN

    tmp.path = cur_path || ARRAY[1];
    tmp.geom = the_geom;

    RETURN NEXT tmp;
    RETURN;

  END IF;


  -- Use ST_NumPoints rather than ST_NPoints to have a NULL value if the_geom isn't
  -- a LINESTRING or CIRCULARSTRING.
  SELECT ST_NumPoints(the_geom) INTO nb_points;

  -- This should never happen
  IF (nb_points IS NULL) THEN
    RAISE EXCEPTION 'Unexpected error while dumping geometry %', ST_AsText(the_geom);
  END IF;

  FOR i IN 1..nb_points LOOP
    tmp.path = cur_path || ARRAY[i];
    tmp.geom := ST_PointN(the_geom, i);
    RETURN NEXT tmp;
  END LOOP;
   
END
$$;


ALTER FUNCTION public._st_dumppoints(the_geom geometry, cur_path integer[]) OWNER TO postgres;

--
-- TOC entry 449 (class 1255 OID 21803)
-- Dependencies: 3 1157 1157
-- Name: _st_dwithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_dwithin(geometry, geometry, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_dwithin';


ALTER FUNCTION public._st_dwithin(geometry, geometry, double precision) OWNER TO postgres;

--
-- TOC entry 774 (class 1255 OID 22163)
-- Dependencies: 1184 1184 3
-- Name: _st_dwithin(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_dwithin(geography, geography, double precision, boolean) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'geography_dwithin';


ALTER FUNCTION public._st_dwithin(geography, geography, double precision, boolean) OWNER TO postgres;

--
-- TOC entry 483 (class 1255 OID 21837)
-- Dependencies: 3 1157 1157
-- Name: _st_equals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_equals(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'geomequals';


ALTER FUNCTION public._st_equals(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 778 (class 1255 OID 22167)
-- Dependencies: 3 1184 1184
-- Name: _st_expand(geography, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_expand(geography, double precision) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_expand';


ALTER FUNCTION public._st_expand(geography, double precision) OWNER TO postgres;

--
-- TOC entry 452 (class 1255 OID 21806)
-- Dependencies: 3 1157 1157
-- Name: _st_intersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_intersects(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'intersects';


ALTER FUNCTION public._st_intersects(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 409 (class 1255 OID 21748)
-- Dependencies: 3 1157 1157
-- Name: _st_linecrossingdirection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_linecrossingdirection(geometry, geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'ST_LineCrossingDirection';


ALTER FUNCTION public._st_linecrossingdirection(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 677 (class 1255 OID 22029)
-- Dependencies: 3 1157 1157 1157
-- Name: _st_longestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_longestline(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_longestline2d';


ALTER FUNCTION public._st_longestline(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 673 (class 1255 OID 22025)
-- Dependencies: 3 1157 1157
-- Name: _st_maxdistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_maxdistance(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_maxdistance2d_linestring';


ALTER FUNCTION public._st_maxdistance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 700 (class 1255 OID 22053)
-- Dependencies: 3 1157 1157
-- Name: _st_orderingequals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_orderingequals(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_same';


ALTER FUNCTION public._st_orderingequals(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 470 (class 1255 OID 21824)
-- Dependencies: 3 1157 1157
-- Name: _st_overlaps(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_overlaps(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'overlaps';


ALTER FUNCTION public._st_overlaps(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 788 (class 1255 OID 22177)
-- Dependencies: 3 1184 1184
-- Name: _st_pointoutside(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_pointoutside(geography) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_point_outside';


ALTER FUNCTION public._st_pointoutside(geography) OWNER TO postgres;

--
-- TOC entry 447 (class 1255 OID 21801)
-- Dependencies: 3 1157 1157
-- Name: _st_touches(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_touches(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'touches';


ALTER FUNCTION public._st_touches(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 458 (class 1255 OID 21812)
-- Dependencies: 3 1157 1157
-- Name: _st_within(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _st_within(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'within';


ALTER FUNCTION public._st_within(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 689 (class 1255 OID 22042)
-- Dependencies: 3 1424
-- Name: addauth(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addauth(text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
	lockid alias for $1;
	okay boolean;
	myrec record;
BEGIN
	-- check to see if table exists
	--  if not, CREATE TEMP TABLE mylock (transid xid, lockcode text)
	okay := 'f';
	FOR myrec IN SELECT * FROM pg_class WHERE relname = 'temp_lock_have_table' LOOP
		okay := 't';
	END LOOP; 
	IF (okay <> 't') THEN 
		CREATE TEMP TABLE temp_lock_have_table (transid xid, lockcode text);
			-- this will only work from pgsql7.4 up
			-- ON COMMIT DELETE ROWS;
	END IF;

	--  INSERT INTO mylock VALUES ( $1)
--	EXECUTE 'INSERT INTO temp_lock_have_table VALUES ( '||
--		quote_literal(getTransactionID()) || ',' ||
--		quote_literal(lockid) ||')';

	INSERT INTO temp_lock_have_table VALUES (getTransactionID(), lockid);

	RETURN true::boolean;
END;
$_$;


ALTER FUNCTION public.addauth(text) OWNER TO postgres;

--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 689
-- Name: FUNCTION addauth(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION addauth(text) IS 'args: auth_token - Add an authorization token to be used in current transaction.';


--
-- TOC entry 142 (class 1255 OID 21441)
-- Dependencies: 3 1157 1157
-- Name: addbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_addBBOX';


ALTER FUNCTION public.addbbox(geometry) OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 21643)
-- Dependencies: 3 1424
-- Name: addgeometrycolumn(character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('','',$1,$2,$3,$4,$5) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.addgeometrycolumn(character varying, character varying, integer, character varying, integer) OWNER TO postgres;

--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 323
-- Name: FUNCTION addgeometrycolumn(character varying, character varying, integer, character varying, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION addgeometrycolumn(character varying, character varying, integer, character varying, integer) IS 'args: table_name, column_name, srid, type, dimension - Adds a geometry column to an existing table of attributes.';


--
-- TOC entry 322 (class 1255 OID 21642)
-- Dependencies: 3 1424
-- Name: addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STABLE STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('',$1,$2,$3,$4,$5,$6) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer) OWNER TO postgres;

--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 322
-- Name: FUNCTION addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer) IS 'args: schema_name, table_name, column_name, srid, type, dimension - Adds a geometry column to an existing table of attributes.';


--
-- TOC entry 321 (class 1255 OID 21641)
-- Dependencies: 3 1424
-- Name: addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	new_srid alias for $5;
	new_type alias for $6;
	new_dim alias for $7;
	rec RECORD;
	sr varchar;
	real_schema name;
	sql text;

BEGIN

	-- Verify geometry type
	IF ( NOT ( (new_type = 'GEOMETRY') OR
			   (new_type = 'GEOMETRYCOLLECTION') OR
			   (new_type = 'POINT') OR
			   (new_type = 'MULTIPOINT') OR
			   (new_type = 'POLYGON') OR
			   (new_type = 'MULTIPOLYGON') OR
			   (new_type = 'LINESTRING') OR
			   (new_type = 'MULTILINESTRING') OR
			   (new_type = 'GEOMETRYCOLLECTIONM') OR
			   (new_type = 'POINTM') OR
			   (new_type = 'MULTIPOINTM') OR
			   (new_type = 'POLYGONM') OR
			   (new_type = 'MULTIPOLYGONM') OR
			   (new_type = 'LINESTRINGM') OR
			   (new_type = 'MULTILINESTRINGM') OR
			   (new_type = 'CIRCULARSTRING') OR
			   (new_type = 'CIRCULARSTRINGM') OR
			   (new_type = 'COMPOUNDCURVE') OR
			   (new_type = 'COMPOUNDCURVEM') OR
			   (new_type = 'CURVEPOLYGON') OR
			   (new_type = 'CURVEPOLYGONM') OR
			   (new_type = 'MULTICURVE') OR
			   (new_type = 'MULTICURVEM') OR
			   (new_type = 'MULTISURFACE') OR
			   (new_type = 'MULTISURFACEM')) )
	THEN
		RAISE EXCEPTION 'Invalid type name - valid ones are:
	POINT, MULTIPOINT,
	LINESTRING, MULTILINESTRING,
	POLYGON, MULTIPOLYGON,
	CIRCULARSTRING, COMPOUNDCURVE, MULTICURVE,
	CURVEPOLYGON, MULTISURFACE,
	GEOMETRY, GEOMETRYCOLLECTION,
	POINTM, MULTIPOINTM,
	LINESTRINGM, MULTILINESTRINGM,
	POLYGONM, MULTIPOLYGONM,
	CIRCULARSTRINGM, COMPOUNDCURVEM, MULTICURVEM
	CURVEPOLYGONM, MULTISURFACEM,
	or GEOMETRYCOLLECTIONM';
		RETURN 'fail';
	END IF;


	-- Verify dimension
	IF ( (new_dim >4) OR (new_dim <0) ) THEN
		RAISE EXCEPTION 'invalid dimension';
		RETURN 'fail';
	END IF;

	IF ( (new_type LIKE '%M') AND (new_dim!=3) ) THEN
		RAISE EXCEPTION 'TypeM needs 3 dimensions';
		RETURN 'fail';
	END IF;


	-- Verify SRID
	IF ( new_srid != -1 ) THEN
		SELECT SRID INTO sr FROM spatial_ref_sys WHERE SRID = new_srid;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'AddGeometryColumns() - invalid SRID';
			RETURN 'fail';
		END IF;
	END IF;


	-- Verify schema
	IF ( schema_name IS NOT NULL AND schema_name != '' ) THEN
		sql := 'SELECT nspname FROM pg_namespace ' ||
			'WHERE text(nspname) = ' || quote_literal(schema_name) ||
			'LIMIT 1';
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Schema % is not a valid schemaname', quote_literal(schema_name);
			RETURN 'fail';
		END IF;
	END IF;

	IF ( real_schema IS NULL ) THEN
		RAISE DEBUG 'Detecting schema';
		sql := 'SELECT n.nspname AS schemaname ' ||
			'FROM pg_catalog.pg_class c ' ||
			  'JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace ' ||
			'WHERE c.relkind = ' || quote_literal('r') ||
			' AND n.nspname NOT IN (' || quote_literal('pg_catalog') || ', ' || quote_literal('pg_toast') || ')' ||
			' AND pg_catalog.pg_table_is_visible(c.oid)' ||
			' AND c.relname = ' || quote_literal(table_name);
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Table % does not occur in the search_path', quote_literal(table_name);
			RETURN 'fail';
		END IF;
	END IF;


	-- Add geometry column to table
	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD COLUMN ' || quote_ident(column_name) ||
		' geometry ';
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Delete stale record in geometry_columns (if any)
	sql := 'DELETE FROM geometry_columns WHERE
		f_table_catalog = ' || quote_literal('') ||
		' AND f_table_schema = ' ||
		quote_literal(real_schema) ||
		' AND f_table_name = ' || quote_literal(table_name) ||
		' AND f_geometry_column = ' || quote_literal(column_name);
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Add record in geometry_columns
	sql := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema,f_table_name,' ||
										  'f_geometry_column,coord_dimension,srid,type)' ||
		' VALUES (' ||
		quote_literal('') || ',' ||
		quote_literal(real_schema) || ',' ||
		quote_literal(table_name) || ',' ||
		quote_literal(column_name) || ',' ||
		new_dim::text || ',' ||
		new_srid::text || ',' ||
		quote_literal(new_type) || ')';
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Add table CHECKs
	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD CONSTRAINT '
		|| quote_ident('enforce_srid_' || column_name)
		|| ' CHECK (ST_SRID(' || quote_ident(column_name) ||
		') = ' || new_srid::text || ')' ;
	RAISE DEBUG '%', sql;
	EXECUTE sql;

	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD CONSTRAINT '
		|| quote_ident('enforce_dims_' || column_name)
		|| ' CHECK (ST_NDims(' || quote_ident(column_name) ||
		') = ' || new_dim::text || ')' ;
	RAISE DEBUG '%', sql;
	EXECUTE sql;

	IF ( NOT (new_type = 'GEOMETRY')) THEN
		sql := 'ALTER TABLE ' ||
			quote_ident(real_schema) || '.' || quote_ident(table_name) || ' ADD CONSTRAINT ' ||
			quote_ident('enforce_geotype_' || column_name) ||
			' CHECK (GeometryType(' ||
			quote_ident(column_name) || ')=' ||
			quote_literal(new_type) || ' OR (' ||
			quote_ident(column_name) || ') is null)';
		RAISE DEBUG '%', sql;
		EXECUTE sql;
	END IF;

	RETURN
		real_schema || '.' ||
		table_name || '.' || column_name ||
		' SRID:' || new_srid::text ||
		' TYPE:' || new_type ||
		' DIMS:' || new_dim::text || ' ';
END;
$_$;


ALTER FUNCTION public.addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer) OWNER TO postgres;

--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 321
-- Name: FUNCTION addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer) IS 'args: catalog_name, schema_name, table_name, column_name, srid, type, dimension - Adds a geometry column to an existing table of attributes.';


--
-- TOC entry 273 (class 1255 OID 21572)
-- Dependencies: 3 1157 1157 1157
-- Name: addpoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addpoint(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_addpoint';


ALTER FUNCTION public.addpoint(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 21574)
-- Dependencies: 1157 1157 1157 3
-- Name: addpoint(geometry, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addpoint(geometry, geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_addpoint';


ALTER FUNCTION public.addpoint(geometry, geometry, integer) OWNER TO postgres;

--
-- TOC entry 41 (class 1255 OID 21286)
-- Dependencies: 1157 1157 3
-- Name: affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


ALTER FUNCTION public.affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 39 (class 1255 OID 21284)
-- Dependencies: 1157 1157 3
-- Name: affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_affine';


ALTER FUNCTION public.affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 194 (class 1255 OID 21493)
-- Dependencies: 3 1157
-- Name: area(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION area(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_area_polygon';


ALTER FUNCTION public.area(geometry) OWNER TO postgres;

--
-- TOC entry 192 (class 1255 OID 21491)
-- Dependencies: 3 1157
-- Name: area2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION area2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_area_polygon';


ALTER FUNCTION public.area2d(geometry) OWNER TO postgres;

--
-- TOC entry 560 (class 1255 OID 21914)
-- Dependencies: 3 1157
-- Name: asbinary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asbinary(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asBinary';


ALTER FUNCTION public.asbinary(geometry) OWNER TO postgres;

--
-- TOC entry 562 (class 1255 OID 21916)
-- Dependencies: 3 1157
-- Name: asbinary(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asbinary(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asBinary';


ALTER FUNCTION public.asbinary(geometry, text) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 21540)
-- Dependencies: 1157 3
-- Name: asewkb(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asewkb(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'WKBFromLWGEOM';


ALTER FUNCTION public.asewkb(geometry) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 21546)
-- Dependencies: 3 1157
-- Name: asewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asewkb(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'WKBFromLWGEOM';


ALTER FUNCTION public.asewkb(geometry, text) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 21538)
-- Dependencies: 1157 3
-- Name: asewkt(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asewkt(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asEWKT';


ALTER FUNCTION public.asewkt(geometry) OWNER TO postgres;

--
-- TOC entry 497 (class 1255 OID 21851)
-- Dependencies: 3 1157
-- Name: asgml(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asgml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


ALTER FUNCTION public.asgml(geometry) OWNER TO postgres;

--
-- TOC entry 495 (class 1255 OID 21849)
-- Dependencies: 3 1157
-- Name: asgml(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asgml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


ALTER FUNCTION public.asgml(geometry, integer) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 21542)
-- Dependencies: 1157 3
-- Name: ashexewkb(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ashexewkb(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asHEXEWKB';


ALTER FUNCTION public.ashexewkb(geometry) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 21544)
-- Dependencies: 1157 3
-- Name: ashexewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ashexewkb(geometry, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asHEXEWKB';


ALTER FUNCTION public.ashexewkb(geometry, text) OWNER TO postgres;

--
-- TOC entry 506 (class 1255 OID 21860)
-- Dependencies: 3 1157
-- Name: askml(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION askml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, transform($1,4326), 15)$_$;


ALTER FUNCTION public.askml(geometry) OWNER TO postgres;

--
-- TOC entry 504 (class 1255 OID 21858)
-- Dependencies: 3 1157
-- Name: askml(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION askml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, transform($1,4326), $2)$_$;


ALTER FUNCTION public.askml(geometry, integer) OWNER TO postgres;

--
-- TOC entry 507 (class 1255 OID 21861)
-- Dependencies: 3 1157
-- Name: askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION askml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, transform($2,4326), $3)$_$;


ALTER FUNCTION public.askml(integer, geometry, integer) OWNER TO postgres;

--
-- TOC entry 492 (class 1255 OID 21846)
-- Dependencies: 3 1157
-- Name: assvg(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION assvg(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'assvg_geometry';


ALTER FUNCTION public.assvg(geometry) OWNER TO postgres;

--
-- TOC entry 490 (class 1255 OID 21844)
-- Dependencies: 3 1157
-- Name: assvg(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION assvg(geometry, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'assvg_geometry';


ALTER FUNCTION public.assvg(geometry, integer) OWNER TO postgres;

--
-- TOC entry 488 (class 1255 OID 21842)
-- Dependencies: 3 1157
-- Name: assvg(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION assvg(geometry, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'assvg_geometry';


ALTER FUNCTION public.assvg(geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 564 (class 1255 OID 21918)
-- Dependencies: 3 1157
-- Name: astext(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION astext(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asText';


ALTER FUNCTION public.astext(geometry) OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 21503)
-- Dependencies: 1157 3 1157
-- Name: azimuth(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION azimuth(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_azimuth';


ALTER FUNCTION public.azimuth(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 683 (class 1255 OID 22035)
-- Dependencies: 3 1424 1157
-- Name: bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bdmpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := multi(BuildArea(mline));

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdmpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 681 (class 1255 OID 22033)
-- Dependencies: 3 1424 1157
-- Name: bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bdpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := BuildArea(mline);

	IF GeometryType(geom) != 'POLYGON'
	THEN
		RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
	END IF;

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 418 (class 1255 OID 21757)
-- Dependencies: 3 1157 1157
-- Name: boundary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION boundary(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'boundary';


ALTER FUNCTION public.boundary(geometry) OWNER TO postgres;

--
-- TOC entry 364 (class 1255 OID 21687)
-- Dependencies: 3 1157
-- Name: box(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box(geometry) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX';


ALTER FUNCTION public.box(geometry) OWNER TO postgres;

--
-- TOC entry 367 (class 1255 OID 21690)
-- Dependencies: 3 1161
-- Name: box(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box(box3d) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_BOX';


ALTER FUNCTION public.box(box3d) OWNER TO postgres;

--
-- TOC entry 70 (class 1255 OID 21320)
-- Dependencies: 1167 3 1164
-- Name: box2d(box3d_extent); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box2d(box3d_extent) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_BOX2DFLOAT4';


ALTER FUNCTION public.box2d(box3d_extent) OWNER TO postgres;

--
-- TOC entry 362 (class 1255 OID 21685)
-- Dependencies: 3 1167 1157
-- Name: box2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box2d(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX2DFLOAT4';


ALTER FUNCTION public.box2d(geometry) OWNER TO postgres;

--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 362
-- Name: FUNCTION box2d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION box2d(geometry) IS 'args: geomA - Returns a BOX2D representing the maximum extents of the geometry.';


--
-- TOC entry 365 (class 1255 OID 21688)
-- Dependencies: 3 1167 1161
-- Name: box2d(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box2d(box3d) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_BOX2DFLOAT4';


ALTER FUNCTION public.box2d(box3d) OWNER TO postgres;

--
-- TOC entry 363 (class 1255 OID 21686)
-- Dependencies: 3 1161 1157
-- Name: box3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3d(geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX3D';


ALTER FUNCTION public.box3d(geometry) OWNER TO postgres;

--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 363
-- Name: FUNCTION box3d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION box3d(geometry) IS 'args: geomA - Returns a BOX3D representing the maximum extents of the geometry.';


--
-- TOC entry 366 (class 1255 OID 21689)
-- Dependencies: 3 1161 1167
-- Name: box3d(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3d(box2d) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_to_BOX3D';


ALTER FUNCTION public.box3d(box2d) OWNER TO postgres;

--
-- TOC entry 69 (class 1255 OID 21318)
-- Dependencies: 1161 3 1164
-- Name: box3d_extent(box3d_extent); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3d_extent(box3d_extent) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_extent_to_BOX3D';


ALTER FUNCTION public.box3d_extent(box3d_extent) OWNER TO postgres;

--
-- TOC entry 369 (class 1255 OID 21692)
-- Dependencies: 3 1161
-- Name: box3dtobox(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION box3dtobox(box3d) RETURNS box
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT box($1)$_$;


ALTER FUNCTION public.box3dtobox(box3d) OWNER TO postgres;

--
-- TOC entry 401 (class 1255 OID 21740)
-- Dependencies: 3 1157 1157
-- Name: buffer(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION buffer(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'buffer';


ALTER FUNCTION public.buffer(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 406 (class 1255 OID 21745)
-- Dependencies: 3 1157 1157
-- Name: buffer(geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION buffer(geometry, double precision, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Buffer($1, $2, $3)$_$;


ALTER FUNCTION public.buffer(geometry, double precision, integer) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 21585)
-- Dependencies: 1157 3 1157
-- Name: buildarea(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION buildarea(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_buildarea';


ALTER FUNCTION public.buildarea(geometry) OWNER TO postgres;

--
-- TOC entry 375 (class 1255 OID 21698)
-- Dependencies: 3 1157
-- Name: bytea(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bytea(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_bytea';


ALTER FUNCTION public.bytea(geometry) OWNER TO postgres;

--
-- TOC entry 474 (class 1255 OID 21828)
-- Dependencies: 3 1157 1157
-- Name: centroid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION centroid(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'centroid';


ALTER FUNCTION public.centroid(geometry) OWNER TO postgres;

--
-- TOC entry 691 (class 1255 OID 22044)
-- Dependencies: 3
-- Name: checkauth(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkauth(text, text) RETURNS integer
    LANGUAGE sql
    AS $_$ SELECT CheckAuth('', $1, $2) $_$;


ALTER FUNCTION public.checkauth(text, text) OWNER TO postgres;

--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 691
-- Name: FUNCTION checkauth(text, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION checkauth(text, text) IS 'args: a_table_name, a_key_column_name - Creates trigger on a table to prevent/allow updates and deletes of rows based on authorization token.';


--
-- TOC entry 690 (class 1255 OID 22043)
-- Dependencies: 3 1424
-- Name: checkauth(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkauth(text, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
	schema text;
BEGIN
	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
	END IF;

	if ( $1 != '' ) THEN
		schema = $1;
	ELSE
		SELECT current_schema() into schema;
	END IF;

	-- TODO: check for an already existing trigger ?

	EXECUTE 'CREATE TRIGGER check_auth BEFORE UPDATE OR DELETE ON ' 
		|| quote_ident(schema) || '.' || quote_ident($2)
		||' FOR EACH ROW EXECUTE PROCEDURE CheckAuthTrigger('
		|| quote_literal($3) || ')';

	RETURN 0;
END;
$_$;


ALTER FUNCTION public.checkauth(text, text, text) OWNER TO postgres;

--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 690
-- Name: FUNCTION checkauth(text, text, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION checkauth(text, text, text) IS 'args: a_schema_name, a_table_name, a_key_column_name - Creates trigger on a table to prevent/allow updates and deletes of rows based on authorization token.';


--
-- TOC entry 692 (class 1255 OID 22045)
-- Dependencies: 3
-- Name: checkauthtrigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkauthtrigger() RETURNS trigger
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'check_authorization';


ALTER FUNCTION public.checkauthtrigger() OWNER TO postgres;

--
-- TOC entry 426 (class 1255 OID 21765)
-- Dependencies: 3 1157 1157 1157
-- Name: collect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION collect(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'LWGEOM_collect';


ALTER FUNCTION public.collect(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 21601)
-- Dependencies: 3 1167 1167 1157
-- Name: combine_bbox(box2d, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION combine_bbox(box2d, geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_combine';


ALTER FUNCTION public.combine_bbox(box2d, geometry) OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 21603)
-- Dependencies: 3 1164 1164 1157
-- Name: combine_bbox(box3d_extent, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION combine_bbox(box3d_extent, geometry) RETURNS box3d_extent
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'BOX3D_combine';


ALTER FUNCTION public.combine_bbox(box3d_extent, geometry) OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 21607)
-- Dependencies: 3 1161 1161 1157
-- Name: combine_bbox(box3d, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION combine_bbox(box3d, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'BOX3D_combine';


ALTER FUNCTION public.combine_bbox(box3d, geometry) OWNER TO postgres;

--
-- TOC entry 161 (class 1255 OID 21460)
-- Dependencies: 3 1169
-- Name: compression(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION compression(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getCompression';


ALTER FUNCTION public.compression(chip) OWNER TO postgres;

--
-- TOC entry 460 (class 1255 OID 21814)
-- Dependencies: 3 1157 1157
-- Name: contains(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION contains(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'contains';


ALTER FUNCTION public.contains(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 407 (class 1255 OID 21746)
-- Dependencies: 3 1157 1157
-- Name: convexhull(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION convexhull(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'convexhull';


ALTER FUNCTION public.convexhull(geometry) OWNER TO postgres;

--
-- TOC entry 454 (class 1255 OID 21808)
-- Dependencies: 3 1157 1157
-- Name: crosses(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosses(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'crosses';


ALTER FUNCTION public.crosses(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 159 (class 1255 OID 21458)
-- Dependencies: 1169 3
-- Name: datatype(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION datatype(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getDatatype';


ALTER FUNCTION public.datatype(chip) OWNER TO postgres;

--
-- TOC entry 416 (class 1255 OID 21755)
-- Dependencies: 3 1157 1157 1157
-- Name: difference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION difference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'difference';


ALTER FUNCTION public.difference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 526 (class 1255 OID 21880)
-- Dependencies: 3 1157
-- Name: dimension(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dimension(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dimension';


ALTER FUNCTION public.dimension(geometry) OWNER TO postgres;

--
-- TOC entry 696 (class 1255 OID 22049)
-- Dependencies: 3 1424
-- Name: disablelongtransactions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION disablelongtransactions() RETURNS text
    LANGUAGE plpgsql
    AS $$ 
DECLARE
	rec RECORD;

BEGIN

	--
	-- Drop all triggers applied by CheckAuth()
	--
	FOR rec IN
		SELECT c.relname, t.tgname, t.tgargs FROM pg_trigger t, pg_class c, pg_proc p
		WHERE p.proname = 'checkauthtrigger' and t.tgfoid = p.oid and t.tgrelid = c.oid
	LOOP
		EXECUTE 'DROP TRIGGER ' || quote_ident(rec.tgname) ||
			' ON ' || quote_ident(rec.relname);
	END LOOP;

	--
	-- Drop the authorization_table table
	--
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorization_table' LOOP
		DROP TABLE authorization_table;
	END LOOP;

	--
	-- Drop the authorized_tables view
	--
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorized_tables' LOOP
		DROP VIEW authorized_tables;
	END LOOP;

	RETURN 'Long transactions support disabled';
END;
$$;


ALTER FUNCTION public.disablelongtransactions() OWNER TO postgres;

--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 696
-- Name: FUNCTION disablelongtransactions(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION disablelongtransactions() IS 'Disable long transaction support. This function removes the long transaction support metadata tables, and drops all triggers attached to lock-checked tables.';


--
-- TOC entry 444 (class 1255 OID 21798)
-- Dependencies: 3 1157 1157
-- Name: disjoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION disjoint(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'disjoint';


ALTER FUNCTION public.disjoint(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 200 (class 1255 OID 21499)
-- Dependencies: 1157 3 1157
-- Name: distance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION distance(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_mindistance2d';


ALTER FUNCTION public.distance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 198 (class 1255 OID 21497)
-- Dependencies: 1157 3 1157
-- Name: distance_sphere(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION distance_sphere(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_distance_sphere';


ALTER FUNCTION public.distance_sphere(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 196 (class 1255 OID 21495)
-- Dependencies: 1157 3 1157 1153
-- Name: distance_spheroid(geometry, geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION distance_spheroid(geometry, geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_distance_ellipsoid';


ALTER FUNCTION public.distance_spheroid(geometry, geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 144 (class 1255 OID 21443)
-- Dependencies: 1157 1157 3
-- Name: dropbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dropBBOX';


ALTER FUNCTION public.dropbbox(geometry) OWNER TO postgres;

--
-- TOC entry 326 (class 1255 OID 21646)
-- Dependencies: 3 1424
-- Name: dropgeometrycolumn(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrycolumn(character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret text;
BEGIN
	SELECT DropGeometryColumn('','',$1,$2) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.dropgeometrycolumn(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 326
-- Name: FUNCTION dropgeometrycolumn(character varying, character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION dropgeometrycolumn(character varying, character varying) IS 'args: table_name, column_name - Removes a geometry column from a spatial table.';


--
-- TOC entry 325 (class 1255 OID 21645)
-- Dependencies: 3 1424
-- Name: dropgeometrycolumn(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrycolumn(character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret text;
BEGIN
	SELECT DropGeometryColumn('',$1,$2,$3) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.dropgeometrycolumn(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 325
-- Name: FUNCTION dropgeometrycolumn(character varying, character varying, character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION dropgeometrycolumn(character varying, character varying, character varying) IS 'args: schema_name, table_name, column_name - Removes a geometry column from a spatial table.';


--
-- TOC entry 324 (class 1255 OID 21644)
-- Dependencies: 3 1424
-- Name: dropgeometrycolumn(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrycolumn(character varying, character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	myrec RECORD;
	okay boolean;
	real_schema name;

BEGIN


	-- Find, check or fix schema_name
	IF ( schema_name != '' ) THEN
		okay = 'f';

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := 't';
		END LOOP;

		IF ( okay <> 't' ) THEN
			RAISE NOTICE 'Invalid schema name - using current_schema()';
			SELECT current_schema() into real_schema;
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT current_schema() into real_schema;
	END IF;

	-- Find out if the column is in the geometry_columns table
	okay = 'f';
	FOR myrec IN SELECT * from geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := 't';
	END LOOP;
	IF (okay <> 't') THEN
		RAISE EXCEPTION 'column not found in geometry_columns table';
		RETURN 'f';
	END IF;

	-- Remove ref from geometry_columns table
	EXECUTE 'delete from geometry_columns where f_table_schema = ' ||
		quote_literal(real_schema) || ' and f_table_name = ' ||
		quote_literal(table_name)  || ' and f_geometry_column = ' ||
		quote_literal(column_name);

	-- Remove table column
	EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) || '.' ||
		quote_ident(table_name) || ' DROP COLUMN ' ||
		quote_ident(column_name);

	RETURN real_schema || '.' || table_name || '.' || column_name ||' effectively removed.';

END;
$_$;


ALTER FUNCTION public.dropgeometrycolumn(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 324
-- Name: FUNCTION dropgeometrycolumn(character varying, character varying, character varying, character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION dropgeometrycolumn(character varying, character varying, character varying, character varying) IS 'args: catalog_name, schema_name, table_name, column_name - Removes a geometry column from a spatial table.';


--
-- TOC entry 297 (class 1255 OID 21649)
-- Dependencies: 3
-- Name: dropgeometrytable(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrytable(character varying) RETURNS text
    LANGUAGE sql STRICT
    AS $_$ SELECT DropGeometryTable('','',$1) $_$;


ALTER FUNCTION public.dropgeometrytable(character varying) OWNER TO postgres;

--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 297
-- Name: FUNCTION dropgeometrytable(character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION dropgeometrytable(character varying) IS 'args: table_name - Drops a table and all its references in geometry_columns.';


--
-- TOC entry 328 (class 1255 OID 21648)
-- Dependencies: 3
-- Name: dropgeometrytable(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrytable(character varying, character varying) RETURNS text
    LANGUAGE sql STRICT
    AS $_$ SELECT DropGeometryTable('',$1,$2) $_$;


ALTER FUNCTION public.dropgeometrytable(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 328
-- Name: FUNCTION dropgeometrytable(character varying, character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION dropgeometrytable(character varying, character varying) IS 'args: schema_name, table_name - Drops a table and all its references in geometry_columns.';


--
-- TOC entry 327 (class 1255 OID 21647)
-- Dependencies: 3 1424
-- Name: dropgeometrytable(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrytable(character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	real_schema name;

BEGIN

	IF ( schema_name = '' ) THEN
		SELECT current_schema() into real_schema;
	ELSE
		real_schema = schema_name;
	END IF;

	-- Remove refs from geometry_columns table
	EXECUTE 'DELETE FROM geometry_columns WHERE ' ||
		'f_table_schema = ' || quote_literal(real_schema) ||
		' AND ' ||
		' f_table_name = ' || quote_literal(table_name);

	-- Remove table
	EXECUTE 'DROP TABLE '
		|| quote_ident(real_schema) || '.' ||
		quote_ident(table_name);

	RETURN
		real_schema || '.' ||
		table_name ||' dropped.';

END;
$_$;


ALTER FUNCTION public.dropgeometrytable(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 327
-- Name: FUNCTION dropgeometrytable(character varying, character varying, character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION dropgeometrytable(character varying, character varying, character varying) IS 'args: catalog_name, schema_name, table_name - Drops a table and all its references in geometry_columns.';


--
-- TOC entry 293 (class 1255 OID 21595)
-- Dependencies: 3 1173 1157
-- Name: dump(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dump(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dump';


ALTER FUNCTION public.dump(geometry) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 21597)
-- Dependencies: 3 1173 1157
-- Name: dumprings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dumprings(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dump_rings';


ALTER FUNCTION public.dumprings(geometry) OWNER TO postgres;

--
-- TOC entry 694 (class 1255 OID 22047)
-- Dependencies: 3 1424
-- Name: enablelongtransactions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION enablelongtransactions() RETURNS text
    LANGUAGE plpgsql
    AS $$ 
DECLARE
	"query" text;
	exists bool;
	rec RECORD;

BEGIN

	exists = 'f';
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorization_table'
	LOOP
		exists = 't';
	END LOOP;

	IF NOT exists
	THEN
		"query" = 'CREATE TABLE authorization_table (
			toid oid, -- table oid
			rid text, -- row id
			expires timestamp,
			authid text
		)';
		EXECUTE "query";
	END IF;

	exists = 'f';
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorized_tables'
	LOOP
		exists = 't';
	END LOOP;

	IF NOT exists THEN
		"query" = 'CREATE VIEW authorized_tables AS ' ||
			'SELECT ' ||
			'n.nspname as schema, ' ||
			'c.relname as table, trim(' ||
			quote_literal(chr(92) || '000') ||
			' from t.tgargs) as id_column ' ||
			'FROM pg_trigger t, pg_class c, pg_proc p ' ||
			', pg_namespace n ' ||
			'WHERE p.proname = ' || quote_literal('checkauthtrigger') ||
			' AND c.relnamespace = n.oid' ||
			' AND t.tgfoid = p.oid and t.tgrelid = c.oid';
		EXECUTE "query";
	END IF;

	RETURN 'Long transactions support enabled';
END;
$$;


ALTER FUNCTION public.enablelongtransactions() OWNER TO postgres;

--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 694
-- Name: FUNCTION enablelongtransactions(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION enablelongtransactions() IS 'Enable long transaction support. This function creates the required metadata tables, needs to be called once before using the other functions in this section. Calling it twice is harmless.';


--
-- TOC entry 550 (class 1255 OID 21904)
-- Dependencies: 3 1157 1157
-- Name: endpoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION endpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_endpoint_linestring';


ALTER FUNCTION public.endpoint(geometry) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 21526)
-- Dependencies: 3 1157 1157
-- Name: envelope(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION envelope(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_envelope';


ALTER FUNCTION public.envelope(geometry) OWNER TO postgres;

--
-- TOC entry 482 (class 1255 OID 21836)
-- Dependencies: 3 1157 1157
-- Name: equals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION equals(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geomequals';


ALTER FUNCTION public.equals(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 21613)
-- Dependencies: 3 1167
-- Name: estimated_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION estimated_extent(text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-1.5', 'LWGEOM_estimated_extent';


ALTER FUNCTION public.estimated_extent(text, text) OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 21611)
-- Dependencies: 3 1167
-- Name: estimated_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION estimated_extent(text, text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-1.5', 'LWGEOM_estimated_extent';


ALTER FUNCTION public.estimated_extent(text, text, text) OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 21520)
-- Dependencies: 1161 3 1161
-- Name: expand(box3d, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION expand(box3d, double precision) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_expand';


ALTER FUNCTION public.expand(box3d, double precision) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 21522)
-- Dependencies: 1167 3 1167
-- Name: expand(box2d, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION expand(box2d, double precision) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_expand';


ALTER FUNCTION public.expand(box2d, double precision) OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 21524)
-- Dependencies: 3 1157 1157
-- Name: expand(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION expand(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_expand';


ALTER FUNCTION public.expand(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 528 (class 1255 OID 21882)
-- Dependencies: 3 1157 1157
-- Name: exteriorring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION exteriorring(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_exteriorring_polygon';


ALTER FUNCTION public.exteriorring(geometry) OWNER TO postgres;

--
-- TOC entry 155 (class 1255 OID 21454)
-- Dependencies: 1169 3
-- Name: factor(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION factor(chip) RETURNS real
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getFactor';


ALTER FUNCTION public.factor(chip) OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 21617)
-- Dependencies: 3 1424 1167
-- Name: find_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_extent(text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text) OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 21615)
-- Dependencies: 1424 3 1167
-- Name: find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_extent(text, text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || schemaname || '"."' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text, text) OWNER TO postgres;

--
-- TOC entry 332 (class 1255 OID 21653)
-- Dependencies: 3 1424
-- Name: find_srid(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_srid(character varying, character varying, character varying) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schem text;
	tabl text;
	sr int4;
BEGIN
	IF $1 IS NULL THEN
	  RAISE EXCEPTION 'find_srid() - schema is NULL!';
	END IF;
	IF $2 IS NULL THEN
	  RAISE EXCEPTION 'find_srid() - table name is NULL!';
	END IF;
	IF $3 IS NULL THEN
	  RAISE EXCEPTION 'find_srid() - column name is NULL!';
	END IF;
	schem = $1;
	tabl = $2;
-- if the table contains a . and the schema is empty
-- split the table into a schema and a table
-- otherwise drop through to default behavior
	IF ( schem = '' and tabl LIKE '%.%' ) THEN
	 schem = substr(tabl,1,strpos(tabl,'.')-1);
	 tabl = substr(tabl,length(schem)+2);
	ELSE
	 schem = schem || '%';
	END IF;

	select SRID into sr from geometry_columns where f_table_schema like schem and f_table_name = tabl and f_geometry_column = $3;
	IF NOT FOUND THEN
	   RAISE EXCEPTION 'find_srid() - couldnt find the corresponding SRID - is the geometry registered in the GEOMETRY_COLUMNS table?  Is there an uppercase/lowercase missmatch?';
	END IF;
	return sr;
END;
$_$;


ALTER FUNCTION public.find_srid(character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 332
-- Name: FUNCTION find_srid(character varying, character varying, character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION find_srid(character varying, character varying, character varying) IS 'args: a_schema_name, a_table_name, a_geomfield_name - The syntax is find_srid(<db/schema>, <table>, <column>) and the function returns the integer SRID of the specified column by searching through the GEOMETRY_COLUMNS table.';


--
-- TOC entry 316 (class 1255 OID 21636)
-- Dependencies: 3 1424
-- Name: fix_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fix_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	mislinked record;
	result text;
	linked integer;
	deleted integer;
	foundschema integer;
BEGIN

	-- Since 7.3 schema support has been added.
	-- Previous postgis versions used to put the database name in
	-- the schema column. This needs to be fixed, so we try to
	-- set the correct schema for each geometry_colums record
	-- looking at table, column, type and srid.
	UPDATE geometry_columns SET f_table_schema = n.nspname
		FROM pg_namespace n, pg_class c, pg_attribute a,
			pg_constraint sridcheck, pg_constraint typecheck
			WHERE ( f_table_schema is NULL
		OR f_table_schema = ''
			OR f_table_schema NOT IN (
					SELECT nspname::varchar
					FROM pg_namespace nn, pg_class cc, pg_attribute aa
					WHERE cc.relnamespace = nn.oid
					AND cc.relname = f_table_name::name
					AND aa.attrelid = cc.oid
					AND aa.attname = f_geometry_column::name))
			AND f_table_name::name = c.relname
			AND c.oid = a.attrelid
			AND c.relnamespace = n.oid
			AND f_geometry_column::name = a.attname

			AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(srid(% = %)'
			AND sridcheck.consrc ~ textcat(' = ', srid::text)

			AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype(%) = ''%''::text) OR (% IS NULL))'
			AND typecheck.consrc ~ textcat(' = ''', type::text)

			AND NOT EXISTS (
					SELECT oid FROM geometry_columns gc
					WHERE c.relname::varchar = gc.f_table_name
					AND n.nspname::varchar = gc.f_table_schema
					AND a.attname::varchar = gc.f_geometry_column
			);

	GET DIAGNOSTICS foundschema = ROW_COUNT;

	-- no linkage to system table needed
	return 'fixed:'||foundschema::text;

END;
$$;


ALTER FUNCTION public.fix_geometry_columns() OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 21505)
-- Dependencies: 3 1157 1157
-- Name: force_2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_2d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_2d';


ALTER FUNCTION public.force_2d(geometry) OWNER TO postgres;

--
-- TOC entry 210 (class 1255 OID 21509)
-- Dependencies: 3 1157 1157
-- Name: force_3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_3d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_3dz';


ALTER FUNCTION public.force_3d(geometry) OWNER TO postgres;

--
-- TOC entry 212 (class 1255 OID 21511)
-- Dependencies: 3 1157 1157
-- Name: force_3dm(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_3dm(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_3dm';


ALTER FUNCTION public.force_3dm(geometry) OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 21507)
-- Dependencies: 1157 3 1157
-- Name: force_3dz(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_3dz(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_3dz';


ALTER FUNCTION public.force_3dz(geometry) OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 21513)
-- Dependencies: 3 1157 1157
-- Name: force_4d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_4d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_4d';


ALTER FUNCTION public.force_4d(geometry) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 21515)
-- Dependencies: 3 1157 1157
-- Name: force_collection(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_collection(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_collection';


ALTER FUNCTION public.force_collection(geometry) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 21530)
-- Dependencies: 1157 1157 3
-- Name: forcerhr(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION forcerhr(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_forceRHR_poly';


ALTER FUNCTION public.forcerhr(geometry) OWNER TO postgres;

--
-- TOC entry 729 (class 1255 OID 22092)
-- Dependencies: 3 1184 1157
-- Name: geography(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography(geometry) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_from_geometry';


ALTER FUNCTION public.geography(geometry) OWNER TO postgres;

--
-- TOC entry 718 (class 1255 OID 22075)
-- Dependencies: 3 1184 1184
-- Name: geography(geography, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography(geography, integer, boolean) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_enforce_typmod';


ALTER FUNCTION public.geography(geography, integer, boolean) OWNER TO postgres;

--
-- TOC entry 746 (class 1255 OID 22122)
-- Dependencies: 1184 3 1184
-- Name: geography_cmp(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_cmp(geography, geography) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_cmp';


ALTER FUNCTION public.geography_cmp(geography, geography) OWNER TO postgres;

--
-- TOC entry 745 (class 1255 OID 22121)
-- Dependencies: 1184 3 1184
-- Name: geography_eq(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_eq(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_eq';


ALTER FUNCTION public.geography_eq(geography, geography) OWNER TO postgres;

--
-- TOC entry 744 (class 1255 OID 22120)
-- Dependencies: 1184 3 1184
-- Name: geography_ge(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_ge(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_ge';


ALTER FUNCTION public.geography_ge(geography, geography) OWNER TO postgres;

--
-- TOC entry 732 (class 1255 OID 22097)
-- Dependencies: 3
-- Name: geography_gist_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_compress(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_compress';


ALTER FUNCTION public.geography_gist_compress(internal) OWNER TO postgres;

--
-- TOC entry 731 (class 1255 OID 22096)
-- Dependencies: 3 1157
-- Name: geography_gist_consistent(internal, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_consistent(internal, geometry, integer) RETURNS boolean
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_consistent';


ALTER FUNCTION public.geography_gist_consistent(internal, geometry, integer) OWNER TO postgres;

--
-- TOC entry 737 (class 1255 OID 22102)
-- Dependencies: 3
-- Name: geography_gist_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_decompress(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_decompress';


ALTER FUNCTION public.geography_gist_decompress(internal) OWNER TO postgres;

--
-- TOC entry 739 (class 1255 OID 22104)
-- Dependencies: 3
-- Name: geography_gist_join_selectivity(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_join_selectivity(internal, oid, internal, smallint) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_join_selectivity';


ALTER FUNCTION public.geography_gist_join_selectivity(internal, oid, internal, smallint) OWNER TO postgres;

--
-- TOC entry 733 (class 1255 OID 22098)
-- Dependencies: 3
-- Name: geography_gist_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_penalty';


ALTER FUNCTION public.geography_gist_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 734 (class 1255 OID 22099)
-- Dependencies: 3
-- Name: geography_gist_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_picksplit(internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_picksplit';


ALTER FUNCTION public.geography_gist_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 736 (class 1255 OID 22101)
-- Dependencies: 3 1167 1167
-- Name: geography_gist_same(box2d, box2d, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_same(box2d, box2d, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_same';


ALTER FUNCTION public.geography_gist_same(box2d, box2d, internal) OWNER TO postgres;

--
-- TOC entry 738 (class 1255 OID 22103)
-- Dependencies: 3
-- Name: geography_gist_selectivity(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_selectivity(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_selectivity';


ALTER FUNCTION public.geography_gist_selectivity(internal, oid, internal, integer) OWNER TO postgres;

--
-- TOC entry 735 (class 1255 OID 22100)
-- Dependencies: 3
-- Name: geography_gist_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gist_union(bytea, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'geography_gist_union';


ALTER FUNCTION public.geography_gist_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 743 (class 1255 OID 22119)
-- Dependencies: 1184 1184 3
-- Name: geography_gt(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_gt(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_gt';


ALTER FUNCTION public.geography_gt(geography, geography) OWNER TO postgres;

--
-- TOC entry 742 (class 1255 OID 22118)
-- Dependencies: 1184 3 1184
-- Name: geography_le(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_le(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_le';


ALTER FUNCTION public.geography_le(geography, geography) OWNER TO postgres;

--
-- TOC entry 741 (class 1255 OID 22117)
-- Dependencies: 1184 3 1184
-- Name: geography_lt(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_lt(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_lt';


ALTER FUNCTION public.geography_lt(geography, geography) OWNER TO postgres;

--
-- TOC entry 740 (class 1255 OID 22105)
-- Dependencies: 1184 3 1184
-- Name: geography_overlaps(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_overlaps(geography, geography) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_overlaps';


ALTER FUNCTION public.geography_overlaps(geography, geography) OWNER TO postgres;

--
-- TOC entry 726 (class 1255 OID 22084)
-- Dependencies: 3
-- Name: geography_typmod_dims(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_typmod_dims(integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_typmod_dims';


ALTER FUNCTION public.geography_typmod_dims(integer) OWNER TO postgres;

--
-- TOC entry 727 (class 1255 OID 22085)
-- Dependencies: 3
-- Name: geography_typmod_srid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_typmod_srid(integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_typmod_srid';


ALTER FUNCTION public.geography_typmod_srid(integer) OWNER TO postgres;

--
-- TOC entry 728 (class 1255 OID 22086)
-- Dependencies: 3
-- Name: geography_typmod_type(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geography_typmod_type(integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_typmod_type';


ALTER FUNCTION public.geography_typmod_type(integer) OWNER TO postgres;

--
-- TOC entry 617 (class 1255 OID 21971)
-- Dependencies: 3 1157
-- Name: geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text) OWNER TO postgres;

--
-- TOC entry 615 (class 1255 OID 21969)
-- Dependencies: 3 1157
-- Name: geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 670 (class 1255 OID 22022)
-- Dependencies: 3 1157
-- Name: geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 668 (class 1255 OID 22020)
-- Dependencies: 3 1157
-- Name: geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 71 (class 1255 OID 21321)
-- Dependencies: 1164 3 1157
-- Name: geometry(box3d_extent); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry(box3d_extent) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_LWGEOM';


ALTER FUNCTION public.geometry(box3d_extent) OWNER TO postgres;

--
-- TOC entry 370 (class 1255 OID 21693)
-- Dependencies: 3 1157 1167
-- Name: geometry(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry(box2d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_to_LWGEOM';


ALTER FUNCTION public.geometry(box2d) OWNER TO postgres;

--
-- TOC entry 371 (class 1255 OID 21694)
-- Dependencies: 3 1157 1161
-- Name: geometry(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry(box3d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_LWGEOM';


ALTER FUNCTION public.geometry(box3d) OWNER TO postgres;

--
-- TOC entry 372 (class 1255 OID 21695)
-- Dependencies: 3 1157
-- Name: geometry(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'parse_WKT_lwgeom';


ALTER FUNCTION public.geometry(text) OWNER TO postgres;

--
-- TOC entry 373 (class 1255 OID 21696)
-- Dependencies: 3 1157 1169
-- Name: geometry(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry(chip) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_to_LWGEOM';


ALTER FUNCTION public.geometry(chip) OWNER TO postgres;

--
-- TOC entry 374 (class 1255 OID 21697)
-- Dependencies: 3 1157
-- Name: geometry(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_bytea';


ALTER FUNCTION public.geometry(bytea) OWNER TO postgres;

--
-- TOC entry 730 (class 1255 OID 22094)
-- Dependencies: 3 1157 1184
-- Name: geometry(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry(geography) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geometry_from_geography';


ALTER FUNCTION public.geometry(geography) OWNER TO postgres;

--
-- TOC entry 129 (class 1255 OID 21395)
-- Dependencies: 1157 1157 3
-- Name: geometry_above(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_above(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_above';


ALTER FUNCTION public.geometry_above(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 130 (class 1255 OID 21396)
-- Dependencies: 3 1157 1157
-- Name: geometry_below(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_below(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_below';


ALTER FUNCTION public.geometry_below(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 103 (class 1255 OID 21356)
-- Dependencies: 1157 1157 3
-- Name: geometry_cmp(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_cmp(geometry, geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_cmp';


ALTER FUNCTION public.geometry_cmp(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 131 (class 1255 OID 21397)
-- Dependencies: 1157 3 1157
-- Name: geometry_contain(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_contain(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_contain';


ALTER FUNCTION public.geometry_contain(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 132 (class 1255 OID 21398)
-- Dependencies: 1157 1157 3
-- Name: geometry_contained(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_contained(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_contained';


ALTER FUNCTION public.geometry_contained(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 102 (class 1255 OID 21355)
-- Dependencies: 3 1157 1157
-- Name: geometry_eq(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_eq(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_eq';


ALTER FUNCTION public.geometry_eq(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 101 (class 1255 OID 21354)
-- Dependencies: 1157 1157 3
-- Name: geometry_ge(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_ge(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_ge';


ALTER FUNCTION public.geometry_ge(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 122 (class 1255 OID 21388)
-- Dependencies: 3
-- Name: geometry_gist_joinsel(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_gist_joinsel(internal, oid, internal, smallint) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_joinsel';


ALTER FUNCTION public.geometry_gist_joinsel(internal, oid, internal, smallint) OWNER TO postgres;

--
-- TOC entry 121 (class 1255 OID 21387)
-- Dependencies: 3
-- Name: geometry_gist_sel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_gist_sel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_sel';


ALTER FUNCTION public.geometry_gist_sel(internal, oid, internal, integer) OWNER TO postgres;

--
-- TOC entry 100 (class 1255 OID 21353)
-- Dependencies: 3 1157 1157
-- Name: geometry_gt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_gt(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_gt';


ALTER FUNCTION public.geometry_gt(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 99 (class 1255 OID 21352)
-- Dependencies: 3 1157 1157
-- Name: geometry_le(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_le(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_le';


ALTER FUNCTION public.geometry_le(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 127 (class 1255 OID 21393)
-- Dependencies: 3 1157 1157
-- Name: geometry_left(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_left(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_left';


ALTER FUNCTION public.geometry_left(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 98 (class 1255 OID 21351)
-- Dependencies: 3 1157 1157
-- Name: geometry_lt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_lt(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_lt';


ALTER FUNCTION public.geometry_lt(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 125 (class 1255 OID 21391)
-- Dependencies: 1157 1157 3
-- Name: geometry_overabove(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_overabove(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overabove';


ALTER FUNCTION public.geometry_overabove(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 126 (class 1255 OID 21392)
-- Dependencies: 1157 3 1157
-- Name: geometry_overbelow(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_overbelow(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overbelow';


ALTER FUNCTION public.geometry_overbelow(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 133 (class 1255 OID 21399)
-- Dependencies: 3 1157 1157
-- Name: geometry_overlap(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_overlap(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overlap';


ALTER FUNCTION public.geometry_overlap(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 123 (class 1255 OID 21389)
-- Dependencies: 1157 3 1157
-- Name: geometry_overleft(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_overleft(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overleft';


ALTER FUNCTION public.geometry_overleft(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 124 (class 1255 OID 21390)
-- Dependencies: 1157 3 1157
-- Name: geometry_overright(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_overright(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overright';


ALTER FUNCTION public.geometry_overright(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 128 (class 1255 OID 21394)
-- Dependencies: 1157 1157 3
-- Name: geometry_right(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_right(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_right';


ALTER FUNCTION public.geometry_right(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 120 (class 1255 OID 21386)
-- Dependencies: 1157 1157 3
-- Name: geometry_same(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_same(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_samebox';


ALTER FUNCTION public.geometry_same(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 134 (class 1255 OID 21400)
-- Dependencies: 1157 3 1157
-- Name: geometry_samebox(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_samebox(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_samebox';


ALTER FUNCTION public.geometry_samebox(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 566 (class 1255 OID 21920)
-- Dependencies: 3 1157
-- Name: geometryfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometryfromtext(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_text';


ALTER FUNCTION public.geometryfromtext(text) OWNER TO postgres;

--
-- TOC entry 568 (class 1255 OID 21922)
-- Dependencies: 3 1157
-- Name: geometryfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometryfromtext(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_text';


ALTER FUNCTION public.geometryfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 524 (class 1255 OID 21878)
-- Dependencies: 3 1157 1157
-- Name: geometryn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometryn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_geometryn_collection';


ALTER FUNCTION public.geometryn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 536 (class 1255 OID 21890)
-- Dependencies: 3 1157
-- Name: geometrytype(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometrytype(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_getTYPE';


ALTER FUNCTION public.geometrytype(geometry) OWNER TO postgres;

--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 536
-- Name: FUNCTION geometrytype(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION geometrytype(geometry) IS 'args: geomA - Returns the type of the geometry as a string. Eg: LINESTRING, POLYGON, MULTIPOINT, etc.';


--
-- TOC entry 249 (class 1255 OID 21548)
-- Dependencies: 1157 3
-- Name: geomfromewkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromewkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOMFromWKB';


ALTER FUNCTION public.geomfromewkb(bytea) OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 21550)
-- Dependencies: 3 1157
-- Name: geomfromewkt(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromewkt(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'parse_WKT_lwgeom';


ALTER FUNCTION public.geomfromewkt(text) OWNER TO postgres;

--
-- TOC entry 570 (class 1255 OID 21924)
-- Dependencies: 3 1157
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geometryfromtext($1)$_$;


ALTER FUNCTION public.geomfromtext(text) OWNER TO postgres;

--
-- TOC entry 572 (class 1255 OID 21926)
-- Dependencies: 3 1157
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geometryfromtext($1, $2)$_$;


ALTER FUNCTION public.geomfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 619 (class 1255 OID 21973)
-- Dependencies: 3 1157
-- Name: geomfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromwkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_WKB';


ALTER FUNCTION public.geomfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 621 (class 1255 OID 21975)
-- Dependencies: 3 1157
-- Name: geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT setSRID(GeomFromWKB($1), $2)$_$;


ALTER FUNCTION public.geomfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 424 (class 1255 OID 21763)
-- Dependencies: 3 1157 1157 1157
-- Name: geomunion(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomunion(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geomunion';


ALTER FUNCTION public.geomunion(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 333 (class 1255 OID 21654)
-- Dependencies: 3 1424
-- Name: get_proj4_from_srid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_proj4_from_srid(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
BEGIN
	RETURN proj4text::text FROM spatial_ref_sys WHERE srid= $1;
END;
$_$;


ALTER FUNCTION public.get_proj4_from_srid(integer) OWNER TO postgres;

--
-- TOC entry 147 (class 1255 OID 21446)
-- Dependencies: 1157 3 1167
-- Name: getbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getbbox(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX2DFLOAT4';


ALTER FUNCTION public.getbbox(geometry) OWNER TO postgres;

--
-- TOC entry 146 (class 1255 OID 21445)
-- Dependencies: 3 1157
-- Name: getsrid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getsrid(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_getSRID';


ALTER FUNCTION public.getsrid(geometry) OWNER TO postgres;

--
-- TOC entry 693 (class 1255 OID 22046)
-- Dependencies: 3
-- Name: gettransactionid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gettransactionid() RETURNS xid
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'getTransactionID';


ALTER FUNCTION public.gettransactionid() OWNER TO postgres;

--
-- TOC entry 149 (class 1255 OID 21448)
-- Dependencies: 3 1157
-- Name: hasbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hasbbox(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_hasBBOX';


ALTER FUNCTION public.hasbbox(geometry) OWNER TO postgres;

--
-- TOC entry 153 (class 1255 OID 21452)
-- Dependencies: 1169 3
-- Name: height(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION height(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getHeight';


ALTER FUNCTION public.height(chip) OWNER TO postgres;

--
-- TOC entry 534 (class 1255 OID 21888)
-- Dependencies: 3 1157 1157
-- Name: interiorringn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interiorringn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_interiorringn_polygon';


ALTER FUNCTION public.interiorringn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 399 (class 1255 OID 21738)
-- Dependencies: 3 1157 1157 1157
-- Name: intersection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intersection(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'intersection';


ALTER FUNCTION public.intersection(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 451 (class 1255 OID 21805)
-- Dependencies: 3 1157 1157
-- Name: intersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intersects(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'intersects';


ALTER FUNCTION public.intersects(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 552 (class 1255 OID 21906)
-- Dependencies: 3 1157
-- Name: isclosed(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isclosed(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_isclosed_linestring';


ALTER FUNCTION public.isclosed(geometry) OWNER TO postgres;

--
-- TOC entry 554 (class 1255 OID 21908)
-- Dependencies: 3 1157
-- Name: isempty(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isempty(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_isempty';


ALTER FUNCTION public.isempty(geometry) OWNER TO postgres;

--
-- TOC entry 476 (class 1255 OID 21830)
-- Dependencies: 3 1157
-- Name: isring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isring(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'isring';


ALTER FUNCTION public.isring(geometry) OWNER TO postgres;

--
-- TOC entry 480 (class 1255 OID 21834)
-- Dependencies: 3 1157
-- Name: issimple(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION issimple(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'issimple';


ALTER FUNCTION public.issimple(geometry) OWNER TO postgres;

--
-- TOC entry 472 (class 1255 OID 21826)
-- Dependencies: 3 1157
-- Name: isvalid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isvalid(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'isvalid';


ALTER FUNCTION public.isvalid(geometry) OWNER TO postgres;

--
-- TOC entry 178 (class 1255 OID 21477)
-- Dependencies: 3 1157
-- Name: length(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_length_linestring';


ALTER FUNCTION public.length(geometry) OWNER TO postgres;

--
-- TOC entry 176 (class 1255 OID 21475)
-- Dependencies: 3 1157
-- Name: length2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_length2d_linestring';


ALTER FUNCTION public.length2d(geometry) OWNER TO postgres;

--
-- TOC entry 184 (class 1255 OID 21483)
-- Dependencies: 1153 3 1157
-- Name: length2d_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length2d_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_length2d_ellipsoid';


ALTER FUNCTION public.length2d_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 174 (class 1255 OID 21473)
-- Dependencies: 3 1157
-- Name: length3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_length_linestring';


ALTER FUNCTION public.length3d(geometry) OWNER TO postgres;

--
-- TOC entry 180 (class 1255 OID 21479)
-- Dependencies: 1157 1153 3
-- Name: length3d_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length3d_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_length_ellipsoid_linestring';


ALTER FUNCTION public.length3d_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 182 (class 1255 OID 21481)
-- Dependencies: 1153 3 1157
-- Name: length_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_length_ellipsoid_linestring';


ALTER FUNCTION public.length_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 388 (class 1255 OID 21727)
-- Dependencies: 3 1157 1157
-- Name: line_interpolate_point(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION line_interpolate_point(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_interpolate_point';


ALTER FUNCTION public.line_interpolate_point(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 392 (class 1255 OID 21731)
-- Dependencies: 3 1157 1157
-- Name: line_locate_point(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION line_locate_point(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_locate_point';


ALTER FUNCTION public.line_locate_point(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 390 (class 1255 OID 21729)
-- Dependencies: 3 1157 1157
-- Name: line_substring(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION line_substring(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_substring';


ALTER FUNCTION public.line_substring(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 21568)
-- Dependencies: 3 1157 1157
-- Name: linefrommultipoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefrommultipoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_from_mpoint';


ALTER FUNCTION public.linefrommultipoint(geometry) OWNER TO postgres;

--
-- TOC entry 578 (class 1255 OID 21932)
-- Dependencies: 3 1157
-- Name: linefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'LINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text) OWNER TO postgres;

--
-- TOC entry 580 (class 1255 OID 21934)
-- Dependencies: 3 1157
-- Name: linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'LINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 629 (class 1255 OID 21983)
-- Dependencies: 3 1157
-- Name: linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 627 (class 1255 OID 21981)
-- Dependencies: 3 1157
-- Name: linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 21590)
-- Dependencies: 3 1157 1157
-- Name: linemerge(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linemerge(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'linemerge';


ALTER FUNCTION public.linemerge(geometry) OWNER TO postgres;

--
-- TOC entry 582 (class 1255 OID 21936)
-- Dependencies: 3 1157
-- Name: linestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1)$_$;


ALTER FUNCTION public.linestringfromtext(text) OWNER TO postgres;

--
-- TOC entry 583 (class 1255 OID 21937)
-- Dependencies: 3 1157
-- Name: linestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1, $2)$_$;


ALTER FUNCTION public.linestringfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 633 (class 1255 OID 21987)
-- Dependencies: 3 1157
-- Name: linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 631 (class 1255 OID 21985)
-- Dependencies: 3 1157
-- Name: linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 396 (class 1255 OID 21735)
-- Dependencies: 3 1157 1157
-- Name: locate_along_measure(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION locate_along_measure(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT locate_between_measures($1, $2, $2) $_$;


ALTER FUNCTION public.locate_along_measure(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 394 (class 1255 OID 21733)
-- Dependencies: 3 1157 1157
-- Name: locate_between_measures(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION locate_between_measures(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_locate_between_m';


ALTER FUNCTION public.locate_between_measures(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 664 (class 1255 OID 22040)
-- Dependencies: 3
-- Name: lockrow(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow(current_schema(), $1, $2, $3, now()::timestamp+'1:00'); $_$;


ALTER FUNCTION public.lockrow(text, text, text) OWNER TO postgres;

--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 664
-- Name: FUNCTION lockrow(text, text, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION lockrow(text, text, text) IS 'args: a_table_name, a_row_key, an_auth_token - Set lock/authorization for specific row in table';


--
-- TOC entry 687 (class 1255 OID 22039)
-- Dependencies: 3
-- Name: lockrow(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text, text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow($1, $2, $3, $4, now()::timestamp+'1:00'); $_$;


ALTER FUNCTION public.lockrow(text, text, text, text) OWNER TO postgres;

--
-- TOC entry 688 (class 1255 OID 22041)
-- Dependencies: 3
-- Name: lockrow(text, text, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text, timestamp without time zone) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow(current_schema(), $1, $2, $3, $4); $_$;


ALTER FUNCTION public.lockrow(text, text, text, timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 688
-- Name: FUNCTION lockrow(text, text, text, timestamp without time zone); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION lockrow(text, text, text, timestamp without time zone) IS 'args: a_table_name, a_row_key, an_auth_token, expire_dt - Set lock/authorization for specific row in table';


--
-- TOC entry 686 (class 1255 OID 22038)
-- Dependencies: 3 1424
-- Name: lockrow(text, text, text, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text, text, timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$ 
DECLARE
	myschema alias for $1;
	mytable alias for $2;
	myrid   alias for $3;
	authid alias for $4;
	expires alias for $5;
	ret int;
	mytoid oid;
	myrec RECORD;
	
BEGIN

	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
	END IF;

	EXECUTE 'DELETE FROM authorization_table WHERE expires < now()'; 

	SELECT c.oid INTO mytoid FROM pg_class c, pg_namespace n
		WHERE c.relname = mytable
		AND c.relnamespace = n.oid
		AND n.nspname = myschema;

	-- RAISE NOTICE 'toid: %', mytoid;

	FOR myrec IN SELECT * FROM authorization_table WHERE 
		toid = mytoid AND rid = myrid
	LOOP
		IF myrec.authid != authid THEN
			RETURN 0;
		ELSE
			RETURN 1;
		END IF;
	END LOOP;

	EXECUTE 'INSERT INTO authorization_table VALUES ('||
		quote_literal(mytoid::text)||','||quote_literal(myrid)||
		','||quote_literal(expires::text)||
		','||quote_literal(authid) ||')';

	GET DIAGNOSTICS ret = ROW_COUNT;

	RETURN ret;
END;
$_$;


ALTER FUNCTION public.lockrow(text, text, text, text, timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 686
-- Name: FUNCTION lockrow(text, text, text, text, timestamp without time zone); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION lockrow(text, text, text, text, timestamp without time zone) IS 'args: a_schema_name, a_table_name, a_row_key, an_auth_token, expire_dt - Set lock/authorization for specific row in table';


--
-- TOC entry 695 (class 1255 OID 22048)
-- Dependencies: 3 1424
-- Name: longtransactionsenabled(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION longtransactionsenabled() RETURNS boolean
    LANGUAGE plpgsql
    AS $$ 
DECLARE
	rec RECORD;
BEGIN
	FOR rec IN SELECT oid FROM pg_class WHERE relname = 'authorized_tables'
	LOOP
		return 't';
	END LOOP;
	return 'f';
END;
$$;


ALTER FUNCTION public.longtransactionsenabled() OWNER TO postgres;

--
-- TOC entry 136 (class 1255 OID 21414)
-- Dependencies: 3
-- Name: lwgeom_gist_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lwgeom_gist_compress(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_compress';


ALTER FUNCTION public.lwgeom_gist_compress(internal) OWNER TO postgres;

--
-- TOC entry 135 (class 1255 OID 21413)
-- Dependencies: 1157 3
-- Name: lwgeom_gist_consistent(internal, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lwgeom_gist_consistent(internal, geometry, integer) RETURNS boolean
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_consistent';


ALTER FUNCTION public.lwgeom_gist_consistent(internal, geometry, integer) OWNER TO postgres;

--
-- TOC entry 141 (class 1255 OID 21419)
-- Dependencies: 3
-- Name: lwgeom_gist_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lwgeom_gist_decompress(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_decompress';


ALTER FUNCTION public.lwgeom_gist_decompress(internal) OWNER TO postgres;

--
-- TOC entry 137 (class 1255 OID 21415)
-- Dependencies: 3
-- Name: lwgeom_gist_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lwgeom_gist_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_penalty';


ALTER FUNCTION public.lwgeom_gist_penalty(internal, internal, internal) OWNER TO postgres;

--
-- TOC entry 138 (class 1255 OID 21416)
-- Dependencies: 3
-- Name: lwgeom_gist_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lwgeom_gist_picksplit(internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_picksplit';


ALTER FUNCTION public.lwgeom_gist_picksplit(internal, internal) OWNER TO postgres;

--
-- TOC entry 140 (class 1255 OID 21418)
-- Dependencies: 1167 1167 3
-- Name: lwgeom_gist_same(box2d, box2d, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lwgeom_gist_same(box2d, box2d, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_same';


ALTER FUNCTION public.lwgeom_gist_same(box2d, box2d, internal) OWNER TO postgres;

--
-- TOC entry 139 (class 1255 OID 21417)
-- Dependencies: 3
-- Name: lwgeom_gist_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lwgeom_gist_union(bytea, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_union';


ALTER FUNCTION public.lwgeom_gist_union(bytea, internal) OWNER TO postgres;

--
-- TOC entry 546 (class 1255 OID 21900)
-- Dependencies: 3 1157
-- Name: m(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION m(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_m_point';


ALTER FUNCTION public.m(geometry) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 21561)
-- Dependencies: 1157 3 1167 1157
-- Name: makebox2d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makebox2d(geometry, geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_construct';


ALTER FUNCTION public.makebox2d(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 21563)
-- Dependencies: 1157 3 1161 1157
-- Name: makebox3d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makebox3d(geometry, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_construct';


ALTER FUNCTION public.makebox3d(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 21570)
-- Dependencies: 3 1157 1157 1157
-- Name: makeline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makeline(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makeline';


ALTER FUNCTION public.makeline(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 21565)
-- Dependencies: 1157 3 1160
-- Name: makeline_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makeline_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makeline_garray';


ALTER FUNCTION public.makeline_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 21553)
-- Dependencies: 3 1157
-- Name: makepoint(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepoint(double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint';


ALTER FUNCTION public.makepoint(double precision, double precision) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 21555)
-- Dependencies: 3 1157
-- Name: makepoint(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepoint(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint';


ALTER FUNCTION public.makepoint(double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 21557)
-- Dependencies: 3 1157
-- Name: makepoint(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepoint(double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint';


ALTER FUNCTION public.makepoint(double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 21559)
-- Dependencies: 3 1157
-- Name: makepointm(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepointm(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint3dm';


ALTER FUNCTION public.makepointm(double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 21583)
-- Dependencies: 1157 3 1157
-- Name: makepolygon(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepolygon(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoly';


ALTER FUNCTION public.makepolygon(geometry) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 21581)
-- Dependencies: 1157 3 1157 1160
-- Name: makepolygon(geometry, geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepolygon(geometry, geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoly';


ALTER FUNCTION public.makepolygon(geometry, geometry[]) OWNER TO postgres;

--
-- TOC entry 672 (class 1255 OID 22024)
-- Dependencies: 3 1157 1157
-- Name: max_distance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION max_distance(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_maxdistance2d_linestring';


ALTER FUNCTION public.max_distance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 166 (class 1255 OID 21465)
-- Dependencies: 3 1157
-- Name: mem_size(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mem_size(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_mem_size';


ALTER FUNCTION public.mem_size(geometry) OWNER TO postgres;

--
-- TOC entry 594 (class 1255 OID 21948)
-- Dependencies: 3 1157
-- Name: mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTILINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text) OWNER TO postgres;

--
-- TOC entry 592 (class 1255 OID 21946)
-- Dependencies: 3 1157
-- Name: mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 657 (class 1255 OID 22010)
-- Dependencies: 3 1157
-- Name: mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 655 (class 1255 OID 22008)
-- Dependencies: 3 1157
-- Name: mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 602 (class 1255 OID 21956)
-- Dependencies: 3 1157
-- Name: mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text) OWNER TO postgres;

--
-- TOC entry 600 (class 1255 OID 21954)
-- Dependencies: 3 1157
-- Name: mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1,$2)) = 'MULTIPOINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 645 (class 1255 OID 21999)
-- Dependencies: 3 1157
-- Name: mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 643 (class 1255 OID 21997)
-- Dependencies: 3 1157
-- Name: mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 609 (class 1255 OID 21963)
-- Dependencies: 3 1157
-- Name: mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text) OWNER TO postgres;

--
-- TOC entry 607 (class 1255 OID 21961)
-- Dependencies: 3 1157
-- Name: mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 661 (class 1255 OID 22014)
-- Dependencies: 3 1157
-- Name: mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 659 (class 1255 OID 22012)
-- Dependencies: 3 1157
-- Name: mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 21518)
-- Dependencies: 1157 3 1157
-- Name: multi(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multi(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_multi';


ALTER FUNCTION public.multi(geometry) OWNER TO postgres;

--
-- TOC entry 653 (class 1255 OID 22006)
-- Dependencies: 3 1157
-- Name: multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 651 (class 1255 OID 22005)
-- Dependencies: 3 1157
-- Name: multilinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 596 (class 1255 OID 21950)
-- Dependencies: 3 1157
-- Name: multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


ALTER FUNCTION public.multilinestringfromtext(text) OWNER TO postgres;

--
-- TOC entry 598 (class 1255 OID 21952)
-- Dependencies: 3 1157
-- Name: multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MLineFromText($1, $2)$_$;


ALTER FUNCTION public.multilinestringfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 606 (class 1255 OID 21959)
-- Dependencies: 3 1157
-- Name: multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1)$_$;


ALTER FUNCTION public.multipointfromtext(text) OWNER TO postgres;

--
-- TOC entry 604 (class 1255 OID 21958)
-- Dependencies: 3 1157
-- Name: multipointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1, $2)$_$;


ALTER FUNCTION public.multipointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 649 (class 1255 OID 22003)
-- Dependencies: 3 1157
-- Name: multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 647 (class 1255 OID 22001)
-- Dependencies: 3 1157
-- Name: multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 666 (class 1255 OID 22018)
-- Dependencies: 3 1157
-- Name: multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 663 (class 1255 OID 22016)
-- Dependencies: 3 1157
-- Name: multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 613 (class 1255 OID 21967)
-- Dependencies: 3 1157
-- Name: multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1)$_$;


ALTER FUNCTION public.multipolygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 611 (class 1255 OID 21965)
-- Dependencies: 3 1157
-- Name: multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1, $2)$_$;


ALTER FUNCTION public.multipolygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 21536)
-- Dependencies: 1157 3
-- Name: ndims(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ndims(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_ndims';


ALTER FUNCTION public.ndims(geometry) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 21532)
-- Dependencies: 3 1157 1157
-- Name: noop(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION noop(geometry) RETURNS geometry
    LANGUAGE c STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_noop';


ALTER FUNCTION public.noop(geometry) OWNER TO postgres;

--
-- TOC entry 170 (class 1255 OID 21469)
-- Dependencies: 1157 3
-- Name: npoints(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION npoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_npoints';


ALTER FUNCTION public.npoints(geometry) OWNER TO postgres;

--
-- TOC entry 172 (class 1255 OID 21471)
-- Dependencies: 1157 3
-- Name: nrings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION nrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_nrings';


ALTER FUNCTION public.nrings(geometry) OWNER TO postgres;

--
-- TOC entry 522 (class 1255 OID 21876)
-- Dependencies: 3 1157
-- Name: numgeometries(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numgeometries(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numgeometries_collection';


ALTER FUNCTION public.numgeometries(geometry) OWNER TO postgres;

--
-- TOC entry 532 (class 1255 OID 21886)
-- Dependencies: 3 1157
-- Name: numinteriorring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numinteriorring(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numinteriorrings_polygon';


ALTER FUNCTION public.numinteriorring(geometry) OWNER TO postgres;

--
-- TOC entry 530 (class 1255 OID 21884)
-- Dependencies: 3 1157
-- Name: numinteriorrings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numinteriorrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numinteriorrings_polygon';


ALTER FUNCTION public.numinteriorrings(geometry) OWNER TO postgres;

--
-- TOC entry 520 (class 1255 OID 21874)
-- Dependencies: 3 1157
-- Name: numpoints(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numpoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numpoints_linestring';


ALTER FUNCTION public.numpoints(geometry) OWNER TO postgres;

--
-- TOC entry 469 (class 1255 OID 21823)
-- Dependencies: 3 1157 1157
-- Name: overlaps(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "overlaps"(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'overlaps';


ALTER FUNCTION public."overlaps"(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 190 (class 1255 OID 21489)
-- Dependencies: 1157 3
-- Name: perimeter(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perimeter(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_perimeter_poly';


ALTER FUNCTION public.perimeter(geometry) OWNER TO postgres;

--
-- TOC entry 188 (class 1255 OID 21487)
-- Dependencies: 3 1157
-- Name: perimeter2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perimeter2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_perimeter2d_poly';


ALTER FUNCTION public.perimeter2d(geometry) OWNER TO postgres;

--
-- TOC entry 186 (class 1255 OID 21485)
-- Dependencies: 1157 3
-- Name: perimeter3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perimeter3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_perimeter_poly';


ALTER FUNCTION public.perimeter3d(geometry) OWNER TO postgres;

--
-- TOC entry 432 (class 1255 OID 21777)
-- Dependencies: 3 1160 1181
-- Name: pgis_geometry_accum_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_geometry_accum_finalfn(pgis_abs) RETURNS geometry[]
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'pgis_geometry_accum_finalfn';


ALTER FUNCTION public.pgis_geometry_accum_finalfn(pgis_abs) OWNER TO postgres;

--
-- TOC entry 431 (class 1255 OID 21776)
-- Dependencies: 3 1181 1181 1157
-- Name: pgis_geometry_accum_transfn(pgis_abs, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_geometry_accum_transfn(pgis_abs, geometry) RETURNS pgis_abs
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'pgis_geometry_accum_transfn';


ALTER FUNCTION public.pgis_geometry_accum_transfn(pgis_abs, geometry) OWNER TO postgres;

--
-- TOC entry 434 (class 1255 OID 21779)
-- Dependencies: 3 1157 1181
-- Name: pgis_geometry_collect_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_geometry_collect_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'pgis_geometry_collect_finalfn';


ALTER FUNCTION public.pgis_geometry_collect_finalfn(pgis_abs) OWNER TO postgres;

--
-- TOC entry 436 (class 1255 OID 21781)
-- Dependencies: 3 1157 1181
-- Name: pgis_geometry_makeline_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_geometry_makeline_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'pgis_geometry_makeline_finalfn';


ALTER FUNCTION public.pgis_geometry_makeline_finalfn(pgis_abs) OWNER TO postgres;

--
-- TOC entry 435 (class 1255 OID 21780)
-- Dependencies: 3 1157 1181
-- Name: pgis_geometry_polygonize_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_geometry_polygonize_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'pgis_geometry_polygonize_finalfn';


ALTER FUNCTION public.pgis_geometry_polygonize_finalfn(pgis_abs) OWNER TO postgres;

--
-- TOC entry 433 (class 1255 OID 21778)
-- Dependencies: 3 1157 1181
-- Name: pgis_geometry_union_finalfn(pgis_abs); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgis_geometry_union_finalfn(pgis_abs) RETURNS geometry
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'pgis_geometry_union_finalfn';


ALTER FUNCTION public.pgis_geometry_union_finalfn(pgis_abs) OWNER TO postgres;

--
-- TOC entry 202 (class 1255 OID 21501)
-- Dependencies: 3 1157
-- Name: point_inside_circle(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION point_inside_circle(geometry, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_inside_circle_point';


ALTER FUNCTION public.point_inside_circle(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 574 (class 1255 OID 21928)
-- Dependencies: 3 1157
-- Name: pointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text) OWNER TO postgres;

--
-- TOC entry 576 (class 1255 OID 21930)
-- Dependencies: 3 1157
-- Name: pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 625 (class 1255 OID 21979)
-- Dependencies: 3 1157
-- Name: pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 623 (class 1255 OID 21977)
-- Dependencies: 3 1157
-- Name: pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 538 (class 1255 OID 21892)
-- Dependencies: 3 1157 1157
-- Name: pointn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_pointn_linestring';


ALTER FUNCTION public.pointn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 478 (class 1255 OID 21832)
-- Dependencies: 3 1157 1157
-- Name: pointonsurface(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointonsurface(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'pointonsurface';


ALTER FUNCTION public.pointonsurface(geometry) OWNER TO postgres;

--
-- TOC entry 584 (class 1255 OID 21938)
-- Dependencies: 3 1157
-- Name: polyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text) OWNER TO postgres;

--
-- TOC entry 586 (class 1255 OID 21940)
-- Dependencies: 3 1157
-- Name: polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 637 (class 1255 OID 21991)
-- Dependencies: 3 1157
-- Name: polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 635 (class 1255 OID 21989)
-- Dependencies: 3 1157
-- Name: polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 590 (class 1255 OID 21944)
-- Dependencies: 3 1157
-- Name: polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1)$_$;


ALTER FUNCTION public.polygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 588 (class 1255 OID 21942)
-- Dependencies: 3 1157
-- Name: polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1, $2)$_$;


ALTER FUNCTION public.polygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 641 (class 1255 OID 21995)
-- Dependencies: 3 1157
-- Name: polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 639 (class 1255 OID 21993)
-- Dependencies: 3 1157
-- Name: polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 21587)
-- Dependencies: 1157 3 1160
-- Name: polygonize_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonize_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'polygonize_garray';


ALTER FUNCTION public.polygonize_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 318 (class 1255 OID 21637)
-- Dependencies: 3 1424
-- Name: populate_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION populate_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted    integer;
	oldcount    integer;
	probed      integer;
	stale       integer;
	gcs         RECORD;
	gc          RECORD;
	gsrid       integer;
	gndims      integer;
	gtype       text;
	query       text;
	gc_is_valid boolean;

BEGIN
	SELECT count(*) INTO oldcount FROM geometry_columns;
	inserted := 0;

	EXECUTE 'TRUNCATE geometry_columns';

	-- Count the number of geometry columns in all tables and views
	SELECT count(DISTINCT c.oid) INTO probed
	FROM pg_class c,
		 pg_attribute a,
		 pg_type t,
		 pg_namespace n
	WHERE (c.relkind = 'r' OR c.relkind = 'v')
	AND t.typname = 'geometry'
	AND a.attisdropped = false
	AND a.atttypid = t.oid
	AND a.attrelid = c.oid
	AND c.relnamespace = n.oid
	AND n.nspname NOT ILIKE 'pg_temp%';

	-- Iterate through all non-dropped geometry columns
	RAISE DEBUG 'Processing Tables.....';

	FOR gcs IN
	SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'r'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
	LOOP

	inserted := inserted + populate_geometry_columns(gcs.oid);
	END LOOP;

	-- Add views to geometry columns table
	RAISE DEBUG 'Processing Views.....';
	FOR gcs IN
	SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'v'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
	LOOP

	inserted := inserted + populate_geometry_columns(gcs.oid);
	END LOOP;

	IF oldcount > inserted THEN
	stale = oldcount-inserted;
	ELSE
	stale = 0;
	END IF;

	RETURN 'probed:' ||probed|| ' inserted:'||inserted|| ' conflicts:'||probed-inserted|| ' deleted:'||stale;
END

$$;


ALTER FUNCTION public.populate_geometry_columns() OWNER TO postgres;

--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 318
-- Name: FUNCTION populate_geometry_columns(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION populate_geometry_columns() IS 'Ensures geometry columns have appropriate spatial constraints and exist in the geometry_columns table.';


--
-- TOC entry 319 (class 1255 OID 21638)
-- Dependencies: 3 1424
-- Name: populate_geometry_columns(oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION populate_geometry_columns(tbl_oid oid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	gcs         RECORD;
	gc          RECORD;
	gsrid       integer;
	gndims      integer;
	gtype       text;
	query       text;
	gc_is_valid boolean;
	inserted    integer;

BEGIN
	inserted := 0;

	-- Iterate through all geometry columns in this table
	FOR gcs IN
	SELECT n.nspname, c.relname, a.attname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'r'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
		AND c.oid = tbl_oid
	LOOP

	RAISE DEBUG 'Processing table %.%.%', gcs.nspname, gcs.relname, gcs.attname;

	DELETE FROM geometry_columns
	  WHERE f_table_schema = quote_ident(gcs.nspname)
	  AND f_table_name = quote_ident(gcs.relname)
	  AND f_geometry_column = quote_ident(gcs.attname);

	gc_is_valid := true;

	-- Try to find srid check from system tables (pg_constraint)
	gsrid :=
		(SELECT replace(replace(split_part(s.consrc, ' = ', 2), ')', ''), '(', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%srid(% = %');
	IF (gsrid IS NULL) THEN
		-- Try to find srid from the geometry itself
		EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gsrid := gc.srid;

		-- Try to apply srid check to column
		IF (gsrid IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
						 ADD CONSTRAINT ' || quote_ident('enforce_srid_' || gcs.attname) || '
						 CHECK (srid(' || quote_ident(gcs.attname) || ') = ' || gsrid || ')';
			EXCEPTION
				WHEN check_violation THEN
					RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (srid(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gsrid;
					gc_is_valid := false;
			END;
		END IF;
	END IF;

	-- Try to find ndims check from system tables (pg_constraint)
	gndims :=
		(SELECT replace(split_part(s.consrc, ' = ', 2), ')', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%ndims(% = %');
	IF (gndims IS NULL) THEN
		-- Try to find ndims from the geometry itself
		EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gndims := gc.ndims;

		-- Try to apply ndims check to column
		IF (gndims IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
						 ADD CONSTRAINT ' || quote_ident('enforce_dims_' || gcs.attname) || '
						 CHECK (ndims(' || quote_ident(gcs.attname) || ') = '||gndims||')';
			EXCEPTION
				WHEN check_violation THEN
					RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (ndims(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gndims;
					gc_is_valid := false;
			END;
		END IF;
	END IF;

	-- Try to find geotype check from system tables (pg_constraint)
	gtype :=
		(SELECT replace(split_part(s.consrc, '''', 2), ')', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%geometrytype(% = %');
	IF (gtype IS NULL) THEN
		-- Try to find geotype from the geometry itself
		EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gtype := gc.geometrytype;
		--IF (gtype IS NULL) THEN
		--    gtype := 'GEOMETRY';
		--END IF;

		-- Try to apply geometrytype check to column
		IF (gtype IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				ADD CONSTRAINT ' || quote_ident('enforce_geotype_' || gcs.attname) || '
				CHECK ((geometrytype(' || quote_ident(gcs.attname) || ') = ' || quote_literal(gtype) || ') OR (' || quote_ident(gcs.attname) || ' IS NULL))';
			EXCEPTION
				WHEN check_violation THEN
					-- No geometry check can be applied. This column contains a number of geometry types.
					RAISE WARNING 'Could not add geometry type check (%) to table column: %.%.%', gtype, quote_ident(gcs.nspname),quote_ident(gcs.relname),quote_ident(gcs.attname);
			END;
		END IF;
	END IF;

	IF (gsrid IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSIF (gndims IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the number of dimensions', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSIF (gtype IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the geometry type', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSE
		-- Only insert into geometry_columns if table constraints could be applied.
		IF (gc_is_valid) THEN
			INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
			VALUES ('', gcs.nspname, gcs.relname, gcs.attname, gndims, gsrid, gtype);
			inserted := inserted + 1;
		END IF;
	END IF;
	END LOOP;

	-- Add views to geometry columns table
	FOR gcs IN
	SELECT n.nspname, c.relname, a.attname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'v'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
		AND c.oid = tbl_oid
	LOOP
		RAISE DEBUG 'Processing view %.%.%', gcs.nspname, gcs.relname, gcs.attname;

		EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gndims := gc.ndims;

		EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gsrid := gc.srid;

		EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gtype := gc.geometrytype;

		IF (gndims IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine ndims', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSIF (gsrid IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSIF (gtype IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine gtype', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSE
			query := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) ' ||
					 'VALUES ('''', ' || quote_literal(gcs.nspname) || ',' || quote_literal(gcs.relname) || ',' || quote_literal(gcs.attname) || ',' || gndims || ',' || gsrid || ',' || quote_literal(gtype) || ')';
			EXECUTE query;
			inserted := inserted + 1;
		END IF;
	END LOOP;

	RETURN inserted;
END

$$;


ALTER FUNCTION public.populate_geometry_columns(tbl_oid oid) OWNER TO postgres;

--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 319
-- Name: FUNCTION populate_geometry_columns(tbl_oid oid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION populate_geometry_columns(tbl_oid oid) IS 'args: relation_oid - Ensures geometry columns have appropriate spatial constraints and exist in the geometry_columns table.';


--
-- TOC entry 143 (class 1255 OID 21442)
-- Dependencies: 1157 1157 3
-- Name: postgis_addbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_addbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_addBBOX';


ALTER FUNCTION public.postgis_addbbox(geometry) OWNER TO postgres;

--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 143
-- Name: FUNCTION postgis_addbbox(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_addbbox(geometry) IS 'args: geomA - Add bounding box to the geometry.';


--
-- TOC entry 253 (class 1255 OID 21552)
-- Dependencies: 3
-- Name: postgis_cache_bbox(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_cache_bbox() RETURNS trigger
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'cache_bbox';


ALTER FUNCTION public.postgis_cache_bbox() OWNER TO postgres;

--
-- TOC entry 145 (class 1255 OID 21444)
-- Dependencies: 1157 1157 3
-- Name: postgis_dropbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_dropbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dropBBOX';


ALTER FUNCTION public.postgis_dropbbox(geometry) OWNER TO postgres;

--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 145
-- Name: FUNCTION postgis_dropbbox(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_dropbbox(geometry) IS 'args: geomA - Drop the bounding box cache from the geometry.';


--
-- TOC entry 347 (class 1255 OID 21668)
-- Dependencies: 3 1424
-- Name: postgis_full_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_full_version() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
	libver text;
	projver text;
	geosver text;
	libxmlver text;
	usestats bool;
	dbproc text;
	relproc text;
	fullver text;
BEGIN
	SELECT postgis_lib_version() INTO libver;
	SELECT postgis_proj_version() INTO projver;
	SELECT postgis_geos_version() INTO geosver;
	SELECT postgis_libxml_version() INTO libxmlver;
	SELECT postgis_uses_stats() INTO usestats;
	SELECT postgis_scripts_installed() INTO dbproc;
	SELECT postgis_scripts_released() INTO relproc;

	fullver = 'POSTGIS="' || libver || '"';

	IF  geosver IS NOT NULL THEN
		fullver = fullver || ' GEOS="' || geosver || '"';
	END IF;

	IF  projver IS NOT NULL THEN
		fullver = fullver || ' PROJ="' || projver || '"';
	END IF;

	IF  libxmlver IS NOT NULL THEN
		fullver = fullver || ' LIBXML="' || libxmlver || '"';
	END IF;

	IF usestats THEN
		fullver = fullver || ' USE_STATS';
	END IF;

	-- fullver = fullver || ' DBPROC="' || dbproc || '"';
	-- fullver = fullver || ' RELPROC="' || relproc || '"';

	IF dbproc != relproc THEN
		fullver = fullver || ' (procs from ' || dbproc || ' need upgrade)';
	END IF;

	RETURN fullver;
END
$$;


ALTER FUNCTION public.postgis_full_version() OWNER TO postgres;

--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 347
-- Name: FUNCTION postgis_full_version(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_full_version() IS 'Reports full postgis version and build configuration infos.';


--
-- TOC entry 343 (class 1255 OID 21664)
-- Dependencies: 3
-- Name: postgis_geos_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_geos_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_geos_version';


ALTER FUNCTION public.postgis_geos_version() OWNER TO postgres;

--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 343
-- Name: FUNCTION postgis_geos_version(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_geos_version() IS 'Returns the version number of the GEOS library.';


--
-- TOC entry 148 (class 1255 OID 21447)
-- Dependencies: 1157 1167 3
-- Name: postgis_getbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_getbbox(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX2DFLOAT4';


ALTER FUNCTION public.postgis_getbbox(geometry) OWNER TO postgres;

--
-- TOC entry 105 (class 1255 OID 21371)
-- Dependencies: 3
-- Name: postgis_gist_joinsel(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_gist_joinsel(internal, oid, internal, smallint) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_joinsel';


ALTER FUNCTION public.postgis_gist_joinsel(internal, oid, internal, smallint) OWNER TO postgres;

--
-- TOC entry 104 (class 1255 OID 21370)
-- Dependencies: 3
-- Name: postgis_gist_sel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_gist_sel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_sel';


ALTER FUNCTION public.postgis_gist_sel(internal, oid, internal, integer) OWNER TO postgres;

--
-- TOC entry 150 (class 1255 OID 21449)
-- Dependencies: 1157 3
-- Name: postgis_hasbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_hasbbox(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_hasBBOX';


ALTER FUNCTION public.postgis_hasbbox(geometry) OWNER TO postgres;

--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 150
-- Name: FUNCTION postgis_hasbbox(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_hasbbox(geometry) IS 'args: geomA - Returns TRUE if the bbox of this geometry is cached, FALSE otherwise.';


--
-- TOC entry 346 (class 1255 OID 21667)
-- Dependencies: 3
-- Name: postgis_lib_build_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_lib_build_date() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_lib_build_date';


ALTER FUNCTION public.postgis_lib_build_date() OWNER TO postgres;

--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 346
-- Name: FUNCTION postgis_lib_build_date(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_lib_build_date() IS 'Returns build date of the PostGIS library.';


--
-- TOC entry 340 (class 1255 OID 21661)
-- Dependencies: 3
-- Name: postgis_lib_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_lib_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_lib_version';


ALTER FUNCTION public.postgis_lib_version() OWNER TO postgres;

--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 340
-- Name: FUNCTION postgis_lib_version(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_lib_version() IS 'Returns the version number of the PostGIS library.';


--
-- TOC entry 344 (class 1255 OID 21665)
-- Dependencies: 3
-- Name: postgis_libxml_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_libxml_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_libxml_version';


ALTER FUNCTION public.postgis_libxml_version() OWNER TO postgres;

--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 344
-- Name: FUNCTION postgis_libxml_version(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_libxml_version() IS 'Returns the version number of the libxml2 library.';


--
-- TOC entry 234 (class 1255 OID 21533)
-- Dependencies: 3 1157 1157
-- Name: postgis_noop(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_noop(geometry) RETURNS geometry
    LANGUAGE c STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_noop';


ALTER FUNCTION public.postgis_noop(geometry) OWNER TO postgres;

--
-- TOC entry 338 (class 1255 OID 21659)
-- Dependencies: 3
-- Name: postgis_proj_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_proj_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_proj_version';


ALTER FUNCTION public.postgis_proj_version() OWNER TO postgres;

--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 338
-- Name: FUNCTION postgis_proj_version(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_proj_version() IS 'Returns the version number of the PROJ4 library.';


--
-- TOC entry 345 (class 1255 OID 21666)
-- Dependencies: 3
-- Name: postgis_scripts_build_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_scripts_build_date() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '2011-02-11 18:09:02'::text AS version$$;


ALTER FUNCTION public.postgis_scripts_build_date() OWNER TO postgres;

--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 345
-- Name: FUNCTION postgis_scripts_build_date(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_scripts_build_date() IS 'Returns build date of the PostGIS scripts.';


--
-- TOC entry 339 (class 1255 OID 21660)
-- Dependencies: 3
-- Name: postgis_scripts_installed(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_scripts_installed() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '1.5 r5166'::text AS version$$;


ALTER FUNCTION public.postgis_scripts_installed() OWNER TO postgres;

--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 339
-- Name: FUNCTION postgis_scripts_installed(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_scripts_installed() IS 'Returns version of the postgis scripts installed in this database.';


--
-- TOC entry 341 (class 1255 OID 21662)
-- Dependencies: 3
-- Name: postgis_scripts_released(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_scripts_released() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_scripts_released';


ALTER FUNCTION public.postgis_scripts_released() OWNER TO postgres;

--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 341
-- Name: FUNCTION postgis_scripts_released(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_scripts_released() IS 'Returns the version number of the postgis.sql script released with the installed postgis lib.';


--
-- TOC entry 334 (class 1255 OID 21655)
-- Dependencies: 3 1157 1157
-- Name: postgis_transform_geometry(geometry, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_transform_geometry(geometry, text, text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'transform_geom';


ALTER FUNCTION public.postgis_transform_geometry(geometry, text, text, integer) OWNER TO postgres;

--
-- TOC entry 342 (class 1255 OID 21663)
-- Dependencies: 3
-- Name: postgis_uses_stats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_uses_stats() RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_uses_stats';


ALTER FUNCTION public.postgis_uses_stats() OWNER TO postgres;

--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 342
-- Name: FUNCTION postgis_uses_stats(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_uses_stats() IS 'Returns TRUE if STATS usage has been enabled.';


--
-- TOC entry 337 (class 1255 OID 21658)
-- Dependencies: 3
-- Name: postgis_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_version() RETURNS text
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'postgis_version';


ALTER FUNCTION public.postgis_version() OWNER TO postgres;

--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 337
-- Name: FUNCTION postgis_version(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION postgis_version() IS 'Returns PostGIS version number and compile-time options.';


--
-- TOC entry 320 (class 1255 OID 21640)
-- Dependencies: 3 1424
-- Name: probe_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION probe_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted integer;
	oldcount integer;
	probed integer;
	stale integer;
BEGIN

	SELECT count(*) INTO oldcount FROM geometry_columns;

	SELECT count(*) INTO probed
		FROM pg_class c, pg_attribute a, pg_type t,
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck

		WHERE t.typname = 'geometry'
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid
		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(srid('||a.attname||') = %)'
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'
		;

	INSERT INTO geometry_columns SELECT
		''::varchar as f_table_catalogue,
		n.nspname::varchar as f_table_schema,
		c.relname::varchar as f_table_name,
		a.attname::varchar as f_geometry_column,
		2 as coord_dimension,
		trim(both  ' =)' from
			replace(replace(split_part(
				sridcheck.consrc, ' = ', 2), ')', ''), '(', ''))::integer AS srid,
		trim(both ' =)''' from substr(typecheck.consrc,
			strpos(typecheck.consrc, '='),
			strpos(typecheck.consrc, '::')-
			strpos(typecheck.consrc, '=')
			))::varchar as type
		FROM pg_class c, pg_attribute a, pg_type t,
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck
		WHERE t.typname = 'geometry'
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid
		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(st_srid('||a.attname||') = %)'
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'

			AND NOT EXISTS (
					SELECT oid FROM geometry_columns gc
					WHERE c.relname::varchar = gc.f_table_name
					AND n.nspname::varchar = gc.f_table_schema
					AND a.attname::varchar = gc.f_geometry_column
			);

	GET DIAGNOSTICS inserted = ROW_COUNT;

	IF oldcount > probed THEN
		stale = oldcount-probed;
	ELSE
		stale = 0;
	END IF;

	RETURN 'probed:'||probed::text||
		' inserted:'||inserted::text||
		' conflicts:'||(probed-inserted)::text||
		' stale:'||stale::text;
END

$$;


ALTER FUNCTION public.probe_geometry_columns() OWNER TO postgres;

--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 320
-- Name: FUNCTION probe_geometry_columns(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION probe_geometry_columns() IS 'Scans all tables with PostGIS geometry constraints and adds them to the geometry_columns table if they are not there.';


--
-- TOC entry 440 (class 1255 OID 21794)
-- Dependencies: 3 1157 1157
-- Name: relate(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION relate(geometry, geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'relate_full';


ALTER FUNCTION public.relate(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 442 (class 1255 OID 21796)
-- Dependencies: 3 1157 1157
-- Name: relate(geometry, geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION relate(geometry, geometry, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'relate_pattern';


ALTER FUNCTION public.relate(geometry, geometry, text) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 21576)
-- Dependencies: 1157 3 1157
-- Name: removepoint(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION removepoint(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_removepoint';


ALTER FUNCTION public.removepoint(geometry, integer) OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 21635)
-- Dependencies: 3
-- Name: rename_geometry_table_constraints(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rename_geometry_table_constraints() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT 'rename_geometry_table_constraint() is obsoleted'::text
$$;


ALTER FUNCTION public.rename_geometry_table_constraints() OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 21528)
-- Dependencies: 1157 3 1157
-- Name: reverse(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION reverse(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_reverse';


ALTER FUNCTION public.reverse(geometry) OWNER TO postgres;

--
-- TOC entry 45 (class 1255 OID 21290)
-- Dependencies: 1157 1157 3
-- Name: rotate(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotate(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT rotateZ($1, $2)$_$;


ALTER FUNCTION public.rotate(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 47 (class 1255 OID 21292)
-- Dependencies: 1157 1157 3
-- Name: rotatex(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotatex(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


ALTER FUNCTION public.rotatex(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 49 (class 1255 OID 21294)
-- Dependencies: 3 1157 1157
-- Name: rotatey(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotatey(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


ALTER FUNCTION public.rotatey(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 43 (class 1255 OID 21288)
-- Dependencies: 3 1157 1157
-- Name: rotatez(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotatez(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


ALTER FUNCTION public.rotatez(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 57 (class 1255 OID 21302)
-- Dependencies: 1157 3 1157
-- Name: scale(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION scale(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT scale($1, $2, $3, 1)$_$;


ALTER FUNCTION public.scale(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 55 (class 1255 OID 21300)
-- Dependencies: 1157 1157 3
-- Name: scale(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION scale(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


ALTER FUNCTION public.scale(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 708 (class 1255 OID 22061)
-- Dependencies: 3 1157 1157
-- Name: se_envelopesintersect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_envelopesintersect(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
	SELECT $1 && $2
	$_$;


ALTER FUNCTION public.se_envelopesintersect(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 702 (class 1255 OID 22055)
-- Dependencies: 3 1157
-- Name: se_is3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_is3d(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_hasz';


ALTER FUNCTION public.se_is3d(geometry) OWNER TO postgres;

--
-- TOC entry 703 (class 1255 OID 22056)
-- Dependencies: 3 1157
-- Name: se_ismeasured(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_ismeasured(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_hasm';


ALTER FUNCTION public.se_ismeasured(geometry) OWNER TO postgres;

--
-- TOC entry 709 (class 1255 OID 22062)
-- Dependencies: 3 1157 1157
-- Name: se_locatealong(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_locatealong(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT locate_between_measures($1, $2, $2) $_$;


ALTER FUNCTION public.se_locatealong(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 710 (class 1255 OID 22063)
-- Dependencies: 3 1157 1157
-- Name: se_locatebetween(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_locatebetween(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_locate_between_m';


ALTER FUNCTION public.se_locatebetween(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 706 (class 1255 OID 22059)
-- Dependencies: 3 1157
-- Name: se_m(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_m(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_m_point';


ALTER FUNCTION public.se_m(geometry) OWNER TO postgres;

--
-- TOC entry 705 (class 1255 OID 22058)
-- Dependencies: 3 1157
-- Name: se_z(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_z(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_z_point';


ALTER FUNCTION public.se_z(geometry) OWNER TO postgres;

--
-- TOC entry 386 (class 1255 OID 21725)
-- Dependencies: 3 1157 1157
-- Name: segmentize(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION segmentize(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_segmentize2d';


ALTER FUNCTION public.segmentize(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 164 (class 1255 OID 21463)
-- Dependencies: 3 1169 1169
-- Name: setfactor(chip, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setfactor(chip, real) RETURNS chip
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_setFactor';


ALTER FUNCTION public.setfactor(chip, real) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 21578)
-- Dependencies: 1157 3 1157 1157
-- Name: setpoint(geometry, integer, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setpoint(geometry, integer, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_setpoint_linestring';


ALTER FUNCTION public.setpoint(geometry, integer, geometry) OWNER TO postgres;

--
-- TOC entry 163 (class 1255 OID 21462)
-- Dependencies: 3 1169 1169
-- Name: setsrid(chip, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setsrid(chip, integer) RETURNS chip
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_setSRID';


ALTER FUNCTION public.setsrid(chip, integer) OWNER TO postgres;

--
-- TOC entry 558 (class 1255 OID 21912)
-- Dependencies: 3 1157 1157
-- Name: setsrid(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setsrid(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_setSRID';


ALTER FUNCTION public.setsrid(geometry, integer) OWNER TO postgres;

--
-- TOC entry 61 (class 1255 OID 21306)
-- Dependencies: 1157 3 1157
-- Name: shift_longitude(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION shift_longitude(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_longitude_shift';


ALTER FUNCTION public.shift_longitude(geometry) OWNER TO postgres;

--
-- TOC entry 376 (class 1255 OID 21715)
-- Dependencies: 3 1157 1157
-- Name: simplify(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION simplify(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_simplify2d';


ALTER FUNCTION public.simplify(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 382 (class 1255 OID 21721)
-- Dependencies: 3 1157 1157
-- Name: snaptogrid(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT SnapToGrid($1, 0, 0, $2, $2)$_$;


ALTER FUNCTION public.snaptogrid(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 380 (class 1255 OID 21719)
-- Dependencies: 3 1157 1157
-- Name: snaptogrid(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT SnapToGrid($1, 0, 0, $2, $3)$_$;


ALTER FUNCTION public.snaptogrid(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 378 (class 1255 OID 21717)
-- Dependencies: 3 1157 1157
-- Name: snaptogrid(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_snaptogrid';


ALTER FUNCTION public.snaptogrid(geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 384 (class 1255 OID 21723)
-- Dependencies: 3 1157 1157 1157
-- Name: snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_snaptogrid_pointoff';


ALTER FUNCTION public.snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 151 (class 1255 OID 21450)
-- Dependencies: 3 1169
-- Name: srid(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION srid(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getSRID';


ALTER FUNCTION public.srid(chip) OWNER TO postgres;

--
-- TOC entry 556 (class 1255 OID 21910)
-- Dependencies: 3 1157
-- Name: srid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION srid(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_getSRID';


ALTER FUNCTION public.srid(geometry) OWNER TO postgres;

--
-- TOC entry 398 (class 1255 OID 21737)
-- Dependencies: 3 1157 1157
-- Name: st_addmeasure(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_addmeasure(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ST_AddMeasure';


ALTER FUNCTION public.st_addmeasure(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 398
-- Name: FUNCTION st_addmeasure(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_addmeasure(geometry, double precision, double precision) IS 'args: geom_mline, measure_start, measure_end - Return a derived geometry with measure elements linearly interpolated between the start and end points. If the geometry has no measure dimension, one is added. If the geometry has a measure dimension, it is over-written with new values. Only LINESTRINGS and MULTILINESTRINGS are supported.';


--
-- TOC entry 274 (class 1255 OID 21573)
-- Dependencies: 3 1157 1157 1157
-- Name: st_addpoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_addpoint(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_addpoint';


ALTER FUNCTION public.st_addpoint(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 274
-- Name: FUNCTION st_addpoint(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_addpoint(geometry, geometry) IS 'args: linestring, point - Adds a point to a LineString before point <position> (0-based index).';


--
-- TOC entry 276 (class 1255 OID 21575)
-- Dependencies: 1157 3 1157 1157
-- Name: st_addpoint(geometry, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_addpoint(geometry, geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_addpoint';


ALTER FUNCTION public.st_addpoint(geometry, geometry, integer) OWNER TO postgres;

--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 276
-- Name: FUNCTION st_addpoint(geometry, geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_addpoint(geometry, geometry, integer) IS 'args: linestring, point, position - Adds a point to a LineString before point <position> (0-based index).';


--
-- TOC entry 42 (class 1255 OID 21287)
-- Dependencies: 3 1157 1157
-- Name: st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


ALTER FUNCTION public.st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 42
-- Name: FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) IS 'args: geomA, a, b, d, e, xoff, yoff - Applies a 3d affine transformation to the geometry to do things like translate, rotate, scale in one step.';


--
-- TOC entry 40 (class 1255 OID 21285)
-- Dependencies: 3 1157 1157
-- Name: st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_affine';


ALTER FUNCTION public.st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 40
-- Name: FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) IS 'args: geomA, a, b, c, d, e, f, g, h, i, xoff, yoff, zoff - Applies a 3d affine transformation to the geometry to do things like translate, rotate, scale in one step.';


--
-- TOC entry 195 (class 1255 OID 21494)
-- Dependencies: 3 1157
-- Name: st_area(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_area(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_area_polygon';


ALTER FUNCTION public.st_area(geometry) OWNER TO postgres;

--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 195
-- Name: FUNCTION st_area(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_area(geometry) IS 'args: g1 - Returns the area of the surface if it is a polygon or multi-polygon. For "geometry" type area is in SRID units. For "geography" area is in square meters.';


--
-- TOC entry 783 (class 1255 OID 22172)
-- Dependencies: 3 1184
-- Name: st_area(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_area(geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Area($1, true)$_$;


ALTER FUNCTION public.st_area(geography) OWNER TO postgres;

--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 783
-- Name: FUNCTION st_area(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_area(geography) IS 'args: g1 - Returns the area of the surface if it is a polygon or multi-polygon. For "geometry" type area is in SRID units. For "geography" area is in square meters.';


--
-- TOC entry 784 (class 1255 OID 22173)
-- Dependencies: 3
-- Name: st_area(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_area(text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Area($1::geometry);  $_$;


ALTER FUNCTION public.st_area(text) OWNER TO postgres;

--
-- TOC entry 782 (class 1255 OID 22171)
-- Dependencies: 3 1184
-- Name: st_area(geography, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_area(geography, boolean) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'geography_area';


ALTER FUNCTION public.st_area(geography, boolean) OWNER TO postgres;

--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 782
-- Name: FUNCTION st_area(geography, boolean); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_area(geography, boolean) IS 'args: g1, use_spheroid - Returns the area of the surface if it is a polygon or multi-polygon. For "geometry" type area is in SRID units. For "geography" area is in square meters.';


--
-- TOC entry 193 (class 1255 OID 21492)
-- Dependencies: 1157 3
-- Name: st_area2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_area2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_area_polygon';


ALTER FUNCTION public.st_area2d(geometry) OWNER TO postgres;

--
-- TOC entry 561 (class 1255 OID 21915)
-- Dependencies: 3 1157
-- Name: st_asbinary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asbinary(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asBinary';


ALTER FUNCTION public.st_asbinary(geometry) OWNER TO postgres;

--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 561
-- Name: FUNCTION st_asbinary(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asbinary(geometry) IS 'args: g1 - Return the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.';


--
-- TOC entry 723 (class 1255 OID 22081)
-- Dependencies: 3 1184
-- Name: st_asbinary(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asbinary(geography) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_binary';


ALTER FUNCTION public.st_asbinary(geography) OWNER TO postgres;

--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 723
-- Name: FUNCTION st_asbinary(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asbinary(geography) IS 'args: g1 - Return the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.';


--
-- TOC entry 724 (class 1255 OID 22082)
-- Dependencies: 3
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);  $_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO postgres;

--
-- TOC entry 563 (class 1255 OID 21917)
-- Dependencies: 3 1157
-- Name: st_asbinary(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asbinary(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asBinary';


ALTER FUNCTION public.st_asbinary(geometry, text) OWNER TO postgres;

--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 563
-- Name: FUNCTION st_asbinary(geometry, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asbinary(geometry, text) IS 'args: g1, NDR_or_XDR - Return the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.';


--
-- TOC entry 242 (class 1255 OID 21541)
-- Dependencies: 1157 3
-- Name: st_asewkb(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asewkb(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'WKBFromLWGEOM';


ALTER FUNCTION public.st_asewkb(geometry) OWNER TO postgres;

--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 242
-- Name: FUNCTION st_asewkb(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asewkb(geometry) IS 'args: g1 - Return the Well-Known Binary (WKB) representation of the geometry with SRID meta data.';


--
-- TOC entry 248 (class 1255 OID 21547)
-- Dependencies: 3 1157
-- Name: st_asewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asewkb(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'WKBFromLWGEOM';


ALTER FUNCTION public.st_asewkb(geometry, text) OWNER TO postgres;

--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 248
-- Name: FUNCTION st_asewkb(geometry, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asewkb(geometry, text) IS 'args: g1, NDR_or_XDR - Return the Well-Known Binary (WKB) representation of the geometry with SRID meta data.';


--
-- TOC entry 240 (class 1255 OID 21539)
-- Dependencies: 1157 3
-- Name: st_asewkt(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asewkt(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asEWKT';


ALTER FUNCTION public.st_asewkt(geometry) OWNER TO postgres;

--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 240
-- Name: FUNCTION st_asewkt(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asewkt(geometry) IS 'args: g1 - Return the Well-Known Text (WKT) representation of the geometry with SRID meta data.';


--
-- TOC entry 513 (class 1255 OID 21867)
-- Dependencies: 3 1157
-- Name: st_asgeojson(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, 15, 0)$_$;


ALTER FUNCTION public.st_asgeojson(geometry) OWNER TO postgres;

--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 513
-- Name: FUNCTION st_asgeojson(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(geometry) IS 'args: g1 - Return the geometry as a GeoJSON element.';


--
-- TOC entry 767 (class 1255 OID 22156)
-- Dependencies: 1184 3
-- Name: st_asgeojson(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, 15, 0)$_$;


ALTER FUNCTION public.st_asgeojson(geography) OWNER TO postgres;

--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 767
-- Name: FUNCTION st_asgeojson(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(geography) IS 'args: g1 - Return the geometry as a GeoJSON element.';


--
-- TOC entry 768 (class 1255 OID 22157)
-- Dependencies: 3
-- Name: st_asgeojson(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsGeoJson($1::geometry);  $_$;


ALTER FUNCTION public.st_asgeojson(text) OWNER TO postgres;

--
-- TOC entry 512 (class 1255 OID 21866)
-- Dependencies: 3 1157
-- Name: st_asgeojson(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, 0)$_$;


ALTER FUNCTION public.st_asgeojson(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 512
-- Name: FUNCTION st_asgeojson(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(geometry, integer) IS 'args: g1, max_decimal_digits - Return the geometry as a GeoJSON element.';


--
-- TOC entry 514 (class 1255 OID 21868)
-- Dependencies: 3 1157
-- Name: st_asgeojson(integer, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, 15, 0)$_$;


ALTER FUNCTION public.st_asgeojson(integer, geometry) OWNER TO postgres;

--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 514
-- Name: FUNCTION st_asgeojson(integer, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(integer, geometry) IS 'args: version, g1 - Return the geometry as a GeoJSON element.';


--
-- TOC entry 766 (class 1255 OID 22155)
-- Dependencies: 1184 3
-- Name: st_asgeojson(geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, 0)$_$;


ALTER FUNCTION public.st_asgeojson(geography, integer) OWNER TO postgres;

--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 766
-- Name: FUNCTION st_asgeojson(geography, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(geography, integer) IS 'args: g1, max_decimal_digits - Return the geometry as a GeoJSON element.';


--
-- TOC entry 769 (class 1255 OID 22158)
-- Dependencies: 3 1184
-- Name: st_asgeojson(integer, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, 15, 0)$_$;


ALTER FUNCTION public.st_asgeojson(integer, geography) OWNER TO postgres;

--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 769
-- Name: FUNCTION st_asgeojson(integer, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(integer, geography) IS 'args: version, g1 - Return the geometry as a GeoJSON element.';


--
-- TOC entry 515 (class 1255 OID 21869)
-- Dependencies: 3 1157
-- Name: st_asgeojson(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, 0)$_$;


ALTER FUNCTION public.st_asgeojson(integer, geometry, integer) OWNER TO postgres;

--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 515
-- Name: FUNCTION st_asgeojson(integer, geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(integer, geometry, integer) IS 'args: version, g1, max_decimal_digits - Return the geometry as a GeoJSON element.';


--
-- TOC entry 516 (class 1255 OID 21870)
-- Dependencies: 3 1157
-- Name: st_asgeojson(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(geometry, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, $3)$_$;


ALTER FUNCTION public.st_asgeojson(geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 516
-- Name: FUNCTION st_asgeojson(geometry, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(geometry, integer, integer) IS 'args: g1, max_decimal_digits, options - Return the geometry as a GeoJSON element.';


--
-- TOC entry 770 (class 1255 OID 22159)
-- Dependencies: 3 1184
-- Name: st_asgeojson(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, 0)$_$;


ALTER FUNCTION public.st_asgeojson(integer, geography, integer) OWNER TO postgres;

--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 770
-- Name: FUNCTION st_asgeojson(integer, geography, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(integer, geography, integer) IS 'args: version, g1, max_decimal_digits - Return the geometry as a GeoJSON element.';


--
-- TOC entry 771 (class 1255 OID 22160)
-- Dependencies: 1184 3
-- Name: st_asgeojson(geography, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(geography, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson(1, $1, $2, $3)$_$;


ALTER FUNCTION public.st_asgeojson(geography, integer, integer) OWNER TO postgres;

--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 771
-- Name: FUNCTION st_asgeojson(geography, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(geography, integer, integer) IS 'args: g1, max_decimal_digits, options - Return the geometry as a GeoJSON element.';


--
-- TOC entry 517 (class 1255 OID 21871)
-- Dependencies: 3 1157
-- Name: st_asgeojson(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(integer, geometry, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, $4)$_$;


ALTER FUNCTION public.st_asgeojson(integer, geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 517
-- Name: FUNCTION st_asgeojson(integer, geometry, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(integer, geometry, integer, integer) IS 'args: version, g1, max_decimal_digits, options - Return the geometry as a GeoJSON element.';


--
-- TOC entry 772 (class 1255 OID 22161)
-- Dependencies: 3 1184
-- Name: st_asgeojson(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(integer, geography, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGeoJson($1, $2, $3, $4)$_$;


ALTER FUNCTION public.st_asgeojson(integer, geography, integer, integer) OWNER TO postgres;

--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 772
-- Name: FUNCTION st_asgeojson(integer, geography, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgeojson(integer, geography, integer, integer) IS 'args: version, g1, max_decimal_digits, options - Return the geometry as a GeoJSON element.';


--
-- TOC entry 498 (class 1255 OID 21852)
-- Dependencies: 3 1157
-- Name: st_asgml(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


ALTER FUNCTION public.st_asgml(geometry) OWNER TO postgres;

--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 498
-- Name: FUNCTION st_asgml(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(geometry) IS 'args: g1 - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 753 (class 1255 OID 22142)
-- Dependencies: 1184 3
-- Name: st_asgml(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0)$_$;


ALTER FUNCTION public.st_asgml(geography) OWNER TO postgres;

--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 753
-- Name: FUNCTION st_asgml(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(geography) IS 'args: g1 - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 754 (class 1255 OID 22143)
-- Dependencies: 3
-- Name: st_asgml(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsGML($1::geometry);  $_$;


ALTER FUNCTION public.st_asgml(text) OWNER TO postgres;

--
-- TOC entry 496 (class 1255 OID 21850)
-- Dependencies: 3 1157
-- Name: st_asgml(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


ALTER FUNCTION public.st_asgml(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 496
-- Name: FUNCTION st_asgml(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(geometry, integer) IS 'args: g1, precision - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 499 (class 1255 OID 21853)
-- Dependencies: 3 1157
-- Name: st_asgml(integer, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, 15, 0)$_$;


ALTER FUNCTION public.st_asgml(integer, geometry) OWNER TO postgres;

--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 499
-- Name: FUNCTION st_asgml(integer, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(integer, geometry) IS 'args: version, g1 - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 752 (class 1255 OID 22141)
-- Dependencies: 3 1184
-- Name: st_asgml(geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0)$_$;


ALTER FUNCTION public.st_asgml(geography, integer) OWNER TO postgres;

--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 752
-- Name: FUNCTION st_asgml(geography, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(geography, integer) IS 'args: g1, precision - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 755 (class 1255 OID 22144)
-- Dependencies: 1184 3
-- Name: st_asgml(integer, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, 15, 0)$_$;


ALTER FUNCTION public.st_asgml(integer, geography) OWNER TO postgres;

--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 755
-- Name: FUNCTION st_asgml(integer, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(integer, geography) IS 'args: version, g1 - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 500 (class 1255 OID 21854)
-- Dependencies: 3 1157
-- Name: st_asgml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, 0)$_$;


ALTER FUNCTION public.st_asgml(integer, geometry, integer) OWNER TO postgres;

--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 500
-- Name: FUNCTION st_asgml(integer, geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(integer, geometry, integer) IS 'args: version, g1, precision - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 501 (class 1255 OID 21855)
-- Dependencies: 3 1157
-- Name: st_asgml(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(geometry, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, $3)$_$;


ALTER FUNCTION public.st_asgml(geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 756 (class 1255 OID 22145)
-- Dependencies: 3 1184
-- Name: st_asgml(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, 0)$_$;


ALTER FUNCTION public.st_asgml(integer, geography, integer) OWNER TO postgres;

--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 756
-- Name: FUNCTION st_asgml(integer, geography, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(integer, geography, integer) IS 'args: version, g1, precision - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 757 (class 1255 OID 22146)
-- Dependencies: 3 1184
-- Name: st_asgml(geography, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(geography, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, $3)$_$;


ALTER FUNCTION public.st_asgml(geography, integer, integer) OWNER TO postgres;

--
-- TOC entry 502 (class 1255 OID 21856)
-- Dependencies: 3 1157
-- Name: st_asgml(integer, geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(integer, geometry, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, $4)$_$;


ALTER FUNCTION public.st_asgml(integer, geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 502
-- Name: FUNCTION st_asgml(integer, geometry, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(integer, geometry, integer, integer) IS 'args: version, g1, precision, options - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 758 (class 1255 OID 22147)
-- Dependencies: 3 1184
-- Name: st_asgml(integer, geography, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(integer, geography, integer, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML($1, $2, $3, $4)$_$;


ALTER FUNCTION public.st_asgml(integer, geography, integer, integer) OWNER TO postgres;

--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 758
-- Name: FUNCTION st_asgml(integer, geography, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_asgml(integer, geography, integer, integer) IS 'args: version, g1, precision, options - Return the geometry as a GML version 2 or 3 element.';


--
-- TOC entry 244 (class 1255 OID 21543)
-- Dependencies: 1157 3
-- Name: st_ashexewkb(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_ashexewkb(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asHEXEWKB';


ALTER FUNCTION public.st_ashexewkb(geometry) OWNER TO postgres;

--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 244
-- Name: FUNCTION st_ashexewkb(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_ashexewkb(geometry) IS 'args: g1 - Returns a Geometry in HEXEWKB format (as text) using either little-endian (NDR) or big-endian (XDR) encoding.';


--
-- TOC entry 246 (class 1255 OID 21545)
-- Dependencies: 3 1157
-- Name: st_ashexewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_ashexewkb(geometry, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asHEXEWKB';


ALTER FUNCTION public.st_ashexewkb(geometry, text) OWNER TO postgres;

--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 246
-- Name: FUNCTION st_ashexewkb(geometry, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_ashexewkb(geometry, text) IS 'args: g1, NDRorXDR - Returns a Geometry in HEXEWKB format (as text) using either little-endian (NDR) or big-endian (XDR) encoding.';


--
-- TOC entry 508 (class 1255 OID 21862)
-- Dependencies: 3 1157
-- Name: st_askml(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_Transform($1,4326), 15)$_$;


ALTER FUNCTION public.st_askml(geometry) OWNER TO postgres;

--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 508
-- Name: FUNCTION st_askml(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(geometry) IS 'args: g1 - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 761 (class 1255 OID 22150)
-- Dependencies: 1184 3
-- Name: st_askml(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, $1, 15)$_$;


ALTER FUNCTION public.st_askml(geography) OWNER TO postgres;

--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 761
-- Name: FUNCTION st_askml(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(geography) IS 'args: g1 - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 762 (class 1255 OID 22151)
-- Dependencies: 3
-- Name: st_askml(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsKML($1::geometry);  $_$;


ALTER FUNCTION public.st_askml(text) OWNER TO postgres;

--
-- TOC entry 505 (class 1255 OID 21859)
-- Dependencies: 3 1157
-- Name: st_askml(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_Transform($1,4326), $2)$_$;


ALTER FUNCTION public.st_askml(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 505
-- Name: FUNCTION st_askml(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(geometry, integer) IS 'args: g1, precision - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 509 (class 1255 OID 21863)
-- Dependencies: 3 1157
-- Name: st_askml(integer, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(integer, geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), 15)$_$;


ALTER FUNCTION public.st_askml(integer, geometry) OWNER TO postgres;

--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 509
-- Name: FUNCTION st_askml(integer, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(integer, geometry) IS 'args: version, geom1 - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 760 (class 1255 OID 22149)
-- Dependencies: 1184 3
-- Name: st_askml(geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, $1, $2)$_$;


ALTER FUNCTION public.st_askml(geography, integer) OWNER TO postgres;

--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 760
-- Name: FUNCTION st_askml(geography, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(geography, integer) IS 'args: g1, precision - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 763 (class 1255 OID 22152)
-- Dependencies: 3 1184
-- Name: st_askml(integer, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(integer, geography) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, $2, 15)$_$;


ALTER FUNCTION public.st_askml(integer, geography) OWNER TO postgres;

--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 763
-- Name: FUNCTION st_askml(integer, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(integer, geography) IS 'args: version, geom1 - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 510 (class 1255 OID 21864)
-- Dependencies: 3 1157
-- Name: st_askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), $3)$_$;


ALTER FUNCTION public.st_askml(integer, geometry, integer) OWNER TO postgres;

--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 510
-- Name: FUNCTION st_askml(integer, geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(integer, geometry, integer) IS 'args: version, geom1, precision - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 764 (class 1255 OID 22153)
-- Dependencies: 1184 3
-- Name: st_askml(integer, geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(integer, geography, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, $2, $3)$_$;


ALTER FUNCTION public.st_askml(integer, geography, integer) OWNER TO postgres;

--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 764
-- Name: FUNCTION st_askml(integer, geography, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_askml(integer, geography, integer) IS 'args: version, geom1, precision - Return the geometry as a KML element. Several variants. Default version=2, default precision=15';


--
-- TOC entry 493 (class 1255 OID 21847)
-- Dependencies: 3 1157
-- Name: st_assvg(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'assvg_geometry';


ALTER FUNCTION public.st_assvg(geometry) OWNER TO postgres;

--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 493
-- Name: FUNCTION st_assvg(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_assvg(geometry) IS 'args: g1 - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- TOC entry 749 (class 1255 OID 22138)
-- Dependencies: 3 1184
-- Name: st_assvg(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(geography) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_svg';


ALTER FUNCTION public.st_assvg(geography) OWNER TO postgres;

--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 749
-- Name: FUNCTION st_assvg(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_assvg(geography) IS 'args: g1 - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- TOC entry 750 (class 1255 OID 22139)
-- Dependencies: 3
-- Name: st_assvg(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsSVG($1::geometry);  $_$;


ALTER FUNCTION public.st_assvg(text) OWNER TO postgres;

--
-- TOC entry 491 (class 1255 OID 21845)
-- Dependencies: 3 1157
-- Name: st_assvg(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(geometry, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'assvg_geometry';


ALTER FUNCTION public.st_assvg(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 491
-- Name: FUNCTION st_assvg(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_assvg(geometry, integer) IS 'args: g1, rel - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- TOC entry 748 (class 1255 OID 22137)
-- Dependencies: 1184 3
-- Name: st_assvg(geography, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(geography, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_svg';


ALTER FUNCTION public.st_assvg(geography, integer) OWNER TO postgres;

--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 748
-- Name: FUNCTION st_assvg(geography, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_assvg(geography, integer) IS 'args: g1, rel - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- TOC entry 489 (class 1255 OID 21843)
-- Dependencies: 3 1157
-- Name: st_assvg(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(geometry, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'assvg_geometry';


ALTER FUNCTION public.st_assvg(geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 489
-- Name: FUNCTION st_assvg(geometry, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_assvg(geometry, integer, integer) IS 'args: g1, rel, maxdecimaldigits - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- TOC entry 747 (class 1255 OID 22136)
-- Dependencies: 3 1184
-- Name: st_assvg(geography, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(geography, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_svg';


ALTER FUNCTION public.st_assvg(geography, integer, integer) OWNER TO postgres;

--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 747
-- Name: FUNCTION st_assvg(geography, integer, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_assvg(geography, integer, integer) IS 'args: g1, rel, maxdecimaldigits - Returns a Geometry in SVG path data given a geometry or geography object.';


--
-- TOC entry 565 (class 1255 OID 21919)
-- Dependencies: 3 1157
-- Name: st_astext(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_astext(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_asText';


ALTER FUNCTION public.st_astext(geometry) OWNER TO postgres;

--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 565
-- Name: FUNCTION st_astext(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_astext(geometry) IS 'args: g1 - Return the Well-Known Text (WKT) representation of the geometry/geography without SRID metadata.';


--
-- TOC entry 719 (class 1255 OID 22077)
-- Dependencies: 3 1184
-- Name: st_astext(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_astext(geography) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_as_text';


ALTER FUNCTION public.st_astext(geography) OWNER TO postgres;

--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 719
-- Name: FUNCTION st_astext(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_astext(geography) IS 'args: g1 - Return the Well-Known Text (WKT) representation of the geometry/geography without SRID metadata.';


--
-- TOC entry 720 (class 1255 OID 22078)
-- Dependencies: 3
-- Name: st_astext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_astext(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);  $_$;


ALTER FUNCTION public.st_astext(text) OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 21504)
-- Dependencies: 3 1157 1157
-- Name: st_azimuth(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_azimuth(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_azimuth';


ALTER FUNCTION public.st_azimuth(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 205
-- Name: FUNCTION st_azimuth(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_azimuth(geometry, geometry) IS 'args: pointA, pointB - Returns the angle in radians from the horizontal of the vector defined by pointA and pointB';


--
-- TOC entry 684 (class 1255 OID 22036)
-- Dependencies: 3 1424 1157
-- Name: st_bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_bdmpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := multi(ST_BuildArea(mline));

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.st_bdmpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 684
-- Name: FUNCTION st_bdmpolyfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_bdmpolyfromtext(text, integer) IS 'args: WKT, srid - Construct a MultiPolygon given an arbitrary collection of closed linestrings as a MultiLineString text representation Well-Known text representation.';


--
-- TOC entry 682 (class 1255 OID 22034)
-- Dependencies: 3 1424 1157
-- Name: st_bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_bdpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := ST_BuildArea(mline);

	IF GeometryType(geom) != 'POLYGON'
	THEN
		RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
	END IF;

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.st_bdpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 682
-- Name: FUNCTION st_bdpolyfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_bdpolyfromtext(text, integer) IS 'args: WKT, srid - Construct a Polygon given an arbitrary collection of closed linestrings as a MultiLineString Well-Known text representation.';


--
-- TOC entry 419 (class 1255 OID 21758)
-- Dependencies: 3 1157 1157
-- Name: st_boundary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_boundary(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'boundary';


ALTER FUNCTION public.st_boundary(geometry) OWNER TO postgres;

--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 419
-- Name: FUNCTION st_boundary(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_boundary(geometry) IS 'args: geomA - Returns the closure of the combinatorial boundary of this Geometry.';


--
-- TOC entry 350 (class 1255 OID 21671)
-- Dependencies: 3 1157
-- Name: st_box(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box(geometry) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX';


ALTER FUNCTION public.st_box(geometry) OWNER TO postgres;

--
-- TOC entry 317 (class 1255 OID 21674)
-- Dependencies: 3 1161
-- Name: st_box(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box(box3d) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_BOX';


ALTER FUNCTION public.st_box(box3d) OWNER TO postgres;

--
-- TOC entry 348 (class 1255 OID 21669)
-- Dependencies: 3 1167 1157
-- Name: st_box2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box2d(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX2DFLOAT4';


ALTER FUNCTION public.st_box2d(geometry) OWNER TO postgres;

--
-- TOC entry 351 (class 1255 OID 21672)
-- Dependencies: 3 1167 1161
-- Name: st_box2d(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box2d(box3d) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_BOX2DFLOAT4';


ALTER FUNCTION public.st_box2d(box3d) OWNER TO postgres;

--
-- TOC entry 360 (class 1255 OID 21683)
-- Dependencies: 3 1167 1164
-- Name: st_box2d(box3d_extent); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box2d(box3d_extent) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_BOX2DFLOAT4';


ALTER FUNCTION public.st_box2d(box3d_extent) OWNER TO postgres;

--
-- TOC entry 88 (class 1255 OID 21340)
-- Dependencies: 3 1167
-- Name: st_box2d_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box2d_in(cstring) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_in';


ALTER FUNCTION public.st_box2d_in(cstring) OWNER TO postgres;

--
-- TOC entry 89 (class 1255 OID 21341)
-- Dependencies: 3 1167
-- Name: st_box2d_out(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box2d_out(box2d) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_out';


ALTER FUNCTION public.st_box2d_out(box2d) OWNER TO postgres;

--
-- TOC entry 349 (class 1255 OID 21670)
-- Dependencies: 3 1161 1157
-- Name: st_box3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d(geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_BOX3D';


ALTER FUNCTION public.st_box3d(geometry) OWNER TO postgres;

--
-- TOC entry 352 (class 1255 OID 21673)
-- Dependencies: 3 1161 1167
-- Name: st_box3d(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d(box2d) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_to_BOX3D';


ALTER FUNCTION public.st_box3d(box2d) OWNER TO postgres;

--
-- TOC entry 359 (class 1255 OID 21682)
-- Dependencies: 3 1161 1164
-- Name: st_box3d_extent(box3d_extent); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d_extent(box3d_extent) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_extent_to_BOX3D';


ALTER FUNCTION public.st_box3d_extent(box3d_extent) OWNER TO postgres;

--
-- TOC entry 63 (class 1255 OID 21309)
-- Dependencies: 1161 3
-- Name: st_box3d_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d_in(cstring) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_in';


ALTER FUNCTION public.st_box3d_in(cstring) OWNER TO postgres;

--
-- TOC entry 64 (class 1255 OID 21310)
-- Dependencies: 1161 3
-- Name: st_box3d_out(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d_out(box3d) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_out';


ALTER FUNCTION public.st_box3d_out(box3d) OWNER TO postgres;

--
-- TOC entry 402 (class 1255 OID 21741)
-- Dependencies: 3 1157 1157
-- Name: st_buffer(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_buffer(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'buffer';


ALTER FUNCTION public.st_buffer(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 402
-- Name: FUNCTION st_buffer(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_buffer(geometry, double precision) IS 'args: g1, radius_of_buffer - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- TOC entry 798 (class 1255 OID 22187)
-- Dependencies: 1184 1184 3
-- Name: st_buffer(geography, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_buffer(geography, double precision) RETURNS geography
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geography(ST_Transform(ST_Buffer(ST_Transform(geometry($1), _ST_BestSRID($1)), $2), 4326))$_$;


ALTER FUNCTION public.st_buffer(geography, double precision) OWNER TO postgres;

--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 798
-- Name: FUNCTION st_buffer(geography, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_buffer(geography, double precision) IS 'args: g1, radius_of_buffer_in_meters - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- TOC entry 799 (class 1255 OID 22188)
-- Dependencies: 3 1157
-- Name: st_buffer(text, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_buffer(text, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Buffer($1::geometry, $2);  $_$;


ALTER FUNCTION public.st_buffer(text, double precision) OWNER TO postgres;

--
-- TOC entry 404 (class 1255 OID 21743)
-- Dependencies: 3 1157 1157
-- Name: st_buffer(geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_buffer(geometry, double precision, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_Buffer($1, $2,
		CAST('quad_segs='||CAST($3 AS text) as cstring))
	   $_$;


ALTER FUNCTION public.st_buffer(geometry, double precision, integer) OWNER TO postgres;

--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 404
-- Name: FUNCTION st_buffer(geometry, double precision, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_buffer(geometry, double precision, integer) IS 'args: g1, radius_of_buffer, num_seg_quarter_circle - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- TOC entry 405 (class 1255 OID 21744)
-- Dependencies: 3 1157 1157
-- Name: st_buffer(geometry, double precision, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_buffer(geometry, double precision, text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT _ST_Buffer($1, $2,
		CAST( regexp_replace($3, '^[0123456789]+$',
			'quad_segs='||$3) AS cstring)
		)
	   $_$;


ALTER FUNCTION public.st_buffer(geometry, double precision, text) OWNER TO postgres;

--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 405
-- Name: FUNCTION st_buffer(geometry, double precision, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_buffer(geometry, double precision, text) IS 'args: g1, radius_of_buffer, buffer_style_parameters - (T) For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper. Introduced in 1.5 support for different end cap and mitre settings to control shape. buffer_style options: quad_segs=#,endcap=round|flat|square,join=round|mitre|bevel,mitre_limit=#.#';


--
-- TOC entry 287 (class 1255 OID 21586)
-- Dependencies: 1157 3 1157
-- Name: st_buildarea(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_buildarea(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_buildarea';


ALTER FUNCTION public.st_buildarea(geometry) OWNER TO postgres;

--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 287
-- Name: FUNCTION st_buildarea(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_buildarea(geometry) IS 'args: A - Creates an areal geometry formed by the constituent linework of given geometry';


--
-- TOC entry 358 (class 1255 OID 21681)
-- Dependencies: 3 1157
-- Name: st_bytea(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_bytea(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_bytea';


ALTER FUNCTION public.st_bytea(geometry) OWNER TO postgres;

--
-- TOC entry 475 (class 1255 OID 21829)
-- Dependencies: 3 1157 1157
-- Name: st_centroid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_centroid(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'centroid';


ALTER FUNCTION public.st_centroid(geometry) OWNER TO postgres;

--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 475
-- Name: FUNCTION st_centroid(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_centroid(geometry) IS 'args: g1 - Returns the geometric center of a geometry.';


--
-- TOC entry 86 (class 1255 OID 21337)
-- Dependencies: 3 1169
-- Name: st_chip_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_chip_in(cstring) RETURNS chip
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_in';


ALTER FUNCTION public.st_chip_in(cstring) OWNER TO postgres;

--
-- TOC entry 87 (class 1255 OID 21338)
-- Dependencies: 3 1169
-- Name: st_chip_out(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_chip_out(chip) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_out';


ALTER FUNCTION public.st_chip_out(chip) OWNER TO postgres;

--
-- TOC entry 675 (class 1255 OID 22027)
-- Dependencies: 3 1157 1157 1157
-- Name: st_closestpoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_closestpoint(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_closestpoint';


ALTER FUNCTION public.st_closestpoint(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 675
-- Name: FUNCTION st_closestpoint(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_closestpoint(geometry, geometry) IS 'args: g1, g2 - Returns the 2-dimensional point on g1 that is closest to g2. This is the first point of the shortest line.';


--
-- TOC entry 428 (class 1255 OID 21769)
-- Dependencies: 3 1157 1160
-- Name: st_collect(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_collect(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_collect_garray';


ALTER FUNCTION public.st_collect(geometry[]) OWNER TO postgres;

--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 428
-- Name: FUNCTION st_collect(geometry[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_collect(geometry[]) IS 'args: g1_array - Return a specified ST_Geometry value from a collection of other geometries.';


--
-- TOC entry 427 (class 1255 OID 21766)
-- Dependencies: 3 1157 1157 1157
-- Name: st_collect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_collect(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'LWGEOM_collect';


ALTER FUNCTION public.st_collect(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 427
-- Name: FUNCTION st_collect(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_collect(geometry, geometry) IS 'args: g1, g2 - Return a specified ST_Geometry value from a collection of other geometries.';


--
-- TOC entry 218 (class 1255 OID 21517)
-- Dependencies: 3 1157 1157
-- Name: st_collectionextract(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_collectionextract(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ST_CollectionExtract';


ALTER FUNCTION public.st_collectionextract(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 218
-- Name: FUNCTION st_collectionextract(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_collectionextract(geometry, integer) IS 'args: collection, type - Given a GEOMETRYCOLLECTION, returns a MULTI* geometry consisting only of the specified type. Sub-geometries that are not the specified type are ignored. If there are no sub-geometries of the right type, an EMPTY collection will be returned. Only points, lines and polygons are supported. Type numbers are 1 == POINT, 2 == LINESTRING, 3 == POLYGON.';


--
-- TOC entry 302 (class 1255 OID 21602)
-- Dependencies: 3 1167 1167 1157
-- Name: st_combine_bbox(box2d, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_combine_bbox(box2d, geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_combine';


ALTER FUNCTION public.st_combine_bbox(box2d, geometry) OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 21604)
-- Dependencies: 3 1164 1164 1157
-- Name: st_combine_bbox(box3d_extent, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_combine_bbox(box3d_extent, geometry) RETURNS box3d_extent
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'BOX3D_combine';


ALTER FUNCTION public.st_combine_bbox(box3d_extent, geometry) OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 21608)
-- Dependencies: 3 1161 1161 1157
-- Name: st_combine_bbox(box3d, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_combine_bbox(box3d, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-1.5', 'BOX3D_combine';


ALTER FUNCTION public.st_combine_bbox(box3d, geometry) OWNER TO postgres;

--
-- TOC entry 162 (class 1255 OID 21461)
-- Dependencies: 1169 3
-- Name: st_compression(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_compression(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getCompression';


ALTER FUNCTION public.st_compression(chip) OWNER TO postgres;

--
-- TOC entry 462 (class 1255 OID 21816)
-- Dependencies: 3 1157 1157
-- Name: st_contains(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_contains(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Contains($1,$2)$_$;


ALTER FUNCTION public.st_contains(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 462
-- Name: FUNCTION st_contains(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_contains(geometry, geometry) IS 'args: geomA, geomB - Returns true if and only if no points of B lie in the exterior of A, and at least one point of the interior of B lies in the interior of A.';


--
-- TOC entry 468 (class 1255 OID 21822)
-- Dependencies: 3 1157 1157
-- Name: st_containsproperly(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_containsproperly(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_ContainsProperly($1,$2)$_$;


ALTER FUNCTION public.st_containsproperly(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 468
-- Name: FUNCTION st_containsproperly(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_containsproperly(geometry, geometry) IS 'args: geomA, geomB - Returns true if B intersects the interior of A but not the boundary (or exterior). A does not contain properly itself, but does contain itself.';


--
-- TOC entry 408 (class 1255 OID 21747)
-- Dependencies: 3 1157 1157
-- Name: st_convexhull(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_convexhull(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'convexhull';


ALTER FUNCTION public.st_convexhull(geometry) OWNER TO postgres;

--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 408
-- Name: FUNCTION st_convexhull(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_convexhull(geometry) IS 'args: geomA - The convex hull of a geometry represents the minimum convex geometry that encloses all geometries within the set.';


--
-- TOC entry 699 (class 1255 OID 22052)
-- Dependencies: 3 1157
-- Name: st_coorddim(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_coorddim(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_ndims';


ALTER FUNCTION public.st_coorddim(geometry) OWNER TO postgres;

--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 699
-- Name: FUNCTION st_coorddim(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_coorddim(geometry) IS 'args: geomA - Return the coordinate dimension of the ST_Geometry value.';


--
-- TOC entry 464 (class 1255 OID 21818)
-- Dependencies: 3 1157 1157
-- Name: st_coveredby(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_coveredby(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_CoveredBy($1,$2)$_$;


ALTER FUNCTION public.st_coveredby(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 464
-- Name: FUNCTION st_coveredby(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_coveredby(geometry, geometry) IS 'args: geomA, geomB - Returns 1 (TRUE) if no point in Geometry/Geography A is outside Geometry/Geography B';


--
-- TOC entry 792 (class 1255 OID 22181)
-- Dependencies: 1184 1184 3
-- Name: st_coveredby(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_coveredby(geography, geography) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT $1 && $2 AND _ST_Covers($2, $1)$_$;


ALTER FUNCTION public.st_coveredby(geography, geography) OWNER TO postgres;

--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 792
-- Name: FUNCTION st_coveredby(geography, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_coveredby(geography, geography) IS 'args: geogA, geogB - Returns 1 (TRUE) if no point in Geometry/Geography A is outside Geometry/Geography B';


--
-- TOC entry 793 (class 1255 OID 22182)
-- Dependencies: 3
-- Name: st_coveredby(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_coveredby(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_CoveredBy($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_coveredby(text, text) OWNER TO postgres;

--
-- TOC entry 466 (class 1255 OID 21820)
-- Dependencies: 3 1157 1157
-- Name: st_covers(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_covers(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Covers($1,$2)$_$;


ALTER FUNCTION public.st_covers(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 466
-- Name: FUNCTION st_covers(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_covers(geometry, geometry) IS 'args: geomA, geomB - Returns 1 (TRUE) if no point in Geometry B is outside Geometry A. For geography: if geography point B is not outside Polygon Geography A';


--
-- TOC entry 790 (class 1255 OID 22179)
-- Dependencies: 1184 1184 3
-- Name: st_covers(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_covers(geography, geography) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT $1 && $2 AND _ST_Covers($1, $2)$_$;


ALTER FUNCTION public.st_covers(geography, geography) OWNER TO postgres;

--
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 790
-- Name: FUNCTION st_covers(geography, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_covers(geography, geography) IS 'args: geogpolyA, geogpointB - Returns 1 (TRUE) if no point in Geometry B is outside Geometry A. For geography: if geography point B is not outside Polygon Geography A';


--
-- TOC entry 791 (class 1255 OID 22180)
-- Dependencies: 3
-- Name: st_covers(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_covers(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Covers($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_covers(text, text) OWNER TO postgres;

--
-- TOC entry 456 (class 1255 OID 21810)
-- Dependencies: 3 1157 1157
-- Name: st_crosses(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_crosses(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Crosses($1,$2)$_$;


ALTER FUNCTION public.st_crosses(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION st_crosses(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_crosses(geometry, geometry) IS 'args: g1, g2 - Returns TRUE if the supplied geometries have some, but not all, interior points in common.';


--
-- TOC entry 803 (class 1255 OID 22192)
-- Dependencies: 1157 3 1157
-- Name: st_curvetoline(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_curvetoline(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_CurveToLine($1, 32)$_$;


ALTER FUNCTION public.st_curvetoline(geometry) OWNER TO postgres;

--
-- TOC entry 3665 (class 0 OID 0)
-- Dependencies: 803
-- Name: FUNCTION st_curvetoline(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_curvetoline(geometry) IS 'args: curveGeom - Converts a CIRCULARSTRING/CURVEDPOLYGON to a LINESTRING/POLYGON';


--
-- TOC entry 802 (class 1255 OID 22191)
-- Dependencies: 1157 3 1157
-- Name: st_curvetoline(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_curvetoline(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_curve_segmentize';


ALTER FUNCTION public.st_curvetoline(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 802
-- Name: FUNCTION st_curvetoline(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_curvetoline(geometry, integer) IS 'args: curveGeom, segments_per_qtr_circle - Converts a CIRCULARSTRING/CURVEDPOLYGON to a LINESTRING/POLYGON';


--
-- TOC entry 160 (class 1255 OID 21459)
-- Dependencies: 3 1169
-- Name: st_datatype(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_datatype(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getDatatype';


ALTER FUNCTION public.st_datatype(chip) OWNER TO postgres;

--
-- TOC entry 680 (class 1255 OID 22032)
-- Dependencies: 3 1157 1157
-- Name: st_dfullywithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dfullywithin(geometry, geometry, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && ST_Expand($2,$3) AND $2 && ST_Expand($1,$3) AND _ST_DFullyWithin(ST_ConvexHull($1), ST_ConvexHull($2), $3)$_$;


ALTER FUNCTION public.st_dfullywithin(geometry, geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 680
-- Name: FUNCTION st_dfullywithin(geometry, geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dfullywithin(geometry, geometry, double precision) IS 'args: g1, g2, distance - Returns true if all of the geometries are within the specified distance of one another';


--
-- TOC entry 417 (class 1255 OID 21756)
-- Dependencies: 3 1157 1157 1157
-- Name: st_difference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_difference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'difference';


ALTER FUNCTION public.st_difference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 417
-- Name: FUNCTION st_difference(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_difference(geometry, geometry) IS 'args: geomA, geomB - Returns a geometry that represents that part of geometry A that does not intersect with geometry B.';


--
-- TOC entry 527 (class 1255 OID 21881)
-- Dependencies: 3 1157
-- Name: st_dimension(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dimension(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dimension';


ALTER FUNCTION public.st_dimension(geometry) OWNER TO postgres;

--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 527
-- Name: FUNCTION st_dimension(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dimension(geometry) IS 'args: g - The inherent dimension of this Geometry object, which must be less than or equal to the coordinate dimension.';


--
-- TOC entry 445 (class 1255 OID 21799)
-- Dependencies: 3 1157 1157
-- Name: st_disjoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_disjoint(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'disjoint';


ALTER FUNCTION public.st_disjoint(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION st_disjoint(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_disjoint(geometry, geometry) IS 'args: A, B - Returns TRUE if the Geometries do not "spatially intersect" - if they do not share any space together.';


--
-- TOC entry 201 (class 1255 OID 21500)
-- Dependencies: 1157 3 1157
-- Name: st_distance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_distance(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_mindistance2d';


ALTER FUNCTION public.st_distance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 201
-- Name: FUNCTION st_distance(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_distance(geometry, geometry) IS 'args: g1, g2 - For geometry type Returns the 2-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units. For geography type defaults to return spheroidal minimum distance between two geographies in meters.';


--
-- TOC entry 776 (class 1255 OID 22165)
-- Dependencies: 3 1184 1184
-- Name: st_distance(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_distance(geography, geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_Distance($1, $2, 0.0, true)$_$;


ALTER FUNCTION public.st_distance(geography, geography) OWNER TO postgres;

--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 776
-- Name: FUNCTION st_distance(geography, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_distance(geography, geography) IS 'args: gg1, gg2 - For geometry type Returns the 2-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units. For geography type defaults to return spheroidal minimum distance between two geographies in meters.';


--
-- TOC entry 777 (class 1255 OID 22166)
-- Dependencies: 3
-- Name: st_distance(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_distance(text, text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Distance($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_distance(text, text) OWNER TO postgres;

--
-- TOC entry 775 (class 1255 OID 22164)
-- Dependencies: 1184 1184 3
-- Name: st_distance(geography, geography, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_distance(geography, geography, boolean) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_Distance($1, $2, 0.0, $3)$_$;


ALTER FUNCTION public.st_distance(geography, geography, boolean) OWNER TO postgres;

--
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 775
-- Name: FUNCTION st_distance(geography, geography, boolean); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_distance(geography, geography, boolean) IS 'args: gg1, gg2, use_spheroid - For geometry type Returns the 2-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units. For geography type defaults to return spheroidal minimum distance between two geographies in meters.';


--
-- TOC entry 199 (class 1255 OID 21498)
-- Dependencies: 1157 3 1157
-- Name: st_distance_sphere(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_distance_sphere(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_distance_sphere';


ALTER FUNCTION public.st_distance_sphere(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 199
-- Name: FUNCTION st_distance_sphere(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_distance_sphere(geometry, geometry) IS 'args: geomlonlatA, geomlonlatB - Returns minimum distance in meters between two lon/lat geometries. Uses a spherical earth and radius of 6370986 meters. Faster than ST_Distance_Spheroid, but less accurate. PostGIS versions prior to 1.5 only implemented for points.';


--
-- TOC entry 197 (class 1255 OID 21496)
-- Dependencies: 1157 3 1157 1153
-- Name: st_distance_spheroid(geometry, geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_distance_spheroid(geometry, geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_distance_ellipsoid';


ALTER FUNCTION public.st_distance_spheroid(geometry, geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 197
-- Name: FUNCTION st_distance_spheroid(geometry, geometry, spheroid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_distance_spheroid(geometry, geometry, spheroid) IS 'args: geomlonlatA, geomlonlatB, measurement_spheroid - Returns the minimum distance between two lon/lat geometries given a particular spheroid. PostGIS versions prior to 1.5 only support points.';


--
-- TOC entry 294 (class 1255 OID 21596)
-- Dependencies: 3 1173 1157
-- Name: st_dump(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dump(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dump';


ALTER FUNCTION public.st_dump(geometry) OWNER TO postgres;

--
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 294
-- Name: FUNCTION st_dump(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dump(geometry) IS 'args: g1 - Returns a set of geometry_dump (geom,path) rows, that make up a geometry g1.';


--
-- TOC entry 300 (class 1255 OID 21600)
-- Dependencies: 3 1173 1157
-- Name: st_dumppoints(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dumppoints(geometry) RETURNS SETOF geometry_dump
    LANGUAGE sql
    AS $_$
  SELECT * FROM _ST_DumpPoints($1, NULL);
$_$;


ALTER FUNCTION public.st_dumppoints(geometry) OWNER TO postgres;

--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 300
-- Name: FUNCTION st_dumppoints(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dumppoints(geometry) IS 'args: geom - Returns a set of geometry_dump (geom,path) rows of all points that make up a geometry.';


--
-- TOC entry 296 (class 1255 OID 21598)
-- Dependencies: 3 1173 1157
-- Name: st_dumprings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dumprings(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_dump_rings';


ALTER FUNCTION public.st_dumprings(geometry) OWNER TO postgres;

--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 296
-- Name: FUNCTION st_dumprings(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dumprings(geometry) IS 'args: a_polygon - Returns a set of geometry_dump rows, representing the exterior and interior rings of a polygon.';


--
-- TOC entry 450 (class 1255 OID 21804)
-- Dependencies: 3 1157 1157
-- Name: st_dwithin(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dwithin(geometry, geometry, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && ST_Expand($2,$3) AND $2 && ST_Expand($1,$3) AND _ST_DWithin($1, $2, $3)$_$;


ALTER FUNCTION public.st_dwithin(geometry, geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 450
-- Name: FUNCTION st_dwithin(geometry, geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dwithin(geometry, geometry, double precision) IS 'args: g1, g2, distance_of_srid - Returns true if the geometries are within the specified distance of one another. For geometry units are in those of spatial reference and For geography units are in meters and measurement is defaulted to use_spheroid=true (measure around spheroid), for faster check, use_spheroid=false to measure along sphere.';


--
-- TOC entry 780 (class 1255 OID 22169)
-- Dependencies: 1184 1184 3
-- Name: st_dwithin(geography, geography, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dwithin(geography, geography, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && _ST_Expand($2,$3) AND $2 && _ST_Expand($1,$3) AND _ST_DWithin($1, $2, $3, true)$_$;


ALTER FUNCTION public.st_dwithin(geography, geography, double precision) OWNER TO postgres;

--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 780
-- Name: FUNCTION st_dwithin(geography, geography, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dwithin(geography, geography, double precision) IS 'args: gg1, gg2, distance_meters - Returns true if the geometries are within the specified distance of one another. For geometry units are in those of spatial reference and For geography units are in meters and measurement is defaulted to use_spheroid=true (measure around spheroid), for faster check, use_spheroid=false to measure along sphere.';


--
-- TOC entry 781 (class 1255 OID 22170)
-- Dependencies: 3
-- Name: st_dwithin(text, text, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dwithin(text, text, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_DWithin($1::geometry, $2::geometry, $3);  $_$;


ALTER FUNCTION public.st_dwithin(text, text, double precision) OWNER TO postgres;

--
-- TOC entry 779 (class 1255 OID 22168)
-- Dependencies: 3 1184 1184
-- Name: st_dwithin(geography, geography, double precision, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dwithin(geography, geography, double precision, boolean) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && _ST_Expand($2,$3) AND $2 && _ST_Expand($1,$3) AND _ST_DWithin($1, $2, $3, $4)$_$;


ALTER FUNCTION public.st_dwithin(geography, geography, double precision, boolean) OWNER TO postgres;

--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 779
-- Name: FUNCTION st_dwithin(geography, geography, double precision, boolean); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_dwithin(geography, geography, double precision, boolean) IS 'args: gg1, gg2, distance_meters, use_spheroid - Returns true if the geometries are within the specified distance of one another. For geometry units are in those of spatial reference and For geography units are in meters and measurement is defaulted to use_spheroid=true (measure around spheroid), for faster check, use_spheroid=false to measure along sphere.';


--
-- TOC entry 551 (class 1255 OID 21905)
-- Dependencies: 3 1157 1157
-- Name: st_endpoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_endpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_endpoint_linestring';


ALTER FUNCTION public.st_endpoint(geometry) OWNER TO postgres;

--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 551
-- Name: FUNCTION st_endpoint(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_endpoint(geometry) IS 'args: g - Returns the last point of a LINESTRING geometry as a POINT.';


--
-- TOC entry 228 (class 1255 OID 21527)
-- Dependencies: 1157 1157 3
-- Name: st_envelope(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_envelope(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_envelope';


ALTER FUNCTION public.st_envelope(geometry) OWNER TO postgres;

--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 228
-- Name: FUNCTION st_envelope(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_envelope(geometry) IS 'args: g1 - Returns a geometry representing the double precision (float8) bounding box of the supplied geometry.';


--
-- TOC entry 484 (class 1255 OID 21838)
-- Dependencies: 3 1157 1157
-- Name: st_equals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_equals(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT $1 && $2 AND _ST_Equals($1,$2)$_$;


ALTER FUNCTION public.st_equals(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 484
-- Name: FUNCTION st_equals(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_equals(geometry, geometry) IS 'args: A, B - Returns true if the given geometries represent the same geometry. Directionality is ignored.';


--
-- TOC entry 310 (class 1255 OID 21614)
-- Dependencies: 3 1167
-- Name: st_estimated_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_estimated_extent(text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-1.5', 'LWGEOM_estimated_extent';


ALTER FUNCTION public.st_estimated_extent(text, text) OWNER TO postgres;

--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 310
-- Name: FUNCTION st_estimated_extent(text, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_estimated_extent(text, text) IS 'args: table_name, geocolumn_name - Return the estimated extent of the given spatial table. The estimated is taken from the geometry columns statistics. The current schema will be used if not specified.';


--
-- TOC entry 308 (class 1255 OID 21612)
-- Dependencies: 3 1167
-- Name: st_estimated_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_estimated_extent(text, text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-1.5', 'LWGEOM_estimated_extent';


ALTER FUNCTION public.st_estimated_extent(text, text, text) OWNER TO postgres;

--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 308
-- Name: FUNCTION st_estimated_extent(text, text, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_estimated_extent(text, text, text) IS 'args: schema_name, table_name, geocolumn_name - Return the estimated extent of the given spatial table. The estimated is taken from the geometry columns statistics. The current schema will be used if not specified.';


--
-- TOC entry 222 (class 1255 OID 21521)
-- Dependencies: 1161 3 1161
-- Name: st_expand(box3d, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_expand(box3d, double precision) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_expand';


ALTER FUNCTION public.st_expand(box3d, double precision) OWNER TO postgres;

--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 222
-- Name: FUNCTION st_expand(box3d, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_expand(box3d, double precision) IS 'args: g1, units_to_expand - Returns bounding box expanded in all directions from the bounding box of the input geometry. Uses double-precision';


--
-- TOC entry 224 (class 1255 OID 21523)
-- Dependencies: 1167 3 1167
-- Name: st_expand(box2d, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_expand(box2d, double precision) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_expand';


ALTER FUNCTION public.st_expand(box2d, double precision) OWNER TO postgres;

--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 224
-- Name: FUNCTION st_expand(box2d, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_expand(box2d, double precision) IS 'args: g1, units_to_expand - Returns bounding box expanded in all directions from the bounding box of the input geometry. Uses double-precision';


--
-- TOC entry 226 (class 1255 OID 21525)
-- Dependencies: 3 1157 1157
-- Name: st_expand(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_expand(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_expand';


ALTER FUNCTION public.st_expand(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 226
-- Name: FUNCTION st_expand(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_expand(geometry, double precision) IS 'args: g1, units_to_expand - Returns bounding box expanded in all directions from the bounding box of the input geometry. Uses double-precision';


--
-- TOC entry 529 (class 1255 OID 21883)
-- Dependencies: 3 1157 1157
-- Name: st_exteriorring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_exteriorring(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_exteriorring_polygon';


ALTER FUNCTION public.st_exteriorring(geometry) OWNER TO postgres;

--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 529
-- Name: FUNCTION st_exteriorring(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_exteriorring(geometry) IS 'args: a_polygon - Returns a line string representing the exterior ring of the POLYGON geometry. Return NULL if the geometry is not a polygon. Will not work with MULTIPOLYGON';


--
-- TOC entry 156 (class 1255 OID 21455)
-- Dependencies: 1169 3
-- Name: st_factor(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_factor(chip) RETURNS real
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getFactor';


ALTER FUNCTION public.st_factor(chip) OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 21618)
-- Dependencies: 3 1424 1167
-- Name: st_find_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_find_extent(text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.st_find_extent(text, text) OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 21616)
-- Dependencies: 3 1424 1167
-- Name: st_find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_find_extent(text, text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT extent("' || columnname || '") FROM "' || schemaname || '"."' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.st_find_extent(text, text, text) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 21506)
-- Dependencies: 1157 3 1157
-- Name: st_force_2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_force_2d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_2d';


ALTER FUNCTION public.st_force_2d(geometry) OWNER TO postgres;

--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 207
-- Name: FUNCTION st_force_2d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_force_2d(geometry) IS 'args: geomA - Forces the geometries into a "2-dimensional mode" so that all output representations will only have the X and Y coordinates.';


--
-- TOC entry 211 (class 1255 OID 21510)
-- Dependencies: 3 1157 1157
-- Name: st_force_3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_force_3d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_3dz';


ALTER FUNCTION public.st_force_3d(geometry) OWNER TO postgres;

--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 211
-- Name: FUNCTION st_force_3d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_force_3d(geometry) IS 'args: geomA - Forces the geometries into XYZ mode. This is an alias for ST_Force_3DZ.';


--
-- TOC entry 213 (class 1255 OID 21512)
-- Dependencies: 3 1157 1157
-- Name: st_force_3dm(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_force_3dm(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_3dm';


ALTER FUNCTION public.st_force_3dm(geometry) OWNER TO postgres;

--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 213
-- Name: FUNCTION st_force_3dm(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_force_3dm(geometry) IS 'args: geomA - Forces the geometries into XYM mode.';


--
-- TOC entry 209 (class 1255 OID 21508)
-- Dependencies: 1157 3 1157
-- Name: st_force_3dz(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_force_3dz(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_3dz';


ALTER FUNCTION public.st_force_3dz(geometry) OWNER TO postgres;

--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 209
-- Name: FUNCTION st_force_3dz(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_force_3dz(geometry) IS 'args: geomA - Forces the geometries into XYZ mode. This is a synonym for ST_Force_3D.';


--
-- TOC entry 215 (class 1255 OID 21514)
-- Dependencies: 3 1157 1157
-- Name: st_force_4d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_force_4d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_4d';


ALTER FUNCTION public.st_force_4d(geometry) OWNER TO postgres;

--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 215
-- Name: FUNCTION st_force_4d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_force_4d(geometry) IS 'args: geomA - Forces the geometries into XYZM mode.';


--
-- TOC entry 217 (class 1255 OID 21516)
-- Dependencies: 1157 1157 3
-- Name: st_force_collection(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_force_collection(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_collection';


ALTER FUNCTION public.st_force_collection(geometry) OWNER TO postgres;

--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 217
-- Name: FUNCTION st_force_collection(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_force_collection(geometry) IS 'args: geomA - Converts the geometry into a GEOMETRYCOLLECTION.';


--
-- TOC entry 232 (class 1255 OID 21531)
-- Dependencies: 3 1157 1157
-- Name: st_forcerhr(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_forcerhr(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_forceRHR_poly';


ALTER FUNCTION public.st_forcerhr(geometry) OWNER TO postgres;

--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 232
-- Name: FUNCTION st_forcerhr(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_forcerhr(geometry) IS 'args: g - Forces the orientation of the vertices in a polygon to follow the Right-Hand-Rule.';


--
-- TOC entry 722 (class 1255 OID 22080)
-- Dependencies: 3 1184
-- Name: st_geogfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geogfromtext(text) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_from_text';


ALTER FUNCTION public.st_geogfromtext(text) OWNER TO postgres;

--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 722
-- Name: FUNCTION st_geogfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geogfromtext(text) IS 'args: EWKT - Return a specified geography value from Well-Known Text representation or extended (WKT).';


--
-- TOC entry 725 (class 1255 OID 22083)
-- Dependencies: 3 1184
-- Name: st_geogfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geogfromwkb(bytea) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_from_binary';


ALTER FUNCTION public.st_geogfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 725
-- Name: FUNCTION st_geogfromwkb(bytea); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geogfromwkb(bytea) IS 'args: geom - Creates a geography instance from a Well-Known Binary geometry representation (WKB) or extended Well Known Binary (EWKB).';


--
-- TOC entry 721 (class 1255 OID 22079)
-- Dependencies: 3 1184
-- Name: st_geographyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geographyfromtext(text) RETURNS geography
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geography_from_text';


ALTER FUNCTION public.st_geographyfromtext(text) OWNER TO postgres;

--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 721
-- Name: FUNCTION st_geographyfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geographyfromtext(text) IS 'args: EWKT - Return a specified geography value from Well-Known Text representation or extended (WKT).';


--
-- TOC entry 519 (class 1255 OID 21873)
-- Dependencies: 3 1157
-- Name: st_geohash(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geohash(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeoHash($1, 0)$_$;


ALTER FUNCTION public.st_geohash(geometry) OWNER TO postgres;

--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 519
-- Name: FUNCTION st_geohash(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geohash(geometry) IS 'args: g1 - Return a GeoHash representation (geohash.org) of the geometry.';


--
-- TOC entry 518 (class 1255 OID 21872)
-- Dependencies: 3 1157
-- Name: st_geohash(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geohash(geometry, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ST_GeoHash';


ALTER FUNCTION public.st_geohash(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 518
-- Name: FUNCTION st_geohash(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geohash(geometry, integer) IS 'args: g1, precision - Return a GeoHash representation (geohash.org) of the geometry.';


--
-- TOC entry 618 (class 1255 OID 21972)
-- Dependencies: 3 1157
-- Name: st_geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomcollfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(ST_GeomFromText($1)) = 'GEOMETRYCOLLECTION'
	THEN ST_GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_geomcollfromtext(text) OWNER TO postgres;

--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 618
-- Name: FUNCTION st_geomcollfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomcollfromtext(text) IS 'args: WKT - Makes a collection Geometry from collection WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 616 (class 1255 OID 21970)
-- Dependencies: 3 1157
-- Name: st_geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomcollfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(ST_GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN ST_GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_geomcollfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 616
-- Name: FUNCTION st_geomcollfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomcollfromtext(text, integer) IS 'args: WKT, srid - Makes a collection Geometry from collection WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 671 (class 1255 OID 22023)
-- Dependencies: 3 1157
-- Name: st_geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomcollfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(ST_GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_geomcollfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 669 (class 1255 OID 22021)
-- Dependencies: 3 1157
-- Name: st_geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomcollfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_geomcollfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 353 (class 1255 OID 21676)
-- Dependencies: 3 1157 1167
-- Name: st_geometry(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(box2d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_to_LWGEOM';


ALTER FUNCTION public.st_geometry(box2d) OWNER TO postgres;

--
-- TOC entry 354 (class 1255 OID 21677)
-- Dependencies: 3 1157 1161
-- Name: st_geometry(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(box3d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_LWGEOM';


ALTER FUNCTION public.st_geometry(box3d) OWNER TO postgres;

--
-- TOC entry 355 (class 1255 OID 21678)
-- Dependencies: 3 1157
-- Name: st_geometry(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'parse_WKT_lwgeom';


ALTER FUNCTION public.st_geometry(text) OWNER TO postgres;

--
-- TOC entry 356 (class 1255 OID 21679)
-- Dependencies: 3 1157 1169
-- Name: st_geometry(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(chip) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_to_LWGEOM';


ALTER FUNCTION public.st_geometry(chip) OWNER TO postgres;

--
-- TOC entry 357 (class 1255 OID 21680)
-- Dependencies: 3 1157
-- Name: st_geometry(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_bytea';


ALTER FUNCTION public.st_geometry(bytea) OWNER TO postgres;

--
-- TOC entry 361 (class 1255 OID 21684)
-- Dependencies: 3 1157 1164
-- Name: st_geometry(box3d_extent); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(box3d_extent) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_to_LWGEOM';


ALTER FUNCTION public.st_geometry(box3d_extent) OWNER TO postgres;

--
-- TOC entry 114 (class 1255 OID 21380)
-- Dependencies: 1157 3 1157
-- Name: st_geometry_above(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_above(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_above';


ALTER FUNCTION public.st_geometry_above(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 31 (class 1255 OID 21275)
-- Dependencies: 3
-- Name: st_geometry_analyze(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_analyze(internal) RETURNS boolean
    LANGUAGE c STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_analyze';


ALTER FUNCTION public.st_geometry_analyze(internal) OWNER TO postgres;

--
-- TOC entry 115 (class 1255 OID 21381)
-- Dependencies: 3 1157 1157
-- Name: st_geometry_below(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_below(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_below';


ALTER FUNCTION public.st_geometry_below(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 97 (class 1255 OID 21350)
-- Dependencies: 3 1157 1157
-- Name: st_geometry_cmp(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_cmp(geometry, geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_cmp';


ALTER FUNCTION public.st_geometry_cmp(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 116 (class 1255 OID 21382)
-- Dependencies: 3 1157 1157
-- Name: st_geometry_contain(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_contain(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_contain';


ALTER FUNCTION public.st_geometry_contain(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 117 (class 1255 OID 21383)
-- Dependencies: 1157 3 1157
-- Name: st_geometry_contained(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_contained(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_contained';


ALTER FUNCTION public.st_geometry_contained(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 96 (class 1255 OID 21349)
-- Dependencies: 1157 1157 3
-- Name: st_geometry_eq(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_eq(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_eq';


ALTER FUNCTION public.st_geometry_eq(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 95 (class 1255 OID 21348)
-- Dependencies: 1157 3 1157
-- Name: st_geometry_ge(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_ge(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_ge';


ALTER FUNCTION public.st_geometry_ge(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 94 (class 1255 OID 21347)
-- Dependencies: 1157 3 1157
-- Name: st_geometry_gt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_gt(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_gt';


ALTER FUNCTION public.st_geometry_gt(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 29 (class 1255 OID 21273)
-- Dependencies: 3 1157
-- Name: st_geometry_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_in(cstring) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_in';


ALTER FUNCTION public.st_geometry_in(cstring) OWNER TO postgres;

--
-- TOC entry 93 (class 1255 OID 21346)
-- Dependencies: 3 1157 1157
-- Name: st_geometry_le(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_le(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_le';


ALTER FUNCTION public.st_geometry_le(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 112 (class 1255 OID 21378)
-- Dependencies: 1157 1157 3
-- Name: st_geometry_left(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_left(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_left';


ALTER FUNCTION public.st_geometry_left(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 92 (class 1255 OID 21345)
-- Dependencies: 1157 1157 3
-- Name: st_geometry_lt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_lt(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'lwgeom_lt';


ALTER FUNCTION public.st_geometry_lt(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 30 (class 1255 OID 21274)
-- Dependencies: 1157 3
-- Name: st_geometry_out(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_out(geometry) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_out';


ALTER FUNCTION public.st_geometry_out(geometry) OWNER TO postgres;

--
-- TOC entry 110 (class 1255 OID 21376)
-- Dependencies: 1157 1157 3
-- Name: st_geometry_overabove(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_overabove(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overabove';


ALTER FUNCTION public.st_geometry_overabove(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 111 (class 1255 OID 21377)
-- Dependencies: 3 1157 1157
-- Name: st_geometry_overbelow(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_overbelow(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overbelow';


ALTER FUNCTION public.st_geometry_overbelow(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 118 (class 1255 OID 21384)
-- Dependencies: 1157 3 1157
-- Name: st_geometry_overlap(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_overlap(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overlap';


ALTER FUNCTION public.st_geometry_overlap(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 108 (class 1255 OID 21374)
-- Dependencies: 3 1157 1157
-- Name: st_geometry_overleft(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_overleft(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overleft';


ALTER FUNCTION public.st_geometry_overleft(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 109 (class 1255 OID 21375)
-- Dependencies: 1157 3 1157
-- Name: st_geometry_overright(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_overright(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_overright';


ALTER FUNCTION public.st_geometry_overright(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 32 (class 1255 OID 21276)
-- Dependencies: 1157 3
-- Name: st_geometry_recv(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_recv(internal) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_recv';


ALTER FUNCTION public.st_geometry_recv(internal) OWNER TO postgres;

--
-- TOC entry 113 (class 1255 OID 21379)
-- Dependencies: 1157 1157 3
-- Name: st_geometry_right(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_right(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_right';


ALTER FUNCTION public.st_geometry_right(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 119 (class 1255 OID 21385)
-- Dependencies: 1157 1157 3
-- Name: st_geometry_same(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_same(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_samebox';


ALTER FUNCTION public.st_geometry_same(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 33 (class 1255 OID 21277)
-- Dependencies: 3 1157
-- Name: st_geometry_send(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_send(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_send';


ALTER FUNCTION public.st_geometry_send(geometry) OWNER TO postgres;

--
-- TOC entry 567 (class 1255 OID 21921)
-- Dependencies: 3 1157
-- Name: st_geometryfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometryfromtext(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_text';


ALTER FUNCTION public.st_geometryfromtext(text) OWNER TO postgres;

--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 567
-- Name: FUNCTION st_geometryfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geometryfromtext(text) IS 'args: WKT - Return a specified ST_Geometry value from Well-Known Text representation (WKT). This is an alias name for ST_GeomFromText';


--
-- TOC entry 569 (class 1255 OID 21923)
-- Dependencies: 3 1157
-- Name: st_geometryfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometryfromtext(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_text';


ALTER FUNCTION public.st_geometryfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 569
-- Name: FUNCTION st_geometryfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geometryfromtext(text, integer) IS 'args: WKT, srid - Return a specified ST_Geometry value from Well-Known Text representation (WKT). This is an alias name for ST_GeomFromText';


--
-- TOC entry 525 (class 1255 OID 21879)
-- Dependencies: 3 1157 1157
-- Name: st_geometryn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometryn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_geometryn_collection';


ALTER FUNCTION public.st_geometryn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 525
-- Name: FUNCTION st_geometryn(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geometryn(geometry, integer) IS 'args: geomA, n - Return the 1-based Nth geometry if the geometry is a GEOMETRYCOLLECTION, MULTIPOINT, MULTILINESTRING, MULTICURVE or MULTIPOLYGON. Otherwise, return NULL.';


--
-- TOC entry 537 (class 1255 OID 21891)
-- Dependencies: 3 1157
-- Name: st_geometrytype(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometrytype(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geometry_geometrytype';


ALTER FUNCTION public.st_geometrytype(geometry) OWNER TO postgres;

--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 537
-- Name: FUNCTION st_geometrytype(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geometrytype(geometry) IS 'args: g1 - Return the geometry type of the ST_Geometry value.';


--
-- TOC entry 250 (class 1255 OID 21549)
-- Dependencies: 1157 3
-- Name: st_geomfromewkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromewkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOMFromWKB';


ALTER FUNCTION public.st_geomfromewkb(bytea) OWNER TO postgres;

--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 250
-- Name: FUNCTION st_geomfromewkb(bytea); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromewkb(bytea) IS 'args: EWKB - Return a specified ST_Geometry value from Extended Well-Known Binary representation (EWKB).';


--
-- TOC entry 252 (class 1255 OID 21551)
-- Dependencies: 1157 3
-- Name: st_geomfromewkt(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromewkt(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'parse_WKT_lwgeom';


ALTER FUNCTION public.st_geomfromewkt(text) OWNER TO postgres;

--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 252
-- Name: FUNCTION st_geomfromewkt(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromewkt(text) IS 'args: EWKT - Return a specified ST_Geometry value from Extended Well-Known Text representation (EWKT).';


--
-- TOC entry 485 (class 1255 OID 21839)
-- Dependencies: 3 1157
-- Name: st_geomfromgml(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromgml(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geom_from_gml';


ALTER FUNCTION public.st_geomfromgml(text) OWNER TO postgres;

--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 485
-- Name: FUNCTION st_geomfromgml(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromgml(text) IS 'args: geomgml - Takes as input GML representation of geometry and outputs a PostGIS geometry object';


--
-- TOC entry 487 (class 1255 OID 21841)
-- Dependencies: 3 1157
-- Name: st_geomfromkml(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromkml(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geom_from_kml';


ALTER FUNCTION public.st_geomfromkml(text) OWNER TO postgres;

--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 487
-- Name: FUNCTION st_geomfromkml(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromkml(text) IS 'args: geomkml - Takes as input KML representation of geometry and outputs a PostGIS geometry object';


--
-- TOC entry 571 (class 1255 OID 21925)
-- Dependencies: 3 1157
-- Name: st_geomfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromtext(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_text';


ALTER FUNCTION public.st_geomfromtext(text) OWNER TO postgres;

--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 571
-- Name: FUNCTION st_geomfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromtext(text) IS 'args: WKT - Return a specified ST_Geometry value from Well-Known Text representation (WKT).';


--
-- TOC entry 573 (class 1255 OID 21927)
-- Dependencies: 3 1157
-- Name: st_geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromtext(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_text';


ALTER FUNCTION public.st_geomfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 573
-- Name: FUNCTION st_geomfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromtext(text, integer) IS 'args: WKT, srid - Return a specified ST_Geometry value from Well-Known Text representation (WKT).';


--
-- TOC entry 620 (class 1255 OID 21974)
-- Dependencies: 3 1157
-- Name: st_geomfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromwkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_WKB';


ALTER FUNCTION public.st_geomfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 620
-- Name: FUNCTION st_geomfromwkb(bytea); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromwkb(bytea) IS 'args: geom - Makes a geometry from WKB with the given SRID';


--
-- TOC entry 622 (class 1255 OID 21976)
-- Dependencies: 3 1157
-- Name: st_geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geomfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SetSRID(ST_GeomFromWKB($1), $2)$_$;


ALTER FUNCTION public.st_geomfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 622
-- Name: FUNCTION st_geomfromwkb(bytea, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_geomfromwkb(bytea, integer) IS 'args: geom, srid - Makes a geometry from WKB with the given SRID';


--
-- TOC entry 486 (class 1255 OID 21840)
-- Dependencies: 3 1157
-- Name: st_gmltosql(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_gmltosql(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geom_from_gml';


ALTER FUNCTION public.st_gmltosql(text) OWNER TO postgres;

--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 486
-- Name: FUNCTION st_gmltosql(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_gmltosql(text) IS 'args: geomgml - Return a specified ST_Geometry value from GML representation. This is an alias name for ST_GeomFromGML';


--
-- TOC entry 804 (class 1255 OID 22193)
-- Dependencies: 3 1157
-- Name: st_hasarc(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_hasarc(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_has_arc';


ALTER FUNCTION public.st_hasarc(geometry) OWNER TO postgres;

--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 804
-- Name: FUNCTION st_hasarc(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_hasarc(geometry) IS 'args: geomA - Returns true if a geometry or geometry collection contains a circular string';


--
-- TOC entry 414 (class 1255 OID 21753)
-- Dependencies: 3 1157 1157
-- Name: st_hausdorffdistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_hausdorffdistance(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'hausdorffdistance';


ALTER FUNCTION public.st_hausdorffdistance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 414
-- Name: FUNCTION st_hausdorffdistance(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_hausdorffdistance(geometry, geometry) IS 'args: g1, g2 - Returns the Hausdorff distance between two geometries. Basically a measure of how similar or dissimilar 2 geometries are. Units are in the units of the spatial reference system of the geometries.';


--
-- TOC entry 415 (class 1255 OID 21754)
-- Dependencies: 3 1157 1157
-- Name: st_hausdorffdistance(geometry, geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_hausdorffdistance(geometry, geometry, double precision) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'hausdorffdistancedensify';


ALTER FUNCTION public.st_hausdorffdistance(geometry, geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 415
-- Name: FUNCTION st_hausdorffdistance(geometry, geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_hausdorffdistance(geometry, geometry, double precision) IS 'args: g1, g2, densifyFrac - Returns the Hausdorff distance between two geometries. Basically a measure of how similar or dissimilar 2 geometries are. Units are in the units of the spatial reference system of the geometries.';


--
-- TOC entry 154 (class 1255 OID 21453)
-- Dependencies: 1169 3
-- Name: st_height(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_height(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getHeight';


ALTER FUNCTION public.st_height(chip) OWNER TO postgres;

--
-- TOC entry 535 (class 1255 OID 21889)
-- Dependencies: 3 1157 1157
-- Name: st_interiorringn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_interiorringn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_interiorringn_polygon';


ALTER FUNCTION public.st_interiorringn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 535
-- Name: FUNCTION st_interiorringn(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_interiorringn(geometry, integer) IS 'args: a_polygon, n - Return the Nth interior linestring ring of the polygon geometry. Return NULL if the geometry is not a polygon or the given N is out of range.';


--
-- TOC entry 400 (class 1255 OID 21739)
-- Dependencies: 3 1157 1157 1157
-- Name: st_intersection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_intersection(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'intersection';


ALTER FUNCTION public.st_intersection(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 400
-- Name: FUNCTION st_intersection(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_intersection(geometry, geometry) IS 'args: geomA, geomB - (T) Returns a geometry that represents the shared portion of geomA and geomB. The geography implementation does a transform to geometry to do the intersection and then transform back to WGS84.';


--
-- TOC entry 800 (class 1255 OID 22189)
-- Dependencies: 1184 1184 1184 3
-- Name: st_intersection(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_intersection(geography, geography) RETURNS geography
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT geography(ST_Transform(ST_Intersection(ST_Transform(geometry($1), _ST_BestSRID($1, $2)), ST_Transform(geometry($2), _ST_BestSRID($1, $2))), 4326))$_$;


ALTER FUNCTION public.st_intersection(geography, geography) OWNER TO postgres;

--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 800
-- Name: FUNCTION st_intersection(geography, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_intersection(geography, geography) IS 'args: geogA, geogB - (T) Returns a geometry that represents the shared portion of geomA and geomB. The geography implementation does a transform to geometry to do the intersection and then transform back to WGS84.';


--
-- TOC entry 801 (class 1255 OID 22190)
-- Dependencies: 3 1157
-- Name: st_intersection(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_intersection(text, text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Intersection($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_intersection(text, text) OWNER TO postgres;

--
-- TOC entry 453 (class 1255 OID 21807)
-- Dependencies: 3 1157 1157
-- Name: st_intersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_intersects(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Intersects($1,$2)$_$;


ALTER FUNCTION public.st_intersects(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION st_intersects(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_intersects(geometry, geometry) IS 'args: geomA, geomB - Returns TRUE if the Geometries/Geography "spatially intersect" - (share any portion of space) and FALSE if they dont (they are Disjoint). For geography -- tolerance is 0.00001 meters (so any points that close are considered to intersect)';


--
-- TOC entry 794 (class 1255 OID 22183)
-- Dependencies: 1184 1184 3
-- Name: st_intersects(geography, geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_intersects(geography, geography) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT $1 && $2 AND _ST_Distance($1, $2, 0.0, false) < 0.00001$_$;


ALTER FUNCTION public.st_intersects(geography, geography) OWNER TO postgres;

--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 794
-- Name: FUNCTION st_intersects(geography, geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_intersects(geography, geography) IS 'args: geogA, geogB - Returns TRUE if the Geometries/Geography "spatially intersect" - (share any portion of space) and FALSE if they dont (they are Disjoint). For geography -- tolerance is 0.00001 meters (so any points that close are considered to intersect)';


--
-- TOC entry 795 (class 1255 OID 22184)
-- Dependencies: 3
-- Name: st_intersects(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_intersects(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Intersects($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_intersects(text, text) OWNER TO postgres;

--
-- TOC entry 553 (class 1255 OID 21907)
-- Dependencies: 3 1157
-- Name: st_isclosed(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_isclosed(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_isclosed_linestring';


ALTER FUNCTION public.st_isclosed(geometry) OWNER TO postgres;

--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 553
-- Name: FUNCTION st_isclosed(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_isclosed(geometry) IS 'args: g - Returns TRUE if the LINESTRINGs start and end points are coincident.';


--
-- TOC entry 555 (class 1255 OID 21909)
-- Dependencies: 3 1157
-- Name: st_isempty(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_isempty(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_isempty';


ALTER FUNCTION public.st_isempty(geometry) OWNER TO postgres;

--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 555
-- Name: FUNCTION st_isempty(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_isempty(geometry) IS 'args: geomA - Returns true if this Geometry is an empty geometry . If true, then this Geometry represents the empty point set - i.e. GEOMETRYCOLLECTION(EMPTY).';


--
-- TOC entry 477 (class 1255 OID 21831)
-- Dependencies: 3 1157
-- Name: st_isring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_isring(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'isring';


ALTER FUNCTION public.st_isring(geometry) OWNER TO postgres;

--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 477
-- Name: FUNCTION st_isring(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_isring(geometry) IS 'args: g - Returns TRUE if this LINESTRING is both closed and simple.';


--
-- TOC entry 481 (class 1255 OID 21835)
-- Dependencies: 3 1157
-- Name: st_issimple(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_issimple(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'issimple';


ALTER FUNCTION public.st_issimple(geometry) OWNER TO postgres;

--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 481
-- Name: FUNCTION st_issimple(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_issimple(geometry) IS 'args: geomA - Returns (TRUE) if this Geometry has no anomalous geometric points, such as self intersection or self tangency.';


--
-- TOC entry 473 (class 1255 OID 21827)
-- Dependencies: 3 1157
-- Name: st_isvalid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_isvalid(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'isvalid';


ALTER FUNCTION public.st_isvalid(geometry) OWNER TO postgres;

--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 473
-- Name: FUNCTION st_isvalid(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_isvalid(geometry) IS 'args: g - Returns true if the ST_Geometry is well formed.';


--
-- TOC entry 413 (class 1255 OID 21752)
-- Dependencies: 3 1157
-- Name: st_isvalidreason(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_isvalidreason(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'isvalidreason';


ALTER FUNCTION public.st_isvalidreason(geometry) OWNER TO postgres;

--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 413
-- Name: FUNCTION st_isvalidreason(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_isvalidreason(geometry) IS 'args: geomA - Returns text stating if a geometry is valid or not and if not valid, a reason why.';


--
-- TOC entry 179 (class 1255 OID 21478)
-- Dependencies: 3 1157
-- Name: st_length(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_length2d_linestring';


ALTER FUNCTION public.st_length(geometry) OWNER TO postgres;

--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 179
-- Name: FUNCTION st_length(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length(geometry) IS 'args: a_2dlinestring - Returns the 2d length of the geometry if it is a linestring or multilinestring. geometry are in units of spatial reference and geography are in meters (default spheroid)';


--
-- TOC entry 786 (class 1255 OID 22175)
-- Dependencies: 1184 3
-- Name: st_length(geography); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length(geography) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ST_Length($1, true)$_$;


ALTER FUNCTION public.st_length(geography) OWNER TO postgres;

--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 786
-- Name: FUNCTION st_length(geography); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length(geography) IS 'args: gg - Returns the 2d length of the geometry if it is a linestring or multilinestring. geometry are in units of spatial reference and geography are in meters (default spheroid)';


--
-- TOC entry 787 (class 1255 OID 22176)
-- Dependencies: 3
-- Name: st_length(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length(text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Length($1::geometry);  $_$;


ALTER FUNCTION public.st_length(text) OWNER TO postgres;

--
-- TOC entry 785 (class 1255 OID 22174)
-- Dependencies: 1184 3
-- Name: st_length(geography, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length(geography, boolean) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'geography_length';


ALTER FUNCTION public.st_length(geography, boolean) OWNER TO postgres;

--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 785
-- Name: FUNCTION st_length(geography, boolean); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length(geography, boolean) IS 'args: gg, use_spheroid - Returns the 2d length of the geometry if it is a linestring or multilinestring. geometry are in units of spatial reference and geography are in meters (default spheroid)';


--
-- TOC entry 177 (class 1255 OID 21476)
-- Dependencies: 1157 3
-- Name: st_length2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_length2d_linestring';


ALTER FUNCTION public.st_length2d(geometry) OWNER TO postgres;

--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 177
-- Name: FUNCTION st_length2d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length2d(geometry) IS 'args: a_2dlinestring - Returns the 2-dimensional length of the geometry if it is a linestring or multi-linestring. This is an alias for ST_Length';


--
-- TOC entry 185 (class 1255 OID 21484)
-- Dependencies: 3 1157 1153
-- Name: st_length2d_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length2d_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_length2d_ellipsoid';


ALTER FUNCTION public.st_length2d_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 185
-- Name: FUNCTION st_length2d_spheroid(geometry, spheroid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length2d_spheroid(geometry, spheroid) IS 'args: a_linestring, a_spheroid - Calculates the 2D length of a linestring/multilinestring on an ellipsoid. This is useful if the coordinates of the geometry are in longitude/latitude and a length is desired without reprojection.';


--
-- TOC entry 175 (class 1255 OID 21474)
-- Dependencies: 1157 3
-- Name: st_length3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_length_linestring';


ALTER FUNCTION public.st_length3d(geometry) OWNER TO postgres;

--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 175
-- Name: FUNCTION st_length3d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length3d(geometry) IS 'args: a_3dlinestring - Returns the 3-dimensional or 2-dimensional length of the geometry if it is a linestring or multi-linestring.';


--
-- TOC entry 181 (class 1255 OID 21480)
-- Dependencies: 1157 1153 3
-- Name: st_length3d_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length3d_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_length_ellipsoid_linestring';


ALTER FUNCTION public.st_length3d_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 181
-- Name: FUNCTION st_length3d_spheroid(geometry, spheroid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length3d_spheroid(geometry, spheroid) IS 'args: a_linestring, a_spheroid - Calculates the length of a geometry on an ellipsoid, taking the elevation into account. This is just an alias for ST_Length_Spheroid.';


--
-- TOC entry 183 (class 1255 OID 21482)
-- Dependencies: 1157 1153 3
-- Name: st_length_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'LWGEOM_length_ellipsoid_linestring';


ALTER FUNCTION public.st_length_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 183
-- Name: FUNCTION st_length_spheroid(geometry, spheroid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_length_spheroid(geometry, spheroid) IS 'args: a_linestring, a_spheroid - Calculates the 2D or 3D length of a linestring/multilinestring on an ellipsoid. This is useful if the coordinates of the geometry are in longitude/latitude and a length is desired without reprojection.';


--
-- TOC entry 389 (class 1255 OID 21728)
-- Dependencies: 3 1157 1157
-- Name: st_line_interpolate_point(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_line_interpolate_point(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_interpolate_point';


ALTER FUNCTION public.st_line_interpolate_point(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 389
-- Name: FUNCTION st_line_interpolate_point(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_line_interpolate_point(geometry, double precision) IS 'args: a_linestring, a_fraction - Returns a point interpolated along a line. Second argument is a float8 between 0 and 1 representing fraction of total length of linestring the point has to be located.';


--
-- TOC entry 393 (class 1255 OID 21732)
-- Dependencies: 3 1157 1157
-- Name: st_line_locate_point(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_line_locate_point(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_locate_point';


ALTER FUNCTION public.st_line_locate_point(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 393
-- Name: FUNCTION st_line_locate_point(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_line_locate_point(geometry, geometry) IS 'args: a_linestring, a_point - Returns a float between 0 and 1 representing the location of the closest point on LineString to the given Point, as a fraction of total 2d line length.';


--
-- TOC entry 391 (class 1255 OID 21730)
-- Dependencies: 3 1157 1157
-- Name: st_line_substring(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_line_substring(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_substring';


ALTER FUNCTION public.st_line_substring(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 391
-- Name: FUNCTION st_line_substring(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_line_substring(geometry, double precision, double precision) IS 'args: a_linestring, startfraction, endfraction - Return a linestring being a substring of the input one starting and ending at the given fractions of total 2d length. Second and third arguments are float8 values between 0 and 1.';


--
-- TOC entry 410 (class 1255 OID 21749)
-- Dependencies: 3 1157 1157
-- Name: st_linecrossingdirection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linecrossingdirection(geometry, geometry) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT CASE WHEN NOT $1 && $2 THEN 0 ELSE _ST_LineCrossingDirection($1,$2) END $_$;


ALTER FUNCTION public.st_linecrossingdirection(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 410
-- Name: FUNCTION st_linecrossingdirection(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linecrossingdirection(geometry, geometry) IS 'args: linestringA, linestringB - Given 2 linestrings, returns a number between -3 and 3 denoting what kind of crossing behavior. 0 is no crossing.';


--
-- TOC entry 270 (class 1255 OID 21569)
-- Dependencies: 3 1157 1157
-- Name: st_linefrommultipoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linefrommultipoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_from_mpoint';


ALTER FUNCTION public.st_linefrommultipoint(geometry) OWNER TO postgres;

--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 270
-- Name: FUNCTION st_linefrommultipoint(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linefrommultipoint(geometry) IS 'args: aMultiPoint - Creates a LineString from a MultiPoint geometry.';


--
-- TOC entry 579 (class 1255 OID 21933)
-- Dependencies: 3 1157
-- Name: st_linefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'LINESTRING'
	THEN ST_GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_linefromtext(text) OWNER TO postgres;

--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 579
-- Name: FUNCTION st_linefromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linefromtext(text) IS 'args: WKT - Makes a Geometry from WKT representation with the given SRID. If SRID is not given, it defaults to -1.';


--
-- TOC entry 581 (class 1255 OID 21935)
-- Dependencies: 3 1157
-- Name: st_linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'LINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_linefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 581
-- Name: FUNCTION st_linefromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linefromtext(text, integer) IS 'args: WKT, srid - Makes a Geometry from WKT representation with the given SRID. If SRID is not given, it defaults to -1.';


--
-- TOC entry 630 (class 1255 OID 21984)
-- Dependencies: 3 1157
-- Name: st_linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'LINESTRING'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_linefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 630
-- Name: FUNCTION st_linefromwkb(bytea); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linefromwkb(bytea) IS 'args: WKB - Makes a LINESTRING from WKB with the given SRID';


--
-- TOC entry 628 (class 1255 OID 21982)
-- Dependencies: 3 1157
-- Name: st_linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_linefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 628
-- Name: FUNCTION st_linefromwkb(bytea, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linefromwkb(bytea, integer) IS 'args: WKB, srid - Makes a LINESTRING from WKB with the given SRID';


--
-- TOC entry 292 (class 1255 OID 21591)
-- Dependencies: 3 1157 1157
-- Name: st_linemerge(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linemerge(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'linemerge';


ALTER FUNCTION public.st_linemerge(geometry) OWNER TO postgres;

--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 292
-- Name: FUNCTION st_linemerge(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linemerge(geometry) IS 'args: amultilinestring - Returns a (set of) LineString(s) formed by sewing together a MULTILINESTRING.';


--
-- TOC entry 634 (class 1255 OID 21988)
-- Dependencies: 3 1157
-- Name: st_linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linestringfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_linestringfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 634
-- Name: FUNCTION st_linestringfromwkb(bytea); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linestringfromwkb(bytea) IS 'args: WKB - Makes a geometry from WKB with the given SRID.';


--
-- TOC entry 632 (class 1255 OID 21986)
-- Dependencies: 3 1157
-- Name: st_linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linestringfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_linestringfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 632
-- Name: FUNCTION st_linestringfromwkb(bytea, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linestringfromwkb(bytea, integer) IS 'args: WKB, srid - Makes a geometry from WKB with the given SRID.';


--
-- TOC entry 805 (class 1255 OID 22194)
-- Dependencies: 1157 3 1157
-- Name: st_linetocurve(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_linetocurve(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_line_desegmentize';


ALTER FUNCTION public.st_linetocurve(geometry) OWNER TO postgres;

--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 805
-- Name: FUNCTION st_linetocurve(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_linetocurve(geometry) IS 'args: geomANoncircular - Converts a LINESTRING/POLYGON to a CIRCULARSTRING, CURVED POLYGON';


--
-- TOC entry 397 (class 1255 OID 21736)
-- Dependencies: 3 1157 1157
-- Name: st_locate_along_measure(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_locate_along_measure(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT locate_between_measures($1, $2, $2) $_$;


ALTER FUNCTION public.st_locate_along_measure(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 397
-- Name: FUNCTION st_locate_along_measure(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_locate_along_measure(geometry, double precision) IS 'args: ageom_with_measure, a_measure - Return a derived geometry collection value with elements that match the specified measure. Polygonal elements are not supported.';


--
-- TOC entry 395 (class 1255 OID 21734)
-- Dependencies: 3 1157 1157
-- Name: st_locate_between_measures(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_locate_between_measures(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_locate_between_m';


ALTER FUNCTION public.st_locate_between_measures(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 395
-- Name: FUNCTION st_locate_between_measures(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_locate_between_measures(geometry, double precision, double precision) IS 'args: geomA, measure_start, measure_end - Return a derived geometry collection value with elements that match the specified range of measures inclusively. Polygonal elements are not supported.';


--
-- TOC entry 411 (class 1255 OID 21750)
-- Dependencies: 3 1157 1157
-- Name: st_locatebetweenelevations(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_locatebetweenelevations(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ST_LocateBetweenElevations';


ALTER FUNCTION public.st_locatebetweenelevations(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 411
-- Name: FUNCTION st_locatebetweenelevations(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_locatebetweenelevations(geometry, double precision, double precision) IS 'args: geom_mline, elevation_start, elevation_end - Return a derived geometry (collection) value with elements that intersect the specified range of elevations inclusively. Only 3D, 4D LINESTRINGS and MULTILINESTRINGS are supported.';


--
-- TOC entry 678 (class 1255 OID 22030)
-- Dependencies: 3 1157 1157 1157
-- Name: st_longestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_longestline(geometry, geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_LongestLine(ST_ConvexHull($1), ST_ConvexHull($2))$_$;


ALTER FUNCTION public.st_longestline(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 678
-- Name: FUNCTION st_longestline(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_longestline(geometry, geometry) IS 'args: g1, g2 - Returns the 2-dimensional longest line points of two geometries. The function will only return the first longest line if more than one, that the function finds. The line returned will always start in g1 and end in g2. The length of the line this function returns will always be the same as st_maxdistance returns for g1 and g2.';


--
-- TOC entry 547 (class 1255 OID 21901)
-- Dependencies: 3 1157
-- Name: st_m(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_m(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_m_point';


ALTER FUNCTION public.st_m(geometry) OWNER TO postgres;

--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 547
-- Name: FUNCTION st_m(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_m(geometry) IS 'args: a_point - Return the M coordinate of the point, or NULL if not available. Input must be a point.';


--
-- TOC entry 263 (class 1255 OID 21562)
-- Dependencies: 1157 3 1167 1157
-- Name: st_makebox2d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makebox2d(geometry, geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX2DFLOAT4_construct';


ALTER FUNCTION public.st_makebox2d(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 263
-- Name: FUNCTION st_makebox2d(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makebox2d(geometry, geometry) IS 'args: pointLowLeft, pointUpRight - Creates a BOX2D defined by the given point geometries.';


--
-- TOC entry 265 (class 1255 OID 21564)
-- Dependencies: 1157 3 1161 1157
-- Name: st_makebox3d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makebox3d(geometry, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_construct';


ALTER FUNCTION public.st_makebox3d(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 265
-- Name: FUNCTION st_makebox3d(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makebox3d(geometry, geometry) IS 'args: point3DLowLeftBottom, point3DUpRightTop - Creates a BOX3D defined by the given 3d point geometries.';


--
-- TOC entry 281 (class 1255 OID 21580)
-- Dependencies: 3 1157
-- Name: st_makeenvelope(double precision, double precision, double precision, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makeenvelope(double precision, double precision, double precision, double precision, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ST_MakeEnvelope';


ALTER FUNCTION public.st_makeenvelope(double precision, double precision, double precision, double precision, integer) OWNER TO postgres;

--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 281
-- Name: FUNCTION st_makeenvelope(double precision, double precision, double precision, double precision, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makeenvelope(double precision, double precision, double precision, double precision, integer) IS 'args: xmin, ymin, xmax, ymax, srid - Creates a rectangular Polygon formed from the given minimums and maximums. Input values must be in SRS specified by the SRID.';


--
-- TOC entry 268 (class 1255 OID 21567)
-- Dependencies: 1157 3 1160
-- Name: st_makeline(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makeline(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makeline_garray';


ALTER FUNCTION public.st_makeline(geometry[]) OWNER TO postgres;

--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 268
-- Name: FUNCTION st_makeline(geometry[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makeline(geometry[]) IS 'args: point_array - Creates a Linestring from point geometries.';


--
-- TOC entry 272 (class 1255 OID 21571)
-- Dependencies: 3 1157 1157 1157
-- Name: st_makeline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makeline(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makeline';


ALTER FUNCTION public.st_makeline(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 272
-- Name: FUNCTION st_makeline(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makeline(geometry, geometry) IS 'args: point1, point2 - Creates a Linestring from point geometries.';


--
-- TOC entry 267 (class 1255 OID 21566)
-- Dependencies: 1160 3 1157
-- Name: st_makeline_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makeline_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makeline_garray';


ALTER FUNCTION public.st_makeline_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 21554)
-- Dependencies: 3 1157
-- Name: st_makepoint(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makepoint(double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint';


ALTER FUNCTION public.st_makepoint(double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 255
-- Name: FUNCTION st_makepoint(double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makepoint(double precision, double precision) IS 'args: x, y - Creates a 2D,3DZ or 4D point geometry.';


--
-- TOC entry 257 (class 1255 OID 21556)
-- Dependencies: 3 1157
-- Name: st_makepoint(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makepoint(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint';


ALTER FUNCTION public.st_makepoint(double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 257
-- Name: FUNCTION st_makepoint(double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makepoint(double precision, double precision, double precision) IS 'args: x, y, z - Creates a 2D,3DZ or 4D point geometry.';


--
-- TOC entry 259 (class 1255 OID 21558)
-- Dependencies: 3 1157
-- Name: st_makepoint(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makepoint(double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint';


ALTER FUNCTION public.st_makepoint(double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 259
-- Name: FUNCTION st_makepoint(double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makepoint(double precision, double precision, double precision, double precision) IS 'args: x, y, z, m - Creates a 2D,3DZ or 4D point geometry.';


--
-- TOC entry 261 (class 1255 OID 21560)
-- Dependencies: 1157 3
-- Name: st_makepointm(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makepointm(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint3dm';


ALTER FUNCTION public.st_makepointm(double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 261
-- Name: FUNCTION st_makepointm(double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makepointm(double precision, double precision, double precision) IS 'args: x, y, m - Creates a point geometry with an x y and m coordinate.';


--
-- TOC entry 285 (class 1255 OID 21584)
-- Dependencies: 3 1157 1157
-- Name: st_makepolygon(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makepolygon(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoly';


ALTER FUNCTION public.st_makepolygon(geometry) OWNER TO postgres;

--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 285
-- Name: FUNCTION st_makepolygon(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makepolygon(geometry) IS 'args: linestring - Creates a Polygon formed by the given shell. Input geometries must be closed LINESTRINGS.';


--
-- TOC entry 283 (class 1255 OID 21582)
-- Dependencies: 1157 3 1157 1160
-- Name: st_makepolygon(geometry, geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makepolygon(geometry, geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoly';


ALTER FUNCTION public.st_makepolygon(geometry, geometry[]) OWNER TO postgres;

--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 283
-- Name: FUNCTION st_makepolygon(geometry, geometry[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_makepolygon(geometry, geometry[]) IS 'args: outerlinestring, interiorlinestrings - Creates a Polygon formed by the given shell. Input geometries must be closed LINESTRINGS.';


--
-- TOC entry 674 (class 1255 OID 22026)
-- Dependencies: 3 1157 1157
-- Name: st_maxdistance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_maxdistance(geometry, geometry) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_MaxDistance(ST_ConvexHull($1), ST_ConvexHull($2))$_$;


ALTER FUNCTION public.st_maxdistance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 674
-- Name: FUNCTION st_maxdistance(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_maxdistance(geometry, geometry) IS 'args: g1, g2 - Returns the 2-dimensional largest distance between two geometries in projected units.';


--
-- TOC entry 167 (class 1255 OID 21466)
-- Dependencies: 3 1157
-- Name: st_mem_size(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mem_size(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_mem_size';


ALTER FUNCTION public.st_mem_size(geometry) OWNER TO postgres;

--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 167
-- Name: FUNCTION st_mem_size(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_mem_size(geometry) IS 'args: geomA - Returns the amount of space (in bytes) the geometry takes.';


--
-- TOC entry 807 (class 1255 OID 22197)
-- Dependencies: 1157 3 1157
-- Name: st_minimumboundingcircle(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_minimumboundingcircle(geometry) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MinimumBoundingCircle($1, 48)$_$;


ALTER FUNCTION public.st_minimumboundingcircle(geometry) OWNER TO postgres;

--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 807
-- Name: FUNCTION st_minimumboundingcircle(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_minimumboundingcircle(geometry) IS 'args: geomA - Returns the smallest circle polygon that can fully contain a geometry. Default uses 48 segments per quarter circle.';


--
-- TOC entry 806 (class 1255 OID 22195)
-- Dependencies: 3 1424 1157 1157
-- Name: st_minimumboundingcircle(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_minimumboundingcircle(inputgeom geometry, segs_per_quarter integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
	DECLARE
	hull GEOMETRY;
	ring GEOMETRY;
	center GEOMETRY;
	radius DOUBLE PRECISION;
	dist DOUBLE PRECISION;
	d DOUBLE PRECISION;
	idx1 integer;
	idx2 integer;
	l1 GEOMETRY;
	l2 GEOMETRY;
	p1 GEOMETRY;
	p2 GEOMETRY;
	a1 DOUBLE PRECISION;
	a2 DOUBLE PRECISION;


	BEGIN

	-- First compute the ConvexHull of the geometry
	hull = ST_ConvexHull(inputgeom);
	--A point really has no MBC
	IF ST_GeometryType(hull) = 'ST_Point' THEN
		RETURN hull;
	END IF;
	-- convert the hull perimeter to a linestring so we can manipulate individual points
	--If its already a linestring force it to a closed linestring
	ring = CASE WHEN ST_GeometryType(hull) = 'ST_LineString' THEN ST_AddPoint(hull, ST_StartPoint(hull)) ELSE ST_ExteriorRing(hull) END;

	dist = 0;
	-- Brute Force - check every pair
	FOR i in 1 .. (ST_NumPoints(ring)-2)
		LOOP
			FOR j in i .. (ST_NumPoints(ring)-1)
				LOOP
				d = ST_Distance(ST_PointN(ring,i),ST_PointN(ring,j));
				-- Check the distance and update if larger
				IF (d > dist) THEN
					dist = d;
					idx1 = i;
					idx2 = j;
				END IF;
			END LOOP;
		END LOOP;

	-- We now have the diameter of the convex hull.  The following line returns it if desired.
	-- RETURN MakeLine(PointN(ring,idx1),PointN(ring,idx2));

	-- Now for the Minimum Bounding Circle.  Since we know the two points furthest from each
	-- other, the MBC must go through those two points. Start with those points as a diameter of a circle.

	-- The radius is half the distance between them and the center is midway between them
	radius = ST_Distance(ST_PointN(ring,idx1),ST_PointN(ring,idx2)) / 2.0;
	center = ST_Line_interpolate_point(ST_MakeLine(ST_PointN(ring,idx1),ST_PointN(ring,idx2)),0.5);

	-- Loop through each vertex and check if the distance from the center to the point
	-- is greater than the current radius.
	FOR k in 1 .. (ST_NumPoints(ring)-1)
		LOOP
		IF(k <> idx1 and k <> idx2) THEN
			dist = ST_Distance(center,ST_PointN(ring,k));
			IF (dist > radius) THEN
				-- We have to expand the circle.  The new circle must pass trhough
				-- three points - the two original diameters and this point.

				-- Draw a line from the first diameter to this point
				l1 = ST_Makeline(ST_PointN(ring,idx1),ST_PointN(ring,k));
				-- Compute the midpoint
				p1 = ST_line_interpolate_point(l1,0.5);
				-- Rotate the line 90 degrees around the midpoint (perpendicular bisector)
				l1 = ST_Translate(ST_Rotate(ST_Translate(l1,-X(p1),-Y(p1)),pi()/2),X(p1),Y(p1));
				--  Compute the azimuth of the bisector
				a1 = ST_Azimuth(ST_PointN(l1,1),ST_PointN(l1,2));
				--  Extend the line in each direction the new computed distance to insure they will intersect
				l1 = ST_AddPoint(l1,ST_Makepoint(X(ST_PointN(l1,2))+sin(a1)*dist,Y(ST_PointN(l1,2))+cos(a1)*dist),-1);
				l1 = ST_AddPoint(l1,ST_Makepoint(X(ST_PointN(l1,1))-sin(a1)*dist,Y(ST_PointN(l1,1))-cos(a1)*dist),0);

				-- Repeat for the line from the point to the other diameter point
				l2 = ST_Makeline(ST_PointN(ring,idx2),ST_PointN(ring,k));
				p2 = ST_Line_interpolate_point(l2,0.5);
				l2 = ST_Translate(ST_Rotate(ST_Translate(l2,-X(p2),-Y(p2)),pi()/2),X(p2),Y(p2));
				a2 = ST_Azimuth(ST_PointN(l2,1),ST_PointN(l2,2));
				l2 = ST_AddPoint(l2,ST_Makepoint(X(ST_PointN(l2,2))+sin(a2)*dist,Y(ST_PointN(l2,2))+cos(a2)*dist),-1);
				l2 = ST_AddPoint(l2,ST_Makepoint(X(ST_PointN(l2,1))-sin(a2)*dist,Y(ST_PointN(l2,1))-cos(a2)*dist),0);

				-- The new center is the intersection of the two bisectors
				center = ST_Intersection(l1,l2);
				-- The new radius is the distance to any of the three points
				radius = ST_Distance(center,ST_PointN(ring,idx1));
			END IF;
		END IF;
		END LOOP;
	--DONE!!  Return the MBC via the buffer command
	RETURN ST_Buffer(center,radius,segs_per_quarter);

	END;
$$;


ALTER FUNCTION public.st_minimumboundingcircle(inputgeom geometry, segs_per_quarter integer) OWNER TO postgres;

--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 806
-- Name: FUNCTION st_minimumboundingcircle(inputgeom geometry, segs_per_quarter integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_minimumboundingcircle(inputgeom geometry, segs_per_quarter integer) IS 'args: geomA, num_segs_per_qt_circ - Returns the smallest circle polygon that can fully contain a geometry. Default uses 48 segments per quarter circle.';


--
-- TOC entry 595 (class 1255 OID 21949)
-- Dependencies: 3 1157
-- Name: st_mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mlinefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'MULTILINESTRING'
	THEN ST_GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mlinefromtext(text) OWNER TO postgres;

--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 595
-- Name: FUNCTION st_mlinefromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_mlinefromtext(text) IS 'args: WKT - Return a specified ST_MultiLineString value from WKT representation.';


--
-- TOC entry 593 (class 1255 OID 21947)
-- Dependencies: 3 1157
-- Name: st_mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mlinefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mlinefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 593
-- Name: FUNCTION st_mlinefromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_mlinefromtext(text, integer) IS 'args: WKT, srid - Return a specified ST_MultiLineString value from WKT representation.';


--
-- TOC entry 658 (class 1255 OID 22011)
-- Dependencies: 3 1157
-- Name: st_mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mlinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mlinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 656 (class 1255 OID 22009)
-- Dependencies: 3 1157
-- Name: st_mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mlinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mlinefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 603 (class 1255 OID 21957)
-- Dependencies: 3 1157
-- Name: st_mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'MULTIPOINT'
	THEN ST_GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpointfromtext(text) OWNER TO postgres;

--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 603
-- Name: FUNCTION st_mpointfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_mpointfromtext(text) IS 'args: WKT - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 601 (class 1255 OID 21955)
-- Dependencies: 3 1157
-- Name: st_mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'MULTIPOINT'
	THEN GeomFromText($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 601
-- Name: FUNCTION st_mpointfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_mpointfromtext(text, integer) IS 'args: WKT, srid - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 646 (class 1255 OID 22000)
-- Dependencies: 3 1157
-- Name: st_mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOINT'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 644 (class 1255 OID 21998)
-- Dependencies: 3 1157
-- Name: st_mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 610 (class 1255 OID 21964)
-- Dependencies: 3 1157
-- Name: st_mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpolyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'MULTIPOLYGON'
	THEN ST_GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpolyfromtext(text) OWNER TO postgres;

--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 610
-- Name: FUNCTION st_mpolyfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_mpolyfromtext(text) IS 'args: WKT - Makes a MultiPolygon Geometry from WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 608 (class 1255 OID 21962)
-- Dependencies: 3 1157
-- Name: st_mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'MULTIPOLYGON'
	THEN ST_GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 608
-- Name: FUNCTION st_mpolyfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_mpolyfromtext(text, integer) IS 'args: WKT, srid - Makes a MultiPolygon Geometry from WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 662 (class 1255 OID 22015)
-- Dependencies: 3 1157
-- Name: st_mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 660 (class 1255 OID 22013)
-- Dependencies: 3 1157
-- Name: st_mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_mpolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_mpolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 21519)
-- Dependencies: 1157 3 1157
-- Name: st_multi(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multi(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_force_multi';


ALTER FUNCTION public.st_multi(geometry) OWNER TO postgres;

--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 220
-- Name: FUNCTION st_multi(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_multi(geometry) IS 'args: g1 - Returns the geometry as a MULTI* geometry. If the geometry is already a MULTI*, it is returned unchanged.';


--
-- TOC entry 654 (class 1255 OID 22007)
-- Dependencies: 3 1157
-- Name: st_multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multilinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_multilinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 597 (class 1255 OID 21951)
-- Dependencies: 3 1157
-- Name: st_multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multilinestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


ALTER FUNCTION public.st_multilinestringfromtext(text) OWNER TO postgres;

--
-- TOC entry 599 (class 1255 OID 21953)
-- Dependencies: 3 1157
-- Name: st_multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multilinestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MLineFromText($1, $2)$_$;


ALTER FUNCTION public.st_multilinestringfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 605 (class 1255 OID 21960)
-- Dependencies: 3 1157
-- Name: st_multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multipointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1)$_$;


ALTER FUNCTION public.st_multipointfromtext(text) OWNER TO postgres;

--
-- TOC entry 650 (class 1255 OID 22004)
-- Dependencies: 3 1157
-- Name: st_multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multipointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOINT'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_multipointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 648 (class 1255 OID 22002)
-- Dependencies: 3 1157
-- Name: st_multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multipointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_multipointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 667 (class 1255 OID 22019)
-- Dependencies: 3 1157
-- Name: st_multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multipolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_multipolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 665 (class 1255 OID 22017)
-- Dependencies: 3 1157
-- Name: st_multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multipolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_multipolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 614 (class 1255 OID 21968)
-- Dependencies: 3 1157
-- Name: st_multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multipolygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1)$_$;


ALTER FUNCTION public.st_multipolygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 612 (class 1255 OID 21966)
-- Dependencies: 3 1157
-- Name: st_multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_multipolygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1, $2)$_$;


ALTER FUNCTION public.st_multipolygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 21537)
-- Dependencies: 3 1157
-- Name: st_ndims(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_ndims(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_ndims';


ALTER FUNCTION public.st_ndims(geometry) OWNER TO postgres;

--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 238
-- Name: FUNCTION st_ndims(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_ndims(geometry) IS 'args: g1 - Returns coordinate dimension of the geometry as a small int. Values are: 2,3 or 4.';


--
-- TOC entry 171 (class 1255 OID 21470)
-- Dependencies: 3 1157
-- Name: st_npoints(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_npoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_npoints';


ALTER FUNCTION public.st_npoints(geometry) OWNER TO postgres;

--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 171
-- Name: FUNCTION st_npoints(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_npoints(geometry) IS 'args: g1 - Return the number of points (vertexes) in a geometry.';


--
-- TOC entry 173 (class 1255 OID 21472)
-- Dependencies: 1157 3
-- Name: st_nrings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_nrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_nrings';


ALTER FUNCTION public.st_nrings(geometry) OWNER TO postgres;

--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 173
-- Name: FUNCTION st_nrings(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_nrings(geometry) IS 'args: geomA - If the geometry is a polygon or multi-polygon returns the number of rings.';


--
-- TOC entry 523 (class 1255 OID 21877)
-- Dependencies: 3 1157
-- Name: st_numgeometries(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_numgeometries(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numgeometries_collection';


ALTER FUNCTION public.st_numgeometries(geometry) OWNER TO postgres;

--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 523
-- Name: FUNCTION st_numgeometries(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_numgeometries(geometry) IS 'args: a_multi_or_geomcollection - If geometry is a GEOMETRYCOLLECTION (or MULTI*) return the number of geometries, otherwise return NULL.';


--
-- TOC entry 533 (class 1255 OID 21887)
-- Dependencies: 3 1157
-- Name: st_numinteriorring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_numinteriorring(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numinteriorrings_polygon';


ALTER FUNCTION public.st_numinteriorring(geometry) OWNER TO postgres;

--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 533
-- Name: FUNCTION st_numinteriorring(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_numinteriorring(geometry) IS 'args: a_polygon - Return the number of interior rings of the first polygon in the geometry. Synonym to ST_NumInteriorRings.';


--
-- TOC entry 531 (class 1255 OID 21885)
-- Dependencies: 3 1157
-- Name: st_numinteriorrings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_numinteriorrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numinteriorrings_polygon';


ALTER FUNCTION public.st_numinteriorrings(geometry) OWNER TO postgres;

--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 531
-- Name: FUNCTION st_numinteriorrings(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_numinteriorrings(geometry) IS 'args: a_polygon - Return the number of interior rings of the first polygon in the geometry. This will work with both POLYGON and MULTIPOLYGON types but only looks at the first polygon. Return NULL if there is no polygon in the geometry.';


--
-- TOC entry 521 (class 1255 OID 21875)
-- Dependencies: 3 1157
-- Name: st_numpoints(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_numpoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_numpoints_linestring';


ALTER FUNCTION public.st_numpoints(geometry) OWNER TO postgres;

--
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 521
-- Name: FUNCTION st_numpoints(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_numpoints(geometry) IS 'args: g1 - Return the number of points in an ST_LineString or ST_CircularString value.';


--
-- TOC entry 701 (class 1255 OID 22054)
-- Dependencies: 3 1157 1157
-- Name: st_orderingequals(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_orderingequals(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
	SELECT $1 ~= $2 AND _ST_OrderingEquals($1, $2)
	$_$;


ALTER FUNCTION public.st_orderingequals(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 701
-- Name: FUNCTION st_orderingequals(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_orderingequals(geometry, geometry) IS 'args: A, B - Returns true if the given geometries represent the same geometry and points are in the same directional order.';


--
-- TOC entry 471 (class 1255 OID 21825)
-- Dependencies: 3 1157 1157
-- Name: st_overlaps(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_overlaps(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Overlaps($1,$2)$_$;


ALTER FUNCTION public.st_overlaps(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 471
-- Name: FUNCTION st_overlaps(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_overlaps(geometry, geometry) IS 'args: A, B - Returns TRUE if the Geometries share space, are of the same dimension, but are not completely contained by each other.';


--
-- TOC entry 191 (class 1255 OID 21490)
-- Dependencies: 1157 3
-- Name: st_perimeter(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_perimeter(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_perimeter2d_poly';


ALTER FUNCTION public.st_perimeter(geometry) OWNER TO postgres;

--
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 191
-- Name: FUNCTION st_perimeter(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_perimeter(geometry) IS 'args: g1 - Return the length measurement of the boundary of an ST_Surface or ST_MultiSurface value. (Polygon, Multipolygon)';


--
-- TOC entry 189 (class 1255 OID 21488)
-- Dependencies: 1157 3
-- Name: st_perimeter2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_perimeter2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_perimeter2d_poly';


ALTER FUNCTION public.st_perimeter2d(geometry) OWNER TO postgres;

--
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 189
-- Name: FUNCTION st_perimeter2d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_perimeter2d(geometry) IS 'args: geomA - Returns the 2-dimensional perimeter of the geometry, if it is a polygon or multi-polygon. This is currently an alias for ST_Perimeter.';


--
-- TOC entry 187 (class 1255 OID 21486)
-- Dependencies: 1157 3
-- Name: st_perimeter3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_perimeter3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_perimeter_poly';


ALTER FUNCTION public.st_perimeter3d(geometry) OWNER TO postgres;

--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 187
-- Name: FUNCTION st_perimeter3d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_perimeter3d(geometry) IS 'args: geomA - Returns the 3-dimensional perimeter of the geometry, if it is a polygon or multi-polygon.';


--
-- TOC entry 704 (class 1255 OID 22057)
-- Dependencies: 3 1157
-- Name: st_point(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_point(double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_makepoint';


ALTER FUNCTION public.st_point(double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 704
-- Name: FUNCTION st_point(double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_point(double precision, double precision) IS 'args: x_lon, y_lat - Returns an ST_Point with the given coordinate values. OGC alias for ST_MakePoint.';


--
-- TOC entry 203 (class 1255 OID 21502)
-- Dependencies: 1157 3
-- Name: st_point_inside_circle(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_point_inside_circle(geometry, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_inside_circle_point';


ALTER FUNCTION public.st_point_inside_circle(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 203
-- Name: FUNCTION st_point_inside_circle(geometry, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_point_inside_circle(geometry, double precision, double precision, double precision) IS 'args: a_point, center_x, center_y, radius - Is the point geometry insert circle defined by center_x, center_y , radius';


--
-- TOC entry 575 (class 1255 OID 21929)
-- Dependencies: 3 1157
-- Name: st_pointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_pointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'POINT'
	THEN ST_GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_pointfromtext(text) OWNER TO postgres;

--
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 575
-- Name: FUNCTION st_pointfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_pointfromtext(text) IS 'args: WKT - Makes a point Geometry from WKT with the given SRID. If SRID is not given, it defaults to unknown.';


--
-- TOC entry 577 (class 1255 OID 21931)
-- Dependencies: 3 1157
-- Name: st_pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_pointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'POINT'
	THEN ST_GeomFromText($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_pointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 577
-- Name: FUNCTION st_pointfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_pointfromtext(text, integer) IS 'args: WKT, srid - Makes a point Geometry from WKT with the given SRID. If SRID is not given, it defaults to unknown.';


--
-- TOC entry 626 (class 1255 OID 21980)
-- Dependencies: 3 1157
-- Name: st_pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_pointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'POINT'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_pointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 624 (class 1255 OID 21978)
-- Dependencies: 3 1157
-- Name: st_pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_pointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'POINT'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_pointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 539 (class 1255 OID 21893)
-- Dependencies: 3 1157 1157
-- Name: st_pointn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_pointn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_pointn_linestring';


ALTER FUNCTION public.st_pointn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 539
-- Name: FUNCTION st_pointn(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_pointn(geometry, integer) IS 'args: a_linestring, n - Return the Nth point in the first linestring or circular linestring in the geometry. Return NULL if there is no linestring in the geometry.';


--
-- TOC entry 479 (class 1255 OID 21833)
-- Dependencies: 3 1157 1157
-- Name: st_pointonsurface(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_pointonsurface(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'pointonsurface';


ALTER FUNCTION public.st_pointonsurface(geometry) OWNER TO postgres;

--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 479
-- Name: FUNCTION st_pointonsurface(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_pointonsurface(geometry) IS 'args: g1 - Returns a POINT guaranteed to lie on the surface.';


--
-- TOC entry 585 (class 1255 OID 21939)
-- Dependencies: 3 1157
-- Name: st_polyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1)) = 'POLYGON'
	THEN ST_GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_polyfromtext(text) OWNER TO postgres;

--
-- TOC entry 587 (class 1255 OID 21941)
-- Dependencies: 3 1157
-- Name: st_polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromText($1, $2)) = 'POLYGON'
	THEN ST_GeomFromText($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_polyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 638 (class 1255 OID 21992)
-- Dependencies: 3 1157
-- Name: st_polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1)) = 'POLYGON'
	THEN ST_GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_polyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 636 (class 1255 OID 21990)
-- Dependencies: 3 1157
-- Name: st_polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'POLYGON'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_polyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 707 (class 1255 OID 22060)
-- Dependencies: 3 1157 1157
-- Name: st_polygon(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygon(geometry, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
	SELECT setSRID(makepolygon($1), $2)
	$_$;


ALTER FUNCTION public.st_polygon(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 707
-- Name: FUNCTION st_polygon(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_polygon(geometry, integer) IS 'args: aLineString, srid - Returns a polygon built from the specified linestring and SRID.';


--
-- TOC entry 591 (class 1255 OID 21945)
-- Dependencies: 3 1157
-- Name: st_polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_PolyFromText($1)$_$;


ALTER FUNCTION public.st_polygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 591
-- Name: FUNCTION st_polygonfromtext(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_polygonfromtext(text) IS 'args: WKT - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 589 (class 1255 OID 21943)
-- Dependencies: 3 1157
-- Name: st_polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1, $2)$_$;


ALTER FUNCTION public.st_polygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 589
-- Name: FUNCTION st_polygonfromtext(text, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_polygonfromtext(text, integer) IS 'args: WKT, srid - Makes a Geometry from WKT with the given SRID. If SRID is not give, it defaults to -1.';


--
-- TOC entry 642 (class 1255 OID 21996)
-- Dependencies: 3 1157
-- Name: st_polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygonfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_polygonfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 640 (class 1255 OID 21994)
-- Dependencies: 3 1157
-- Name: st_polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygonfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1,$2)) = 'POLYGON'
	THEN ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.st_polygonfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 21589)
-- Dependencies: 3 1157 1160
-- Name: st_polygonize(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygonize(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'polygonize_garray';


ALTER FUNCTION public.st_polygonize(geometry[]) OWNER TO postgres;

--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 290
-- Name: FUNCTION st_polygonize(geometry[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_polygonize(geometry[]) IS 'args: geom_array - Aggregate. Creates a GeometryCollection containing possible polygons formed from the constituent linework of a set of geometries.';


--
-- TOC entry 289 (class 1255 OID 21588)
-- Dependencies: 3 1157 1160
-- Name: st_polygonize_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygonize_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'polygonize_garray';


ALTER FUNCTION public.st_polygonize_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 107 (class 1255 OID 21373)
-- Dependencies: 3
-- Name: st_postgis_gist_joinsel(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_postgis_gist_joinsel(internal, oid, internal, smallint) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_joinsel';


ALTER FUNCTION public.st_postgis_gist_joinsel(internal, oid, internal, smallint) OWNER TO postgres;

--
-- TOC entry 106 (class 1255 OID 21372)
-- Dependencies: 3
-- Name: st_postgis_gist_sel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_postgis_gist_sel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c
    AS '$libdir/postgis-1.5', 'LWGEOM_gist_sel';


ALTER FUNCTION public.st_postgis_gist_sel(internal, oid, internal, integer) OWNER TO postgres;

--
-- TOC entry 441 (class 1255 OID 21795)
-- Dependencies: 3 1157 1157
-- Name: st_relate(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_relate(geometry, geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'relate_full';


ALTER FUNCTION public.st_relate(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 441
-- Name: FUNCTION st_relate(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_relate(geometry, geometry) IS 'args: geomA, geomB - Returns true if this Geometry is spatially related to anotherGeometry, by testing for intersections between the Interior, Boundary and Exterior of the two geometries as specified by the values in the intersectionMatrixPattern. If no intersectionMatrixPattern is passed in, then returns the maximum intersectionMatrixPattern that relates the 2 geometries.';


--
-- TOC entry 443 (class 1255 OID 21797)
-- Dependencies: 3 1157 1157
-- Name: st_relate(geometry, geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_relate(geometry, geometry, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'relate_pattern';


ALTER FUNCTION public.st_relate(geometry, geometry, text) OWNER TO postgres;

--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 443
-- Name: FUNCTION st_relate(geometry, geometry, text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_relate(geometry, geometry, text) IS 'args: geomA, geomB, intersectionMatrixPattern - Returns true if this Geometry is spatially related to anotherGeometry, by testing for intersections between the Interior, Boundary and Exterior of the two geometries as specified by the values in the intersectionMatrixPattern. If no intersectionMatrixPattern is passed in, then returns the maximum intersectionMatrixPattern that relates the 2 geometries.';


--
-- TOC entry 278 (class 1255 OID 21577)
-- Dependencies: 1157 3 1157
-- Name: st_removepoint(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_removepoint(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_removepoint';


ALTER FUNCTION public.st_removepoint(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 278
-- Name: FUNCTION st_removepoint(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_removepoint(geometry, integer) IS 'args: linestring, offset - Removes point from a linestring. Offset is 0-based.';


--
-- TOC entry 230 (class 1255 OID 21529)
-- Dependencies: 3 1157 1157
-- Name: st_reverse(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_reverse(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_reverse';


ALTER FUNCTION public.st_reverse(geometry) OWNER TO postgres;

--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 230
-- Name: FUNCTION st_reverse(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_reverse(geometry) IS 'args: g1 - Returns the geometry with vertex order reversed.';


--
-- TOC entry 46 (class 1255 OID 21291)
-- Dependencies: 1157 3 1157
-- Name: st_rotate(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_rotate(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT rotateZ($1, $2)$_$;


ALTER FUNCTION public.st_rotate(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 46
-- Name: FUNCTION st_rotate(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_rotate(geometry, double precision) IS 'args: geomA, rotZRadians - This is a synonym for ST_RotateZ';


--
-- TOC entry 48 (class 1255 OID 21293)
-- Dependencies: 3 1157 1157
-- Name: st_rotatex(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_rotatex(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


ALTER FUNCTION public.st_rotatex(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 48
-- Name: FUNCTION st_rotatex(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_rotatex(geometry, double precision) IS 'args: geomA, rotRadians - Rotate a geometry rotRadians about the X axis.';


--
-- TOC entry 50 (class 1255 OID 21295)
-- Dependencies: 1157 1157 3
-- Name: st_rotatey(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_rotatey(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


ALTER FUNCTION public.st_rotatey(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 50
-- Name: FUNCTION st_rotatey(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_rotatey(geometry, double precision) IS 'args: geomA, rotRadians - Rotate a geometry rotRadians about the Y axis.';


--
-- TOC entry 44 (class 1255 OID 21289)
-- Dependencies: 1157 1157 3
-- Name: st_rotatez(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_rotatez(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


ALTER FUNCTION public.st_rotatez(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 44
-- Name: FUNCTION st_rotatez(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_rotatez(geometry, double precision) IS 'args: geomA, rotRadians - Rotate a geometry rotRadians about the Z axis.';


--
-- TOC entry 58 (class 1255 OID 21303)
-- Dependencies: 1157 3 1157
-- Name: st_scale(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_scale(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT scale($1, $2, $3, 1)$_$;


ALTER FUNCTION public.st_scale(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 58
-- Name: FUNCTION st_scale(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_scale(geometry, double precision, double precision) IS 'args: geomA, XFactor, YFactor - Scales the geometry to a new size by multiplying the ordinates with the parameters. Ie: ST_Scale(geom, Xfactor, Yfactor, Zfactor).';


--
-- TOC entry 56 (class 1255 OID 21301)
-- Dependencies: 1157 3 1157
-- Name: st_scale(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_scale(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


ALTER FUNCTION public.st_scale(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 56
-- Name: FUNCTION st_scale(geometry, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_scale(geometry, double precision, double precision, double precision) IS 'args: geomA, XFactor, YFactor, ZFactor - Scales the geometry to a new size by multiplying the ordinates with the parameters. Ie: ST_Scale(geom, Xfactor, Yfactor, Zfactor).';


--
-- TOC entry 387 (class 1255 OID 21726)
-- Dependencies: 3 1157 1157
-- Name: st_segmentize(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_segmentize(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_segmentize2d';


ALTER FUNCTION public.st_segmentize(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 387
-- Name: FUNCTION st_segmentize(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_segmentize(geometry, double precision) IS 'args: geomA, max_length - Return a modified geometry having no segment longer than the given distance. Distance computation is performed in 2d only.';


--
-- TOC entry 165 (class 1255 OID 21464)
-- Dependencies: 1169 1169 3
-- Name: st_setfactor(chip, real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_setfactor(chip, real) RETURNS chip
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_setFactor';


ALTER FUNCTION public.st_setfactor(chip, real) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 21579)
-- Dependencies: 1157 3 1157 1157
-- Name: st_setpoint(geometry, integer, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_setpoint(geometry, integer, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_setpoint_linestring';


ALTER FUNCTION public.st_setpoint(geometry, integer, geometry) OWNER TO postgres;

--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 280
-- Name: FUNCTION st_setpoint(geometry, integer, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_setpoint(geometry, integer, geometry) IS 'args: linestring, zerobasedposition, point - Replace point N of linestring with given point. Index is 0-based.';


--
-- TOC entry 559 (class 1255 OID 21913)
-- Dependencies: 3 1157 1157
-- Name: st_setsrid(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_setsrid(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_setSRID';


ALTER FUNCTION public.st_setsrid(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 559
-- Name: FUNCTION st_setsrid(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_setsrid(geometry, integer) IS 'args: geom, srid - Sets the SRID on a geometry to a particular integer value.';


--
-- TOC entry 62 (class 1255 OID 21307)
-- Dependencies: 1157 1157 3
-- Name: st_shift_longitude(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_shift_longitude(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_longitude_shift';


ALTER FUNCTION public.st_shift_longitude(geometry) OWNER TO postgres;

--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 62
-- Name: FUNCTION st_shift_longitude(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_shift_longitude(geometry) IS 'args: geomA - Reads every point/vertex in every component of every feature in a geometry, and if the longitude coordinate is <0, adds 360 to it. The result would be a 0-360 version of the data to be plotted in a 180 centric map';


--
-- TOC entry 676 (class 1255 OID 22028)
-- Dependencies: 3 1157 1157 1157
-- Name: st_shortestline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_shortestline(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_shortestline2d';


ALTER FUNCTION public.st_shortestline(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 676
-- Name: FUNCTION st_shortestline(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_shortestline(geometry, geometry) IS 'args: g1, g2 - Returns the 2-dimensional shortest line between two geometries';


--
-- TOC entry 377 (class 1255 OID 21716)
-- Dependencies: 3 1157 1157
-- Name: st_simplify(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_simplify(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_simplify2d';


ALTER FUNCTION public.st_simplify(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 377
-- Name: FUNCTION st_simplify(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_simplify(geometry, double precision) IS 'args: geomA, tolerance - Returns a "simplified" version of the given geometry using the Douglas-Peuker algorithm.';


--
-- TOC entry 412 (class 1255 OID 21751)
-- Dependencies: 3 1157 1157
-- Name: st_simplifypreservetopology(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_simplifypreservetopology(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-1.5', 'topologypreservesimplify';


ALTER FUNCTION public.st_simplifypreservetopology(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 412
-- Name: FUNCTION st_simplifypreservetopology(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_simplifypreservetopology(geometry, double precision) IS 'args: geomA, tolerance - Returns a "simplified" version of the given geometry using the Douglas-Peuker algorithm. Will avoid creating derived geometries (polygons in particular) that are invalid.';


--
-- TOC entry 383 (class 1255 OID 21722)
-- Dependencies: 3 1157 1157
-- Name: st_snaptogrid(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_snaptogrid(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $2)$_$;


ALTER FUNCTION public.st_snaptogrid(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 383
-- Name: FUNCTION st_snaptogrid(geometry, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_snaptogrid(geometry, double precision) IS 'args: geomA, size - Snap all points of the input geometry to the grid defined by its origin and cell size. Remove consecutive points falling on the same cell, eventually returning NULL if output points are not enough to define a geometry of the given type. Collapsed geometries in a collection are stripped from it. Useful for reducing precision.';


--
-- TOC entry 381 (class 1255 OID 21720)
-- Dependencies: 3 1157 1157
-- Name: st_snaptogrid(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_snaptogrid(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $3)$_$;


ALTER FUNCTION public.st_snaptogrid(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 381
-- Name: FUNCTION st_snaptogrid(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_snaptogrid(geometry, double precision, double precision) IS 'args: geomA, sizeX, sizeY - Snap all points of the input geometry to the grid defined by its origin and cell size. Remove consecutive points falling on the same cell, eventually returning NULL if output points are not enough to define a geometry of the given type. Collapsed geometries in a collection are stripped from it. Useful for reducing precision.';


--
-- TOC entry 379 (class 1255 OID 21718)
-- Dependencies: 3 1157 1157
-- Name: st_snaptogrid(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_snaptogrid(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_snaptogrid';


ALTER FUNCTION public.st_snaptogrid(geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 379
-- Name: FUNCTION st_snaptogrid(geometry, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_snaptogrid(geometry, double precision, double precision, double precision, double precision) IS 'args: geomA, originX, originY, sizeX, sizeY - Snap all points of the input geometry to the grid defined by its origin and cell size. Remove consecutive points falling on the same cell, eventually returning NULL if output points are not enough to define a geometry of the given type. Collapsed geometries in a collection are stripped from it. Useful for reducing precision.';


--
-- TOC entry 385 (class 1255 OID 21724)
-- Dependencies: 3 1157 1157 1157
-- Name: st_snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_snaptogrid_pointoff';


ALTER FUNCTION public.st_snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 385
-- Name: FUNCTION st_snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision) IS 'args: geomA, pointOrigin, sizeX, sizeY, sizeZ, sizeM - Snap all points of the input geometry to the grid defined by its origin and cell size. Remove consecutive points falling on the same cell, eventually returning NULL if output points are not enough to define a geometry of the given type. Collapsed geometries in a collection are stripped from it. Useful for reducing precision.';


--
-- TOC entry 25 (class 1255 OID 21267)
-- Dependencies: 3 1153
-- Name: st_spheroid_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_spheroid_in(cstring) RETURNS spheroid
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ellipsoid_in';


ALTER FUNCTION public.st_spheroid_in(cstring) OWNER TO postgres;

--
-- TOC entry 26 (class 1255 OID 21268)
-- Dependencies: 3 1153
-- Name: st_spheroid_out(spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_spheroid_out(spheroid) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'ellipsoid_out';


ALTER FUNCTION public.st_spheroid_out(spheroid) OWNER TO postgres;

--
-- TOC entry 152 (class 1255 OID 21451)
-- Dependencies: 1169 3
-- Name: st_srid(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_srid(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getSRID';


ALTER FUNCTION public.st_srid(chip) OWNER TO postgres;

--
-- TOC entry 557 (class 1255 OID 21911)
-- Dependencies: 3 1157
-- Name: st_srid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_srid(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_getSRID';


ALTER FUNCTION public.st_srid(geometry) OWNER TO postgres;

--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 557
-- Name: FUNCTION st_srid(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_srid(geometry) IS 'args: g1 - Returns the spatial reference identifier for the ST_Geometry as defined in spatial_ref_sys table.';


--
-- TOC entry 549 (class 1255 OID 21903)
-- Dependencies: 3 1157 1157
-- Name: st_startpoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_startpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_startpoint_linestring';


ALTER FUNCTION public.st_startpoint(geometry) OWNER TO postgres;

--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 549
-- Name: FUNCTION st_startpoint(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_startpoint(geometry) IS 'args: geomA - Returns the first point of a LINESTRING geometry as a POINT.';


--
-- TOC entry 169 (class 1255 OID 21468)
-- Dependencies: 1157 3
-- Name: st_summary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_summary(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_summary';


ALTER FUNCTION public.st_summary(geometry) OWNER TO postgres;

--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 169
-- Name: FUNCTION st_summary(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_summary(geometry) IS 'args: g - Returns a text summary of the contents of the ST_Geometry.';


--
-- TOC entry 421 (class 1255 OID 21760)
-- Dependencies: 3 1157 1157 1157
-- Name: st_symdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_symdifference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'symdifference';


ALTER FUNCTION public.st_symdifference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 421
-- Name: FUNCTION st_symdifference(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_symdifference(geometry, geometry) IS 'args: geomA, geomB - Returns a geometry that represents the portions of A and B that do not intersect. It is called a symmetric difference because ST_SymDifference(A,B) = ST_SymDifference(B,A).';


--
-- TOC entry 423 (class 1255 OID 21762)
-- Dependencies: 3 1157 1157 1157
-- Name: st_symmetricdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_symmetricdifference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'symdifference';


ALTER FUNCTION public.st_symmetricdifference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 21675)
-- Dependencies: 3 1157
-- Name: st_text(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_text(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_text';


ALTER FUNCTION public.st_text(geometry) OWNER TO postgres;

--
-- TOC entry 448 (class 1255 OID 21802)
-- Dependencies: 3 1157 1157
-- Name: st_touches(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_touches(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Touches($1,$2)$_$;


ALTER FUNCTION public.st_touches(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION st_touches(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_touches(geometry, geometry) IS 'args: g1, g2 - Returns TRUE if the geometries have at least one point in common, but their interiors do not intersect.';


--
-- TOC entry 336 (class 1255 OID 21657)
-- Dependencies: 3 1157 1157
-- Name: st_transform(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_transform(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'transform';


ALTER FUNCTION public.st_transform(geometry, integer) OWNER TO postgres;

--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 336
-- Name: FUNCTION st_transform(geometry, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_transform(geometry, integer) IS 'args: g1, srid - Returns a new geometry with its coordinates transformed to the SRID referenced by the integer parameter.';


--
-- TOC entry 54 (class 1255 OID 21299)
-- Dependencies: 1157 3 1157
-- Name: st_translate(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_translate(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT translate($1, $2, $3, 0)$_$;


ALTER FUNCTION public.st_translate(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 54
-- Name: FUNCTION st_translate(geometry, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_translate(geometry, double precision, double precision) IS 'args: g1, deltax, deltay - Translates the geometry to a new location using the numeric parameters as offsets. Ie: ST_Translate(geom, X, Y) or ST_Translate(geom, X, Y,Z).';


--
-- TOC entry 52 (class 1255 OID 21297)
-- Dependencies: 1157 3 1157
-- Name: st_translate(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_translate(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


ALTER FUNCTION public.st_translate(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 52
-- Name: FUNCTION st_translate(geometry, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_translate(geometry, double precision, double precision, double precision) IS 'args: g1, deltax, deltay, deltaz - Translates the geometry to a new location using the numeric parameters as offsets. Ie: ST_Translate(geom, X, Y) or ST_Translate(geom, X, Y,Z).';


--
-- TOC entry 60 (class 1255 OID 21305)
-- Dependencies: 1157 1157 3
-- Name: st_transscale(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_transscale(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $4, 0, 0,  0, $5, 0,
		0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


ALTER FUNCTION public.st_transscale(geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 60
-- Name: FUNCTION st_transscale(geometry, double precision, double precision, double precision, double precision); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_transscale(geometry, double precision, double precision, double precision, double precision) IS 'args: geomA, deltaX, deltaY, XFactor, YFactor - Translates the geometry using the deltaX and deltaY args, then scales it using the XFactor, YFactor args, working in 2D only.';


--
-- TOC entry 439 (class 1255 OID 21786)
-- Dependencies: 3 1157 1160
-- Name: st_union(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_union(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'pgis_union_geometry_array';


ALTER FUNCTION public.st_union(geometry[]) OWNER TO postgres;

--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 439
-- Name: FUNCTION st_union(geometry[]); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_union(geometry[]) IS 'args: g1_array - Returns a geometry that represents the point set union of the Geometries.';


--
-- TOC entry 425 (class 1255 OID 21764)
-- Dependencies: 3 1157 1157 1157
-- Name: st_union(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_union(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'geomunion';


ALTER FUNCTION public.st_union(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 425
-- Name: FUNCTION st_union(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_union(geometry, geometry) IS 'args: g1, g2 - Returns a geometry that represents the point set union of the Geometries.';


--
-- TOC entry 438 (class 1255 OID 21785)
-- Dependencies: 3 1157 1160
-- Name: st_unite_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_unite_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'pgis_union_geometry_array';


ALTER FUNCTION public.st_unite_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 158 (class 1255 OID 21457)
-- Dependencies: 3 1169
-- Name: st_width(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_width(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getWidth';


ALTER FUNCTION public.st_width(chip) OWNER TO postgres;

--
-- TOC entry 459 (class 1255 OID 21813)
-- Dependencies: 3 1157 1157
-- Name: st_within(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_within(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 && $2 AND _ST_Within($1,$2)$_$;


ALTER FUNCTION public.st_within(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 459
-- Name: FUNCTION st_within(geometry, geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_within(geometry, geometry) IS 'args: A, B - Returns true if the geometry A is completely inside geometry B';


--
-- TOC entry 698 (class 1255 OID 22051)
-- Dependencies: 3 1157
-- Name: st_wkbtosql(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_wkbtosql(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_WKB';


ALTER FUNCTION public.st_wkbtosql(bytea) OWNER TO postgres;

--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 698
-- Name: FUNCTION st_wkbtosql(bytea); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_wkbtosql(bytea) IS 'args: WKB - Return a specified ST_Geometry value from Well-Known Binary representation (WKB). This is an alias name for ST_GeomFromWKB that takes no srid';


--
-- TOC entry 697 (class 1255 OID 22050)
-- Dependencies: 3 1157
-- Name: st_wkttosql(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_wkttosql(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_from_text';


ALTER FUNCTION public.st_wkttosql(text) OWNER TO postgres;

--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 697
-- Name: FUNCTION st_wkttosql(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_wkttosql(text) IS 'args: WKT - Return a specified ST_Geometry value from Well-Known Text representation (WKT). This is an alias name for ST_GeomFromText';


--
-- TOC entry 541 (class 1255 OID 21895)
-- Dependencies: 3 1157
-- Name: st_x(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_x(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_x_point';


ALTER FUNCTION public.st_x(geometry) OWNER TO postgres;

--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 541
-- Name: FUNCTION st_x(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_x(geometry) IS 'args: a_point - Return the X coordinate of the point, or NULL if not available. Input must be a point.';


--
-- TOC entry 79 (class 1255 OID 21329)
-- Dependencies: 1161 3
-- Name: st_xmax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_xmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_xmax';


ALTER FUNCTION public.st_xmax(box3d) OWNER TO postgres;

--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 79
-- Name: FUNCTION st_xmax(box3d); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_xmax(box3d) IS 'args: aGeomorBox2DorBox3D - Returns X maxima of a bounding box 2d or 3d or a geometry.';


--
-- TOC entry 73 (class 1255 OID 21323)
-- Dependencies: 3 1161
-- Name: st_xmin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_xmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_xmin';


ALTER FUNCTION public.st_xmin(box3d) OWNER TO postgres;

--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 73
-- Name: FUNCTION st_xmin(box3d); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_xmin(box3d) IS 'args: aGeomorBox2DorBox3D - Returns X minima of a bounding box 2d or 3d or a geometry.';


--
-- TOC entry 543 (class 1255 OID 21897)
-- Dependencies: 3 1157
-- Name: st_y(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_y(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_y_point';


ALTER FUNCTION public.st_y(geometry) OWNER TO postgres;

--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 543
-- Name: FUNCTION st_y(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_y(geometry) IS 'args: a_point - Return the Y coordinate of the point, or NULL if not available. Input must be a point.';


--
-- TOC entry 81 (class 1255 OID 21331)
-- Dependencies: 3 1161
-- Name: st_ymax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_ymax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_ymax';


ALTER FUNCTION public.st_ymax(box3d) OWNER TO postgres;

--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 81
-- Name: FUNCTION st_ymax(box3d); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_ymax(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Y maxima of a bounding box 2d or 3d or a geometry.';


--
-- TOC entry 75 (class 1255 OID 21325)
-- Dependencies: 3 1161
-- Name: st_ymin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_ymin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_ymin';


ALTER FUNCTION public.st_ymin(box3d) OWNER TO postgres;

--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 75
-- Name: FUNCTION st_ymin(box3d); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_ymin(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Y minima of a bounding box 2d or 3d or a geometry.';


--
-- TOC entry 545 (class 1255 OID 21899)
-- Dependencies: 3 1157
-- Name: st_z(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_z(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_z_point';


ALTER FUNCTION public.st_z(geometry) OWNER TO postgres;

--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 545
-- Name: FUNCTION st_z(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_z(geometry) IS 'args: a_point - Return the Z coordinate of the point, or NULL if not available. Input must be a point.';


--
-- TOC entry 83 (class 1255 OID 21333)
-- Dependencies: 3 1161
-- Name: st_zmax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_zmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_zmax';


ALTER FUNCTION public.st_zmax(box3d) OWNER TO postgres;

--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 83
-- Name: FUNCTION st_zmax(box3d); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_zmax(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Z minima of a bounding box 2d or 3d or a geometry.';


--
-- TOC entry 236 (class 1255 OID 21535)
-- Dependencies: 3 1157
-- Name: st_zmflag(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_zmflag(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_zmflag';


ALTER FUNCTION public.st_zmflag(geometry) OWNER TO postgres;

--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 236
-- Name: FUNCTION st_zmflag(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_zmflag(geometry) IS 'args: geomA - Returns ZM (dimension semantic) flag of the geometries as a small int. Values are: 0=2d, 1=3dm, 2=3dz, 3=4d.';


--
-- TOC entry 77 (class 1255 OID 21327)
-- Dependencies: 1161 3
-- Name: st_zmin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_zmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_zmin';


ALTER FUNCTION public.st_zmin(box3d) OWNER TO postgres;

--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 77
-- Name: FUNCTION st_zmin(box3d); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION st_zmin(box3d) IS 'args: aGeomorBox2DorBox3D - Returns Z minima of a bounding box 2d or 3d or a geometry.';


--
-- TOC entry 548 (class 1255 OID 21902)
-- Dependencies: 3 1157 1157
-- Name: startpoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION startpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_startpoint_linestring';


ALTER FUNCTION public.startpoint(geometry) OWNER TO postgres;

--
-- TOC entry 168 (class 1255 OID 21467)
-- Dependencies: 3 1157
-- Name: summary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION summary(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_summary';


ALTER FUNCTION public.summary(geometry) OWNER TO postgres;

--
-- TOC entry 420 (class 1255 OID 21759)
-- Dependencies: 3 1157 1157 1157
-- Name: symdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION symdifference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'symdifference';


ALTER FUNCTION public.symdifference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 422 (class 1255 OID 21761)
-- Dependencies: 3 1157 1157 1157
-- Name: symmetricdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION symmetricdifference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'symdifference';


ALTER FUNCTION public.symmetricdifference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 368 (class 1255 OID 21691)
-- Dependencies: 3 1157
-- Name: text(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION text(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_to_text';


ALTER FUNCTION public.text(geometry) OWNER TO postgres;

--
-- TOC entry 446 (class 1255 OID 21800)
-- Dependencies: 3 1157 1157
-- Name: touches(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION touches(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'touches';


ALTER FUNCTION public.touches(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 335 (class 1255 OID 21656)
-- Dependencies: 3 1157 1157
-- Name: transform(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION transform(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'transform';


ALTER FUNCTION public.transform(geometry, integer) OWNER TO postgres;

--
-- TOC entry 53 (class 1255 OID 21298)
-- Dependencies: 1157 3 1157
-- Name: translate(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION translate(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT translate($1, $2, $3, 0)$_$;


ALTER FUNCTION public.translate(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 51 (class 1255 OID 21296)
-- Dependencies: 1157 3 1157
-- Name: translate(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION translate(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


ALTER FUNCTION public.translate(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 59 (class 1255 OID 21304)
-- Dependencies: 1157 1157 3
-- Name: transscale(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION transscale(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT affine($1,  $4, 0, 0,  0, $5, 0,
		0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


ALTER FUNCTION public.transscale(geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 437 (class 1255 OID 21784)
-- Dependencies: 3 1157 1160
-- Name: unite_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION unite_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'pgis_union_geometry_array';


ALTER FUNCTION public.unite_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 685 (class 1255 OID 22037)
-- Dependencies: 3 1424
-- Name: unlockrows(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION unlockrows(text) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$ 
DECLARE
	ret int;
BEGIN

	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
	END IF;

	EXECUTE 'DELETE FROM authorization_table where authid = ' ||
		quote_literal($1);

	GET DIAGNOSTICS ret = ROW_COUNT;

	RETURN ret;
END;
$_$;


ALTER FUNCTION public.unlockrows(text) OWNER TO postgres;

--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 685
-- Name: FUNCTION unlockrows(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION unlockrows(text) IS 'args: auth_token - Remove all locks held by specified authorization id. Returns the number of locks released.';


--
-- TOC entry 331 (class 1255 OID 21652)
-- Dependencies: 3 1424
-- Name: updategeometrysrid(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT UpdateGeometrySRID('','',$1,$2,$3) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.updategeometrysrid(character varying, character varying, integer) OWNER TO postgres;

--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 331
-- Name: FUNCTION updategeometrysrid(character varying, character varying, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION updategeometrysrid(character varying, character varying, integer) IS 'args: table_name, column_name, srid - Updates the SRID of all features in a geometry column, geometry_columns metadata and srid table constraint';


--
-- TOC entry 330 (class 1255 OID 21651)
-- Dependencies: 3 1424
-- Name: updategeometrysrid(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT UpdateGeometrySRID('',$1,$2,$3,$4) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.updategeometrysrid(character varying, character varying, character varying, integer) OWNER TO postgres;

--
-- TOC entry 3849 (class 0 OID 0)
-- Dependencies: 330
-- Name: FUNCTION updategeometrysrid(character varying, character varying, character varying, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION updategeometrysrid(character varying, character varying, character varying, integer) IS 'args: schema_name, table_name, column_name, srid - Updates the SRID of all features in a geometry column, geometry_columns metadata and srid table constraint';


--
-- TOC entry 329 (class 1255 OID 21650)
-- Dependencies: 3 1424
-- Name: updategeometrysrid(character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	new_srid alias for $5;
	myrec RECORD;
	okay boolean;
	cname varchar;
	real_schema name;

BEGIN


	-- Find, check or fix schema_name
	IF ( schema_name != '' ) THEN
		okay = 'f';

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := 't';
		END LOOP;

		IF ( okay <> 't' ) THEN
			RAISE EXCEPTION 'Invalid schema name';
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT INTO real_schema current_schema()::text;
	END IF;

	-- Find out if the column is in the geometry_columns table
	okay = 'f';
	FOR myrec IN SELECT * from geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := 't';
	END LOOP;
	IF (okay <> 't') THEN
		RAISE EXCEPTION 'column not found in geometry_columns table';
		RETURN 'f';
	END IF;

	-- Update ref from geometry_columns table
	EXECUTE 'UPDATE geometry_columns SET SRID = ' || new_srid::text ||
		' where f_table_schema = ' ||
		quote_literal(real_schema) || ' and f_table_name = ' ||
		quote_literal(table_name)  || ' and f_geometry_column = ' ||
		quote_literal(column_name);

	-- Make up constraint name
	cname = 'enforce_srid_'  || column_name;

	-- Drop enforce_srid constraint
	EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
		'.' || quote_ident(table_name) ||
		' DROP constraint ' || quote_ident(cname);

	-- Update geometries SRID
	EXECUTE 'UPDATE ' || quote_ident(real_schema) ||
		'.' || quote_ident(table_name) ||
		' SET ' || quote_ident(column_name) ||
		' = setSRID(' || quote_ident(column_name) ||
		', ' || new_srid::text || ')';

	-- Reset enforce_srid constraint
	EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
		'.' || quote_ident(table_name) ||
		' ADD constraint ' || quote_ident(cname) ||
		' CHECK (srid(' || quote_ident(column_name) ||
		') = ' || new_srid::text || ')';

	RETURN real_schema || '.' || table_name || '.' || column_name ||' SRID changed to ' || new_srid::text;

END;
$_$;


ALTER FUNCTION public.updategeometrysrid(character varying, character varying, character varying, character varying, integer) OWNER TO postgres;

--
-- TOC entry 3850 (class 0 OID 0)
-- Dependencies: 329
-- Name: FUNCTION updategeometrysrid(character varying, character varying, character varying, character varying, integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION updategeometrysrid(character varying, character varying, character varying, character varying, integer) IS 'args: catalog_name, schema_name, table_name, column_name, srid - Updates the SRID of all features in a geometry column, geometry_columns metadata and srid table constraint';


--
-- TOC entry 157 (class 1255 OID 21456)
-- Dependencies: 3 1169
-- Name: width(chip); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION width(chip) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'CHIP_getWidth';


ALTER FUNCTION public.width(chip) OWNER TO postgres;

--
-- TOC entry 457 (class 1255 OID 21811)
-- Dependencies: 3 1157 1157
-- Name: within(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION within(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'within';


ALTER FUNCTION public.within(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 540 (class 1255 OID 21894)
-- Dependencies: 3 1157
-- Name: x(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION x(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_x_point';


ALTER FUNCTION public.x(geometry) OWNER TO postgres;

--
-- TOC entry 78 (class 1255 OID 21328)
-- Dependencies: 1161 3
-- Name: xmax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_xmax';


ALTER FUNCTION public.xmax(box3d) OWNER TO postgres;

--
-- TOC entry 72 (class 1255 OID 21322)
-- Dependencies: 1161 3
-- Name: xmin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_xmin';


ALTER FUNCTION public.xmin(box3d) OWNER TO postgres;

--
-- TOC entry 542 (class 1255 OID 21896)
-- Dependencies: 3 1157
-- Name: y(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION y(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_y_point';


ALTER FUNCTION public.y(geometry) OWNER TO postgres;

--
-- TOC entry 80 (class 1255 OID 21330)
-- Dependencies: 1161 3
-- Name: ymax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ymax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_ymax';


ALTER FUNCTION public.ymax(box3d) OWNER TO postgres;

--
-- TOC entry 74 (class 1255 OID 21324)
-- Dependencies: 3 1161
-- Name: ymin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ymin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_ymin';


ALTER FUNCTION public.ymin(box3d) OWNER TO postgres;

--
-- TOC entry 544 (class 1255 OID 21898)
-- Dependencies: 3 1157
-- Name: z(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION z(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_z_point';


ALTER FUNCTION public.z(geometry) OWNER TO postgres;

--
-- TOC entry 82 (class 1255 OID 21332)
-- Dependencies: 1161 3
-- Name: zmax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION zmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_zmax';


ALTER FUNCTION public.zmax(box3d) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 21534)
-- Dependencies: 1157 3
-- Name: zmflag(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION zmflag(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'LWGEOM_zmflag';


ALTER FUNCTION public.zmflag(geometry) OWNER TO postgres;

--
-- TOC entry 76 (class 1255 OID 21326)
-- Dependencies: 3 1161
-- Name: zmin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION zmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-1.5', 'BOX3D_zmin';


ALTER FUNCTION public.zmin(box3d) OWNER TO postgres;

SET search_path = source, pg_catalog;

--
-- TOC entry 856 (class 1255 OID 42786)
-- Dependencies: 11
-- Name: children_of_node(integer); Type: FUNCTION; Schema: source; Owner: entangled_bank_user
--

CREATE FUNCTION children_of_node(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT np.child_node_id
	FROM source.node_path np
	WHERE np.parent_node_id = $1
	AND np.distance = 1;
$_$;


ALTER FUNCTION source.children_of_node(integer) OWNER TO entangled_bank_user;

--
-- TOC entry 857 (class 1255 OID 42787)
-- Dependencies: 11 1424
-- Name: delete_tree(integer); Type: FUNCTION; Schema: source; Owner: entangled_bank_user
--

CREATE FUNCTION delete_tree(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

	BEGIN

	DELETE
	FROM source.edge_qualifier_value eq
	WHERE eq.edge_id
	IN (
	SELECT source.tree_edges($1)
	);

	DELETE
	FROM source.edge e
	WHERE e.edge_id
	IN (
	SELECT source.tree_edges($1)
	);

	DELETE
	FROM source.node_qualifier_value nq
	WHERE nq.node_id
	IN (
	SELECT n.node_id
	FROM source.node n
	WHERE n.tree_id = $1
	);

	DELETE
	FROM node_path np
	WHERE np.child_node_id
	IN (
	SELECT n.node_id
	FROM source.node n
	WHERE n.tree_id = $1
	UNION
	SELECT t.node_id
	FROM source.tree t
	WHERE t.tree_id = $1	
	);
	
	DELETE FROM source.node WHERE tree_id = $1;

	DELETE FROM source.tree WHERE tree_id = $1;

	END;
	
$_$;


ALTER FUNCTION source.delete_tree(integer) OWNER TO entangled_bank_user;

--
-- TOC entry 858 (class 1255 OID 42788)
-- Dependencies: 11
-- Name: tree_edges(integer); Type: FUNCTION; Schema: source; Owner: entangled_bank_user
--

CREATE FUNCTION tree_edges(integer) RETURNS SETOF integer
    LANGUAGE sql
    AS $_$
	
	SELECT e.edge_id 
	FROM source.edge e, source.node pt, source.node ch 
	WHERE 
	    pt.tree_id = $1
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	
	$_$;


ALTER FUNCTION source.tree_edges(integer) OWNER TO entangled_bank_user;

SET search_path = funct, pg_catalog;

--
-- TOC entry 1442 (class 1255 OID 42789)
-- Dependencies: 848 8
-- Name: lowerquartile(numeric); Type: AGGREGATE; Schema: funct; Owner: entangled_bank_user
--

CREATE AGGREGATE lowerquartile(numeric) (
    SFUNC = array_append,
    STYPE = numeric[],
    INITCOND = '{}',
    FINALFUNC = _final_lowerquartile
);


ALTER AGGREGATE funct.lowerquartile(numeric) OWNER TO entangled_bank_user;

--
-- TOC entry 1443 (class 1255 OID 42790)
-- Dependencies: 849 8
-- Name: lowervigintile(numeric); Type: AGGREGATE; Schema: funct; Owner: entangled_bank_user
--

CREATE AGGREGATE lowervigintile(numeric) (
    SFUNC = array_append,
    STYPE = numeric[],
    INITCOND = '{}',
    FINALFUNC = _final_lowervigintile
);


ALTER AGGREGATE funct.lowervigintile(numeric) OWNER TO entangled_bank_user;

--
-- TOC entry 1444 (class 1255 OID 42791)
-- Dependencies: 8 850
-- Name: median(numeric); Type: AGGREGATE; Schema: funct; Owner: entangled_bank_user
--

CREATE AGGREGATE median(numeric) (
    SFUNC = array_append,
    STYPE = numeric[],
    INITCOND = '{}',
    FINALFUNC = _final_median
);


ALTER AGGREGATE funct.median(numeric) OWNER TO entangled_bank_user;

--
-- TOC entry 1445 (class 1255 OID 42792)
-- Dependencies: 851 8
-- Name: upperquartile(numeric); Type: AGGREGATE; Schema: funct; Owner: entangled_bank_user
--

CREATE AGGREGATE upperquartile(numeric) (
    SFUNC = array_append,
    STYPE = numeric[],
    INITCOND = '{}',
    FINALFUNC = _final_upperquartile
);


ALTER AGGREGATE funct.upperquartile(numeric) OWNER TO entangled_bank_user;

--
-- TOC entry 1446 (class 1255 OID 42793)
-- Dependencies: 852 8
-- Name: uppervigintile(numeric); Type: AGGREGATE; Schema: funct; Owner: entangled_bank_user
--

CREATE AGGREGATE uppervigintile(numeric) (
    SFUNC = array_append,
    STYPE = numeric[],
    INITCOND = '{}',
    FINALFUNC = _final_uppervigintile
);


ALTER AGGREGATE funct.uppervigintile(numeric) OWNER TO entangled_bank_user;

SET search_path = public, pg_catalog;

--
-- TOC entry 1433 (class 1255 OID 21782)
-- Dependencies: 431 432 1157 1160 3
-- Name: accum(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE accum(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_accum_finalfn
);


ALTER AGGREGATE public.accum(geometry) OWNER TO postgres;

--
-- TOC entry 1436 (class 1255 OID 21788)
-- Dependencies: 3 1157 1157 431 434
-- Name: collect(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE collect(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_collect_finalfn
);


ALTER AGGREGATE public.collect(geometry) OWNER TO postgres;

--
-- TOC entry 1426 (class 1255 OID 21605)
-- Dependencies: 3 1164 1157 304
-- Name: extent(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE extent(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d_extent
);


ALTER AGGREGATE public.extent(geometry) OWNER TO postgres;

--
-- TOC entry 1428 (class 1255 OID 21609)
-- Dependencies: 3 1161 1157 305
-- Name: extent3d(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE extent3d(geometry) (
    SFUNC = public.combine_bbox,
    STYPE = box3d
);


ALTER AGGREGATE public.extent3d(geometry) OWNER TO postgres;

--
-- TOC entry 1440 (class 1255 OID 21792)
-- Dependencies: 3 1157 1157 431 436
-- Name: makeline(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE makeline(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_makeline_finalfn
);


ALTER AGGREGATE public.makeline(geometry) OWNER TO postgres;

--
-- TOC entry 1430 (class 1255 OID 21767)
-- Dependencies: 3 1157 1157 427
-- Name: memcollect(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE memcollect(geometry) (
    SFUNC = public.st_collect,
    STYPE = geometry
);


ALTER AGGREGATE public.memcollect(geometry) OWNER TO postgres;

--
-- TOC entry 1431 (class 1255 OID 21770)
-- Dependencies: 3 1157 1157 424
-- Name: memgeomunion(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE memgeomunion(geometry) (
    SFUNC = geomunion,
    STYPE = geometry
);


ALTER AGGREGATE public.memgeomunion(geometry) OWNER TO postgres;

--
-- TOC entry 1438 (class 1255 OID 21790)
-- Dependencies: 3 1157 1157 431 435
-- Name: polygonize(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE polygonize(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_polygonize_finalfn
);


ALTER AGGREGATE public.polygonize(geometry) OWNER TO postgres;

--
-- TOC entry 1434 (class 1255 OID 21783)
-- Dependencies: 3 1160 1157 431 432
-- Name: st_accum(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_accum(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_accum_finalfn
);


ALTER AGGREGATE public.st_accum(geometry) OWNER TO postgres;

--
-- TOC entry 3851 (class 0 OID 0)
-- Dependencies: 1434
-- Name: AGGREGATE st_accum(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_accum(geometry) IS 'args: geomfield - Aggregate. Constructs an array of geometries.';


--
-- TOC entry 1437 (class 1255 OID 21789)
-- Dependencies: 3 1157 1157 431 434
-- Name: st_collect(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_collect(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_collect_finalfn
);


ALTER AGGREGATE public.st_collect(geometry) OWNER TO postgres;

--
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 1437
-- Name: AGGREGATE st_collect(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_collect(geometry) IS 'args: g1field - Return a specified ST_Geometry value from a collection of other geometries.';


--
-- TOC entry 1427 (class 1255 OID 21606)
-- Dependencies: 3 1164 1157 304
-- Name: st_extent(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_extent(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d_extent
);


ALTER AGGREGATE public.st_extent(geometry) OWNER TO postgres;

--
-- TOC entry 3853 (class 0 OID 0)
-- Dependencies: 1427
-- Name: AGGREGATE st_extent(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_extent(geometry) IS 'args: geomfield - an aggregate function that returns the bounding box that bounds rows of geometries.';


--
-- TOC entry 1429 (class 1255 OID 21610)
-- Dependencies: 3 1161 1157 306
-- Name: st_extent3d(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_extent3d(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d
);


ALTER AGGREGATE public.st_extent3d(geometry) OWNER TO postgres;

--
-- TOC entry 3854 (class 0 OID 0)
-- Dependencies: 1429
-- Name: AGGREGATE st_extent3d(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_extent3d(geometry) IS 'args: geomfield - an aggregate function that returns the box3D bounding box that bounds rows of geometries.';


--
-- TOC entry 1441 (class 1255 OID 21793)
-- Dependencies: 3 1157 1157 431 436
-- Name: st_makeline(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_makeline(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_makeline_finalfn
);


ALTER AGGREGATE public.st_makeline(geometry) OWNER TO postgres;

--
-- TOC entry 3855 (class 0 OID 0)
-- Dependencies: 1441
-- Name: AGGREGATE st_makeline(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_makeline(geometry) IS 'args: pointfield - Creates a Linestring from point geometries.';


--
-- TOC entry 1425 (class 1255 OID 21768)
-- Dependencies: 3 1157 1157 427
-- Name: st_memcollect(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_memcollect(geometry) (
    SFUNC = public.st_collect,
    STYPE = geometry
);


ALTER AGGREGATE public.st_memcollect(geometry) OWNER TO postgres;

--
-- TOC entry 1432 (class 1255 OID 21771)
-- Dependencies: 3 1157 1157 425
-- Name: st_memunion(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_memunion(geometry) (
    SFUNC = public.st_union,
    STYPE = geometry
);


ALTER AGGREGATE public.st_memunion(geometry) OWNER TO postgres;

--
-- TOC entry 3856 (class 0 OID 0)
-- Dependencies: 1432
-- Name: AGGREGATE st_memunion(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_memunion(geometry) IS 'args: geomfield - Same as ST_Union, only memory-friendly (uses less memory and more processor time).';


--
-- TOC entry 1439 (class 1255 OID 21791)
-- Dependencies: 3 1157 1157 431 435
-- Name: st_polygonize(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_polygonize(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_polygonize_finalfn
);


ALTER AGGREGATE public.st_polygonize(geometry) OWNER TO postgres;

--
-- TOC entry 3857 (class 0 OID 0)
-- Dependencies: 1439
-- Name: AGGREGATE st_polygonize(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_polygonize(geometry) IS 'args: geomfield - Aggregate. Creates a GeometryCollection containing possible polygons formed from the constituent linework of a set of geometries.';


--
-- TOC entry 1435 (class 1255 OID 21787)
-- Dependencies: 3 1157 1157 431 433
-- Name: st_union(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_union(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_union_finalfn
);


ALTER AGGREGATE public.st_union(geometry) OWNER TO postgres;

--
-- TOC entry 3858 (class 0 OID 0)
-- Dependencies: 1435
-- Name: AGGREGATE st_union(geometry); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON AGGREGATE st_union(geometry) IS 'args: g1field - Returns a geometry that represents the point set union of the Geometries.';


--
-- TOC entry 2164 (class 2617 OID 21409)
-- Dependencies: 121 122 3 1157 1157 133
-- Name: &&; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR && (
    PROCEDURE = geometry_overlap,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &&,
    RESTRICT = geometry_gist_sel,
    JOIN = geometry_gist_joinsel
);


ALTER OPERATOR public.&& (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2168 (class 2617 OID 22106)
-- Dependencies: 1184 1184 739 738 3 740
-- Name: &&; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR && (
    PROCEDURE = geography_overlaps,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = &&,
    RESTRICT = geography_gist_selectivity,
    JOIN = geography_gist_join_selectivity
);


ALTER OPERATOR public.&& (geography, geography) OWNER TO postgres;

--
-- TOC entry 2159 (class 2617 OID 21404)
-- Dependencies: 1157 3 1157 123
-- Name: &<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &< (
    PROCEDURE = geometry_overleft,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.&< (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2163 (class 2617 OID 21408)
-- Dependencies: 1157 3 1157 126
-- Name: &<|; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &<| (
    PROCEDURE = geometry_overbelow,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = |&>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.&<| (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2158 (class 2617 OID 21403)
-- Dependencies: 124 3 1157 1157
-- Name: &>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &> (
    PROCEDURE = geometry_overright,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &<,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.&> (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2153 (class 2617 OID 21359)
-- Dependencies: 98 1157 3 1157
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = geometry_lt,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.< (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2171 (class 2617 OID 22125)
-- Dependencies: 1184 3 1184 741
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = geography_lt,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.< (geography, geography) OWNER TO postgres;

--
-- TOC entry 2157 (class 2617 OID 21402)
-- Dependencies: 127 3 1157 1157
-- Name: <<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR << (
    PROCEDURE = geometry_left,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = >>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.<< (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2161 (class 2617 OID 21406)
-- Dependencies: 3 1157 130 1157
-- Name: <<|; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <<| (
    PROCEDURE = geometry_below,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = |>>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.<<| (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2154 (class 2617 OID 21360)
-- Dependencies: 1157 3 1157 99
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = geometry_le,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<= (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2172 (class 2617 OID 22126)
-- Dependencies: 3 1184 1184 742
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = geography_le,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<= (geography, geography) OWNER TO postgres;

--
-- TOC entry 2155 (class 2617 OID 21361)
-- Dependencies: 1157 102 1157 3
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = geometry_eq,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = =,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.= (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2173 (class 2617 OID 22127)
-- Dependencies: 3 745 1184 1184
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = geography_eq,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = =,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.= (geography, geography) OWNER TO postgres;

--
-- TOC entry 2151 (class 2617 OID 21357)
-- Dependencies: 1157 3 1157 100
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = geometry_gt,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.> (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2169 (class 2617 OID 22123)
-- Dependencies: 1184 743 1184 3
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = geography_gt,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.> (geography, geography) OWNER TO postgres;

--
-- TOC entry 2152 (class 2617 OID 21358)
-- Dependencies: 1157 1157 3 101
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = geometry_ge,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.>= (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2170 (class 2617 OID 22124)
-- Dependencies: 1184 744 3 1184
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = geography_ge,
    LEFTARG = geography,
    RIGHTARG = geography,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.>= (geography, geography) OWNER TO postgres;

--
-- TOC entry 2156 (class 2617 OID 21401)
-- Dependencies: 1157 128 1157 3
-- Name: >>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >> (
    PROCEDURE = geometry_right,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <<,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.>> (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2167 (class 2617 OID 21412)
-- Dependencies: 132 1157 1157 3
-- Name: @; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @ (
    PROCEDURE = geometry_contained,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2162 (class 2617 OID 21407)
-- Dependencies: 3 125 1157 1157
-- Name: |&>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR |&> (
    PROCEDURE = geometry_overabove,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = &<|,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.|&> (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2160 (class 2617 OID 21405)
-- Dependencies: 3 129 1157 1157
-- Name: |>>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR |>> (
    PROCEDURE = geometry_above,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = <<|,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.|>> (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2166 (class 2617 OID 21411)
-- Dependencies: 131 1157 3 1157
-- Name: ~; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~ (
    PROCEDURE = geometry_contain,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2165 (class 2617 OID 21410)
-- Dependencies: 1157 1157 3 134
-- Name: ~=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR ~= (
    PROCEDURE = geometry_samebox,
    LEFTARG = geometry,
    RIGHTARG = geometry,
    COMMUTATOR = ~=,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.~= (geometry, geometry) OWNER TO postgres;

--
-- TOC entry 2288 (class 2616 OID 22129)
-- Dependencies: 1184 3 2398
-- Name: btree_geography_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS btree_geography_ops
    DEFAULT FOR TYPE geography USING btree AS
    OPERATOR 1 <(geography,geography) ,
    OPERATOR 2 <=(geography,geography) ,
    OPERATOR 3 =(geography,geography) ,
    OPERATOR 4 >=(geography,geography) ,
    OPERATOR 5 >(geography,geography) ,
    FUNCTION 1 geography_cmp(geography,geography);


ALTER OPERATOR CLASS public.btree_geography_ops USING btree OWNER TO postgres;

--
-- TOC entry 2285 (class 2616 OID 21363)
-- Dependencies: 3 1157 2395
-- Name: btree_geometry_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS btree_geometry_ops
    DEFAULT FOR TYPE geometry USING btree AS
    OPERATOR 1 <(geometry,geometry) ,
    OPERATOR 2 <=(geometry,geometry) ,
    OPERATOR 3 =(geometry,geometry) ,
    OPERATOR 4 >=(geometry,geometry) ,
    OPERATOR 5 >(geometry,geometry) ,
    FUNCTION 1 geometry_cmp(geometry,geometry);


ALTER OPERATOR CLASS public.btree_geometry_ops USING btree OWNER TO postgres;

--
-- TOC entry 2287 (class 2616 OID 22108)
-- Dependencies: 1187 1184 3 2397
-- Name: gist_geography_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_geography_ops
    DEFAULT FOR TYPE geography USING gist AS
    STORAGE gidx ,
    OPERATOR 3 &&(geography,geography) ,
    FUNCTION 1 geography_gist_consistent(internal,geometry,integer) ,
    FUNCTION 2 geography_gist_union(bytea,internal) ,
    FUNCTION 3 geography_gist_compress(internal) ,
    FUNCTION 4 geography_gist_decompress(internal) ,
    FUNCTION 5 geography_gist_penalty(internal,internal,internal) ,
    FUNCTION 6 geography_gist_picksplit(internal,internal) ,
    FUNCTION 7 geography_gist_same(box2d,box2d,internal);


ALTER OPERATOR CLASS public.gist_geography_ops USING gist OWNER TO postgres;

--
-- TOC entry 2286 (class 2616 OID 21421)
-- Dependencies: 1167 3 1157 2396
-- Name: gist_geometry_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_geometry_ops
    DEFAULT FOR TYPE geometry USING gist AS
    STORAGE box2d ,
    OPERATOR 1 <<(geometry,geometry) ,
    OPERATOR 2 &<(geometry,geometry) ,
    OPERATOR 3 &&(geometry,geometry) ,
    OPERATOR 4 &>(geometry,geometry) ,
    OPERATOR 5 >>(geometry,geometry) ,
    OPERATOR 6 ~=(geometry,geometry) ,
    OPERATOR 7 ~(geometry,geometry) ,
    OPERATOR 8 @(geometry,geometry) ,
    OPERATOR 9 &<|(geometry,geometry) ,
    OPERATOR 10 <<|(geometry,geometry) ,
    OPERATOR 11 |>>(geometry,geometry) ,
    OPERATOR 12 |&>(geometry,geometry) ,
    FUNCTION 1 lwgeom_gist_consistent(internal,geometry,integer) ,
    FUNCTION 2 lwgeom_gist_union(bytea,internal) ,
    FUNCTION 3 lwgeom_gist_compress(internal) ,
    FUNCTION 4 lwgeom_gist_decompress(internal) ,
    FUNCTION 5 lwgeom_gist_penalty(internal,internal,internal) ,
    FUNCTION 6 lwgeom_gist_picksplit(internal,internal) ,
    FUNCTION 7 lwgeom_gist_same(box2d,box2d,internal);


ALTER OPERATOR CLASS public.gist_geometry_ops USING gist OWNER TO postgres;

SET search_path = pg_catalog;

--
-- TOC entry 3108 (class 2605 OID 21703)
-- Dependencies: 366 1161 1167 366
-- Name: CAST (public.box2d AS public.box3d); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box2d AS public.box3d) WITH FUNCTION public.box3d(public.box2d) AS IMPLICIT;


--
-- TOC entry 3107 (class 2605 OID 21704)
-- Dependencies: 370 1157 1167 370
-- Name: CAST (public.box2d AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box2d AS public.geometry) WITH FUNCTION public.geometry(public.box2d) AS IMPLICIT;


--
-- TOC entry 3101 (class 2605 OID 21705)
-- Dependencies: 367 1161 367
-- Name: CAST (public.box3d AS box); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box3d AS box) WITH FUNCTION public.box(public.box3d) AS IMPLICIT;


--
-- TOC entry 3103 (class 2605 OID 21702)
-- Dependencies: 365 365 1161 1167
-- Name: CAST (public.box3d AS public.box2d); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box3d AS public.box2d) WITH FUNCTION public.box2d(public.box3d) AS IMPLICIT;


--
-- TOC entry 3102 (class 2605 OID 21706)
-- Dependencies: 371 1157 1161 371
-- Name: CAST (public.box3d AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box3d AS public.geometry) WITH FUNCTION public.geometry(public.box3d) AS IMPLICIT;


--
-- TOC entry 3106 (class 2605 OID 21713)
-- Dependencies: 70 1167 1164 70
-- Name: CAST (public.box3d_extent AS public.box2d); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box3d_extent AS public.box2d) WITH FUNCTION public.box2d(public.box3d_extent) AS IMPLICIT;


--
-- TOC entry 3105 (class 2605 OID 21712)
-- Dependencies: 69 69 1161 1164
-- Name: CAST (public.box3d_extent AS public.box3d); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box3d_extent AS public.box3d) WITH FUNCTION public.box3d_extent(public.box3d_extent) AS IMPLICIT;


--
-- TOC entry 3104 (class 2605 OID 21714)
-- Dependencies: 71 1164 1157 71
-- Name: CAST (public.box3d_extent AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.box3d_extent AS public.geometry) WITH FUNCTION public.geometry(public.box3d_extent) AS IMPLICIT;


--
-- TOC entry 2906 (class 2605 OID 21710)
-- Dependencies: 374 1157 374
-- Name: CAST (bytea AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (bytea AS public.geometry) WITH FUNCTION public.geometry(bytea) AS IMPLICIT;


--
-- TOC entry 3109 (class 2605 OID 21709)
-- Dependencies: 373 373 1157 1169
-- Name: CAST (public.chip AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.chip AS public.geometry) WITH FUNCTION public.geometry(public.chip) AS IMPLICIT;


--
-- TOC entry 3111 (class 2605 OID 22076)
-- Dependencies: 718 1184 718 1184
-- Name: CAST (public.geography AS public.geography); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geography AS public.geography) WITH FUNCTION public.geography(public.geography, integer, boolean) AS IMPLICIT;


--
-- TOC entry 3110 (class 2605 OID 22095)
-- Dependencies: 730 730 1157 1184
-- Name: CAST (public.geography AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geography AS public.geometry) WITH FUNCTION public.geometry(public.geography);


--
-- TOC entry 3097 (class 2605 OID 21701)
-- Dependencies: 364 1157 364
-- Name: CAST (public.geometry AS box); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geometry AS box) WITH FUNCTION public.box(public.geometry) AS IMPLICIT;


--
-- TOC entry 3099 (class 2605 OID 21699)
-- Dependencies: 362 1157 362 1167
-- Name: CAST (public.geometry AS public.box2d); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geometry AS public.box2d) WITH FUNCTION public.box2d(public.geometry) AS IMPLICIT;


--
-- TOC entry 3098 (class 2605 OID 21700)
-- Dependencies: 363 1161 1157 363
-- Name: CAST (public.geometry AS public.box3d); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geometry AS public.box3d) WITH FUNCTION public.box3d(public.geometry) AS IMPLICIT;


--
-- TOC entry 3095 (class 2605 OID 21711)
-- Dependencies: 375 1157 375
-- Name: CAST (public.geometry AS bytea); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geometry AS bytea) WITH FUNCTION public.bytea(public.geometry) AS IMPLICIT;


--
-- TOC entry 3100 (class 2605 OID 22093)
-- Dependencies: 729 1184 1157 729
-- Name: CAST (public.geometry AS public.geography); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geometry AS public.geography) WITH FUNCTION public.geography(public.geometry) AS IMPLICIT;


--
-- TOC entry 3096 (class 2605 OID 21708)
-- Dependencies: 368 1157 368
-- Name: CAST (public.geometry AS text); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (public.geometry AS text) WITH FUNCTION public.text(public.geometry) AS IMPLICIT;


--
-- TOC entry 2972 (class 2605 OID 21707)
-- Dependencies: 372 1157 372
-- Name: CAST (text AS public.geometry); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (text AS public.geometry) WITH FUNCTION public.geometry(text) AS IMPLICIT;


SET search_path = biosql, pg_catalog;

--
-- TOC entry 2669 (class 1259 OID 42794)
-- Dependencies: 6
-- Name: biodatabase_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE biodatabase_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.biodatabase_pk_seq OWNER TO entangled_bank_user;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 2670 (class 1259 OID 42796)
-- Dependencies: 3112 6
-- Name: biodatabase; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE biodatabase (
    biodatabase_id integer DEFAULT nextval('biodatabase_pk_seq'::regclass) NOT NULL,
    name character varying(128) NOT NULL,
    authority character varying(128),
    description text
);


ALTER TABLE biosql.biodatabase OWNER TO entangled_bank_user;

--
-- TOC entry 2671 (class 1259 OID 42803)
-- Dependencies: 6
-- Name: bioentry_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE bioentry_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.bioentry_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2672 (class 1259 OID 42805)
-- Dependencies: 3113 6
-- Name: bioentry; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE bioentry (
    bioentry_id integer DEFAULT nextval('bioentry_pk_seq'::regclass) NOT NULL,
    biodatabase_id integer NOT NULL,
    taxon_id integer,
    name character varying(40) NOT NULL,
    accession character varying(128) NOT NULL,
    identifier character varying(40),
    division character varying(6),
    description text,
    version integer NOT NULL
);


ALTER TABLE biosql.bioentry OWNER TO entangled_bank_user;

--
-- TOC entry 2673 (class 1259 OID 42812)
-- Dependencies: 6
-- Name: bioentry_dbxref; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE bioentry_dbxref (
    bioentry_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    rank integer
);


ALTER TABLE biosql.bioentry_dbxref OWNER TO entangled_bank_user;

--
-- TOC entry 2674 (class 1259 OID 42815)
-- Dependencies: 6
-- Name: bioentry_path; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE bioentry_path (
    object_bioentry_id integer NOT NULL,
    subject_bioentry_id integer NOT NULL,
    term_id integer NOT NULL,
    distance integer
);


ALTER TABLE biosql.bioentry_path OWNER TO entangled_bank_user;

--
-- TOC entry 2675 (class 1259 OID 42818)
-- Dependencies: 3114 6
-- Name: bioentry_qualifier_value; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE bioentry_qualifier_value (
    bioentry_id integer NOT NULL,
    term_id integer NOT NULL,
    value text,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.bioentry_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 2676 (class 1259 OID 42825)
-- Dependencies: 3115 6
-- Name: bioentry_reference; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE bioentry_reference (
    bioentry_id integer NOT NULL,
    reference_id integer NOT NULL,
    start_pos integer,
    end_pos integer,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.bioentry_reference OWNER TO entangled_bank_user;

--
-- TOC entry 2677 (class 1259 OID 42829)
-- Dependencies: 6
-- Name: bioentry_relationship_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE bioentry_relationship_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.bioentry_relationship_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2678 (class 1259 OID 42831)
-- Dependencies: 3116 6
-- Name: bioentry_relationship; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE bioentry_relationship (
    bioentry_relationship_id integer DEFAULT nextval('bioentry_relationship_pk_seq'::regclass) NOT NULL,
    object_bioentry_id integer NOT NULL,
    subject_bioentry_id integer NOT NULL,
    term_id integer NOT NULL,
    rank integer
);


ALTER TABLE biosql.bioentry_relationship OWNER TO entangled_bank_user;

--
-- TOC entry 2679 (class 1259 OID 42835)
-- Dependencies: 6
-- Name: biosequence; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE biosequence (
    bioentry_id integer NOT NULL,
    version integer,
    length integer,
    alphabet character varying(10),
    seq text
);


ALTER TABLE biosql.biosequence OWNER TO entangled_bank_user;

--
-- TOC entry 2680 (class 1259 OID 42841)
-- Dependencies: 6
-- Name: comment_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE comment_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.comment_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2681 (class 1259 OID 42843)
-- Dependencies: 3117 3118 6
-- Name: comment; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE comment (
    comment_id integer DEFAULT nextval('comment_pk_seq'::regclass) NOT NULL,
    bioentry_id integer NOT NULL,
    comment_text text NOT NULL,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.comment OWNER TO entangled_bank_user;

--
-- TOC entry 2682 (class 1259 OID 42851)
-- Dependencies: 6
-- Name: dbxref_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE dbxref_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.dbxref_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2683 (class 1259 OID 42853)
-- Dependencies: 3119 6
-- Name: dbxref; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE dbxref (
    dbxref_id integer DEFAULT nextval('dbxref_pk_seq'::regclass) NOT NULL,
    dbname character varying(40) NOT NULL,
    accession character varying(128) NOT NULL,
    version integer NOT NULL
);


ALTER TABLE biosql.dbxref OWNER TO entangled_bank_user;

--
-- TOC entry 2684 (class 1259 OID 42857)
-- Dependencies: 3120 6
-- Name: dbxref_qualifier_value; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE dbxref_qualifier_value (
    dbxref_id integer NOT NULL,
    term_id integer NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    value text
);


ALTER TABLE biosql.dbxref_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 2685 (class 1259 OID 42864)
-- Dependencies: 6
-- Name: edge_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE edge_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.edge_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2686 (class 1259 OID 42866)
-- Dependencies: 3121 6
-- Name: edge; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE edge (
    edge_id integer DEFAULT nextval('edge_pk_seq'::regclass) NOT NULL,
    child_node_id integer NOT NULL,
    parent_node_id integer NOT NULL
);


ALTER TABLE biosql.edge OWNER TO entangled_bank_user;

--
-- TOC entry 3860 (class 0 OID 0)
-- Dependencies: 2686
-- Name: TABLE edge; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE edge IS 'An edge between two nodes in a tree (or graph).';


--
-- TOC entry 3861 (class 0 OID 0)
-- Dependencies: 2686
-- Name: COLUMN edge.child_node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN edge.child_node_id IS 'The endpoint node of the two nodes connected by a directed edge. In a phylogenetic tree, this is the descendant.';


--
-- TOC entry 3862 (class 0 OID 0)
-- Dependencies: 2686
-- Name: COLUMN edge.parent_node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN edge.parent_node_id IS 'The startpoint node of the two nodes connected by a directed edge. In a phylogenetic tree, this is the ancestor.';


--
-- TOC entry 2687 (class 1259 OID 42870)
-- Dependencies: 3122 6
-- Name: edge_qualifier_value; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE edge_qualifier_value (
    value text,
    rank integer DEFAULT 0 NOT NULL,
    edge_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE biosql.edge_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 3863 (class 0 OID 0)
-- Dependencies: 2687
-- Name: TABLE edge_qualifier_value; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE edge_qualifier_value IS 'Edge metadata as attribute/value pairs. Attribute names are from a controlled vocabulary (or ontology).';


--
-- TOC entry 3864 (class 0 OID 0)
-- Dependencies: 2687
-- Name: COLUMN edge_qualifier_value.value; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN edge_qualifier_value.value IS 'The value of the attribute/value pair association of metadata (if applicable).';


--
-- TOC entry 3865 (class 0 OID 0)
-- Dependencies: 2687
-- Name: COLUMN edge_qualifier_value.rank; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN edge_qualifier_value.rank IS 'The index of the metadata value if there is more than one value for the same metadata element. If there is only one value, this may be left at the default of zero.';


--
-- TOC entry 3866 (class 0 OID 0)
-- Dependencies: 2687
-- Name: COLUMN edge_qualifier_value.edge_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN edge_qualifier_value.edge_id IS 'The tree edge to which the metadata is being associated.';


--
-- TOC entry 3867 (class 0 OID 0)
-- Dependencies: 2687
-- Name: COLUMN edge_qualifier_value.term_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN edge_qualifier_value.term_id IS 'The name of the metadate element as a term from a controlled vocabulary (or ontology).';


--
-- TOC entry 2688 (class 1259 OID 42877)
-- Dependencies: 6
-- Name: location_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE location_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.location_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2689 (class 1259 OID 42879)
-- Dependencies: 3123 3124 3125 6
-- Name: location; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE location (
    location_id integer DEFAULT nextval('location_pk_seq'::regclass) NOT NULL,
    seqfeature_id integer NOT NULL,
    dbxref_id integer,
    term_id integer,
    start_pos integer,
    end_pos integer,
    strand integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.location OWNER TO entangled_bank_user;

--
-- TOC entry 2690 (class 1259 OID 42885)
-- Dependencies: 6
-- Name: location_qualifier_value; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE location_qualifier_value (
    location_id integer NOT NULL,
    term_id integer NOT NULL,
    value character varying(255) NOT NULL,
    int_value integer
);


ALTER TABLE biosql.location_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 2691 (class 1259 OID 42888)
-- Dependencies: 6
-- Name: node_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE node_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.node_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2692 (class 1259 OID 42890)
-- Dependencies: 3126 6
-- Name: node; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE node (
    node_id integer DEFAULT nextval('node_pk_seq'::regclass) NOT NULL,
    label character varying(255),
    tree_id integer NOT NULL,
    left_idx integer,
    right_idx integer
);


ALTER TABLE biosql.node OWNER TO entangled_bank_user;

--
-- TOC entry 3868 (class 0 OID 0)
-- Dependencies: 2692
-- Name: TABLE node; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE node IS 'A node in a tree. Typically, this will be a node in a phylogenetic tree, resembling either a nucleotide or protein sequence, or a taxon, or more generally an ''operational taxonomic unit'' (OTU).';


--
-- TOC entry 3869 (class 0 OID 0)
-- Dependencies: 2692
-- Name: COLUMN node.label; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node.label IS 'The label of a node. This may the latin binomial of the taxon, the accession number of a sequences, or any other construct that uniquely identifies the node within one tree.';


--
-- TOC entry 3870 (class 0 OID 0)
-- Dependencies: 2692
-- Name: COLUMN node.tree_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node.tree_id IS 'The tree of which this node is a part of.';


--
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 2692
-- Name: COLUMN node.left_idx; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node.left_idx IS 'The left value of the nested set optimization structure for efficient hierarchical queries. Needs to be precomputed by a program, see J. Celko, SQL for Smarties.';


--
-- TOC entry 3872 (class 0 OID 0)
-- Dependencies: 2692
-- Name: COLUMN node.right_idx; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node.right_idx IS 'The right value of the nested set optimization structure for efficient hierarchical queries. Needs to be precomputed by a program, see J. Celko, SQL for Smarties.';


--
-- TOC entry 2693 (class 1259 OID 42894)
-- Dependencies: 6
-- Name: node_bioentry_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE node_bioentry_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.node_bioentry_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2694 (class 1259 OID 42896)
-- Dependencies: 3127 3128 6
-- Name: node_bioentry; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE node_bioentry (
    node_bioentry_id integer DEFAULT nextval('node_bioentry_pk_seq'::regclass) NOT NULL,
    node_id integer NOT NULL,
    bioentry_id integer NOT NULL,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.node_bioentry OWNER TO entangled_bank_user;

--
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 2694
-- Name: TABLE node_bioentry; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE node_bioentry IS 'Links tree nodes to sequences (or other bioentries). If the alignment is concatenated on molecular data, there will be more than one sequence, and rank can be used to order these appropriately.';


--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 2694
-- Name: COLUMN node_bioentry.node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_bioentry.node_id IS 'The node to which the bioentry is being linked.';


--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 2694
-- Name: COLUMN node_bioentry.bioentry_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_bioentry.bioentry_id IS 'The bioentry being linked to the node.';


--
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 2694
-- Name: COLUMN node_bioentry.rank; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_bioentry.rank IS 'The index of this bioentry within the list of bioentries being linked to the node, if the order is significant. Typically, this will be used to represent the position of the respective sequence within the concatenated alignment, or the partition index.';


--
-- TOC entry 2695 (class 1259 OID 42901)
-- Dependencies: 6
-- Name: node_dbxref; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE node_dbxref (
    node_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE biosql.node_dbxref OWNER TO entangled_bank_user;

--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 2695
-- Name: TABLE node_dbxref; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE node_dbxref IS 'Identifiers and other database cross-references for nodes. There can only be one dbxref of a specific type for a node.';


--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 2695
-- Name: COLUMN node_dbxref.node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_dbxref.node_id IS 'The node to which the database cross-reference is being assigned.';


--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 2695
-- Name: COLUMN node_dbxref.dbxref_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_dbxref.dbxref_id IS 'The database cross-reference being assigned to the node.';


--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 2695
-- Name: COLUMN node_dbxref.term_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_dbxref.term_id IS 'The type of the database cross-reference as a controlled vocabulary or ontology term. The type of a node identifier should be ''primary identifier''.';


--
-- TOC entry 2696 (class 1259 OID 42904)
-- Dependencies: 6
-- Name: node_path; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE node_path (
    child_node_id integer NOT NULL,
    parent_node_id integer NOT NULL,
    path text,
    distance integer NOT NULL
);


ALTER TABLE biosql.node_path OWNER TO entangled_bank_user;

--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 2696
-- Name: TABLE node_path; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE node_path IS 'An path between two nodes in a tree (or graph). Two nodes A and B are connected by a (directed) path if B can be reached from A by following nodes that are connected by (directed) edges.';


--
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 2696
-- Name: COLUMN node_path.child_node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_path.child_node_id IS 'The endpoint node of the two nodes connected by a (directed) path. In a phylogenetic tree, this is the descendant.';


--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 2696
-- Name: COLUMN node_path.parent_node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_path.parent_node_id IS 'The startpoint node of the two nodes connected by a (directed) path. In a phylogenetic tree, this is the ancestor.';


--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 2696
-- Name: COLUMN node_path.path; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_path.path IS 'The path from startpoint to endpoint as the series of nodes visited along the path. The nodes may be identified by label, or, typically more efficient, by their primary key, or left or right value. The latter or often smaller than the primary key, and hence consume less space. One may increase efficiency further by using a base-34 numeric representation (24 letters of the alphabet, plus 10 digits) instead of decimal (base-10) representation. The actual method used is not important, though it should be used consistently.';


--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 2696
-- Name: COLUMN node_path.distance; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_path.distance IS 'The distance (or length) of the path. The path between a node and itself has length zero, and length 1 between two nodes directly connected by an edge. If there is a path of length l between two nodes A and Z and an edge between Z and B, there is a path of length l+1 between nodes A and B.';


--
-- TOC entry 2697 (class 1259 OID 42910)
-- Dependencies: 3129 6
-- Name: node_qualifier_value; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE node_qualifier_value (
    value text,
    rank integer DEFAULT 0 NOT NULL,
    node_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE biosql.node_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 2697
-- Name: TABLE node_qualifier_value; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE node_qualifier_value IS 'Tree (or network) node metadata as attribute/value pairs. Attribute names are from a controlled vocabulary (or ontology).';


--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 2697
-- Name: COLUMN node_qualifier_value.value; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_qualifier_value.value IS 'The value of the attribute/value pair association of metadata (if applicable).';


--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 2697
-- Name: COLUMN node_qualifier_value.rank; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_qualifier_value.rank IS 'The index of the metadata value if there is more than one value for the same metadata element. If there is only one value, this may be left at the default of zero.';


--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 2697
-- Name: COLUMN node_qualifier_value.node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_qualifier_value.node_id IS 'The tree (or network) node to which the metadata is being associated.';


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 2697
-- Name: COLUMN node_qualifier_value.term_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_qualifier_value.term_id IS 'The name of the metadate element as a term from a controlled vocabulary (or ontology).';


--
-- TOC entry 2698 (class 1259 OID 42917)
-- Dependencies: 6
-- Name: node_taxon_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE node_taxon_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.node_taxon_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2699 (class 1259 OID 42919)
-- Dependencies: 3130 3131 6
-- Name: node_taxon; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE node_taxon (
    node_taxon_id integer DEFAULT nextval('node_taxon_pk_seq'::regclass) NOT NULL,
    node_id integer NOT NULL,
    taxon_id integer NOT NULL,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.node_taxon OWNER TO entangled_bank_user;

--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 2699
-- Name: TABLE node_taxon; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE node_taxon IS 'Links tree nodes to taxa. If the alignment is concatenated on molecular data, there may be more than one sequence, and these may not necessarily be from the same taxon (e.g., they might be from subspecies). Rank can be used to order these appropriately.';


--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 2699
-- Name: COLUMN node_taxon.node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_taxon.node_id IS 'The node to which the taxon is being linked.';


--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 2699
-- Name: COLUMN node_taxon.taxon_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_taxon.taxon_id IS 'The taxon being linked to the node.';


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 2699
-- Name: COLUMN node_taxon.rank; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN node_taxon.rank IS 'The index of this taxon within the list of taxa being linked to the node, if the order is significant. Typically, this will be used to represent the position of the respective sequence within the concatenated alignment, or the partition index.';


--
-- TOC entry 2700 (class 1259 OID 42924)
-- Dependencies: 6
-- Name: ontology_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE ontology_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.ontology_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2701 (class 1259 OID 42926)
-- Dependencies: 3132 6
-- Name: ontology; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE ontology (
    ontology_id integer DEFAULT nextval('ontology_pk_seq'::regclass) NOT NULL,
    name character varying(32) NOT NULL,
    definition text
);


ALTER TABLE biosql.ontology OWNER TO entangled_bank_user;

--
-- TOC entry 2702 (class 1259 OID 42933)
-- Dependencies: 6
-- Name: reference_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE reference_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.reference_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2703 (class 1259 OID 42935)
-- Dependencies: 3133 6
-- Name: reference; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE reference (
    reference_id integer DEFAULT nextval('reference_pk_seq'::regclass) NOT NULL,
    dbxref_id integer,
    location text NOT NULL,
    title text,
    authors text,
    crc character varying(32)
);


ALTER TABLE biosql.reference OWNER TO entangled_bank_user;

--
-- TOC entry 2704 (class 1259 OID 42942)
-- Dependencies: 6
-- Name: seqfeature_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE seqfeature_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.seqfeature_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2705 (class 1259 OID 42944)
-- Dependencies: 3134 3135 6
-- Name: seqfeature; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE seqfeature (
    seqfeature_id integer DEFAULT nextval('seqfeature_pk_seq'::regclass) NOT NULL,
    bioentry_id integer NOT NULL,
    type_term_id integer NOT NULL,
    source_term_id integer NOT NULL,
    display_name character varying(64),
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.seqfeature OWNER TO entangled_bank_user;

--
-- TOC entry 2706 (class 1259 OID 42949)
-- Dependencies: 6
-- Name: seqfeature_dbxref; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE seqfeature_dbxref (
    seqfeature_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    rank integer
);


ALTER TABLE biosql.seqfeature_dbxref OWNER TO entangled_bank_user;

--
-- TOC entry 2707 (class 1259 OID 42952)
-- Dependencies: 6
-- Name: seqfeature_path; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE seqfeature_path (
    object_seqfeature_id integer NOT NULL,
    subject_seqfeature_id integer NOT NULL,
    term_id integer NOT NULL,
    distance integer
);


ALTER TABLE biosql.seqfeature_path OWNER TO entangled_bank_user;

--
-- TOC entry 2708 (class 1259 OID 42955)
-- Dependencies: 3136 6
-- Name: seqfeature_qualifier_value; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE seqfeature_qualifier_value (
    seqfeature_id integer NOT NULL,
    term_id integer NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    value text NOT NULL
);


ALTER TABLE biosql.seqfeature_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 2709 (class 1259 OID 42962)
-- Dependencies: 6
-- Name: seqfeature_relationship_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE seqfeature_relationship_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.seqfeature_relationship_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2710 (class 1259 OID 42964)
-- Dependencies: 3137 6
-- Name: seqfeature_relationship; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE seqfeature_relationship (
    seqfeature_relationship_id integer DEFAULT nextval('seqfeature_relationship_pk_seq'::regclass) NOT NULL,
    object_seqfeature_id integer NOT NULL,
    subject_seqfeature_id integer NOT NULL,
    term_id integer NOT NULL,
    rank integer
);


ALTER TABLE biosql.seqfeature_relationship OWNER TO entangled_bank_user;

--
-- TOC entry 2711 (class 1259 OID 42968)
-- Dependencies: 6
-- Name: taxon_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE taxon_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.taxon_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2712 (class 1259 OID 42970)
-- Dependencies: 3138 6
-- Name: taxon; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE taxon (
    taxon_id integer DEFAULT nextval('taxon_pk_seq'::regclass) NOT NULL,
    ncbi_taxon_id integer,
    parent_taxon_id integer,
    node_rank character varying(32),
    genetic_code smallint,
    mito_genetic_code smallint,
    left_value integer,
    right_value integer
);


ALTER TABLE biosql.taxon OWNER TO entangled_bank_user;

--
-- TOC entry 2713 (class 1259 OID 42974)
-- Dependencies: 6
-- Name: taxon_name; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE taxon_name (
    taxon_id integer NOT NULL,
    name character varying(255) NOT NULL,
    name_class character varying(32) NOT NULL
);


ALTER TABLE biosql.taxon_name OWNER TO entangled_bank_user;

--
-- TOC entry 2714 (class 1259 OID 42977)
-- Dependencies: 6
-- Name: taxon_table; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE taxon_table (
    "TaxonID" integer NOT NULL,
    "Genus" character varying(50) NOT NULL,
    "Species" character varying(50) NOT NULL,
    "Subspecies" character varying(50) NOT NULL,
    "Authority" character varying(200) NOT NULL,
    "MSW93Binomial" character varying(100),
    "MSW05Binomial" character varying(100),
    "MSW05Trinomial" character varying(200)
);


ALTER TABLE biosql.taxon_table OWNER TO entangled_bank_user;

--
-- TOC entry 2715 (class 1259 OID 42983)
-- Dependencies: 6 2714
-- Name: taxon_table_TaxonID_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE "taxon_table_TaxonID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql."taxon_table_TaxonID_seq" OWNER TO entangled_bank_user;

--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 2715
-- Name: taxon_table_TaxonID_seq; Type: SEQUENCE OWNED BY; Schema: biosql; Owner: entangled_bank_user
--

ALTER SEQUENCE "taxon_table_TaxonID_seq" OWNED BY taxon_table."TaxonID";


--
-- TOC entry 2716 (class 1259 OID 42985)
-- Dependencies: 6
-- Name: term_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE term_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.term_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2717 (class 1259 OID 42987)
-- Dependencies: 3140 6
-- Name: term; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE term (
    term_id integer DEFAULT nextval('term_pk_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL,
    definition text,
    identifier character varying(40),
    is_obsolete character(1),
    ontology_id integer NOT NULL
);


ALTER TABLE biosql.term OWNER TO entangled_bank_user;

--
-- TOC entry 2718 (class 1259 OID 42994)
-- Dependencies: 6
-- Name: term_dbxref; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE term_dbxref (
    term_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    rank integer
);


ALTER TABLE biosql.term_dbxref OWNER TO entangled_bank_user;

--
-- TOC entry 2719 (class 1259 OID 42997)
-- Dependencies: 6
-- Name: term_path_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE term_path_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.term_path_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2720 (class 1259 OID 42999)
-- Dependencies: 3141 6
-- Name: term_path; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE term_path (
    term_path_id integer DEFAULT nextval('term_path_pk_seq'::regclass) NOT NULL,
    subject_term_id integer NOT NULL,
    predicate_term_id integer NOT NULL,
    object_term_id integer NOT NULL,
    ontology_id integer NOT NULL,
    distance integer
);


ALTER TABLE biosql.term_path OWNER TO entangled_bank_user;

--
-- TOC entry 2721 (class 1259 OID 43003)
-- Dependencies: 6
-- Name: term_relationship_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE term_relationship_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.term_relationship_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2722 (class 1259 OID 43005)
-- Dependencies: 3142 6
-- Name: term_relationship; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE term_relationship (
    term_relationship_id integer DEFAULT nextval('term_relationship_pk_seq'::regclass) NOT NULL,
    subject_term_id integer NOT NULL,
    predicate_term_id integer NOT NULL,
    object_term_id integer NOT NULL,
    ontology_id integer NOT NULL
);


ALTER TABLE biosql.term_relationship OWNER TO entangled_bank_user;

--
-- TOC entry 2723 (class 1259 OID 43009)
-- Dependencies: 6
-- Name: term_relationship_term; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE term_relationship_term (
    term_relationship_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE biosql.term_relationship_term OWNER TO entangled_bank_user;

--
-- TOC entry 2724 (class 1259 OID 43012)
-- Dependencies: 6
-- Name: term_synonym; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE term_synonym (
    synonym character varying(255) NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE biosql.term_synonym OWNER TO entangled_bank_user;

--
-- TOC entry 2725 (class 1259 OID 43015)
-- Dependencies: 6
-- Name: tree_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE tree_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.tree_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2726 (class 1259 OID 43017)
-- Dependencies: 3143 3144 6
-- Name: tree; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE tree (
    tree_id integer DEFAULT nextval('tree_pk_seq'::regclass) NOT NULL,
    name character varying(32) NOT NULL,
    identifier character varying(32),
    is_rooted boolean DEFAULT true,
    node_id integer NOT NULL,
    biodatabase_id integer NOT NULL
);


ALTER TABLE biosql.tree OWNER TO entangled_bank_user;

--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 2726
-- Name: TABLE tree; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE tree IS 'A tree basically is a namespace for nodes, and thereby implicitly for their relationships (edges). In this model, tree is also bit of misnomer because we try to support reticulating trees, i.e., networks, too, so arguably it should be called graph. Typically, this will be used for storing phylogenetic trees, sequence trees (a.k.a. gene trees) as much as species trees.';


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 2726
-- Name: COLUMN tree.name; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree.name IS 'The name of the tree, in essence a label.';


--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 2726
-- Name: COLUMN tree.identifier; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree.identifier IS 'The identifier of the tree, if there is one.';


--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 2726
-- Name: COLUMN tree.is_rooted; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree.is_rooted IS 'Whether or not the tree is rooted. By default, a tree is assumed to be rooted.';


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 2726
-- Name: COLUMN tree.node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree.node_id IS 'The starting node of the tree. If the tree is rooted, this will usually be the root node. Note that the root node(s) of a rooted tree must be stored in tree_root, too.';


--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 2726
-- Name: COLUMN tree.biodatabase_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree.biodatabase_id IS 'The namespace of the tree itself. Though trees are in a sense named containers themselves (namely for nodes), they also constitute (possibly identifiable!) data objects in their own right. Some data sources may only provide a single tree, so that assigning a namespace for the tree may seem excessive, but others, such as TreeBASE, contain many trees, just as sequence databanks contain many sequences. The choice of how to name a tree is up to the user; one may assign a default namespace (such as "biosql"), or create one named the same as the tree.';


--
-- TOC entry 2727 (class 1259 OID 43022)
-- Dependencies: 6
-- Name: tree_dbxref; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE tree_dbxref (
    tree_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE biosql.tree_dbxref OWNER TO entangled_bank_user;

--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 2727
-- Name: TABLE tree_dbxref; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE tree_dbxref IS 'Secondary identifiers and other database cross-references for trees. There can only be one dbxref of a specific type for a tree.';


--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 2727
-- Name: COLUMN tree_dbxref.tree_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_dbxref.tree_id IS 'The tree to which the database corss-reference is being assigned.';


--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 2727
-- Name: COLUMN tree_dbxref.dbxref_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_dbxref.dbxref_id IS 'The database cross-reference being assigned to the tree.';


--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 2727
-- Name: COLUMN tree_dbxref.term_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_dbxref.term_id IS 'The type of the database cross-reference as a controlled vocabulary or ontology term. The type of a tree accession should be ''primary identifier''.';


--
-- TOC entry 2728 (class 1259 OID 43025)
-- Dependencies: 3145 6
-- Name: tree_qualifier_value; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE tree_qualifier_value (
    tree_id integer NOT NULL,
    term_id integer NOT NULL,
    value text,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE biosql.tree_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 2728
-- Name: TABLE tree_qualifier_value; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE tree_qualifier_value IS 'Tree metadata as attribute/value pairs. Attribute names are from a controlled vocabulary (or ontology).';


--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 2728
-- Name: COLUMN tree_qualifier_value.tree_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_qualifier_value.tree_id IS 'The tree with which the metadata is being associated.';


--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 2728
-- Name: COLUMN tree_qualifier_value.term_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_qualifier_value.term_id IS 'The name of the metadate element as a term from a controlled vocabulary (or ontology).';


--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 2728
-- Name: COLUMN tree_qualifier_value.value; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_qualifier_value.value IS 'The value of the metadata element.';


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 2728
-- Name: COLUMN tree_qualifier_value.rank; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_qualifier_value.rank IS 'The index of the metadata value if there is more than one value for the same metadata element. If there is only one value, this may be left at the default of zero.';


--
-- TOC entry 2729 (class 1259 OID 43032)
-- Dependencies: 6
-- Name: tree_root_pk_seq; Type: SEQUENCE; Schema: biosql; Owner: entangled_bank_user
--

CREATE SEQUENCE tree_root_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE biosql.tree_root_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2730 (class 1259 OID 43034)
-- Dependencies: 3146 3147 6
-- Name: tree_root; Type: TABLE; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE tree_root (
    tree_root_id integer DEFAULT nextval('tree_root_pk_seq'::regclass) NOT NULL,
    tree_id integer NOT NULL,
    node_id integer NOT NULL,
    is_alternate boolean DEFAULT false,
    significance real
);


ALTER TABLE biosql.tree_root OWNER TO entangled_bank_user;

--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 2730
-- Name: TABLE tree_root; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON TABLE tree_root IS 'Root node for a rooted tree. A phylogenetic analysis might suggest several alternative root nodes, with possible probabilities.';


--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 2730
-- Name: COLUMN tree_root.tree_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_root.tree_id IS 'The tree for which the referenced node is a root node.';


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 2730
-- Name: COLUMN tree_root.node_id; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_root.node_id IS 'The node that is a root for the referenced tree.';


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 2730
-- Name: COLUMN tree_root.is_alternate; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_root.is_alternate IS 'True if the root node is the preferential (most likely) root node of the tree, and false otherwise.';


--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 2730
-- Name: COLUMN tree_root.significance; Type: COMMENT; Schema: biosql; Owner: entangled_bank_user
--

COMMENT ON COLUMN tree_root.significance IS 'The significance (such as likelihood, or posterior probability) with which the node is the root node. This only has meaning if the method used for reconstructing the tree calculates this value.';


SET search_path = gpdd, pg_catalog;

--
-- TOC entry 2732 (class 1259 OID 43065)
-- Dependencies: 9
-- Name: biotope; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE biotope (
    "BiotopeID" integer,
    "HabitatName" character varying(255),
    "BiotopeType" character varying(255)
);


ALTER TABLE gpdd.biotope OWNER TO entangled_bank_user;

--
-- TOC entry 2734 (class 1259 OID 43095)
-- Dependencies: 9
-- Name: data; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE data (
    "DataID" integer,
    "MainID" integer,
    "Population" double precision,
    "PopulationUntransformed" double precision,
    "SampleYear" integer,
    "TimePeriodID" integer,
    "Generation" integer,
    "SeriesStep" integer,
    "DecimalYearBegin" double precision,
    "DecimalYearEnd" double precision
);


ALTER TABLE gpdd.data OWNER TO entangled_bank_user;

--
-- TOC entry 2735 (class 1259 OID 43098)
-- Dependencies: 9
-- Name: datasource; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE datasource (
    "DataSourceID" integer,
    "Author" character varying(255),
    "Year" character varying(255),
    "Title" character varying(255),
    "Reference" character varying(255),
    "Availability" character varying(255),
    "ContactAddress" character varying(255),
    "DataMedium" character varying(255),
    "Notes" text
);


ALTER TABLE gpdd.datasource OWNER TO entangled_bank_user;

--
-- TOC entry 2736 (class 1259 OID 43104)
-- Dependencies: 9
-- Name: location; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE location (
    "LocationID" integer,
    "ExactName" character varying(255),
    "TownName" character varying(255),
    "CountyStateProvince" character varying(80),
    "Country" character varying(255),
    "Continent" character varying(50),
    "Ocean" character varying(50),
    "LongitudeDegrees" double precision,
    "LongitudeMinutes" double precision,
    "EorW" character varying(255),
    "LatitudeDegrees" double precision,
    "LatitudeMinutes" double precision,
    "NorS" character varying(255),
    "LongDD" double precision,
    "LatDD" double precision,
    "North" numeric(18,10),
    "East" numeric(18,10),
    "South" numeric(18,10),
    "West" numeric(18,10),
    "Altitude" double precision,
    "Area" double precision,
    "Notes" character varying(255),
    "SpatialAccuracy" integer,
    "LocationExtent" integer
);


ALTER TABLE gpdd.location OWNER TO entangled_bank_user;

--
-- TOC entry 2739 (class 1259 OID 43179)
-- Dependencies: 9 1184
-- Name: location_bbox; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE location_bbox (
    gid integer NOT NULL,
    the_geom public.geography(Polygon,4326),
    locationid integer
);


ALTER TABLE gpdd.location_bbox OWNER TO entangled_bank_user;

--
-- TOC entry 2740 (class 1259 OID 43185)
-- Dependencies: 2739 9
-- Name: location_bbox_gid_seq; Type: SEQUENCE; Schema: gpdd; Owner: entangled_bank_user
--

CREATE SEQUENCE location_bbox_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gpdd.location_bbox_gid_seq OWNER TO entangled_bank_user;

--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 2740
-- Name: location_bbox_gid_seq; Type: SEQUENCE OWNED BY; Schema: gpdd; Owner: entangled_bank_user
--

ALTER SEQUENCE location_bbox_gid_seq OWNED BY location_bbox.gid;


--
-- TOC entry 2741 (class 1259 OID 43187)
-- Dependencies: 1184 9
-- Name: location_pt; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE location_pt (
    gid integer NOT NULL,
    the_geom public.geography(Point,4326),
    locationid integer
);


ALTER TABLE gpdd.location_pt OWNER TO entangled_bank_user;

--
-- TOC entry 2742 (class 1259 OID 43193)
-- Dependencies: 9 2741
-- Name: location_pt_gid_seq; Type: SEQUENCE; Schema: gpdd; Owner: entangled_bank_user
--

CREATE SEQUENCE location_pt_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gpdd.location_pt_gid_seq OWNER TO entangled_bank_user;

--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 2742
-- Name: location_pt_gid_seq; Type: SEQUENCE OWNED BY; Schema: gpdd; Owner: entangled_bank_user
--

ALTER SEQUENCE location_pt_gid_seq OWNED BY location_pt.gid;


--
-- TOC entry 2737 (class 1259 OID 43110)
-- Dependencies: 9
-- Name: main; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE main (
    "MainID" integer,
    "TaxonID" integer,
    "DataSourceID" integer,
    "BiotopeID" integer,
    "LocationID" integer,
    "SamplingUnits" character varying(255),
    "SamplingProtocol" character varying(255),
    "SourceDimension" character varying(255),
    "SamplingEffort" character varying(255),
    "SpatialDensity" character varying(255),
    "SourceTransform" character varying(255),
    "SourceTransformReference" character varying(255),
    "AssociatedDataSets" character varying(255),
    "Reliability" double precision,
    "StartYear" integer,
    "EndYear" integer,
    "SamplingFrequency" character varying(50),
    "DatasetLength" double precision,
    "Notes" text,
    "SiblyFittedTheta" double precision,
    "SiblyThetaCILower" double precision,
    "SiblyThetaCIUpper" double precision,
    "SiblyExtremeNEffect" character(1),
    "SiblyReturnRate" double precision,
    "SiblyCarryingCapacity" double precision
);


ALTER TABLE gpdd.main OWNER TO entangled_bank_user;

--
-- TOC entry 2733 (class 1259 OID 43071)
-- Dependencies: 9
-- Name: taxon; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE taxon (
    "TaxonID" integer,
    "TaxonName" character varying(255),
    "WoldaCode" character varying(50),
    "Authority" character varying(255),
    "TaxonomicLevel" character varying(255),
    "CommonName" character varying(255),
    "TaxonomicPhylum" character varying(255),
    "TaxonomicClass" character varying(255),
    "TaxonomicOrder" character varying(255),
    "TaxonomicFamily" character varying(255),
    "TaxonomicGenus" character varying(255),
    "Notes" character varying(255),
    binomial character varying(255),
    trinomial character varying(255)
);


ALTER TABLE gpdd.taxon OWNER TO entangled_bank_user;

--
-- TOC entry 2738 (class 1259 OID 43116)
-- Dependencies: 9
-- Name: timeperiod; Type: TABLE; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE timeperiod (
    "TimePeriodID" integer,
    "TimePeriod" character varying(255),
    "TimePeriodGroup" character varying(50),
    "TimePeriodOrder" integer,
    "Begin" real,
    "End" real
);


ALTER TABLE gpdd.timeperiod OWNER TO entangled_bank_user;

SET search_path = msw05, pg_catalog;

--
-- TOC entry 2743 (class 1259 OID 43195)
-- Dependencies: 3152 3153 10 1157
-- Name: behrmann; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE behrmann (
    "MSW05binom" character varying(254),
    "Pantheria_" integer,
    the_geom public.geometry,
    gid integer NOT NULL,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.srid(the_geom) = (-1)))
);


ALTER TABLE msw05.behrmann OWNER TO entangled_bank_user;

--
-- TOC entry 2744 (class 1259 OID 43203)
-- Dependencies: 2743 10
-- Name: Behrmann_a_d_gid_seq; Type: SEQUENCE; Schema: msw05; Owner: entangled_bank_user
--

CREATE SEQUENCE "Behrmann_a_d_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE msw05."Behrmann_a_d_gid_seq" OWNER TO entangled_bank_user;

--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 2744
-- Name: Behrmann_a_d_gid_seq; Type: SEQUENCE OWNED BY; Schema: msw05; Owner: entangled_bank_user
--

ALTER SEQUENCE "Behrmann_a_d_gid_seq" OWNED BY behrmann.gid;


--
-- TOC entry 2745 (class 1259 OID 43205)
-- Dependencies: 10
-- Name: data_worldclim_fields; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE data_worldclim_fields (
    field_code character varying(6) NOT NULL,
    full_text character varying(100) NOT NULL,
    data_type character varying(5) NOT NULL
);


ALTER TABLE msw05.data_worldclim_fields OWNER TO entangled_bank_user;

--
-- TOC entry 2746 (class 1259 OID 43208)
-- Dependencies: 3154 3155 10 1157
-- Name: mollweide_e_j; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE mollweide_e_j (
    gid integer NOT NULL,
    "MSW05binom" character varying(254),
    "Area" double precision,
    "Pantheria_" integer,
    the_geom public.geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.srid(the_geom) = (-1)))
);


ALTER TABLE msw05.mollweide_e_j OWNER TO entangled_bank_user;

--
-- TOC entry 2747 (class 1259 OID 43216)
-- Dependencies: 3156 3157 1157 10
-- Name: mollweide_k_m; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE mollweide_k_m (
    gid integer NOT NULL,
    "MSW05binom" character varying(254),
    "Area" double precision,
    "Pantheria_" integer,
    the_geom public.geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.srid(the_geom) = (-1)))
);


ALTER TABLE msw05.mollweide_k_m OWNER TO entangled_bank_user;

--
-- TOC entry 2748 (class 1259 OID 43224)
-- Dependencies: 3158 3159 1157 10
-- Name: mollweide_n_p; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE mollweide_n_p (
    gid integer NOT NULL,
    "MSW05binom" character varying(254),
    "Area" double precision,
    "Pantheria_" integer,
    the_geom public.geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.srid(the_geom) = (-1)))
);


ALTER TABLE msw05.mollweide_n_p OWNER TO entangled_bank_user;

--
-- TOC entry 2749 (class 1259 OID 43232)
-- Dependencies: 3160 3161 1157 10
-- Name: mollweide_r_z; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE mollweide_r_z (
    gid integer NOT NULL,
    "MSW05binom" character varying(254),
    "Area" double precision,
    the_geom public.geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.ndims(the_geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.srid(the_geom) = (-1)))
);


ALTER TABLE msw05.mollweide_r_z OWNER TO entangled_bank_user;

--
-- TOC entry 2750 (class 1259 OID 43240)
-- Dependencies: 10 1184
-- Name: msw05_geographic; Type: TABLE; Schema: msw05; Owner: postgres; Tablespace: 
--

CREATE TABLE msw05_geographic (
    gid integer NOT NULL,
    msw05_binomial character varying(254),
    geog public.geography(MultiPolygon,4326),
    "Area_km" numeric
);


ALTER TABLE msw05.msw05_geographic OWNER TO postgres;

--
-- TOC entry 2751 (class 1259 OID 43246)
-- Dependencies: 3164 3165 3166 10 1157
-- Name: msw05_geographic_1deg; Type: TABLE; Schema: msw05; Owner: postgres; Tablespace: 
--

CREATE TABLE msw05_geographic_1deg (
    gid integer NOT NULL,
    msw05binom character varying(254),
    guid character varying(38),
    the_geom public.geometry,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((public.geometrytype(the_geom) = 'MULTIPOLYGON'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.st_srid(the_geom) = (-1)))
);


ALTER TABLE msw05.msw05_geographic_1deg OWNER TO postgres;

--
-- TOC entry 2752 (class 1259 OID 43255)
-- Dependencies: 10 2750
-- Name: msw05_geographic_geog_gid_seq; Type: SEQUENCE; Schema: msw05; Owner: postgres
--

CREATE SEQUENCE msw05_geographic_geog_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE msw05.msw05_geographic_geog_gid_seq OWNER TO postgres;

--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 2752
-- Name: msw05_geographic_geog_gid_seq; Type: SEQUENCE OWNED BY; Schema: msw05; Owner: postgres
--

ALTER SEQUENCE msw05_geographic_geog_gid_seq OWNED BY msw05_geographic.gid;


--
-- TOC entry 2753 (class 1259 OID 43257)
-- Dependencies: 2751 10
-- Name: msw05_geographic_gridded_gid_seq; Type: SEQUENCE; Schema: msw05; Owner: postgres
--

CREATE SEQUENCE msw05_geographic_gridded_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE msw05.msw05_geographic_gridded_gid_seq OWNER TO postgres;

--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 2753
-- Name: msw05_geographic_gridded_gid_seq; Type: SEQUENCE OWNED BY; Schema: msw05; Owner: postgres
--

ALTER SEQUENCE msw05_geographic_gridded_gid_seq OWNED BY msw05_geographic_1deg.gid;


--
-- TOC entry 2754 (class 1259 OID 43259)
-- Dependencies: 10
-- Name: msw05_geographic_worldclim_10mins; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE msw05_geographic_worldclim_10mins (
    msw05_binomial character varying(200) NOT NULL,
    pointid numeric NOT NULL
);


ALTER TABLE msw05.msw05_geographic_worldclim_10mins OWNER TO entangled_bank_user;

--
-- TOC entry 2755 (class 1259 OID 43265)
-- Dependencies: 10
-- Name: msw05_geographic_worldclim_10mins_stats_bio; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE msw05_geographic_worldclim_10mins_stats_bio (
    msw05_binomial character varying(200),
    n bigint,
    bio_1_min numeric,
    bio_1_avg numeric,
    bio_1_max numeric,
    bio_1_stddev numeric,
    bio_1_var numeric,
    bio_2_min numeric,
    bio_2_avg numeric,
    bio_2_max numeric,
    bio_2_stddev numeric,
    bio_2_var numeric,
    bio_3_min numeric,
    bio_3_avg numeric,
    bio_3_max numeric,
    bio_3_stddev numeric,
    bio_3_var numeric,
    bio_4_min numeric,
    bio_4_avg numeric,
    bio_4_max numeric,
    bio_4_stddev numeric,
    bio_4_var numeric,
    bio_5_min numeric,
    bio_5_avg numeric,
    bio_5_max numeric,
    bio_5_stddev numeric,
    bio_5_var numeric,
    bio_6_min numeric,
    bio_6_avg numeric,
    bio_6_max numeric,
    bio_6_stddev numeric,
    bio_6_var numeric,
    bio_7_min numeric,
    bio_7_avg numeric,
    bio_7_max numeric,
    bio_7_stddev numeric,
    bio_7_var numeric,
    bio_8_min numeric,
    bio_8_avg numeric,
    bio_8_max numeric,
    bio_8_stddev numeric,
    bio_8_var numeric,
    bio_9_min numeric,
    bio_9_avg numeric,
    bio_9_max numeric,
    bio_9_stddev numeric,
    bio_9_var numeric,
    bio_10_min numeric,
    bio_10_avg numeric,
    bio_10_max numeric,
    bio_10_stddev numeric,
    bio_10_var numeric,
    bio_11_min numeric,
    bio_11_avg numeric,
    bio_11_max numeric,
    bio_11_stddev numeric,
    bio_11_var numeric,
    bio_12_min numeric,
    bio_12_avg numeric,
    bio_12_max numeric,
    bio_12_stddev numeric,
    bio_12_var numeric,
    bio_13_min numeric,
    bio_13_avg numeric,
    bio_13_max numeric,
    bio_13_stddev numeric,
    bio_13_var numeric,
    bio_14_min numeric,
    bio_14_avg numeric,
    bio_14_max numeric,
    bio_14_stddev numeric,
    bio_14_var numeric,
    bio_15_min numeric,
    bio_15_avg numeric,
    bio_15_max numeric,
    bio_15_stddev numeric,
    bio_15_var numeric,
    bio_16_min numeric,
    bio_16_avg numeric,
    bio_16_max numeric,
    bio_16_stddev numeric,
    bio_16_var numeric,
    bio_17_min numeric,
    bio_17_avg numeric,
    bio_17_max numeric,
    bio_17_stddev numeric,
    bio_17_var numeric,
    bio_18_min numeric,
    bio_18_avg numeric,
    bio_18_max numeric,
    bio_18_stddev numeric,
    bio_18_var numeric,
    bio_19_min numeric,
    bio_19_avg numeric,
    bio_19_max numeric,
    bio_19_stddev numeric,
    bio_19_var numeric
);


ALTER TABLE msw05.msw05_geographic_worldclim_10mins_stats_bio OWNER TO entangled_bank_user;

--
-- TOC entry 2731 (class 1259 OID 43039)
-- Dependencies: 10
-- Name: msw05_pantheria; Type: TABLE; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE msw05_pantheria (
    pantheria_05id integer NOT NULL,
    msw05_order character varying(30) NOT NULL,
    msw05_family character varying(30) NOT NULL,
    msw05_genus character varying(30) NOT NULL,
    msw05_species character varying(30) NOT NULL,
    msw05_binomial character varying(50) NOT NULL,
    "References" character varying(1000),
    "1-1_ActivityCycle" integer,
    "2-1_AgeatEyeOpening_d" numeric,
    "3-1_AgeatFirstBirth_d" numeric,
    "5-1_AdultBodyMass_g" numeric,
    "5-2_BasalMetRateMass_g" numeric,
    "5-3_NeonateBodyMass_g" numeric,
    "5-4_WeaningBodyMass_g" numeric,
    "5-5_AdultBodyMass_g_EXT" numeric,
    "5-6_NeonateBodyMass_g_EXT" numeric,
    "5-7_WeaningBodyMass_g_EXT" numeric,
    "6-1_DietBreadth" integer,
    "6-2_TrophicLevel" integer,
    "7-1_DispersalAge_d" numeric,
    "8-1_AdultForearmLen_mm" numeric,
    "9-1_GestationLen_d" numeric,
    "10-1_PopulationGrpSize" numeric,
    "10-2_SocialGrpSize" numeric,
    "12-1_HabitatBreadth" integer,
    "12-2_Terrestriality" integer,
    "13-1_AdultHeadBodyLen_mm" numeric,
    "13-2_NeonateHeadBodyLen_mm" numeric,
    "13-3_WeaningHeadBodyLen_mm" numeric,
    "14-1_InterbirthInterval_d" numeric,
    "15-1_LitterSize" numeric,
    "16-1_LittersPerYear" numeric,
    "16-2_LittersPerYear_EXT" numeric,
    "17-1_MaxLongevity_m" numeric,
    "18-1_BasalMetRate_mLO2hr" numeric,
    "21-1_PopulationDensity_n/km2" numeric,
    "22-1_HomeRange_km2" numeric,
    "22-2_HomeRange_Indiv_km2" numeric,
    "23-1_SexualMaturityAge_d" numeric,
    "24-1_TeatNumber" integer,
    "25-1_WeaningAge_d" numeric,
    "26-1_GR_Area_km2" numeric,
    "26-2_GR_MaxLat_dd" numeric,
    "26-3_GR_MinLat_dd" numeric,
    "26-4_GR_MidRangeLat_dd" numeric,
    "26-5_GR_MaxLong_dd" numeric,
    "26-6_GR_MinLong_dd" numeric,
    "26-7_GR_MidRangeLong_dd" numeric,
    "27-1_HuPopDen_Min_n/km2" numeric,
    "27-2_HuPopDen_Mean_n/km2" numeric,
    "27-3_HuPopDen_5p_n/km2" numeric,
    "27-4_HuPopDen_Change" numeric,
    "28-1_Precip_Mean_mm" numeric,
    "28-2_Temp_Mean_01degC" numeric,
    "30-1_AET_Mean_mm" numeric,
    "30-2_PET_Mean_mm" numeric
);


ALTER TABLE msw05.msw05_pantheria OWNER TO entangled_bank_user;

--
-- TOC entry 2756 (class 1259 OID 43271)
-- Dependencies: 2731 10
-- Name: pantheria_05_pantheria_05id_seq; Type: SEQUENCE; Schema: msw05; Owner: entangled_bank_user
--

CREATE SEQUENCE pantheria_05_pantheria_05id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE msw05.pantheria_05_pantheria_05id_seq OWNER TO entangled_bank_user;

--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 2756
-- Name: pantheria_05_pantheria_05id_seq; Type: SEQUENCE OWNED BY; Schema: msw05; Owner: entangled_bank_user
--

ALTER SEQUENCE pantheria_05_pantheria_05id_seq OWNED BY msw05_pantheria.pantheria_05id;


SET search_path = public, pg_catalog;

--
-- TOC entry 2667 (class 1259 OID 22087)
-- Dependencies: 2869 3
-- Name: geography_columns; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW geography_columns AS
    SELECT current_database() AS f_table_catalog, n.nspname AS f_table_schema, c.relname AS f_table_name, a.attname AS f_geography_column, geography_typmod_dims(a.atttypmod) AS coord_dimension, geography_typmod_srid(a.atttypmod) AS srid, geography_typmod_type(a.atttypmod) AS type FROM pg_class c, pg_attribute a, pg_type t, pg_namespace n WHERE ((((((c.relkind = ANY (ARRAY['r'::"char", 'v'::"char"])) AND (t.typname = 'geography'::name)) AND (a.attisdropped = false)) AND (a.atttypid = t.oid)) AND (a.attrelid = c.oid)) AND (c.relnamespace = n.oid));


ALTER TABLE public.geography_columns OWNER TO postgres;

SET default_with_oids = true;

--
-- TOC entry 2666 (class 1259 OID 21627)
-- Dependencies: 3
-- Name: geometry_columns; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE geometry_columns (
    f_table_catalog character varying(256) NOT NULL,
    f_table_schema character varying(256) NOT NULL,
    f_table_name character varying(256) NOT NULL,
    f_geometry_column character varying(256) NOT NULL,
    coord_dimension integer NOT NULL,
    srid integer NOT NULL,
    type character varying(30) NOT NULL
);


ALTER TABLE public.geometry_columns OWNER TO postgres;

SET default_with_oids = false;

--
-- TOC entry 2665 (class 1259 OID 21619)
-- Dependencies: 3
-- Name: spatial_ref_sys; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spatial_ref_sys (
    srid integer NOT NULL,
    auth_name character varying(256),
    auth_srid integer,
    srtext character varying(2048),
    proj4text character varying(2048)
);


ALTER TABLE public.spatial_ref_sys OWNER TO postgres;

SET search_path = source, pg_catalog;

--
-- TOC entry 2757 (class 1259 OID 43273)
-- Dependencies: 11
-- Name: edge_pk_seq; Type: SEQUENCE; Schema: source; Owner: entangled_bank_user
--

CREATE SEQUENCE edge_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.edge_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2758 (class 1259 OID 43275)
-- Dependencies: 11
-- Name: node_pk_seq; Type: SEQUENCE; Schema: source; Owner: entangled_bank_user
--

CREATE SEQUENCE node_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.node_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2759 (class 1259 OID 43277)
-- Dependencies: 11
-- Name: source_id_seq; Type: SEQUENCE; Schema: source; Owner: entangled_bank_user
--

CREATE SEQUENCE source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.source_id_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2760 (class 1259 OID 43279)
-- Dependencies: 3167 3168 11
-- Name: source; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source (
    source_id integer DEFAULT nextval('source_id_seq'::regclass) NOT NULL,
    name character varying(254) NOT NULL,
    term_id integer NOT NULL,
    schema character varying(30) NOT NULL,
    tablename character varying(50) NOT NULL,
    n integer,
    www character(254),
    active boolean DEFAULT true NOT NULL,
    code character(10),
    description character varying
);


ALTER TABLE source.source OWNER TO entangled_bank_user;

--
-- TOC entry 2761 (class 1259 OID 43287)
-- Dependencies: 3169 11
-- Name: source_edge; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_edge (
    edge_id integer DEFAULT nextval('edge_pk_seq'::regclass) NOT NULL,
    child_node_id integer NOT NULL,
    parent_node_id integer NOT NULL
);


ALTER TABLE source.source_edge OWNER TO entangled_bank_user;

--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 2761
-- Name: TABLE source_edge; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_edge IS 'An edge between two nodes in a tree (or graph).';


--
-- TOC entry 3929 (class 0 OID 0)
-- Dependencies: 2761
-- Name: COLUMN source_edge.child_node_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_edge.child_node_id IS 'The endpoint node of the two nodes connected by a directed edge. In a phylogenetic tree, this is the descendant.';


--
-- TOC entry 3930 (class 0 OID 0)
-- Dependencies: 2761
-- Name: COLUMN source_edge.parent_node_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_edge.parent_node_id IS 'The startpoint node of the two nodes connected by a directed edge. In a phylogenetic tree, this is the ancestor.';


--
-- TOC entry 2762 (class 1259 OID 43291)
-- Dependencies: 3170 11
-- Name: source_edge_qualifier_value; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_edge_qualifier_value (
    value text,
    rank integer DEFAULT 0 NOT NULL,
    edge_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE source.source_edge_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 3931 (class 0 OID 0)
-- Dependencies: 2762
-- Name: TABLE source_edge_qualifier_value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_edge_qualifier_value IS 'Edge metadata as attribute/value pairs. Attribute names are from a controlled vocabulary (or ontology).';


--
-- TOC entry 3932 (class 0 OID 0)
-- Dependencies: 2762
-- Name: COLUMN source_edge_qualifier_value.value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_edge_qualifier_value.value IS 'The value of the attribute/value pair association of metadata (if applicable).';


--
-- TOC entry 3933 (class 0 OID 0)
-- Dependencies: 2762
-- Name: COLUMN source_edge_qualifier_value.rank; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_edge_qualifier_value.rank IS 'The index of the metadata value if there is more than one value for the same metadata element. If there is only one value, this may be left at the default of zero.';


--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 2762
-- Name: COLUMN source_edge_qualifier_value.edge_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_edge_qualifier_value.edge_id IS 'The tree edge to which the metadata is being associated.';


--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 2762
-- Name: COLUMN source_edge_qualifier_value.term_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_edge_qualifier_value.term_id IS 'The name of the metadate element as a term from a controlled vocabulary (or ontology).';


--
-- TOC entry 2763 (class 1259 OID 43298)
-- Dependencies: 11
-- Name: source_fieldcodes; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_fieldcodes (
    item integer NOT NULL,
    name character varying(100) NOT NULL,
    field_id integer,
    code_id integer NOT NULL
);


ALTER TABLE source.source_fieldcodes OWNER TO entangled_bank_user;

--
-- TOC entry 2764 (class 1259 OID 43301)
-- Dependencies: 11
-- Name: source_fieldcodes_code_id_seq; Type: SEQUENCE; Schema: source; Owner: postgres
--

CREATE SEQUENCE source_fieldcodes_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.source_fieldcodes_code_id_seq OWNER TO postgres;

--
-- TOC entry 2765 (class 1259 OID 43303)
-- Dependencies: 11
-- Name: source_fields_field_id_seq; Type: SEQUENCE; Schema: source; Owner: postgres
--

CREATE SEQUENCE source_fields_field_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.source_fields_field_id_seq OWNER TO postgres;

--
-- TOC entry 2766 (class 1259 OID 43305)
-- Dependencies: 3171 11
-- Name: source_fields; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_fields (
    field_name character varying(100) NOT NULL,
    field_description character varying(1000) NOT NULL,
    source_id integer,
    field_id integer DEFAULT nextval('source_fields_field_id_seq'::regclass) NOT NULL,
    rank integer,
    term_id integer,
    lookup_id integer,
    field_alias character varying(30)
);


ALTER TABLE source.source_fields OWNER TO entangled_bank_user;

--
-- TOC entry 2767 (class 1259 OID 43312)
-- Dependencies: 11
-- Name: sourcejoin_id_seq; Type: SEQUENCE; Schema: source; Owner: entangled_bank_user
--

CREATE SEQUENCE sourcejoin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.sourcejoin_id_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2768 (class 1259 OID 43314)
-- Dependencies: 3172 11
-- Name: source_join; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_join (
    sourcejoin_id integer DEFAULT nextval('sourcejoin_id_seq'::regclass) NOT NULL,
    source_id integer NOT NULL,
    link_id integer NOT NULL,
    join_id integer NOT NULL,
    stats_id integer
);


ALTER TABLE source.source_join OWNER TO entangled_bank_user;

--
-- TOC entry 2769 (class 1259 OID 43318)
-- Dependencies: 11
-- Name: source_join_id_seq; Type: SEQUENCE; Schema: source; Owner: entangled_bank_user
--

CREATE SEQUENCE source_join_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.source_join_id_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2770 (class 1259 OID 43320)
-- Dependencies: 11
-- Name: source_lookup_table; Type: TABLE; Schema: source; Owner: postgres; Tablespace: 
--

CREATE TABLE source_lookup_table (
    source_field_lookup_id integer NOT NULL,
    source_id integer NOT NULL,
    lookup_id integer NOT NULL,
    source_field text NOT NULL,
    lookup_field text NOT NULL
);


ALTER TABLE source.source_lookup_table OWNER TO postgres;

--
-- TOC entry 2771 (class 1259 OID 43326)
-- Dependencies: 3173 11
-- Name: source_node; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_node (
    node_id integer DEFAULT nextval('node_pk_seq'::regclass) NOT NULL,
    label character varying(255),
    tree_id integer NOT NULL,
    left_idx integer,
    right_idx integer
);


ALTER TABLE source.source_node OWNER TO entangled_bank_user;

--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 2771
-- Name: TABLE source_node; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_node IS 'A node in a tree. Typically, this will be a node in a phylogenetic tree, resembling either a nucleotide or protein sequence, or a taxon, or more generally an ''operational taxonomic unit'' (OTU).';


--
-- TOC entry 3937 (class 0 OID 0)
-- Dependencies: 2771
-- Name: COLUMN source_node.label; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node.label IS 'The label of a node. This may the latin binomial of the taxon, the accession number of a sequences, or any other construct that uniquely identifies the node within one tree.';


--
-- TOC entry 3938 (class 0 OID 0)
-- Dependencies: 2771
-- Name: COLUMN source_node.tree_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node.tree_id IS 'The tree of which this node is a part of.';


--
-- TOC entry 3939 (class 0 OID 0)
-- Dependencies: 2771
-- Name: COLUMN source_node.left_idx; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node.left_idx IS 'The left value of the nested set optimization structure for efficient hierarchical queries. Needs to be precomputed by a program, see J. Celko, SQL for Smarties.';


--
-- TOC entry 3940 (class 0 OID 0)
-- Dependencies: 2771
-- Name: COLUMN source_node.right_idx; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node.right_idx IS 'The right value of the nested set optimization structure for efficient hierarchical queries. Needs to be precomputed by a program, see J. Celko, SQL for Smarties.';


--
-- TOC entry 2772 (class 1259 OID 43330)
-- Dependencies: 11
-- Name: source_node_path; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_node_path (
    child_node_id integer NOT NULL,
    parent_node_id integer NOT NULL,
    path text,
    distance integer NOT NULL
);


ALTER TABLE source.source_node_path OWNER TO entangled_bank_user;

--
-- TOC entry 3941 (class 0 OID 0)
-- Dependencies: 2772
-- Name: TABLE source_node_path; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_node_path IS 'An path between two nodes in a tree (or graph). Two nodes A and B are connected by a (directed) path if B can be reached from A by following nodes that are connected by (directed) edges.';


--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 2772
-- Name: COLUMN source_node_path.child_node_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_path.child_node_id IS 'The endpoint node of the two nodes connected by a (directed) path. In a phylogenetic tree, this is the descendant.';


--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 2772
-- Name: COLUMN source_node_path.parent_node_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_path.parent_node_id IS 'The startpoint node of the two nodes connected by a (directed) path. In a phylogenetic tree, this is the ancestor.';


--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 2772
-- Name: COLUMN source_node_path.path; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_path.path IS 'The path from startpoint to endpoint as the series of nodes visited along the path. The nodes may be identified by label, or, typically more efficient, by their primary key, or left or right value. The latter or often smaller than the primary key, and hence consume less space. One may increase efficiency further by using a base-34 numeric representation (24 letters of the alphabet, plus 10 digits) instead of decimal (base-10) representation. The actual method used is not important, though it should be used consistently.';


--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 2772
-- Name: COLUMN source_node_path.distance; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_path.distance IS 'The distance (or length) of the path. The path between a node and itself has length zero, and length 1 between two nodes directly connected by an edge. If there is a path of length l between two nodes A and Z and an edge between Z and B, there is a path of length l+1 between nodes A and B.';


--
-- TOC entry 2773 (class 1259 OID 43336)
-- Dependencies: 3174 11
-- Name: source_node_qualifier_value; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_node_qualifier_value (
    value text,
    rank integer DEFAULT 0 NOT NULL,
    node_id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE source.source_node_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 2773
-- Name: TABLE source_node_qualifier_value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_node_qualifier_value IS 'Tree (or network) node metadata as attribute/value pairs. Attribute names are from a controlled vocabulary (or ontology).';


--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 2773
-- Name: COLUMN source_node_qualifier_value.value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_qualifier_value.value IS 'The value of the attribute/value pair association of metadata (if applicable).';


--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 2773
-- Name: COLUMN source_node_qualifier_value.rank; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_qualifier_value.rank IS 'The index of the metadata value if there is more than one value for the same metadata element. If there is only one value, this may be left at the default of zero.';


--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 2773
-- Name: COLUMN source_node_qualifier_value.node_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_qualifier_value.node_id IS 'The tree (or network) node to which the metadata is being associated.';


--
-- TOC entry 3950 (class 0 OID 0)
-- Dependencies: 2773
-- Name: COLUMN source_node_qualifier_value.term_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_node_qualifier_value.term_id IS 'The name of the metadate element as a term from a controlled vocabulary (or ontology).';


--
-- TOC entry 2774 (class 1259 OID 43343)
-- Dependencies: 3175 11
-- Name: source_qualifier_value; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_qualifier_value (
    source_id integer NOT NULL,
    term_id integer NOT NULL,
    value text NOT NULL,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE source.source_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 3951 (class 0 OID 0)
-- Dependencies: 2774
-- Name: TABLE source_qualifier_value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_qualifier_value IS 'Source metadata as attribute/value pairs. Attribute names are from a controlled vocabulary (or ontology).';


--
-- TOC entry 3952 (class 0 OID 0)
-- Dependencies: 2774
-- Name: COLUMN source_qualifier_value.source_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_qualifier_value.source_id IS 'The source with which the metadata is being associated.';


--
-- TOC entry 3953 (class 0 OID 0)
-- Dependencies: 2774
-- Name: COLUMN source_qualifier_value.term_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_qualifier_value.term_id IS 'The name of the metadate element as a term from a controlled vocabulary (or ontology).';


--
-- TOC entry 3954 (class 0 OID 0)
-- Dependencies: 2774
-- Name: COLUMN source_qualifier_value.value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_qualifier_value.value IS 'The value of the metadata element.';


--
-- TOC entry 3955 (class 0 OID 0)
-- Dependencies: 2774
-- Name: COLUMN source_qualifier_value.rank; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_qualifier_value.rank IS 'The index of the metadata value if there is more than one value for the same metadata element. If there is only one value, this may be left at the default of zero.';


--
-- TOC entry 2775 (class 1259 OID 43350)
-- Dependencies: 11
-- Name: tree_pk_seq; Type: SEQUENCE; Schema: source; Owner: entangled_bank_user
--

CREATE SEQUENCE tree_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.tree_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2776 (class 1259 OID 43352)
-- Dependencies: 3176 3177 11
-- Name: source_tree; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_tree (
    tree_id integer DEFAULT nextval('tree_pk_seq'::regclass) NOT NULL,
    name character varying(32) NOT NULL,
    identifier character varying(32),
    is_rooted boolean DEFAULT true,
    node_id integer NOT NULL,
    biodatabase_id integer NOT NULL
);


ALTER TABLE source.source_tree OWNER TO entangled_bank_user;

--
-- TOC entry 3956 (class 0 OID 0)
-- Dependencies: 2776
-- Name: TABLE source_tree; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_tree IS 'A tree basically is a namespace for nodes, and thereby implicitly for their relationships (edges). In this model, tree is also bit of misnomer because we try to support reticulating trees, i.e., networks, too, so arguably it should be called graph. Typically, this will be used for storing phylogenetic trees, sequence trees (a.k.a. gene trees) as much as species trees.';


--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN source_tree.name; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree.name IS 'The name of the tree, in essence a label.';


--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN source_tree.identifier; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree.identifier IS 'The identifier of the tree, if there is one.';


--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN source_tree.is_rooted; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree.is_rooted IS 'Whether or not the tree is rooted. By default, a tree is assumed to be rooted.';


--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN source_tree.node_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree.node_id IS 'The starting node of the tree. If the tree is rooted, this will usually be the root node. Note that the root node(s) of a rooted tree must be stored in tree_root, too.';


--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN source_tree.biodatabase_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree.biodatabase_id IS 'The namespace of the tree itself. Though trees are in a sense named containers themselves (namely for nodes), they also constitute (possibly identifiable!) data objects in their own right. Some data sources may only provide a single tree, so that assigning a namespace for the tree may seem excessive, but others, such as TreeBASE, contain many trees, just as sequence databanks contain many sequences. The choice of how to name a tree is up to the user; one may assign a default namespace (such as "biosql"), or create one named the same as the tree.';


--
-- TOC entry 2777 (class 1259 OID 43357)
-- Dependencies: 3178 11
-- Name: source_tree_qualifier_value; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_tree_qualifier_value (
    tree_id integer NOT NULL,
    term_id integer NOT NULL,
    value text,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE source.source_tree_qualifier_value OWNER TO entangled_bank_user;

--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 2777
-- Name: TABLE source_tree_qualifier_value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_tree_qualifier_value IS 'Tree metadata as attribute/value pairs. Attribute names are from a controlled vocabulary (or ontology).';


--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 2777
-- Name: COLUMN source_tree_qualifier_value.tree_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_qualifier_value.tree_id IS 'The tree with which the metadata is being associated.';


--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 2777
-- Name: COLUMN source_tree_qualifier_value.term_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_qualifier_value.term_id IS 'The name of the metadate element as a term from a controlled vocabulary (or ontology).';


--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 2777
-- Name: COLUMN source_tree_qualifier_value.value; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_qualifier_value.value IS 'The value of the metadata element.';


--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 2777
-- Name: COLUMN source_tree_qualifier_value.rank; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_qualifier_value.rank IS 'The index of the metadata value if there is more than one value for the same metadata element. If there is only one value, this may be left at the default of zero.';


--
-- TOC entry 2778 (class 1259 OID 43364)
-- Dependencies: 11
-- Name: tree_root_pk_seq; Type: SEQUENCE; Schema: source; Owner: entangled_bank_user
--

CREATE SEQUENCE tree_root_pk_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE source.tree_root_pk_seq OWNER TO entangled_bank_user;

--
-- TOC entry 2779 (class 1259 OID 43366)
-- Dependencies: 3179 3180 11
-- Name: source_tree_root; Type: TABLE; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE source_tree_root (
    tree_root_id integer DEFAULT nextval('tree_root_pk_seq'::regclass) NOT NULL,
    tree_id integer NOT NULL,
    node_id integer NOT NULL,
    is_alternate boolean DEFAULT false,
    significance real
);


ALTER TABLE source.source_tree_root OWNER TO entangled_bank_user;

--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 2779
-- Name: TABLE source_tree_root; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON TABLE source_tree_root IS 'Root node for a rooted tree. A phylogenetic analysis might suggest several alternative root nodes, with possible probabilities.';


--
-- TOC entry 3968 (class 0 OID 0)
-- Dependencies: 2779
-- Name: COLUMN source_tree_root.tree_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_root.tree_id IS 'The tree for which the referenced node is a root node.';


--
-- TOC entry 3969 (class 0 OID 0)
-- Dependencies: 2779
-- Name: COLUMN source_tree_root.node_id; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_root.node_id IS 'The node that is a root for the referenced tree.';


--
-- TOC entry 3970 (class 0 OID 0)
-- Dependencies: 2779
-- Name: COLUMN source_tree_root.is_alternate; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_root.is_alternate IS 'True if the root node is the preferential (most likely) root node of the tree, and false otherwise.';


--
-- TOC entry 3971 (class 0 OID 0)
-- Dependencies: 2779
-- Name: COLUMN source_tree_root.significance; Type: COMMENT; Schema: source; Owner: entangled_bank_user
--

COMMENT ON COLUMN source_tree_root.significance IS 'The significance (such as likelihood, or posterior probability) with which the node is the root node. This only has meaning if the method used for reconstructing the tree calculates this value.';


SET search_path = worldclim, pg_catalog;

--
-- TOC entry 2780 (class 1259 OID 43371)
-- Dependencies: 12
-- Name: worldclim_10mins; Type: TABLE; Schema: worldclim; Owner: entangled_bank_user; Tablespace: 
--

CREATE TABLE worldclim_10mins (
    "point_X" numeric NOT NULL,
    "point_Y" numeric NOT NULL,
    bio_1 integer NOT NULL,
    bio_2 numeric NOT NULL,
    bio_3 numeric NOT NULL,
    bio_4 numeric NOT NULL,
    bio_5 numeric NOT NULL,
    bio_6 numeric NOT NULL,
    bio_7 numeric NOT NULL,
    bio_8 numeric NOT NULL,
    bio_9 numeric NOT NULL,
    bio_10 numeric NOT NULL,
    bio_11 numeric NOT NULL,
    bio_12 numeric NOT NULL,
    bio_13 numeric NOT NULL,
    bio_14 numeric NOT NULL,
    bio_15 numeric NOT NULL,
    bio_16 numeric NOT NULL,
    bio_17 numeric NOT NULL,
    bio_18 numeric NOT NULL,
    bio_19 numeric NOT NULL,
    pointid integer NOT NULL,
    tmin_1 integer,
    tmin_2 integer,
    tmin_3 integer,
    tmin_4 integer,
    tmin_5 integer,
    tmin_6 integer,
    tmin_7 integer,
    tmin_8 integer,
    tmin_9 integer,
    tmin_10 integer,
    tmin_11 integer,
    tmin_12 integer,
    tmax_1 integer,
    tmax_2 integer,
    tmax_3 integer,
    tmax_4 integer,
    tmax_5 integer,
    tmax_6 integer,
    tmax_7 integer,
    tmax_8 integer,
    tmax_9 integer,
    tmax_10 integer,
    tmax_11 integer,
    tmax_12 integer,
    tmean_1 integer,
    tmean_2 integer,
    tmean_3 integer,
    tmean_4 integer,
    tmean_5 integer,
    tmean_6 integer,
    tmean_7 integer,
    tmean_8 integer,
    tmean_9 integer,
    tmean_10 integer,
    tmean_11 integer,
    tmean_12 integer,
    prec_1 integer,
    prec_2 integer,
    prec_3 integer,
    prec_4 integer,
    prec_5 integer,
    prec_6 integer,
    prec_7 integer,
    prec_8 integer,
    prec_9 integer,
    prec_10 integer,
    prec_11 integer,
    prec_12 integer,
    alt integer
);


ALTER TABLE worldclim.worldclim_10mins OWNER TO entangled_bank_user;

--
-- TOC entry 2781 (class 1259 OID 43377)
-- Dependencies: 2780 12
-- Name: worldclim_10mins_pointid_seq; Type: SEQUENCE; Schema: worldclim; Owner: entangled_bank_user
--

CREATE SEQUENCE worldclim_10mins_pointid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE worldclim.worldclim_10mins_pointid_seq OWNER TO entangled_bank_user;

--
-- TOC entry 3972 (class 0 OID 0)
-- Dependencies: 2781
-- Name: worldclim_10mins_pointid_seq; Type: SEQUENCE OWNED BY; Schema: worldclim; Owner: entangled_bank_user
--

ALTER SEQUENCE worldclim_10mins_pointid_seq OWNED BY worldclim_10mins.pointid;


SET search_path = biosql, pg_catalog;

--
-- TOC entry 3139 (class 2604 OID 43379)
-- Dependencies: 2715 2714
-- Name: TaxonID; Type: DEFAULT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE taxon_table ALTER COLUMN "TaxonID" SET DEFAULT nextval('"taxon_table_TaxonID_seq"'::regclass);


SET search_path = gpdd, pg_catalog;

--
-- TOC entry 3149 (class 2604 OID 43380)
-- Dependencies: 2740 2739
-- Name: gid; Type: DEFAULT; Schema: gpdd; Owner: entangled_bank_user
--

ALTER TABLE location_bbox ALTER COLUMN gid SET DEFAULT nextval('location_bbox_gid_seq'::regclass);


--
-- TOC entry 3150 (class 2604 OID 43381)
-- Dependencies: 2742 2741
-- Name: gid; Type: DEFAULT; Schema: gpdd; Owner: entangled_bank_user
--

ALTER TABLE location_pt ALTER COLUMN gid SET DEFAULT nextval('location_pt_gid_seq'::regclass);


SET search_path = msw05, pg_catalog;

--
-- TOC entry 3151 (class 2604 OID 43382)
-- Dependencies: 2744 2743
-- Name: gid; Type: DEFAULT; Schema: msw05; Owner: entangled_bank_user
--

ALTER TABLE behrmann ALTER COLUMN gid SET DEFAULT nextval('"Behrmann_a_d_gid_seq"'::regclass);


--
-- TOC entry 3162 (class 2604 OID 43383)
-- Dependencies: 2752 2750
-- Name: gid; Type: DEFAULT; Schema: msw05; Owner: postgres
--

ALTER TABLE msw05_geographic ALTER COLUMN gid SET DEFAULT nextval('msw05_geographic_geog_gid_seq'::regclass);


--
-- TOC entry 3163 (class 2604 OID 43384)
-- Dependencies: 2753 2751
-- Name: gid; Type: DEFAULT; Schema: msw05; Owner: postgres
--

ALTER TABLE msw05_geographic_1deg ALTER COLUMN gid SET DEFAULT nextval('msw05_geographic_gridded_gid_seq'::regclass);


--
-- TOC entry 3148 (class 2604 OID 43385)
-- Dependencies: 2756 2731
-- Name: pantheria_05id; Type: DEFAULT; Schema: msw05; Owner: entangled_bank_user
--

ALTER TABLE msw05_pantheria ALTER COLUMN pantheria_05id SET DEFAULT nextval('pantheria_05_pantheria_05id_seq'::regclass);


SET search_path = worldclim, pg_catalog;

--
-- TOC entry 3181 (class 2604 OID 43386)
-- Dependencies: 2781 2780
-- Name: pointid; Type: DEFAULT; Schema: worldclim; Owner: entangled_bank_user
--

ALTER TABLE worldclim_10mins ALTER COLUMN pointid SET DEFAULT nextval('worldclim_10mins_pointid_seq'::regclass);


SET search_path = biosql, pg_catalog;

--
-- TOC entry 3187 (class 2606 OID 57321)
-- Dependencies: 2670 2670
-- Name: biodatabase_name_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY biodatabase
    ADD CONSTRAINT biodatabase_name_key UNIQUE (name);


--
-- TOC entry 3189 (class 2606 OID 57324)
-- Dependencies: 2670 2670
-- Name: biodatabase_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY biodatabase
    ADD CONSTRAINT biodatabase_pkey PRIMARY KEY (biodatabase_id);


--
-- TOC entry 3192 (class 2606 OID 57326)
-- Dependencies: 2672 2672 2672 2672
-- Name: bioentry_accession_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry
    ADD CONSTRAINT bioentry_accession_key UNIQUE (accession, biodatabase_id, version);


--
-- TOC entry 3201 (class 2606 OID 57328)
-- Dependencies: 2673 2673 2673
-- Name: bioentry_dbxref_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry_dbxref
    ADD CONSTRAINT bioentry_dbxref_pkey PRIMARY KEY (bioentry_id, dbxref_id);


--
-- TOC entry 3195 (class 2606 OID 57330)
-- Dependencies: 2672 2672 2672
-- Name: bioentry_identifier_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry
    ADD CONSTRAINT bioentry_identifier_key UNIQUE (identifier, biodatabase_id);


--
-- TOC entry 3204 (class 2606 OID 57332)
-- Dependencies: 2674 2674 2674 2674 2674
-- Name: bioentry_path_object_bioentry_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry_path
    ADD CONSTRAINT bioentry_path_object_bioentry_id_key UNIQUE (object_bioentry_id, subject_bioentry_id, term_id, distance);


--
-- TOC entry 3198 (class 2606 OID 57334)
-- Dependencies: 2672 2672
-- Name: bioentry_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry
    ADD CONSTRAINT bioentry_pkey PRIMARY KEY (bioentry_id);


--
-- TOC entry 3208 (class 2606 OID 57336)
-- Dependencies: 2675 2675 2675 2675
-- Name: bioentry_qualifier_value_bioentry_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry_qualifier_value
    ADD CONSTRAINT bioentry_qualifier_value_bioentry_id_key UNIQUE (bioentry_id, term_id, rank);


--
-- TOC entry 3211 (class 2606 OID 57338)
-- Dependencies: 2676 2676 2676 2676
-- Name: bioentry_reference_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry_reference
    ADD CONSTRAINT bioentry_reference_pkey PRIMARY KEY (bioentry_id, reference_id, rank);


--
-- TOC entry 3214 (class 2606 OID 57340)
-- Dependencies: 2678 2678 2678 2678
-- Name: bioentry_relationship_object_bioentry_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry_relationship
    ADD CONSTRAINT bioentry_relationship_object_bioentry_id_key UNIQUE (object_bioentry_id, subject_bioentry_id, term_id);


--
-- TOC entry 3216 (class 2606 OID 57342)
-- Dependencies: 2678 2678
-- Name: bioentry_relationship_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY bioentry_relationship
    ADD CONSTRAINT bioentry_relationship_pkey PRIMARY KEY (bioentry_relationship_id);


--
-- TOC entry 3220 (class 2606 OID 57344)
-- Dependencies: 2679 2679
-- Name: biosequence_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY biosequence
    ADD CONSTRAINT biosequence_pkey PRIMARY KEY (bioentry_id);


--
-- TOC entry 3222 (class 2606 OID 57346)
-- Dependencies: 2681 2681 2681
-- Name: comment_bioentry_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_bioentry_id_key UNIQUE (bioentry_id, rank);


--
-- TOC entry 3224 (class 2606 OID 57348)
-- Dependencies: 2681 2681
-- Name: comment_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3226 (class 2606 OID 57350)
-- Dependencies: 2683 2683 2683 2683
-- Name: dbxref_accession_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY dbxref
    ADD CONSTRAINT dbxref_accession_key UNIQUE (accession, dbname, version);


--
-- TOC entry 3229 (class 2606 OID 57352)
-- Dependencies: 2683 2683
-- Name: dbxref_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY dbxref
    ADD CONSTRAINT dbxref_pkey PRIMARY KEY (dbxref_id);


--
-- TOC entry 3231 (class 2606 OID 57354)
-- Dependencies: 2684 2684 2684 2684
-- Name: dbxref_qualifier_value_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY dbxref_qualifier_value
    ADD CONSTRAINT dbxref_qualifier_value_pkey PRIMARY KEY (dbxref_id, term_id, rank);


--
-- TOC entry 3235 (class 2606 OID 57356)
-- Dependencies: 2686 2686 2686
-- Name: edge_child_node_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY edge
    ADD CONSTRAINT edge_child_node_id_key UNIQUE (child_node_id, parent_node_id);


--
-- TOC entry 3238 (class 2606 OID 57358)
-- Dependencies: 2686 2686
-- Name: edge_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY edge
    ADD CONSTRAINT edge_pkey PRIMARY KEY (edge_id);


--
-- TOC entry 3240 (class 2606 OID 57360)
-- Dependencies: 2687 2687 2687 2687
-- Name: edge_qualifier_value_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY edge_qualifier_value
    ADD CONSTRAINT edge_qualifier_value_pkey PRIMARY KEY (edge_id, term_id, rank);


--
-- TOC entry 3242 (class 2606 OID 57362)
-- Dependencies: 2689 2689
-- Name: location_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);


--
-- TOC entry 3249 (class 2606 OID 57364)
-- Dependencies: 2690 2690 2690
-- Name: location_qualifier_value_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY location_qualifier_value
    ADD CONSTRAINT location_qualifier_value_pkey PRIMARY KEY (location_id, term_id);


--
-- TOC entry 3244 (class 2606 OID 57366)
-- Dependencies: 2689 2689 2689
-- Name: location_seqfeature_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_seqfeature_id_key UNIQUE (seqfeature_id, rank);


--
-- TOC entry 3260 (class 2606 OID 57368)
-- Dependencies: 2694 2694 2694 2694
-- Name: node_bioentry_node_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node_bioentry
    ADD CONSTRAINT node_bioentry_node_id_key UNIQUE (node_id, bioentry_id, rank);


--
-- TOC entry 3262 (class 2606 OID 57370)
-- Dependencies: 2694 2694
-- Name: node_bioentry_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node_bioentry
    ADD CONSTRAINT node_bioentry_pkey PRIMARY KEY (node_bioentry_id);


--
-- TOC entry 3265 (class 2606 OID 57372)
-- Dependencies: 2695 2695 2695 2695
-- Name: node_dbxref_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node_dbxref
    ADD CONSTRAINT node_dbxref_pkey PRIMARY KEY (node_id, dbxref_id, term_id);


--
-- TOC entry 3254 (class 2606 OID 57374)
-- Dependencies: 2692 2692 2692
-- Name: node_left_idx_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_left_idx_key UNIQUE (left_idx, tree_id);


--
-- TOC entry 3268 (class 2606 OID 57376)
-- Dependencies: 2696 2696 2696 2696
-- Name: node_path_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node_path
    ADD CONSTRAINT node_path_pkey PRIMARY KEY (child_node_id, parent_node_id, distance);


--
-- TOC entry 3256 (class 2606 OID 57378)
-- Dependencies: 2692 2692
-- Name: node_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_pkey PRIMARY KEY (node_id);


--
-- TOC entry 3270 (class 2606 OID 57380)
-- Dependencies: 2697 2697 2697
-- Name: node_qualifier_value_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node_qualifier_value
    ADD CONSTRAINT node_qualifier_value_pkey PRIMARY KEY (node_id, term_id);


--
-- TOC entry 3258 (class 2606 OID 57382)
-- Dependencies: 2692 2692 2692
-- Name: node_right_idx_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_right_idx_key UNIQUE (right_idx, tree_id);


--
-- TOC entry 3272 (class 2606 OID 57384)
-- Dependencies: 2699 2699 2699 2699
-- Name: node_taxon_node_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node_taxon
    ADD CONSTRAINT node_taxon_node_id_key UNIQUE (node_id, taxon_id, rank);


--
-- TOC entry 3274 (class 2606 OID 57386)
-- Dependencies: 2699 2699
-- Name: node_taxon_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY node_taxon
    ADD CONSTRAINT node_taxon_pkey PRIMARY KEY (node_taxon_id);


--
-- TOC entry 3276 (class 2606 OID 57388)
-- Dependencies: 2701 2701
-- Name: ontology_name_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY ontology
    ADD CONSTRAINT ontology_name_key UNIQUE (name);


--
-- TOC entry 3278 (class 2606 OID 57390)
-- Dependencies: 2701 2701
-- Name: ontology_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY ontology
    ADD CONSTRAINT ontology_pkey PRIMARY KEY (ontology_id);


--
-- TOC entry 3280 (class 2606 OID 57392)
-- Dependencies: 2703 2703
-- Name: reference_crc_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY reference
    ADD CONSTRAINT reference_crc_key UNIQUE (crc);


--
-- TOC entry 3282 (class 2606 OID 57394)
-- Dependencies: 2703 2703
-- Name: reference_dbxref_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY reference
    ADD CONSTRAINT reference_dbxref_id_key UNIQUE (dbxref_id);


--
-- TOC entry 3284 (class 2606 OID 57396)
-- Dependencies: 2703 2703
-- Name: reference_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY reference
    ADD CONSTRAINT reference_pkey PRIMARY KEY (reference_id);


--
-- TOC entry 3286 (class 2606 OID 57398)
-- Dependencies: 2705 2705 2705 2705 2705
-- Name: seqfeature_bioentry_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY seqfeature
    ADD CONSTRAINT seqfeature_bioentry_id_key UNIQUE (bioentry_id, type_term_id, source_term_id, rank);


--
-- TOC entry 3293 (class 2606 OID 57400)
-- Dependencies: 2706 2706 2706
-- Name: seqfeature_dbxref_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY seqfeature_dbxref
    ADD CONSTRAINT seqfeature_dbxref_pkey PRIMARY KEY (seqfeature_id, dbxref_id);


--
-- TOC entry 3295 (class 2606 OID 57402)
-- Dependencies: 2707 2707 2707 2707 2707
-- Name: seqfeature_path_object_seqfeature_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY seqfeature_path
    ADD CONSTRAINT seqfeature_path_object_seqfeature_id_key UNIQUE (object_seqfeature_id, subject_seqfeature_id, term_id, distance);


--
-- TOC entry 3289 (class 2606 OID 57404)
-- Dependencies: 2705 2705
-- Name: seqfeature_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY seqfeature
    ADD CONSTRAINT seqfeature_pkey PRIMARY KEY (seqfeature_id);


--
-- TOC entry 3299 (class 2606 OID 57406)
-- Dependencies: 2708 2708 2708 2708
-- Name: seqfeature_qualifier_value_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY seqfeature_qualifier_value
    ADD CONSTRAINT seqfeature_qualifier_value_pkey PRIMARY KEY (seqfeature_id, term_id, rank);


--
-- TOC entry 3302 (class 2606 OID 57408)
-- Dependencies: 2710 2710 2710 2710
-- Name: seqfeature_relationship_object_seqfeature_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY seqfeature_relationship
    ADD CONSTRAINT seqfeature_relationship_object_seqfeature_id_key UNIQUE (object_seqfeature_id, subject_seqfeature_id, term_id);


--
-- TOC entry 3304 (class 2606 OID 57410)
-- Dependencies: 2710 2710
-- Name: seqfeature_relationship_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY seqfeature_relationship
    ADD CONSTRAINT seqfeature_relationship_pkey PRIMARY KEY (seqfeature_relationship_id);


--
-- TOC entry 3319 (class 2606 OID 57412)
-- Dependencies: 2713 2713 2713 2713
-- Name: taxon_name_name_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY taxon_name
    ADD CONSTRAINT taxon_name_name_key UNIQUE (name, name_class, taxon_id);


--
-- TOC entry 3308 (class 2606 OID 57414)
-- Dependencies: 2712 2712
-- Name: taxon_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY taxon
    ADD CONSTRAINT taxon_pkey PRIMARY KEY (taxon_id);


--
-- TOC entry 3321 (class 2606 OID 57417)
-- Dependencies: 2714 2714
-- Name: taxon_table_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY taxon_table
    ADD CONSTRAINT taxon_table_pkey PRIMARY KEY ("TaxonID");


--
-- TOC entry 3330 (class 2606 OID 57419)
-- Dependencies: 2718 2718 2718
-- Name: term_dbxref_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_dbxref
    ADD CONSTRAINT term_dbxref_pkey PRIMARY KEY (term_id, dbxref_id);


--
-- TOC entry 3323 (class 2606 OID 57421)
-- Dependencies: 2717 2717
-- Name: term_identifier_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term
    ADD CONSTRAINT term_identifier_key UNIQUE (identifier);


--
-- TOC entry 3325 (class 2606 OID 57423)
-- Dependencies: 2717 2717 2717 2717
-- Name: term_name_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term
    ADD CONSTRAINT term_name_key UNIQUE (name, ontology_id, is_obsolete);


--
-- TOC entry 3333 (class 2606 OID 57425)
-- Dependencies: 2720 2720
-- Name: term_path_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_path
    ADD CONSTRAINT term_path_pkey PRIMARY KEY (term_path_id);


--
-- TOC entry 3335 (class 2606 OID 57427)
-- Dependencies: 2720 2720 2720 2720 2720 2720
-- Name: term_path_subject_term_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_path
    ADD CONSTRAINT term_path_subject_term_id_key UNIQUE (subject_term_id, predicate_term_id, object_term_id, ontology_id, distance);


--
-- TOC entry 3328 (class 2606 OID 57429)
-- Dependencies: 2717 2717
-- Name: term_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term
    ADD CONSTRAINT term_pkey PRIMARY KEY (term_id);


--
-- TOC entry 3340 (class 2606 OID 57431)
-- Dependencies: 2722 2722
-- Name: term_relationship_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_relationship
    ADD CONSTRAINT term_relationship_pkey PRIMARY KEY (term_relationship_id);


--
-- TOC entry 3342 (class 2606 OID 57433)
-- Dependencies: 2722 2722 2722 2722 2722
-- Name: term_relationship_subject_term_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_relationship
    ADD CONSTRAINT term_relationship_subject_term_id_key UNIQUE (subject_term_id, predicate_term_id, object_term_id, ontology_id);


--
-- TOC entry 3347 (class 2606 OID 57435)
-- Dependencies: 2723 2723
-- Name: term_relationship_term_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_relationship_term
    ADD CONSTRAINT term_relationship_term_pkey PRIMARY KEY (term_relationship_id);


--
-- TOC entry 3349 (class 2606 OID 57437)
-- Dependencies: 2723 2723
-- Name: term_relationship_term_term_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_relationship_term
    ADD CONSTRAINT term_relationship_term_term_id_key UNIQUE (term_id);


--
-- TOC entry 3351 (class 2606 OID 57439)
-- Dependencies: 2724 2724 2724
-- Name: term_synonym_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY term_synonym
    ADD CONSTRAINT term_synonym_pkey PRIMARY KEY (term_id, synonym);


--
-- TOC entry 3353 (class 2606 OID 57441)
-- Dependencies: 2726 2726 2726
-- Name: tree_c1; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY tree
    ADD CONSTRAINT tree_c1 UNIQUE (name, biodatabase_id);


--
-- TOC entry 3358 (class 2606 OID 57443)
-- Dependencies: 2727 2727 2727 2727
-- Name: tree_dbxref_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY tree_dbxref
    ADD CONSTRAINT tree_dbxref_pkey PRIMARY KEY (tree_id, dbxref_id, term_id);


--
-- TOC entry 3355 (class 2606 OID 57445)
-- Dependencies: 2726 2726
-- Name: tree_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY tree
    ADD CONSTRAINT tree_pkey PRIMARY KEY (tree_id);


--
-- TOC entry 3360 (class 2606 OID 57447)
-- Dependencies: 2728 2728 2728 2728
-- Name: tree_qualifier_value_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY tree_qualifier_value
    ADD CONSTRAINT tree_qualifier_value_pkey PRIMARY KEY (tree_id, term_id, rank);


--
-- TOC entry 3362 (class 2606 OID 57449)
-- Dependencies: 2730 2730
-- Name: tree_root_pkey; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY tree_root
    ADD CONSTRAINT tree_root_pkey PRIMARY KEY (tree_root_id);


--
-- TOC entry 3364 (class 2606 OID 57451)
-- Dependencies: 2730 2730 2730
-- Name: tree_root_tree_id_key; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY tree_root
    ADD CONSTRAINT tree_root_tree_id_key UNIQUE (tree_id, node_id);


--
-- TOC entry 3311 (class 2606 OID 57453)
-- Dependencies: 2712 2712
-- Name: xaktaxon_left_value; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY taxon
    ADD CONSTRAINT xaktaxon_left_value UNIQUE (left_value);


--
-- TOC entry 3313 (class 2606 OID 57455)
-- Dependencies: 2712 2712
-- Name: xaktaxon_ncbi_taxon_id; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY taxon
    ADD CONSTRAINT xaktaxon_ncbi_taxon_id UNIQUE (ncbi_taxon_id);


--
-- TOC entry 3315 (class 2606 OID 57457)
-- Dependencies: 2712 2712
-- Name: xaktaxon_right_value; Type: CONSTRAINT; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY taxon
    ADD CONSTRAINT xaktaxon_right_value UNIQUE (right_value);


SET search_path = gpdd, pg_catalog;

--
-- TOC entry 3371 (class 2606 OID 57459)
-- Dependencies: 2739 2739
-- Name: location_bbox_pkey; Type: CONSTRAINT; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY location_bbox
    ADD CONSTRAINT location_bbox_pkey PRIMARY KEY (gid);


--
-- TOC entry 3374 (class 2606 OID 57461)
-- Dependencies: 2741 2741
-- Name: location_pt_pkey; Type: CONSTRAINT; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY location_pt
    ADD CONSTRAINT location_pt_pkey PRIMARY KEY (gid);


SET search_path = msw05, pg_catalog;

--
-- TOC entry 3376 (class 2606 OID 57463)
-- Dependencies: 2743 2743
-- Name: Behrmann_a_d_pkey; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY behrmann
    ADD CONSTRAINT "Behrmann_a_d_pkey" PRIMARY KEY (gid);


--
-- TOC entry 3378 (class 2606 OID 57465)
-- Dependencies: 2746 2746
-- Name: Mollweide_e_j_pkey; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY mollweide_e_j
    ADD CONSTRAINT "Mollweide_e_j_pkey" PRIMARY KEY (gid);


--
-- TOC entry 3380 (class 2606 OID 57467)
-- Dependencies: 2747 2747
-- Name: Mollweide_k_m_pkey; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY mollweide_k_m
    ADD CONSTRAINT "Mollweide_k_m_pkey" PRIMARY KEY (gid);


--
-- TOC entry 3382 (class 2606 OID 57469)
-- Dependencies: 2748 2748
-- Name: Mollweide_n_p_pkey; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY mollweide_n_p
    ADD CONSTRAINT "Mollweide_n_p_pkey" PRIMARY KEY (gid);


--
-- TOC entry 3384 (class 2606 OID 57471)
-- Dependencies: 2749 2749
-- Name: Mollweide_r_z_pkey; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY mollweide_r_z
    ADD CONSTRAINT "Mollweide_r_z_pkey" PRIMARY KEY (gid);


--
-- TOC entry 3387 (class 2606 OID 57473)
-- Dependencies: 2750 2750
-- Name: msw05_geographic_geog_pkey; Type: CONSTRAINT; Schema: msw05; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY msw05_geographic
    ADD CONSTRAINT msw05_geographic_geog_pkey PRIMARY KEY (gid);


--
-- TOC entry 3389 (class 2606 OID 57475)
-- Dependencies: 2751 2751
-- Name: msw05_geographic_gridded_pkey; Type: CONSTRAINT; Schema: msw05; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY msw05_geographic_1deg
    ADD CONSTRAINT msw05_geographic_gridded_pkey PRIMARY KEY (gid);


--
-- TOC entry 3393 (class 2606 OID 57477)
-- Dependencies: 2754 2754 2754
-- Name: msw05_geographic_worldclim_10mins_pkey; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY msw05_geographic_worldclim_10mins
    ADD CONSTRAINT msw05_geographic_worldclim_10mins_pkey PRIMARY KEY (pointid, msw05_binomial);


--
-- TOC entry 3366 (class 2606 OID 57479)
-- Dependencies: 2731 2731
-- Name: pantheria_05_msw05_binomial_key; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY msw05_pantheria
    ADD CONSTRAINT pantheria_05_msw05_binomial_key UNIQUE (msw05_binomial);


--
-- TOC entry 3368 (class 2606 OID 57481)
-- Dependencies: 2731 2731
-- Name: pantheria_05_pkey; Type: CONSTRAINT; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY msw05_pantheria
    ADD CONSTRAINT pantheria_05_pkey PRIMARY KEY (pantheria_05id);


SET search_path = public, pg_catalog;

--
-- TOC entry 3185 (class 2606 OID 21634)
-- Dependencies: 2666 2666 2666 2666 2666
-- Name: geometry_columns_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY geometry_columns
    ADD CONSTRAINT geometry_columns_pk PRIMARY KEY (f_table_catalog, f_table_schema, f_table_name, f_geometry_column);


--
-- TOC entry 3183 (class 2606 OID 21626)
-- Dependencies: 2665 2665
-- Name: spatial_ref_sys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatial_ref_sys
    ADD CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid);


SET search_path = source, pg_catalog;

--
-- TOC entry 3395 (class 2606 OID 57483)
-- Dependencies: 2760 2760
-- Name: data_object_name; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source
    ADD CONSTRAINT data_object_name UNIQUE (name);


--
-- TOC entry 3399 (class 2606 OID 57485)
-- Dependencies: 2761 2761 2761
-- Name: edge_child_node_id_key; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_edge
    ADD CONSTRAINT edge_child_node_id_key UNIQUE (child_node_id, parent_node_id);


--
-- TOC entry 3402 (class 2606 OID 57487)
-- Dependencies: 2761 2761
-- Name: edge_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_edge
    ADD CONSTRAINT edge_pkey PRIMARY KEY (edge_id);


--
-- TOC entry 3404 (class 2606 OID 57489)
-- Dependencies: 2762 2762 2762 2762
-- Name: edge_qualifier_value_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_edge_qualifier_value
    ADD CONSTRAINT edge_qualifier_value_pkey PRIMARY KEY (edge_id, term_id, rank);


--
-- TOC entry 3418 (class 2606 OID 57491)
-- Dependencies: 2771 2771 2771
-- Name: node_left_idx_key; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_node
    ADD CONSTRAINT node_left_idx_key UNIQUE (left_idx, tree_id);


--
-- TOC entry 3425 (class 2606 OID 57493)
-- Dependencies: 2772 2772 2772 2772
-- Name: node_path_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_node_path
    ADD CONSTRAINT node_path_pkey PRIMARY KEY (child_node_id, parent_node_id, distance);


--
-- TOC entry 3420 (class 2606 OID 57495)
-- Dependencies: 2771 2771
-- Name: node_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_node
    ADD CONSTRAINT node_pkey PRIMARY KEY (node_id);


--
-- TOC entry 3427 (class 2606 OID 57497)
-- Dependencies: 2773 2773 2773
-- Name: node_qualifier_value_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_node_qualifier_value
    ADD CONSTRAINT node_qualifier_value_pkey PRIMARY KEY (node_id, term_id);


--
-- TOC entry 3422 (class 2606 OID 57499)
-- Dependencies: 2771 2771 2771
-- Name: node_right_idx_key; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_node
    ADD CONSTRAINT node_right_idx_key UNIQUE (right_idx, tree_id);


--
-- TOC entry 3397 (class 2606 OID 57501)
-- Dependencies: 2760 2760
-- Name: pkdata_object_id; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source
    ADD CONSTRAINT pkdata_object_id PRIMARY KEY (source_id);


--
-- TOC entry 3414 (class 2606 OID 57503)
-- Dependencies: 2770 2770
-- Name: source_field_lookup_id_pk_seq; Type: CONSTRAINT; Schema: source; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY source_lookup_table
    ADD CONSTRAINT source_field_lookup_id_pk_seq PRIMARY KEY (source_field_lookup_id);


--
-- TOC entry 3406 (class 2606 OID 57505)
-- Dependencies: 2763 2763
-- Name: source_fieldcodes_code_id_key; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_fieldcodes
    ADD CONSTRAINT source_fieldcodes_code_id_key UNIQUE (code_id);


--
-- TOC entry 3408 (class 2606 OID 57507)
-- Dependencies: 2763 2763
-- Name: source_fieldcodes_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_fieldcodes
    ADD CONSTRAINT source_fieldcodes_pkey PRIMARY KEY (code_id);


--
-- TOC entry 3410 (class 2606 OID 57509)
-- Dependencies: 2766 2766
-- Name: source_fields_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_fields
    ADD CONSTRAINT source_fields_pkey PRIMARY KEY (field_id);


--
-- TOC entry 3429 (class 2606 OID 57511)
-- Dependencies: 2774 2774 2774 2774 2774
-- Name: source_qualifier_value_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_qualifier_value
    ADD CONSTRAINT source_qualifier_value_pkey PRIMARY KEY (source_id, term_id, value, rank);


--
-- TOC entry 3412 (class 2606 OID 57513)
-- Dependencies: 2768 2768
-- Name: sourcejoin_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_join
    ADD CONSTRAINT sourcejoin_pkey PRIMARY KEY (sourcejoin_id);


--
-- TOC entry 3431 (class 2606 OID 57515)
-- Dependencies: 2776 2776 2776
-- Name: tree_c1; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_tree
    ADD CONSTRAINT tree_c1 UNIQUE (name, biodatabase_id);


--
-- TOC entry 3433 (class 2606 OID 57517)
-- Dependencies: 2776 2776
-- Name: tree_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_tree
    ADD CONSTRAINT tree_pkey PRIMARY KEY (tree_id);


--
-- TOC entry 3435 (class 2606 OID 57519)
-- Dependencies: 2777 2777 2777 2777
-- Name: tree_qualifier_value_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_tree_qualifier_value
    ADD CONSTRAINT tree_qualifier_value_pkey PRIMARY KEY (tree_id, term_id, rank);


--
-- TOC entry 3437 (class 2606 OID 57521)
-- Dependencies: 2779 2779
-- Name: tree_root_pkey; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_tree_root
    ADD CONSTRAINT tree_root_pkey PRIMARY KEY (tree_root_id);


--
-- TOC entry 3439 (class 2606 OID 57523)
-- Dependencies: 2779 2779 2779
-- Name: tree_root_tree_id_key; Type: CONSTRAINT; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY source_tree_root
    ADD CONSTRAINT tree_root_tree_id_key UNIQUE (tree_id, node_id);


SET search_path = worldclim, pg_catalog;

--
-- TOC entry 3441 (class 2606 OID 57525)
-- Dependencies: 2780 2780
-- Name: worldclim_10mins_pkey; Type: CONSTRAINT; Schema: worldclim; Owner: entangled_bank_user; Tablespace: 
--

ALTER TABLE ONLY worldclim_10mins
    ADD CONSTRAINT worldclim_10mins_pkey PRIMARY KEY (pointid);


SET search_path = biosql, pg_catalog;

--
-- TOC entry 3193 (class 1259 OID 57526)
-- Dependencies: 2672
-- Name: bioentry_db; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentry_db ON bioentry USING btree (biodatabase_id);


--
-- TOC entry 3196 (class 1259 OID 57527)
-- Dependencies: 2672
-- Name: bioentry_name; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentry_name ON bioentry USING btree (name);


--
-- TOC entry 3199 (class 1259 OID 57528)
-- Dependencies: 2672
-- Name: bioentry_tax; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentry_tax ON bioentry USING btree (taxon_id);


--
-- TOC entry 3205 (class 1259 OID 57529)
-- Dependencies: 2674
-- Name: bioentrypath_child; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentrypath_child ON bioentry_path USING btree (subject_bioentry_id);


--
-- TOC entry 3206 (class 1259 OID 57530)
-- Dependencies: 2674
-- Name: bioentrypath_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentrypath_trm ON bioentry_path USING btree (term_id);


--
-- TOC entry 3209 (class 1259 OID 57531)
-- Dependencies: 2675
-- Name: bioentryqual_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentryqual_trm ON bioentry_qualifier_value USING btree (term_id);


--
-- TOC entry 3212 (class 1259 OID 57532)
-- Dependencies: 2676
-- Name: bioentryref_ref; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentryref_ref ON bioentry_reference USING btree (reference_id);


--
-- TOC entry 3217 (class 1259 OID 57533)
-- Dependencies: 2678
-- Name: bioentryrel_child; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentryrel_child ON bioentry_relationship USING btree (subject_bioentry_id);


--
-- TOC entry 3218 (class 1259 OID 57534)
-- Dependencies: 2678
-- Name: bioentryrel_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX bioentryrel_trm ON bioentry_relationship USING btree (term_id);


--
-- TOC entry 3190 (class 1259 OID 57535)
-- Dependencies: 2670
-- Name: db_auth; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX db_auth ON biodatabase USING btree (authority);


--
-- TOC entry 3202 (class 1259 OID 57536)
-- Dependencies: 2673
-- Name: dblink_dbx; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX dblink_dbx ON bioentry_dbxref USING btree (dbxref_id);


--
-- TOC entry 3227 (class 1259 OID 57537)
-- Dependencies: 2683
-- Name: dbxref_db; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX dbxref_db ON dbxref USING btree (dbname);


--
-- TOC entry 3232 (class 1259 OID 57538)
-- Dependencies: 2684
-- Name: dbxrefqual_dbx; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX dbxrefqual_dbx ON dbxref_qualifier_value USING btree (dbxref_id);


--
-- TOC entry 3233 (class 1259 OID 57539)
-- Dependencies: 2684
-- Name: dbxrefqual_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX dbxrefqual_trm ON dbxref_qualifier_value USING btree (term_id);


--
-- TOC entry 3236 (class 1259 OID 57540)
-- Dependencies: 2686
-- Name: edge_i1; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX edge_i1 ON edge USING btree (parent_node_id);


--
-- TOC entry 3291 (class 1259 OID 57541)
-- Dependencies: 2706
-- Name: feadblink_dbx; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX feadblink_dbx ON seqfeature_dbxref USING btree (dbxref_id);


--
-- TOC entry 3250 (class 1259 OID 57542)
-- Dependencies: 2690
-- Name: locationqual_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX locationqual_trm ON location_qualifier_value USING btree (term_id);


--
-- TOC entry 3263 (class 1259 OID 57543)
-- Dependencies: 2695
-- Name: node_dbxref_i1; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX node_dbxref_i1 ON node_dbxref USING btree (dbxref_id);


--
-- TOC entry 3251 (class 1259 OID 57544)
-- Dependencies: 2692
-- Name: node_i1; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX node_i1 ON node USING btree (label);


--
-- TOC entry 3252 (class 1259 OID 57545)
-- Dependencies: 2692
-- Name: node_i2; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX node_i2 ON node USING btree (tree_id);


--
-- TOC entry 3266 (class 1259 OID 57546)
-- Dependencies: 2696
-- Name: node_path_i1; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX node_path_i1 ON node_path USING btree (parent_node_id);


--
-- TOC entry 3287 (class 1259 OID 57547)
-- Dependencies: 2705
-- Name: seqfeature_fsrc; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeature_fsrc ON seqfeature USING btree (source_term_id);


--
-- TOC entry 3290 (class 1259 OID 57548)
-- Dependencies: 2705
-- Name: seqfeature_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeature_trm ON seqfeature USING btree (type_term_id);


--
-- TOC entry 3245 (class 1259 OID 57549)
-- Dependencies: 2689
-- Name: seqfeatureloc_dbx; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeatureloc_dbx ON location USING btree (dbxref_id);


--
-- TOC entry 3246 (class 1259 OID 57550)
-- Dependencies: 2689 2689
-- Name: seqfeatureloc_start; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeatureloc_start ON location USING btree (start_pos, end_pos);


--
-- TOC entry 3247 (class 1259 OID 57551)
-- Dependencies: 2689
-- Name: seqfeatureloc_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeatureloc_trm ON location USING btree (term_id);


--
-- TOC entry 3296 (class 1259 OID 57552)
-- Dependencies: 2707
-- Name: seqfeaturepath_child; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeaturepath_child ON seqfeature_path USING btree (subject_seqfeature_id);


--
-- TOC entry 3297 (class 1259 OID 57553)
-- Dependencies: 2707
-- Name: seqfeaturepath_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeaturepath_trm ON seqfeature_path USING btree (term_id);


--
-- TOC entry 3300 (class 1259 OID 57554)
-- Dependencies: 2708
-- Name: seqfeaturequal_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeaturequal_trm ON seqfeature_qualifier_value USING btree (term_id);


--
-- TOC entry 3305 (class 1259 OID 57555)
-- Dependencies: 2710
-- Name: seqfeaturerel_child; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeaturerel_child ON seqfeature_relationship USING btree (subject_seqfeature_id);


--
-- TOC entry 3306 (class 1259 OID 57556)
-- Dependencies: 2710
-- Name: seqfeaturerel_trm; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX seqfeaturerel_trm ON seqfeature_relationship USING btree (term_id);


--
-- TOC entry 3316 (class 1259 OID 57557)
-- Dependencies: 2713
-- Name: taxnamename; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX taxnamename ON taxon_name USING btree (name);


--
-- TOC entry 3317 (class 1259 OID 57558)
-- Dependencies: 2713
-- Name: taxnametaxonid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX taxnametaxonid ON taxon_name USING btree (taxon_id);


--
-- TOC entry 3309 (class 1259 OID 57559)
-- Dependencies: 2712
-- Name: taxparent; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX taxparent ON taxon USING btree (parent_taxon_id);


--
-- TOC entry 3326 (class 1259 OID 57560)
-- Dependencies: 2717
-- Name: term_ont; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX term_ont ON term USING btree (ontology_id);


--
-- TOC entry 3356 (class 1259 OID 57561)
-- Dependencies: 2727
-- Name: tree_dbxref_i1; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX tree_dbxref_i1 ON tree_dbxref USING btree (dbxref_id);


--
-- TOC entry 3331 (class 1259 OID 57562)
-- Dependencies: 2718
-- Name: trmdbxref_dbxrefid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX trmdbxref_dbxrefid ON term_dbxref USING btree (dbxref_id);


--
-- TOC entry 3336 (class 1259 OID 57563)
-- Dependencies: 2720
-- Name: trmpath_objectid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX trmpath_objectid ON term_path USING btree (object_term_id);


--
-- TOC entry 3337 (class 1259 OID 57564)
-- Dependencies: 2720
-- Name: trmpath_ontid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX trmpath_ontid ON term_path USING btree (ontology_id);


--
-- TOC entry 3338 (class 1259 OID 57565)
-- Dependencies: 2720
-- Name: trmpath_predicateid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX trmpath_predicateid ON term_path USING btree (predicate_term_id);


--
-- TOC entry 3343 (class 1259 OID 57566)
-- Dependencies: 2722
-- Name: trmrel_objectid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX trmrel_objectid ON term_relationship USING btree (object_term_id);


--
-- TOC entry 3344 (class 1259 OID 57567)
-- Dependencies: 2722
-- Name: trmrel_ontid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX trmrel_ontid ON term_relationship USING btree (ontology_id);


--
-- TOC entry 3345 (class 1259 OID 57568)
-- Dependencies: 2722
-- Name: trmrel_predicateid; Type: INDEX; Schema: biosql; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX trmrel_predicateid ON term_relationship USING btree (predicate_term_id);


SET search_path = gpdd, pg_catalog;

--
-- TOC entry 3369 (class 1259 OID 57569)
-- Dependencies: 2739 2287
-- Name: location_bbox__gist; Type: INDEX; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX location_bbox__gist ON location_bbox USING gist (the_geom);


--
-- TOC entry 3372 (class 1259 OID 57570)
-- Dependencies: 2287 2741
-- Name: location_pt__gist; Type: INDEX; Schema: gpdd; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX location_pt__gist ON location_pt USING gist (the_geom);


SET search_path = msw05, pg_catalog;

--
-- TOC entry 3391 (class 1259 OID 57571)
-- Dependencies: 2754
-- Name: idx_pointid_geog_worldclim; Type: INDEX; Schema: msw05; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX idx_pointid_geog_worldclim ON msw05_geographic_worldclim_10mins USING btree (pointid);


--
-- TOC entry 3385 (class 1259 OID 57572)
-- Dependencies: 2287 2750
-- Name: msw05_geographic__gist; Type: INDEX; Schema: msw05; Owner: postgres; Tablespace: 
--

CREATE INDEX msw05_geographic__gist ON msw05_geographic USING gist (geog);


--
-- TOC entry 3390 (class 1259 OID 57573)
-- Dependencies: 2286 2751
-- Name: msw05_geographic_gridded_the_geom_gist; Type: INDEX; Schema: msw05; Owner: postgres; Tablespace: 
--

CREATE INDEX msw05_geographic_gridded_the_geom_gist ON msw05_geographic_1deg USING gist (the_geom);


SET search_path = source, pg_catalog;

--
-- TOC entry 3400 (class 1259 OID 57574)
-- Dependencies: 2761
-- Name: edge_i1; Type: INDEX; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX edge_i1 ON source_edge USING btree (parent_node_id);


--
-- TOC entry 3415 (class 1259 OID 57575)
-- Dependencies: 2771
-- Name: node_i1; Type: INDEX; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX node_i1 ON source_node USING btree (label);


--
-- TOC entry 3416 (class 1259 OID 57576)
-- Dependencies: 2771
-- Name: node_i2; Type: INDEX; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX node_i2 ON source_node USING btree (tree_id);


--
-- TOC entry 3423 (class 1259 OID 57577)
-- Dependencies: 2772
-- Name: node_path_i1; Type: INDEX; Schema: source; Owner: entangled_bank_user; Tablespace: 
--

CREATE INDEX node_path_i1 ON source_node_path USING btree (parent_node_id);


SET search_path = biosql, pg_catalog;

--
-- TOC entry 2870 (class 2618 OID 57578)
-- Dependencies: 2670 2670 2670 2670 2670
-- Name: rule_biodatabase_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_biodatabase_i AS ON INSERT TO biodatabase WHERE ((SELECT biodatabase.biodatabase_id FROM biodatabase WHERE ((biodatabase.name)::text = (new.name)::text)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2871 (class 2618 OID 57579)
-- Dependencies: 2673 2673 2673 2673 2673
-- Name: rule_bioentry_dbxref_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_bioentry_dbxref_i AS ON INSERT TO bioentry_dbxref WHERE ((SELECT bioentry_dbxref.dbxref_id FROM bioentry_dbxref WHERE ((bioentry_dbxref.bioentry_id = new.bioentry_id) AND (bioentry_dbxref.dbxref_id = new.dbxref_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2872 (class 2618 OID 57580)
-- Dependencies: 2672 2672 2672 2672 2672 2672
-- Name: rule_bioentry_i1; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_bioentry_i1 AS ON INSERT TO bioentry WHERE ((SELECT bioentry.bioentry_id FROM bioentry WHERE (((bioentry.identifier)::text = (new.identifier)::text) AND (bioentry.biodatabase_id = new.biodatabase_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2873 (class 2618 OID 57581)
-- Dependencies: 2672 2672 2672 2672 2672 2672 2672
-- Name: rule_bioentry_i2; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_bioentry_i2 AS ON INSERT TO bioentry WHERE ((SELECT bioentry.bioentry_id FROM bioentry WHERE ((((bioentry.accession)::text = (new.accession)::text) AND (bioentry.biodatabase_id = new.biodatabase_id)) AND (bioentry.version = new.version))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2874 (class 2618 OID 57582)
-- Dependencies: 2674 2678 2678 2674 2674 2674 2674 2674 2678 2678
-- Name: rule_bioentry_path_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_bioentry_path_i AS ON INSERT TO bioentry_path WHERE ((SELECT bioentry_relationship.bioentry_relationship_id FROM bioentry_relationship WHERE (((bioentry_relationship.object_bioentry_id = new.object_bioentry_id) AND (bioentry_relationship.subject_bioentry_id = new.subject_bioentry_id)) AND (bioentry_relationship.term_id = new.term_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2875 (class 2618 OID 57583)
-- Dependencies: 2675 2675 2675 2675 2675 2675
-- Name: rule_bioentry_qualifier_value_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_bioentry_qualifier_value_i AS ON INSERT TO bioentry_qualifier_value WHERE ((SELECT bioentry_qualifier_value.bioentry_id FROM bioentry_qualifier_value WHERE (((bioentry_qualifier_value.bioentry_id = new.bioentry_id) AND (bioentry_qualifier_value.term_id = new.term_id)) AND (bioentry_qualifier_value.rank = new.rank))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2876 (class 2618 OID 57584)
-- Dependencies: 2676 2676 2676 2676 2676 2676
-- Name: rule_bioentry_reference_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_bioentry_reference_i AS ON INSERT TO bioentry_reference WHERE ((SELECT bioentry_reference.bioentry_id FROM bioentry_reference WHERE (((bioentry_reference.bioentry_id = new.bioentry_id) AND (bioentry_reference.reference_id = new.reference_id)) AND (bioentry_reference.rank = new.rank))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2877 (class 2618 OID 57585)
-- Dependencies: 2678 2678 2678 2678 2678 2678 2678
-- Name: rule_bioentry_relationship_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_bioentry_relationship_i AS ON INSERT TO bioentry_relationship WHERE ((SELECT bioentry_relationship.bioentry_relationship_id FROM bioentry_relationship WHERE (((bioentry_relationship.object_bioentry_id = new.object_bioentry_id) AND (bioentry_relationship.subject_bioentry_id = new.subject_bioentry_id)) AND (bioentry_relationship.term_id = new.term_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2878 (class 2618 OID 57586)
-- Dependencies: 2679 2679 2679 2679
-- Name: rule_biosequence_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_biosequence_i AS ON INSERT TO biosequence WHERE ((SELECT biosequence.bioentry_id FROM biosequence WHERE (biosequence.bioentry_id = new.bioentry_id)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2879 (class 2618 OID 57587)
-- Dependencies: 2681 2681 2681 2681 2681 2681
-- Name: rule_comment_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_comment_i AS ON INSERT TO comment WHERE ((SELECT comment.comment_id FROM comment WHERE ((comment.bioentry_id = new.bioentry_id) AND (comment.rank = new.rank))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2880 (class 2618 OID 57588)
-- Dependencies: 2683 2683 2683 2683 2683 2683 2683
-- Name: rule_dbxref_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_dbxref_i AS ON INSERT TO dbxref WHERE ((SELECT dbxref.dbxref_id FROM dbxref WHERE ((((dbxref.accession)::text = (new.accession)::text) AND ((dbxref.dbname)::text = (new.dbname)::text)) AND (dbxref.version = new.version))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2881 (class 2618 OID 57589)
-- Dependencies: 2684 2684 2684 2684 2684 2684
-- Name: rule_dbxref_qualifier_value_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_dbxref_qualifier_value_i AS ON INSERT TO dbxref_qualifier_value WHERE ((SELECT dbxref_qualifier_value.dbxref_id FROM dbxref_qualifier_value WHERE (((dbxref_qualifier_value.dbxref_id = new.dbxref_id) AND (dbxref_qualifier_value.term_id = new.term_id)) AND (dbxref_qualifier_value.rank = new.rank))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2882 (class 2618 OID 57590)
-- Dependencies: 2689 2689 2689 2689 2689 2689
-- Name: rule_location_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_location_i AS ON INSERT TO location WHERE ((SELECT location.location_id FROM location WHERE ((location.seqfeature_id = new.seqfeature_id) AND (location.rank = new.rank))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2883 (class 2618 OID 57591)
-- Dependencies: 2690 2690 2690 2690 2690
-- Name: rule_location_qualifier_value_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_location_qualifier_value_i AS ON INSERT TO location_qualifier_value WHERE ((SELECT location_qualifier_value.location_id FROM location_qualifier_value WHERE ((location_qualifier_value.location_id = new.location_id) AND (location_qualifier_value.term_id = new.term_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2884 (class 2618 OID 57592)
-- Dependencies: 2701 2701 2701 2701 2701
-- Name: rule_ontology_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_ontology_i AS ON INSERT TO ontology WHERE ((SELECT ontology.ontology_id FROM ontology WHERE ((ontology.name)::text = (new.name)::text)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2885 (class 2618 OID 57593)
-- Dependencies: 2703 2703 2703 2703 2703
-- Name: rule_reference_i1; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_reference_i1 AS ON INSERT TO reference WHERE ((SELECT reference.reference_id FROM reference WHERE ((reference.crc)::text = (new.crc)::text)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2886 (class 2618 OID 57594)
-- Dependencies: 2703 2703 2703 2703 2703
-- Name: rule_reference_i2; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_reference_i2 AS ON INSERT TO reference WHERE ((SELECT reference.reference_id FROM reference WHERE (reference.dbxref_id = new.dbxref_id)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2887 (class 2618 OID 57595)
-- Dependencies: 2706 2706 2706 2706 2706
-- Name: rule_seqfeature_dbxref_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_seqfeature_dbxref_i AS ON INSERT TO seqfeature_dbxref WHERE ((SELECT seqfeature_dbxref.seqfeature_id FROM seqfeature_dbxref WHERE ((seqfeature_dbxref.seqfeature_id = new.seqfeature_id) AND (seqfeature_dbxref.dbxref_id = new.dbxref_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2888 (class 2618 OID 57596)
-- Dependencies: 2705 2705 2705 2705 2705 2705 2705 2705
-- Name: rule_seqfeature_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_seqfeature_i AS ON INSERT TO seqfeature WHERE ((SELECT seqfeature.seqfeature_id FROM seqfeature WHERE ((((seqfeature.bioentry_id = new.bioentry_id) AND (seqfeature.type_term_id = new.type_term_id)) AND (seqfeature.source_term_id = new.source_term_id)) AND (seqfeature.rank = new.rank))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2889 (class 2618 OID 57597)
-- Dependencies: 2707 2707 2707 2707 2707 2707
-- Name: rule_seqfeature_path_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_seqfeature_path_i AS ON INSERT TO seqfeature_path WHERE ((SELECT seqfeature_path.subject_seqfeature_id FROM seqfeature_path WHERE (((seqfeature_path.object_seqfeature_id = new.object_seqfeature_id) AND (seqfeature_path.subject_seqfeature_id = new.subject_seqfeature_id)) AND (seqfeature_path.term_id = new.term_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2890 (class 2618 OID 57598)
-- Dependencies: 2708 2708 2708 2708 2708 2708
-- Name: rule_seqfeature_qualifier_value_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_seqfeature_qualifier_value_i AS ON INSERT TO seqfeature_qualifier_value WHERE ((SELECT seqfeature_qualifier_value.seqfeature_id FROM seqfeature_qualifier_value WHERE (((seqfeature_qualifier_value.seqfeature_id = new.seqfeature_id) AND (seqfeature_qualifier_value.term_id = new.term_id)) AND (seqfeature_qualifier_value.rank = new.rank))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2891 (class 2618 OID 57599)
-- Dependencies: 2710 2710 2710 2710 2710 2710
-- Name: rule_seqfeature_relationship_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_seqfeature_relationship_i AS ON INSERT TO seqfeature_relationship WHERE ((SELECT seqfeature_relationship.subject_seqfeature_id FROM seqfeature_relationship WHERE (((seqfeature_relationship.object_seqfeature_id = new.object_seqfeature_id) AND (seqfeature_relationship.subject_seqfeature_id = new.subject_seqfeature_id)) AND (seqfeature_relationship.term_id = new.term_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2892 (class 2618 OID 57600)
-- Dependencies: 2712 2712 2712 2712 2712
-- Name: rule_taxon_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_taxon_i AS ON INSERT TO taxon WHERE ((SELECT taxon.taxon_id FROM taxon WHERE (taxon.ncbi_taxon_id = new.ncbi_taxon_id)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2893 (class 2618 OID 57601)
-- Dependencies: 2713 2713 2713 2713 2713 2713
-- Name: rule_taxon_name_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_taxon_name_i AS ON INSERT TO taxon_name WHERE ((SELECT taxon_name.taxon_id FROM taxon_name WHERE (((taxon_name.taxon_id = new.taxon_id) AND ((taxon_name.name)::text = (new.name)::text)) AND ((taxon_name.name_class)::text = (new.name_class)::text))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2894 (class 2618 OID 57602)
-- Dependencies: 2718 2718 2718 2718 2718
-- Name: rule_term_dbxref_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_dbxref_i AS ON INSERT TO term_dbxref WHERE ((SELECT term_dbxref.dbxref_id FROM term_dbxref WHERE ((term_dbxref.dbxref_id = new.dbxref_id) AND (term_dbxref.term_id = new.term_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2895 (class 2618 OID 57603)
-- Dependencies: 2717 2717 2717 2717 2717
-- Name: rule_term_i1; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_i1 AS ON INSERT TO term WHERE ((SELECT term.term_id FROM term WHERE ((term.identifier)::text = (new.identifier)::text)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2896 (class 2618 OID 57604)
-- Dependencies: 2717 2717 2717 2717 2717 2717 2717
-- Name: rule_term_i2; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_i2 AS ON INSERT TO term WHERE ((SELECT term.term_id FROM term WHERE ((((term.name)::text = (new.name)::text) AND (term.ontology_id = new.ontology_id)) AND (term.is_obsolete = new.is_obsolete))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2897 (class 2618 OID 57605)
-- Dependencies: 2720 2720 2720 2720 2720 2720 2720 2720
-- Name: rule_term_path_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_path_i AS ON INSERT TO term_path WHERE ((SELECT term_path.subject_term_id FROM term_path WHERE (((((term_path.subject_term_id = new.subject_term_id) AND (term_path.predicate_term_id = new.predicate_term_id)) AND (term_path.object_term_id = new.object_term_id)) AND (term_path.ontology_id = new.ontology_id)) AND (term_path.distance = new.distance))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2898 (class 2618 OID 57606)
-- Dependencies: 2722 2722 2722 2722 2722 2722 2722 2722
-- Name: rule_term_relationship_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_relationship_i AS ON INSERT TO term_relationship WHERE ((SELECT term_relationship.term_relationship_id FROM term_relationship WHERE ((((term_relationship.subject_term_id = new.subject_term_id) AND (term_relationship.predicate_term_id = new.predicate_term_id)) AND (term_relationship.object_term_id = new.object_term_id)) AND (term_relationship.ontology_id = new.ontology_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2899 (class 2618 OID 57607)
-- Dependencies: 2723 2723 2723 2723
-- Name: rule_term_relationship_term_i1; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_relationship_term_i1 AS ON INSERT TO term_relationship_term WHERE ((SELECT term_relationship_term.term_relationship_id FROM term_relationship_term WHERE (term_relationship_term.term_relationship_id = new.term_relationship_id)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2900 (class 2618 OID 57608)
-- Dependencies: 2723 2723 2723 2723
-- Name: rule_term_relationship_term_i2; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_relationship_term_i2 AS ON INSERT TO term_relationship_term WHERE ((SELECT term_relationship_term.term_id FROM term_relationship_term WHERE (term_relationship_term.term_id = new.term_id)) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 2901 (class 2618 OID 57609)
-- Dependencies: 2724 2724 2724 2724 2724
-- Name: rule_term_synonym_i; Type: RULE; Schema: biosql; Owner: entangled_bank_user
--

CREATE RULE rule_term_synonym_i AS ON INSERT TO term_synonym WHERE ((SELECT term_synonym.term_id FROM term_synonym WHERE (((term_synonym.synonym)::text = (new.synonym)::text) AND (term_synonym.term_id = new.term_id))) IS NOT NULL) DO INSTEAD NOTHING;


--
-- TOC entry 3509 (class 2606 OID 57610)
-- Dependencies: 3188 2670 2726
-- Name: fkbiodatabase; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree
    ADD CONSTRAINT fkbiodatabase FOREIGN KEY (biodatabase_id) REFERENCES biodatabase(biodatabase_id);


--
-- TOC entry 3442 (class 2606 OID 57615)
-- Dependencies: 3188 2672 2670
-- Name: fkbiodatabase_bioentry; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry
    ADD CONSTRAINT fkbiodatabase_bioentry FOREIGN KEY (biodatabase_id) REFERENCES biodatabase(biodatabase_id);


--
-- TOC entry 3456 (class 2606 OID 57620)
-- Dependencies: 3197 2679 2672
-- Name: fkbioentry_bioseq; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY biosequence
    ADD CONSTRAINT fkbioentry_bioseq FOREIGN KEY (bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3457 (class 2606 OID 57625)
-- Dependencies: 3197 2681 2672
-- Name: fkbioentry_comment; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT fkbioentry_comment FOREIGN KEY (bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3444 (class 2606 OID 57630)
-- Dependencies: 3197 2673 2672
-- Name: fkbioentry_dblink; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_dbxref
    ADD CONSTRAINT fkbioentry_dblink FOREIGN KEY (bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3449 (class 2606 OID 57635)
-- Dependencies: 2675 2672 3197
-- Name: fkbioentry_entqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_qualifier_value
    ADD CONSTRAINT fkbioentry_entqual FOREIGN KEY (bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3451 (class 2606 OID 57640)
-- Dependencies: 2676 2672 3197
-- Name: fkbioentry_entryref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_reference
    ADD CONSTRAINT fkbioentry_entryref FOREIGN KEY (bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3481 (class 2606 OID 57645)
-- Dependencies: 2672 3197 2705
-- Name: fkbioentry_seqfeature; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature
    ADD CONSTRAINT fkbioentry_seqfeature FOREIGN KEY (bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3446 (class 2606 OID 57650)
-- Dependencies: 2672 3197 2674
-- Name: fkchildent_bioentrypath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_path
    ADD CONSTRAINT fkchildent_bioentrypath FOREIGN KEY (subject_bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3453 (class 2606 OID 57655)
-- Dependencies: 3197 2678 2672
-- Name: fkchildent_bioentryrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_relationship
    ADD CONSTRAINT fkchildent_bioentryrel FOREIGN KEY (subject_bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3486 (class 2606 OID 57660)
-- Dependencies: 3288 2707 2705
-- Name: fkchildfeat_seqfeatpath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_path
    ADD CONSTRAINT fkchildfeat_seqfeatpath FOREIGN KEY (subject_seqfeature_id) REFERENCES seqfeature(seqfeature_id) ON DELETE CASCADE;


--
-- TOC entry 3491 (class 2606 OID 57665)
-- Dependencies: 3288 2710 2705
-- Name: fkchildfeat_seqfeatrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_relationship
    ADD CONSTRAINT fkchildfeat_seqfeatrel FOREIGN KEY (subject_seqfeature_id) REFERENCES seqfeature(seqfeature_id) ON DELETE CASCADE;


--
-- TOC entry 3445 (class 2606 OID 57670)
-- Dependencies: 3228 2673 2683
-- Name: fkdbxref_dblink; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_dbxref
    ADD CONSTRAINT fkdbxref_dblink FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


--
-- TOC entry 3458 (class 2606 OID 57675)
-- Dependencies: 2684 2683 3228
-- Name: fkdbxref_dbxrefqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY dbxref_qualifier_value
    ADD CONSTRAINT fkdbxref_dbxrefqual FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


--
-- TOC entry 3484 (class 2606 OID 57680)
-- Dependencies: 3228 2706 2683
-- Name: fkdbxref_feadblink; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_dbxref
    ADD CONSTRAINT fkdbxref_feadblink FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


--
-- TOC entry 3464 (class 2606 OID 57685)
-- Dependencies: 2683 2689 3228
-- Name: fkdbxref_location; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fkdbxref_location FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id);


--
-- TOC entry 3472 (class 2606 OID 57690)
-- Dependencies: 2683 3228 2695
-- Name: fkdbxref_nodedbxref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_dbxref
    ADD CONSTRAINT fkdbxref_nodedbxref FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


--
-- TOC entry 3480 (class 2606 OID 57695)
-- Dependencies: 2703 2683 3228
-- Name: fkdbxref_reference; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY reference
    ADD CONSTRAINT fkdbxref_reference FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id);


--
-- TOC entry 3511 (class 2606 OID 57700)
-- Dependencies: 2683 2727 3228
-- Name: fkdbxref_treedbxref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree_dbxref
    ADD CONSTRAINT fkdbxref_treedbxref FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


--
-- TOC entry 3496 (class 2606 OID 57705)
-- Dependencies: 2683 3228 2718
-- Name: fkdbxref_trmdbxref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_dbxref
    ADD CONSTRAINT fkdbxref_trmdbxref FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


--
-- TOC entry 3462 (class 2606 OID 57710)
-- Dependencies: 3237 2687 2686
-- Name: fkeav_edge; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY edge_qualifier_value
    ADD CONSTRAINT fkeav_edge FOREIGN KEY (edge_id) REFERENCES edge(edge_id) ON DELETE CASCADE;


--
-- TOC entry 3463 (class 2606 OID 57715)
-- Dependencies: 2687 2717 3327
-- Name: fkeav_term; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY edge_qualifier_value
    ADD CONSTRAINT fkeav_term FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3460 (class 2606 OID 57720)
-- Dependencies: 2686 2692 3255
-- Name: fkedge_child; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY edge
    ADD CONSTRAINT fkedge_child FOREIGN KEY (child_node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3461 (class 2606 OID 57725)
-- Dependencies: 3255 2686 2692
-- Name: fkedge_parent; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY edge
    ADD CONSTRAINT fkedge_parent FOREIGN KEY (parent_node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3467 (class 2606 OID 57730)
-- Dependencies: 2689 2690 3241
-- Name: fkfeatloc_locqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY location_qualifier_value
    ADD CONSTRAINT fkfeatloc_locqual FOREIGN KEY (location_id) REFERENCES location(location_id) ON DELETE CASCADE;


--
-- TOC entry 3476 (class 2606 OID 57735)
-- Dependencies: 2692 2697 3255
-- Name: fknav_node; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_qualifier_value
    ADD CONSTRAINT fknav_node FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3477 (class 2606 OID 57740)
-- Dependencies: 2717 2697 3327
-- Name: fknav_term; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_qualifier_value
    ADD CONSTRAINT fknav_term FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3510 (class 2606 OID 57745)
-- Dependencies: 2692 2726 3255
-- Name: fknode; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree
    ADD CONSTRAINT fknode FOREIGN KEY (node_id) REFERENCES node(node_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3473 (class 2606 OID 57750)
-- Dependencies: 3255 2695 2692
-- Name: fknode_nodedbxref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_dbxref
    ADD CONSTRAINT fknode_nodedbxref FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3469 (class 2606 OID 57755)
-- Dependencies: 2692 2726 3354
-- Name: fknode_tree; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node
    ADD CONSTRAINT fknode_tree FOREIGN KEY (tree_id) REFERENCES tree(tree_id);


--
-- TOC entry 3515 (class 2606 OID 57760)
-- Dependencies: 3255 2730 2692
-- Name: fknode_treeroot; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree_root
    ADD CONSTRAINT fknode_treeroot FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3470 (class 2606 OID 57765)
-- Dependencies: 2672 2694 3197
-- Name: fknodebioentry_bioentry; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_bioentry
    ADD CONSTRAINT fknodebioentry_bioentry FOREIGN KEY (bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3471 (class 2606 OID 57770)
-- Dependencies: 2694 2692 3255
-- Name: fknodebioentry_node; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_bioentry
    ADD CONSTRAINT fknodebioentry_node FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3478 (class 2606 OID 57775)
-- Dependencies: 3255 2699 2692
-- Name: fknodetaxon_node; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_taxon
    ADD CONSTRAINT fknodetaxon_node FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3479 (class 2606 OID 57780)
-- Dependencies: 3307 2712 2699
-- Name: fknodetaxon_taxon; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_taxon
    ADD CONSTRAINT fknodetaxon_taxon FOREIGN KEY (taxon_id) REFERENCES taxon(taxon_id) ON DELETE CASCADE;


--
-- TOC entry 3474 (class 2606 OID 57785)
-- Dependencies: 2696 3255 2692
-- Name: fknpath_child; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_path
    ADD CONSTRAINT fknpath_child FOREIGN KEY (child_node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3475 (class 2606 OID 57790)
-- Dependencies: 2692 3255 2696
-- Name: fknpath_parent; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY node_path
    ADD CONSTRAINT fknpath_parent FOREIGN KEY (parent_node_id) REFERENCES node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3495 (class 2606 OID 57795)
-- Dependencies: 2701 3277 2717
-- Name: fkont_term; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term
    ADD CONSTRAINT fkont_term FOREIGN KEY (ontology_id) REFERENCES ontology(ontology_id) ON DELETE CASCADE;


--
-- TOC entry 3498 (class 2606 OID 57800)
-- Dependencies: 2701 2720 3277
-- Name: fkontology_trmpath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_path
    ADD CONSTRAINT fkontology_trmpath FOREIGN KEY (ontology_id) REFERENCES ontology(ontology_id) ON DELETE CASCADE;


--
-- TOC entry 3502 (class 2606 OID 57805)
-- Dependencies: 2701 3277 2722
-- Name: fkontology_trmrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_relationship
    ADD CONSTRAINT fkontology_trmrel FOREIGN KEY (ontology_id) REFERENCES ontology(ontology_id) ON DELETE CASCADE;


--
-- TOC entry 3447 (class 2606 OID 57810)
-- Dependencies: 2674 3197 2672
-- Name: fkparentent_bioentrypath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_path
    ADD CONSTRAINT fkparentent_bioentrypath FOREIGN KEY (object_bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3454 (class 2606 OID 57815)
-- Dependencies: 3197 2678 2672
-- Name: fkparentent_bioentryrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_relationship
    ADD CONSTRAINT fkparentent_bioentryrel FOREIGN KEY (object_bioentry_id) REFERENCES bioentry(bioentry_id) ON DELETE CASCADE;


--
-- TOC entry 3487 (class 2606 OID 57820)
-- Dependencies: 2707 3288 2705
-- Name: fkparentfeat_seqfeatpath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_path
    ADD CONSTRAINT fkparentfeat_seqfeatpath FOREIGN KEY (object_seqfeature_id) REFERENCES seqfeature(seqfeature_id) ON DELETE CASCADE;


--
-- TOC entry 3492 (class 2606 OID 57825)
-- Dependencies: 3288 2710 2705
-- Name: fkparentfeat_seqfeatrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_relationship
    ADD CONSTRAINT fkparentfeat_seqfeatrel FOREIGN KEY (object_seqfeature_id) REFERENCES seqfeature(seqfeature_id) ON DELETE CASCADE;


--
-- TOC entry 3452 (class 2606 OID 57830)
-- Dependencies: 2703 3283 2676
-- Name: fkreference_entryref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_reference
    ADD CONSTRAINT fkreference_entryref FOREIGN KEY (reference_id) REFERENCES reference(reference_id) ON DELETE CASCADE;


--
-- TOC entry 3485 (class 2606 OID 57835)
-- Dependencies: 2705 3288 2706
-- Name: fkseqfeature_feadblink; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_dbxref
    ADD CONSTRAINT fkseqfeature_feadblink FOREIGN KEY (seqfeature_id) REFERENCES seqfeature(seqfeature_id) ON DELETE CASCADE;


--
-- TOC entry 3489 (class 2606 OID 57840)
-- Dependencies: 2708 2705 3288
-- Name: fkseqfeature_featqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_qualifier_value
    ADD CONSTRAINT fkseqfeature_featqual FOREIGN KEY (seqfeature_id) REFERENCES seqfeature(seqfeature_id) ON DELETE CASCADE;


--
-- TOC entry 3465 (class 2606 OID 57845)
-- Dependencies: 2689 2705 3288
-- Name: fkseqfeature_location; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fkseqfeature_location FOREIGN KEY (seqfeature_id) REFERENCES seqfeature(seqfeature_id) ON DELETE CASCADE;


--
-- TOC entry 3482 (class 2606 OID 57850)
-- Dependencies: 2717 3327 2705
-- Name: fksourceterm_seqfeature; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature
    ADD CONSTRAINT fksourceterm_seqfeature FOREIGN KEY (source_term_id) REFERENCES term(term_id);


--
-- TOC entry 3443 (class 2606 OID 57855)
-- Dependencies: 2672 2712 3307
-- Name: fktaxon_bioentry; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry
    ADD CONSTRAINT fktaxon_bioentry FOREIGN KEY (taxon_id) REFERENCES taxon(taxon_id);


--
-- TOC entry 3494 (class 2606 OID 57860)
-- Dependencies: 2713 2712 3307
-- Name: fktaxon_taxonname; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY taxon_name
    ADD CONSTRAINT fktaxon_taxonname FOREIGN KEY (taxon_id) REFERENCES taxon(taxon_id) ON DELETE CASCADE;


--
-- TOC entry 3448 (class 2606 OID 57865)
-- Dependencies: 3327 2717 2674
-- Name: fkterm_bioentrypath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_path
    ADD CONSTRAINT fkterm_bioentrypath FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3455 (class 2606 OID 57870)
-- Dependencies: 2678 2717 3327
-- Name: fkterm_bioentryrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_relationship
    ADD CONSTRAINT fkterm_bioentryrel FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3450 (class 2606 OID 57875)
-- Dependencies: 3327 2717 2675
-- Name: fkterm_entqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY bioentry_qualifier_value
    ADD CONSTRAINT fkterm_entqual FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3466 (class 2606 OID 57880)
-- Dependencies: 3327 2717 2689
-- Name: fkterm_featloc; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fkterm_featloc FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3490 (class 2606 OID 57885)
-- Dependencies: 3327 2717 2708
-- Name: fkterm_featqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_qualifier_value
    ADD CONSTRAINT fkterm_featqual FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3468 (class 2606 OID 57890)
-- Dependencies: 3327 2717 2690
-- Name: fkterm_locqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY location_qualifier_value
    ADD CONSTRAINT fkterm_locqual FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3488 (class 2606 OID 57895)
-- Dependencies: 3327 2717 2707
-- Name: fkterm_seqfeatpath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_path
    ADD CONSTRAINT fkterm_seqfeatpath FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3493 (class 2606 OID 57900)
-- Dependencies: 2717 3327 2710
-- Name: fkterm_seqfeatrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature_relationship
    ADD CONSTRAINT fkterm_seqfeatrel FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3483 (class 2606 OID 57905)
-- Dependencies: 2717 3327 2705
-- Name: fkterm_seqfeature; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY seqfeature
    ADD CONSTRAINT fkterm_seqfeature FOREIGN KEY (type_term_id) REFERENCES term(term_id);


--
-- TOC entry 3508 (class 2606 OID 57910)
-- Dependencies: 3327 2717 2724
-- Name: fkterm_syn; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_synonym
    ADD CONSTRAINT fkterm_syn FOREIGN KEY (term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3513 (class 2606 OID 57915)
-- Dependencies: 2717 2728 3327
-- Name: fkterm_treequal; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree_qualifier_value
    ADD CONSTRAINT fkterm_treequal FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3497 (class 2606 OID 57920)
-- Dependencies: 3327 2717 2718
-- Name: fkterm_trmdbxref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_dbxref
    ADD CONSTRAINT fkterm_trmdbxref FOREIGN KEY (term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3512 (class 2606 OID 57925)
-- Dependencies: 3354 2726 2727
-- Name: fktree_treedbxref; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree_dbxref
    ADD CONSTRAINT fktree_treedbxref FOREIGN KEY (tree_id) REFERENCES tree(tree_id) ON DELETE CASCADE;


--
-- TOC entry 3514 (class 2606 OID 57930)
-- Dependencies: 3354 2728 2726
-- Name: fktree_treequal; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree_qualifier_value
    ADD CONSTRAINT fktree_treequal FOREIGN KEY (tree_id) REFERENCES tree(tree_id) ON DELETE CASCADE;


--
-- TOC entry 3516 (class 2606 OID 57935)
-- Dependencies: 2730 2726 3354
-- Name: fktree_treeroot; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY tree_root
    ADD CONSTRAINT fktree_treeroot FOREIGN KEY (tree_id) REFERENCES tree(tree_id) ON DELETE CASCADE;


--
-- TOC entry 3459 (class 2606 OID 57940)
-- Dependencies: 3327 2684 2717
-- Name: fktrm_dbxrefqual; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY dbxref_qualifier_value
    ADD CONSTRAINT fktrm_dbxrefqual FOREIGN KEY (term_id) REFERENCES term(term_id);


--
-- TOC entry 3506 (class 2606 OID 57945)
-- Dependencies: 3327 2717 2723
-- Name: fktrm_trmreltrm; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_relationship_term
    ADD CONSTRAINT fktrm_trmreltrm FOREIGN KEY (term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3499 (class 2606 OID 57950)
-- Dependencies: 3327 2717 2720
-- Name: fktrmobject_trmpath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_path
    ADD CONSTRAINT fktrmobject_trmpath FOREIGN KEY (object_term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3503 (class 2606 OID 57955)
-- Dependencies: 2717 3327 2722
-- Name: fktrmobject_trmrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_relationship
    ADD CONSTRAINT fktrmobject_trmrel FOREIGN KEY (object_term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3500 (class 2606 OID 57960)
-- Dependencies: 2720 3327 2717
-- Name: fktrmpredicate_trmpath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_path
    ADD CONSTRAINT fktrmpredicate_trmpath FOREIGN KEY (predicate_term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3504 (class 2606 OID 57965)
-- Dependencies: 2717 3327 2722
-- Name: fktrmpredicate_trmrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_relationship
    ADD CONSTRAINT fktrmpredicate_trmrel FOREIGN KEY (predicate_term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3507 (class 2606 OID 57970)
-- Dependencies: 2723 3339 2722
-- Name: fktrmrel_trmreltrm; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_relationship_term
    ADD CONSTRAINT fktrmrel_trmreltrm FOREIGN KEY (term_relationship_id) REFERENCES term_relationship(term_relationship_id) ON DELETE CASCADE;


--
-- TOC entry 3501 (class 2606 OID 57975)
-- Dependencies: 2720 2717 3327
-- Name: fktrmsubject_trmpath; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_path
    ADD CONSTRAINT fktrmsubject_trmpath FOREIGN KEY (subject_term_id) REFERENCES term(term_id) ON DELETE CASCADE;


--
-- TOC entry 3505 (class 2606 OID 57980)
-- Dependencies: 2722 3327 2717
-- Name: fktrmsubject_trmrel; Type: FK CONSTRAINT; Schema: biosql; Owner: entangled_bank_user
--

ALTER TABLE ONLY term_relationship
    ADD CONSTRAINT fktrmsubject_trmrel FOREIGN KEY (subject_term_id) REFERENCES term(term_id) ON DELETE CASCADE;


SET search_path = source, pg_catalog;

--
-- TOC entry 3531 (class 2606 OID 57985)
-- Dependencies: 2670 3188 2776
-- Name: fkbiodatabase; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_tree
    ADD CONSTRAINT fkbiodatabase FOREIGN KEY (biodatabase_id) REFERENCES biosql.biodatabase(biodatabase_id);


--
-- TOC entry 3519 (class 2606 OID 57990)
-- Dependencies: 2762 2761 3401
-- Name: fkeav_edge; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_edge_qualifier_value
    ADD CONSTRAINT fkeav_edge FOREIGN KEY (edge_id) REFERENCES source_edge(edge_id) ON DELETE CASCADE;


--
-- TOC entry 3520 (class 2606 OID 57995)
-- Dependencies: 2717 3327 2762
-- Name: fkeav_term; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_edge_qualifier_value
    ADD CONSTRAINT fkeav_term FOREIGN KEY (term_id) REFERENCES biosql.term(term_id);


--
-- TOC entry 3517 (class 2606 OID 58000)
-- Dependencies: 2761 3419 2771
-- Name: fkedge_child; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_edge
    ADD CONSTRAINT fkedge_child FOREIGN KEY (child_node_id) REFERENCES source_node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3518 (class 2606 OID 58005)
-- Dependencies: 3419 2771 2761
-- Name: fkedge_parent; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_edge
    ADD CONSTRAINT fkedge_parent FOREIGN KEY (parent_node_id) REFERENCES source_node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3521 (class 2606 OID 58010)
-- Dependencies: 2768 2760 3396
-- Name: fkjoin_id; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_join
    ADD CONSTRAINT fkjoin_id FOREIGN KEY (source_id) REFERENCES source(source_id);


--
-- TOC entry 3522 (class 2606 OID 58015)
-- Dependencies: 2768 2760 3396
-- Name: fklink_id; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_join
    ADD CONSTRAINT fklink_id FOREIGN KEY (source_id) REFERENCES source(source_id);


--
-- TOC entry 3527 (class 2606 OID 58020)
-- Dependencies: 2773 3419 2771
-- Name: fknav_node; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_node_qualifier_value
    ADD CONSTRAINT fknav_node FOREIGN KEY (node_id) REFERENCES source_node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3528 (class 2606 OID 58025)
-- Dependencies: 3327 2773 2717
-- Name: fknav_term; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_node_qualifier_value
    ADD CONSTRAINT fknav_term FOREIGN KEY (term_id) REFERENCES biosql.term(term_id);


--
-- TOC entry 3532 (class 2606 OID 58030)
-- Dependencies: 3419 2776 2771
-- Name: fknode; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_tree
    ADD CONSTRAINT fknode FOREIGN KEY (node_id) REFERENCES source_node(node_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3533 (class 2606 OID 58035)
-- Dependencies: 2776 2776 3432
-- Name: fknode_tree; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_tree
    ADD CONSTRAINT fknode_tree FOREIGN KEY (tree_id) REFERENCES source_tree(tree_id);


--
-- TOC entry 3537 (class 2606 OID 58040)
-- Dependencies: 2771 3419 2779
-- Name: fknode_treeroot; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_tree_root
    ADD CONSTRAINT fknode_treeroot FOREIGN KEY (node_id) REFERENCES source_node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3525 (class 2606 OID 58045)
-- Dependencies: 2771 3419 2772
-- Name: fknpath_child; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_node_path
    ADD CONSTRAINT fknpath_child FOREIGN KEY (child_node_id) REFERENCES source_node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3526 (class 2606 OID 58050)
-- Dependencies: 2772 3419 2771
-- Name: fknpath_parent; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_node_path
    ADD CONSTRAINT fknpath_parent FOREIGN KEY (parent_node_id) REFERENCES source_node(node_id) ON DELETE CASCADE;


--
-- TOC entry 3529 (class 2606 OID 58055)
-- Dependencies: 2774 2760 3396
-- Name: fksource_sourcequal; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_qualifier_value
    ADD CONSTRAINT fksource_sourcequal FOREIGN KEY (source_id) REFERENCES source(source_id) ON DELETE CASCADE;


--
-- TOC entry 3530 (class 2606 OID 58060)
-- Dependencies: 2774 3327 2717
-- Name: fkterm_sourcequal; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_qualifier_value
    ADD CONSTRAINT fkterm_sourcequal FOREIGN KEY (term_id) REFERENCES biosql.term(term_id);


--
-- TOC entry 3535 (class 2606 OID 58065)
-- Dependencies: 2717 2777 3327
-- Name: fkterm_treequal; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_tree_qualifier_value
    ADD CONSTRAINT fkterm_treequal FOREIGN KEY (term_id) REFERENCES biosql.term(term_id);


--
-- TOC entry 3534 (class 2606 OID 58070)
-- Dependencies: 2777 3432 2776
-- Name: fktree_treequal; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_tree_qualifier_value
    ADD CONSTRAINT fktree_treequal FOREIGN KEY (tree_id) REFERENCES source_tree(tree_id) ON DELETE CASCADE;


--
-- TOC entry 3536 (class 2606 OID 58075)
-- Dependencies: 2779 3432 2776
-- Name: fktree_treeroot; Type: FK CONSTRAINT; Schema: source; Owner: entangled_bank_user
--

ALTER TABLE ONLY source_tree_root
    ADD CONSTRAINT fktree_treeroot FOREIGN KEY (tree_id) REFERENCES source_tree(tree_id) ON DELETE CASCADE;


--
-- TOC entry 3523 (class 2606 OID 58080)
-- Dependencies: 2760 2770 3396
-- Name: lookup_exists; Type: FK CONSTRAINT; Schema: source; Owner: postgres
--

ALTER TABLE ONLY source_lookup_table
    ADD CONSTRAINT lookup_exists FOREIGN KEY (lookup_id) REFERENCES source(source_id);


--
-- TOC entry 3524 (class 2606 OID 58085)
-- Dependencies: 2760 3396 2770
-- Name: source_exists; Type: FK CONSTRAINT; Schema: source; Owner: postgres
--

ALTER TABLE ONLY source_lookup_table
    ADD CONSTRAINT source_exists FOREIGN KEY (source_id) REFERENCES source(source_id);


--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO PUBLIC;


SET search_path = biosql, pg_catalog;

--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 2670
-- Name: biodatabase; Type: ACL; Schema: biosql; Owner: entangled_bank_user
--

REVOKE ALL ON TABLE biodatabase FROM PUBLIC;
REVOKE ALL ON TABLE biodatabase FROM entangled_bank_user;
GRANT ALL ON TABLE biodatabase TO entangled_bank_user;


SET search_path = gpdd, pg_catalog;

--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 2739
-- Name: location_bbox; Type: ACL; Schema: gpdd; Owner: entangled_bank_user
--

REVOKE ALL ON TABLE location_bbox FROM PUBLIC;
REVOKE ALL ON TABLE location_bbox FROM entangled_bank_user;
GRANT ALL ON TABLE location_bbox TO entangled_bank_user;


--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 2741
-- Name: location_pt; Type: ACL; Schema: gpdd; Owner: entangled_bank_user
--

REVOKE ALL ON TABLE location_pt FROM PUBLIC;
REVOKE ALL ON TABLE location_pt FROM entangled_bank_user;
GRANT ALL ON TABLE location_pt TO entangled_bank_user;


SET search_path = msw05, pg_catalog;

--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 2750
-- Name: msw05_geographic; Type: ACL; Schema: msw05; Owner: postgres
--

REVOKE ALL ON TABLE msw05_geographic FROM PUBLIC;
REVOKE ALL ON TABLE msw05_geographic FROM postgres;
GRANT ALL ON TABLE msw05_geographic TO postgres;
GRANT SELECT ON TABLE msw05_geographic TO entangled_bank_user;


SET search_path = public, pg_catalog;

--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 2667
-- Name: geography_columns; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE geography_columns FROM PUBLIC;
REVOKE ALL ON TABLE geography_columns FROM postgres;
GRANT ALL ON TABLE geography_columns TO postgres;
GRANT SELECT ON TABLE geography_columns TO entangled_bank_user;


--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 2666
-- Name: geometry_columns; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE geometry_columns FROM PUBLIC;
REVOKE ALL ON TABLE geometry_columns FROM postgres;
GRANT ALL ON TABLE geometry_columns TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE geometry_columns TO entangled_bank_developer;
GRANT SELECT ON TABLE geometry_columns TO PUBLIC;


--
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 2665
-- Name: spatial_ref_sys; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE spatial_ref_sys FROM PUBLIC;
REVOKE ALL ON TABLE spatial_ref_sys FROM postgres;
GRANT ALL ON TABLE spatial_ref_sys TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE spatial_ref_sys TO entangled_bank_developer;


-- Completed on 2011-11-15 15:09:39

--
-- PostgreSQL database dump complete
--


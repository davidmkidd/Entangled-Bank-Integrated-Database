-- $Id: biosql-topo-functions.sql 258 2008-02-21 17:09:07Z lapp $
--
-- Copyright 2006-2008 Hilmar Lapp, William Piel
-- Copyright 2009      David Kidd
-- 
--  This file is part of BioSQL.
--idx
--  BioSQL is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as
--  published by the Free Software Foundation, either version 3 of the
--  License, or (at your option) any later version.
--
--  BioSQL is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with BioSQL. If not, see <http://www.gnu.org/licenses/>.
--
-- ========================================================================

-- TYPES
CREATE TYPE biosql.int_count AS (f1 int, f2 bigint);

--DROP TYPE biosql.int_count;

-- ========================================================================

-- Is node a tip?;

CREATE OR REPLACE FUNCTION biosql.phydb_istip(INTEGER)

	--$1 node id

	RETURNS BOOLEAN AS $$


	SELECT
	CAST((CASE WHEN n.node_id IS NULL THEN FALSE ELSE TRUE END) AS BOOLEAN) AS IsTip
	FROM biosql.node n
	WHERE n.node_id = $1
	AND n.left_idx = (n.right_idx - 1)
	;
$$
LANGUAGE 'SQL';

-- SELECT biosql.phydb_istip(22648)

CREATE OR REPLACE FUNCTION biosql.phydb_istip(TEXT, INTEGER)

	--$1 node id

	RETURNS BOOLEAN AS $$

	SELECT
	CAST((CASE WHEN n.node_id IS NULL THEN FALSE ELSE TRUE END) AS BOOLEAN) AS IsTip
	FROM biosql.node n
	WHERE n.label = $1
	AND n.tree_id = $2
	AND n.left_idx = (n.right_idx - 1)
	;
$$
LANGUAGE 'SQL';

-- SELECT biosql.phydb_istip(22648)

-- NUMBER OF BRANCHES WITH NODES IN ARRAY

CREATE OR REPLACE FUNCTION biosql.phydb_nbrnames(INTEGER, TEXT[], INTEGER)

	--$1 node id
	--$2 names array
	--$3 treeid

	RETURNS BIGINT AS $$
	
		SELECT COUNT(*)
		FROM biosql.node_path np
		WHERE np.parent_node_id = $1
		AND np.child_node_id IN (SELECT label_to_id($2, $3))
		;
$$
LANGUAGE 'SQL';


CREATE OR REPLACE FUNCTION biosql.phydb_nbrnames(INTEGER, INTEGER[])

	--$1 node id
	--$2 nodes array

	RETURNS BIGINT AS $$
	
		SELECT COUNT(*)
		FROM biosql.node_path np
		WHERE np.parent_node_id = $1
		AND np.child_node_id =ANY($2)
		;
$$
LANGUAGE 'SQL';
-- ========================================================================

-- 1) Get node_ids in a tree from labels

-- ========================================================================

-- 1a) Single label
-- ==================

CREATE OR REPLACE FUNCTION biosql.label_to_id(TEXT, INTEGER)

	RETURNS INTEGER AS $$
	--$1 node label
	--$2 tree id	
	SELECT n.node_id
	FROM biosql.node n
	WHERE n.label = $1
	AND   n.tree_id = $2
	ORDER BY n.node_id
	LIMIT 1;
$$
LANGUAGE 'SQL';

--SELECT biosql.label_to_id('Glis glis', 14);

--DROP FUNCTION biosql.label_to_id(TEXT, INTEGER);


-- 1b) Multiple labels in an array given a tree_id
-- =================================================

CREATE OR REPLACE FUNCTION biosql.label_to_id(TEXT[], INTEGER)

	RETURNS SETOF INTEGER AS $$
	--$1 node label
	--$2 tree id	
	SELECT n.node_id
	FROM biosql.node n
	WHERE n.label = ANY($1)
	AND   n.tree_id = $2
	ORDER BY n.node_id;
$$
LANGUAGE 'SQL';

--SELECT biosql.label_to_id(ARRAY['Glis glis','Jaculus jaculus', 'Alces alces'], 14);

--DROP FUNCTION biosql.label_to_id(TEXT[], INTEGER)


-- ========================================================================

-- 2) Get labels from node_ids

-- ========================================================================

-- 2a) Single id
-- ===============

CREATE OR REPLACE FUNCTION biosql.id_to_label(INTEGER)

	--$1 node id

	RETURNS TEXT AS $$
	
	SELECT n.label
	FROM biosql.node n
	WHERE n.node_id = $1
	ORDER BY n.node_id
	LIMIT 1;
$$
LANGUAGE 'SQL';

--SELECT biosql.id_to_label(22648);

--DROP FUNCTION biosql.id_to_label(INTEGER);

-- 2b Multiple node ids in an array
-- ==================================

CREATE OR REPLACE FUNCTION biosql.id_to_label(INTEGER[])

	RETURNS SETOF TEXT AS $$
	--$1 node id
	SELECT n.label
	FROM biosql.node n
	WHERE n.node_id = ANY($1)
	ORDER BY n.node_id;
$$
LANGUAGE 'SQL';

--SELECT biosql.id_to_label(ARRAY[22648,25452,26499]);

--DROP FUNCTION biosql.id_to_label(INTEGER[])


-- ========================================================================

-- 3) Find the LCA (last common ancestor) 

-- ========================================================================

-- 3a) LCA of nodes A and B
-- ==========================

CREATE OR REPLACE FUNCTION biosql.lca(INTEGER, INTEGER)

	RETURNS INTEGER AS '
	
	SELECT lca.node_id
	FROM biosql.node lca, biosql.node_path pA, biosql.node_path pB
	WHERE pA.parent_node_id = pB.parent_node_id
	AND   lca.node_id = pA.parent_node_id
	AND   pA.child_node_id = $1
	AND   pB.child_node_id = $2
	ORDER BY pA.distance
	LIMIT 1;'

LANGUAGE 'SQL';

--SELECT biosql.lca(22648,25452);

--DROP FUNCTION biosql.lca(INTEGER, INTEGER);


-- 3b) LCA of multiple nodes in an array
-- =======================================

-- Tree_id is required as index range can refer to more than one tree
-- Should get the tree_id from the node array checking that all nodes are in the same tree

CREATE OR REPLACE FUNCTION biosql.lca(integer[],INTEGER)
  RETURNS integer AS
$BODY$

	DECLARE
	min_idx INTEGER;
	max_idx INTEGER;
	lca INTEGER;

	BEGIN
	SELECT INTO min_idx MIN(n.left_idx) FROM biosql.node n WHERE n.node_id = ANY($1);
	SELECT INTO max_idx MAX(n.right_idx) FROM biosql.node n WHERE n.node_id = ANY($1);

	SELECT INTO lca n.node_id
	FROM biosql.node n
	WHERE n.left_idx <= min_idx
	AND n.right_idx >= max_idx
	AND n.tree_id = $2
	ORDER BY n.right_idx - n.left_idx ASC
	LIMIT 1;

	RETURN lca;
	END;
	$BODY$
  LANGUAGE 'plpgsql' VOLATILE
  COST 100;
ALTER FUNCTION biosql.lca(integer[]) OWNER TO entangled_bank_user;


--SELECT biosql.lca(ARRAY[22648,25452,26499], 14);

--DROP FUNCTION biosql.lca(INTEGER[]);


-- 3c) LCA of a pair of nodes identified with labels within a tree
-- ===============================================================

CREATE OR REPLACE FUNCTION biosql.lca(TEXT, TEXT, INTEGER)

	RETURNS INTEGER AS $$
	-- $1	node A
	-- $2	node B
	-- $3   tree id
	SELECT n.node_id
	FROM biosql.node n, biosql.node_path pA, biosql.node_path pB
	WHERE pA.parent_node_id = pB.parent_node_id
	AND   n.node_id = pA.parent_node_id
	AND   pA.child_node_id IN (SELECT biosql.label_to_id($1,$3))
	AND   pB.child_node_id IN (SELECT biosql.label_to_id($2,$3))
	AND   n.tree_id = $3
	ORDER BY pA.distance
	LIMIT 1;
	$$

LANGUAGE 'SQL';

--SELECT biosql.lca('Glis glis','Jaculus jaculus',14);


-- 3d) LCA of a set of node labels within a tree
-- ===============================================

CREATE OR REPLACE FUNCTION biosql.lca(TEXT[],INTEGER)

	RETURNS INTEGER AS $$

	DECLARE
	min_idx INTEGER;
	max_idx INTEGER;
	lca INTEGER;

	BEGIN
	SELECT INTO min_idx MIN(n.left_idx) FROM biosql.node n WHERE n.label = ANY($1) AND n.tree_id = $2;
	SELECT INTO max_idx MAX(n.right_idx) FROM biosql.node n WHERE n.label = ANY($1) AND n.tree_id = $2;

	SELECT INTO lca n.node_id
	FROM biosql.node n
	WHERE n.left_idx <= min_idx
	AND   n.right_idx >= max_idx
	ORDER BY n.right_idx - n.left_idx ASC
	LIMIT 1;

	RETURN lca;
	END;
	$$

LANGUAGE 'PLPGSQL';

--SELECT biosql.lca(ARRAY['Glis glis', 'Alces alces','Jaculus jaculus'], 14);

--DROP FUNCTION biosql.lca(TEXT[],INTEGER)


-- ========================================================================

-- 4) Find the oldest ancestor node of A such that B is not
-- descended from the ancestor

-- ========================================================================

CREATE OR REPLACE FUNCTION biosql.lca_of_a_excluding_b(INTEGER, INTEGER)
	RETURNS INTEGER AS $$

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
	$$
LANGUAGE 'SQL';

--SELECT biosql.lca_of_a_excluding_b(22648,25452);

--DROP FUNCTION biosql.lca_of_a_excluding_b(INT,INT);


-- ========================================================================

-- 5) Edges of subtrees

-- ========================================================================


-- 5a) Edges of an entire tree
-- =============================

CREATE OR REPLACE FUNCTION biosql.tree_edges(INTEGER)
	RETURNS SETOF INTEGER AS $$
	
	SELECT e.edge_id 
	FROM biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    pt.tree_id = $1
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	
	$$
LANGUAGE 'SQL';

--SELECT biosql.tree_edges(14);

--DROP FUNCTION biosql.tree_edges(INTEGER);


-- 5b) Edges of the subtree rooted at LCA(A,B) of nodes A and B 
-- (minimal spanning clade)
-- =====================================================================

CREATE OR REPLACE FUNCTION biosql.lca_subtree(INTEGER, INTEGER)
	RETURNS SETOF INTEGER AS '
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
	      ORDER BY pA.distance
	      LIMIT 1
	)'
LANGUAGE 'SQL'

--SELECT biosql.lca_subtree(22648,25452);

--DROP FUNCTION biosql.lca_subtree(INTEGER, INTEGER);


-- 5c) Edges of a subtree rooted at the LCA of an array of nodes 
--(minimal spanning clade)
-- ===============================================================

CREATE OR REPLACE FUNCTION biosql.lca_subtree(INTEGER[])
	RETURNS SETOF INTEGER AS $$

	DECLARE
		--myedge 		biosql.edge.edge_id%TYPE;
		myedge		INTEGER;
		mylca 		INTEGER;
		lca_left	INTEGER;
		lca_right	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.lca($1);
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
	END
	$$
LANGUAGE 'PLPGSQL';

--SELECT * FROM biosql.lca_subtree(ARRAY[22648,25452]);

--DROP FUNCTION biosql.lca_subtree(INTEGER[]);


-- 5d) Edges of the subtree rooted at a node
-- ===========================================

CREATE OR REPLACE FUNCTION biosql.node_subtree(INTEGER)
	RETURNS SETOF INTEGER AS '
	SELECT e.edge_id 
	FROM biosql.node_path p, biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    e.child_node_id = p.child_node_id
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	AND p.parent_node_id = $1'
LANGUAGE 'SQL';


-- 5e) Edges of the subtree rooted at the lca of an array of labels within a tree
-- ================================================================================

CREATE OR REPLACE FUNCTION biosql.node_subtree(TEXT[],INTEGER)
	RETURNS SETOF INTEGER AS $$
	SELECT e.edge_id 
	FROM biosql.node_path p, biosql.edge e, biosql.node pt, biosql.node ch 
	WHERE 
	    e.child_node_id = p.child_node_id
	AND pt.node_id = e.parent_node_id
	AND ch.node_id = e.child_node_id
	AND p.parent_node_id = biosql.lca($1,$2)
	$$
LANGUAGE 'SQL';


-- ========================================================================

-- 6) Nodes of subtrees

-- ========================================================================


-- 6a) Nodes of a subtree rooted at the lca by id
-- ================================================

CREATE OR REPLACE FUNCTION biosql.lca_subtree_nodes(INTEGER)
	RETURNS SETOF INTEGER AS $$
	
	SELECT p.child_node_id
	FROM biosql.node_path p
	WHERE p.parent_node_id = $1
	UNION
	SELECT $1
	$$
LANGUAGE 'SQL';



-- 6c) Nodes of a subtree rooted at the lca of an array of nodes
-- ==============================================================================

CREATE OR REPLACE FUNCTION biosql.lca_subtree_nodes(INTEGER[])
	RETURNS SETOF INTEGER AS $$

	DECLARE
		mylca 	INTEGER;
		mynode	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.lca($1);
	
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
	$$
LANGUAGE 'PLPGSQL';


-- 6b) Nodes of a subtree rooted at the lca of an array of labels within a tree
-- ==============================================================================

CREATE OR REPLACE FUNCTION biosql.lca_subtree_nodes_by_label(TEXT[],INTEGER)
	RETURNS SETOF INTEGER AS $$

	DECLARE
		mylca 	INTEGER;
		mynode	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.lca($1,$2);
	
		FOR mynode IN
		
			SELECT p.child_node_id as lca
			FROM biosql.node_path p
			WHERE p.parent_node_id = mylca
			UNION
			SELECT biosql.lca($1,$2)

		LOOP
		RETURN NEXT mynode;
		END LOOP;
	END;
	$$
LANGUAGE 'PLPGSQL';

--SELECT * FROM biosql.lca_subtree_nodes_by_label(ARRAY['Helogale hirtula','Mungos mungo','Crossarchus obscurus'],14) ORDER BY lca_subtree_nodes_by_label;

--SELECT biosql.lca(ARRAY['Helogale hirtula','Mungos mungo','Crossarchus obscurus'],14);

--SELECT * FROM biosql.node_path p WHERE p.parent_node_id = 27171 ORDER BY child_node_id;

--SELECT * from biosql.node WHERE label = 'Ichneumia albicauda';

--SELECT * FROM biosql.lca_subtree_nodes_by_label(ARRAY['Glis glis', 'Alces alces','Jaculus jaculus'], 14) ORDER BY lca_subtree_nodes_by_label;

--DROP FUNCTION  biosql.lca_subtree_nodes_by_label(INTEGER);


-- 6d) The tips of a subtree rooted at the lca of an array of labels within a tree
-- ===============================================================================

-- [CHECK REQUIRED]

CREATE OR REPLACE FUNCTION biosql.lca_subtree_tips_by_label(TEXT[],INTEGER)

	RETURNS SETOF INTEGER AS $$

	DECLARE
		mylca 	INTEGER;
		mynodes	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.lca($1,$2);
	
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
	$$
LANGUAGE 'PLPGSQL';

SELECT * FROM biosql.lca_subtree_tips_by_label(ARRAY['Helogale hirtula','Mungos mungo','Crossarchus obscurus'], 14) ORDER BY lca_subtree_tips_by_label;

SELECT * FROM biosql.lca_subtree_tips_by_label(ARRAY['Varecia variegata','Eulemur coronatus','Lemur catta'], 21)

--DROP FUNCTION  biosql.lca_subtree_tips_by_label(TEXT[],INTEGER);



-- 6e) The tip labels of a subtree rooted at the lca of an array of labels within a tree
-- ===============================================================================


CREATE OR REPLACE FUNCTION biosql.lca_subtree_tip_label_by_label(text[], integer)
  RETURNS SETOF text AS
$BODY$

	DECLARE
		mylca 	INTEGER;
		mylab	TEXT;

	BEGIN
		SELECT INTO mylca biosql.lca($1,$2);
	
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
	$BODY$
  LANGUAGE 'plpgsql' VOLATILE


--SELECT * FROM biosql.lca_subtree_tips_by_label(ARRAY['Helogale hirtula','Mungos mungo','Crossarchus obscurus'], 14) ORDER BY lca_subtree_tips_by_label;

--DROP FUNCTION  biosql.lca_subtree_tips_by_label(TEXT[],INTEGER);


-- 6d) The internal nodes of a subtree rooted at the lca of an array of labels within a tree
-- ===========================================================================================
-- [CHECK REQUIRED]

CREATE OR REPLACE FUNCTION biosql.lca_subtree_internal_by_label(TEXT[],INTEGER)

	RETURNS SETOF INTEGER AS $$

	DECLARE
		mylca 	INTEGER;
		mynodes	INTEGER;

	BEGIN
		SELECT INTO mylca biosql.lca($1,$2);
	
		FOR mynodes IN
		
			SELECT p.child_node_id
			FROM biosql.node_path p, biosql.node n
			WHERE p.parent_node_id = mylca
			AND n.node_id = p.child_node_id
			AND (n.right_idx - n.left_idx) != 1
			UNION
			SELECT biosql.lca($1,$2)

		LOOP
		RETURN NEXT mynodes;
		END LOOP;
	END;
	$$
LANGUAGE 'PLPGSQL';

--SELECT * FROM biosql.lca_subtree_internal_by_label(ARRAY['Helogale hirtula','Mungos mungo','Crossarchus obscurus'], 14) ORDER BY lca_subtree_tips_by_label;

--DROP FUNCTION  biosql.lca_subtree_internal_by_label(TEXT[],INTEGER);



-- 6e) The tip labels of a subtree rooted at the lca of an array of labels within a tree
-- ===============================================================================


CREATE OR REPLACE FUNCTION biosql.lca_subtree_internal_label_by_label(text[], integer)
  RETURNS SETOF text AS
$BODY$

	DECLARE
		mylca 	INTEGER;
		mylab	TEXT;

	BEGIN
		SELECT INTO mylca biosql.lca($1,$2);
	
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
	$BODY$
  LANGUAGE 'plpgsql' VOLATILE


-- =======================================================================================================

-- 7) Find the maximim spanning clade that includes nodes A and B but not C
-- (stem query)

-- ===========================================================================================
-- [CHECK REQUIRED]

CREATE OR REPLACE FUNCTION biosql.maxspan_subtree(INT, INT, INT)
	RETURNS SETOF INTEGER AS $$
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
	$$
LANGUAGE 'SQL';


--SELECT phydb_maxspan_subtree(297086,297098,297099);

--DROP FUNCTION phydb_maxspan_subtree(INT,INT,INT);


-- ========================================================================

-- 7) Tree pattern match 

-- ========================================================================


-- 7a) Trees for which the minimum spanning clade of nodes A and B
-- includes node C (as identified by label)
-- =================================================================
-- [CHECK REQUIRED]

CREATE OR REPLACE FUNCTION biosql.phydb_treetop_acb_by_label(TEXT, TEXT, TEXT)
	RETURNS SETOF INTEGER AS '
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
	;'
LANGUAGE 'SQL';

--SELECT phydb_treetop_acb_by_label('Avahi laniger','Daubentonia madagascariensis','Indri indri');

--DROP FUNCTION phydb_treetop_acb_by_label(TEXT, TEXT, TEXT);


-- 7b) Trees in which the minimum spanning clade of nodes A and B
-- does not include node C (as identified by label)
-- ===========================================================================================
-- [CHECK REQUIRED]

-- Added DISTINCT as otherwise returning multiple rows for each tree.

CREATE OR REPLACE FUNCTION biosql.treetop_abc_by_label(TEXT, TEXT, TEXT)
	RETURNS SETOF INTEGER AS '
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
	);'
LANGUAGE 'SQL';

--SELECT biosql.treetop_abc_by_label('Avahi laniger','Indri indri','Daubentonia madagascariensis');

--DROP FUNCTION biosql.treetop_abc_by_label(TEXT, TEXT, TEXT);


-- ===================================================================================

-- 8) Tree projection

-- Obtain the subtree induced by the chosen set of nodes A_1, ..., A_n
-- Two steps:
-- i) Find the last common ancestor node LCA = LCA(A_1,...,A_n)
-- ii) Obtain the minimum spanning clade rooted at LCA, and prune off
-- non-matching terminal nodes, and non-shared internal nodes.

-- ===================================================================================


-- 8a) Nodes of subtree including intermediate nodes with single child by ids
-- =============================================================================

CREATE OR REPLACE FUNCTION biosql.subtree_node_by_id(INTEGER[])
	RETURNS SETOF INTEGER AS $$

	DECLARE
		lca 	INTEGER;
		mynodes	INTEGER;

	BEGIN
		SELECT INTO lca biosql.lca($1);

		FOR mynodes IN
		SELECT p.child_node_id AS id FROM biosql.node_path p WHERE p.parent_node_id = lca
		INTERSECT
		SELECT c.parent_node_id AS id FROM biosql.node_path c WHERE c.child_node_id = ANY($1)
		UNION
		SELECT phydb_lca($1) AS id
		UNION
		SELECT t.child_node_id AS id FROM biosql.node_path t WHERE t.child_node_id = ANY($1)

		LOOP
		RETURN NEXT mynodes;
		END LOOP;
	END;
$$
LANGUAGE 'PLPGSQL';


--SELECT id FROM biosql_subtree_nodes_by_id(ARRAY[297086,297095,297099]) as id;

--DROP FUNCTION biosql_subtree_nodes_by_id(INTEGER[]);


-- 8b) Nodes of subtree including intermediate nodes with single child by labels
-- =============================================================================

CREATE OR REPLACE FUNCTION biosql.subtree_node_by_label(TEXT[],INTEGER)
	RETURNS SETOF INTEGER AS $$

	DECLARE
		lca 	INTEGER;
		mynodes	INTEGER;

	BEGIN
		SELECT INTO lca biosql.lca($1,$2);

		FOR mynodes IN
			SELECT p.child_node_id AS id FROM biosql.node_path p WHERE p.parent_node_id = lca
		INTERSECT
			SELECT c.parent_node_id AS id
			FROM biosql.node_path c, biosql.node n
			WHERE c.child_node_id = n.node_id
			AND n.label = ANY($1)
			AND n.tree_id = $2
		UNION
			SELECT biosql.lca($1,$2) AS id
		UNION
			SELECT t.child_node_id AS id
			FROM biosql.node_path t, biosql.node n
			WHERE t.child_node_id = n.node_id
			AND n.label = ANY($1)
			AND n.tree_id = $2
		LOOP
		RETURN NEXT mynodes;
		END LOOP;
	END;
$$
LANGUAGE 'PLPGSQL';

--USAGE

--SELECT * FROM biosql.subtree_node_by_label(ARRAY['Helogale hirtula','Mungos mungo','Crossarchus obscurus'],14);

--DROP FUNCTION biosql.subtree_node_by_label(TEXT[],INTEGER);
-- 
-- -- 8c) Label Array Version (DUPLICATE OF ABOVE?)
-- 
-- 
-- 
-- 
-- 
-- CREATE OR REPLACE FUNCTION biosql.subtree_node_by_label(TEXT[],INTEGER)
-- 	RETURNS SETOF INTEGER AS $$
-- 
-- 	DECLARE
-- 		lca 	INTEGER;
-- 		mynodes	INTEGER;
-- 
-- 	BEGIN
-- 		SELECT INTO lca biosql.lca($1,$2);
-- 
-- 		FOR mynodes IN
-- 			SELECT p.child_node_id AS id FROM biosql.node_path p WHERE p.parent_node_id = lca
-- 		INTERSECT
-- 			SELECT c.parent_node_id AS id
-- 			FROM biosql.node_path c, biosql.node n
-- 			WHERE c.child_node_id = n.node_id
-- 			AND n.label = ANY($1)
-- 		UNION
-- 			SELECT biosql.lca($1,$2) AS id
-- 		UNION
-- 			SELECT t.child_node_id AS id
-- 			FROM biosql.node_path t, biosql.node n
-- 			WHERE t.child_node_id = n.node_id
-- 			AND n.label = ANY($1)
-- 
-- 		LOOP
-- 		RETURN NEXT mynodes;
-- 		END LOOP;
-- 	END;
-- $$
-- LANGUAGE 'PLPGSQL';
-- 
-- --USAGE
-- 
-- SELECT * FROM biosql.subtree_node_by_label(ARRAY['Helogale hirtula','Mungos mungo','Crossarchus obscurus'],14);
-- 
-- 
-- DROP FUNCTION biosql.subtree_node_by_label(TEXT[],INTEGER);

--8c) Edges of subtree connecting given nodes. This includes singletons.

CREATE OR REPLACE FUNCTION biosql.subtree_edges_by_id(INTEGER[])
	RETURNS INTEGER AS $$

	SELECT e.edge_id
	FROM biosql.edge e, biosql.node n
	WHERE e.parent_node_id = ANY($1)
	AND e.child_node_id = ANY($1)

$$LANGUAGE 'SQL';

--DROP FUNCTION biosql.subtree_edges_by_id(INTEGER[]);

--SELECT biosql.subtree_edges_by_id(ARRAY[297086,297095,297099]);

-- ========================================================================


-- 9) Subsetting trees:
-- all trees that have at least the given nodes, identified by label
CREATE OR REPLACE FUNCTION biosql.trees_by_label(TEXT[])
	RETURNS SETOF INTEGER AS '

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

'LANGUAGE 'PLPGSQL';

--USAGE
--SELECT tree_id FROM phydb_trees_by_label(ARRAY['Avahi laniger','Indri indri','Daubentonia madagascariensis']) as tree_id;

--DROP FUNCTION phydb_subtree_nodes_by_id(TEXT[]);

-- ========================================================================

-- 10) Edge Qualifier Values associated with a tree

CREATE OR REPLACE FUNCTION biosql.edge_qualifier_id_by_tree(INTEGER)
	RETURNS SETOF INTEGER AS $$
	
	SELECT DISTINCT t.term_id
	FROM biosql.term t, biosql.node n, biosql.edge e, biosql.edge_qualifier_value eq
	WHERE eq.term_id = t.term_id
	AND e.edge_id = eq.edge_id
	AND (e.parent_node_id = n.node_id
	OR e.child_node_id = n.node_id)
	AND n.tree_id = $1;
$$
LANGUAGE 'SQL';

--SELECT biosql.edge_qualifier_id_by_tree(14);

--DROP FUNCTION biosql.edge_qualifiers_by_tree(INTEGER);

-- ========================================================================

-- 11) Number of children for a set of nodes

CREATE OR REPLACE FUNCTION biosql.n_children_of_nodes(INTEGER[])
	RETURNS SETOF biosql.int_count AS $$
	
	SELECT n.node_id, COUNT(e.child_node_id)
	FROM biosql.node n, biosql.edge e
	WHERE n.node_id = e.parent_node_id
	AND e.child_node_id = ANY($1)
	GROUP BY n.node_id;
$$
LANGUAGE 'SQL';

--SELECT biosql.n_children_of_node(ARRAY[...]);

--DROP FUNCTION biosql.n_childern_of_nodes(INTEGER);


-- 11a) Number of children of a node

CREATE OR REPLACE FUNCTION biosql.n_children(INTEGER)
	RETURNS INTEGER AS $$
	
	SELECT COUNT(*)
	FROM biosql.edge e
	WHERE e.parent_node_id = $1
$$
LANGUAGE 'SQL';

--SELECT biosql.n_children_of_node(ARRAY[...]);

--DROP FUNCTION biosql.n_childern_of_nodes(INTEGER);


-- ========================================================================

-- 12) Children of a node in set of nodes

CREATE OR REPLACE FUNCTION biosql.children_of_node_in_array(INTEGER, INTEGER[])
	RETURNS SETOF INTEGER AS $$
	
	SELECT np.child_node_id
	FROM biosql.node_path np
	WHERE np.parent_node_id = $1
	AND np.child_node_id = ANY($2)
	AND np.distance = 1;
$$
LANGUAGE 'SQL';

--SELECT biosql.children_of_node_in_array(27171,ARRAY[27173,27175,27181,27184,27178,27174,27182,27183,27172,27180,27179,27177,27176]);

--DROP FUNCTION biosql.n_childern_of_node_in_array(INTEGER, INTEGER[]);


-- Number of children of a node in an array by parent id


CREATE OR REPLACE FUNCTION biosql.n_children_of_node_in_array(INTEGER, INTEGER[])
	RETURNS BIGINT AS $$
	
	SELECT COUNT(*)
	FROM biosql.node_path np
	WHERE np.parent_node_id = $1
	AND np.child_node_id = ANY($2)
	AND np.distance = 1;
$$
LANGUAGE 'SQL';

--SELECT biosql.n_childern_of_node_in_array(27171,ARRAY[27173,27175,27181,27184,27178,27174,27182,27183,27172,27180,27179,27177,27176])

--DROP FUNCTION n_children_of_node_in_array(INTEGER, INTEGER[])

-- Number of children of a node in an array by parent label

CREATE OR REPLACE FUNCTION biosql.n_childern_of_node_in_array(TEXT, INTEGER[])
	RETURNS BIGINT AS $$
	
	SELECT COUNT(*)
	FROM biosql.node_path np, biosql.node n
	WHERE np.parent_node_id = n.node_id
	AND n.label = $1
	AND np.child_node_id = ANY($2)
	AND np.distance = 1;
$$
LANGUAGE 'SQL';

--SELECT biosql.n_childern_of_node_in_array('1505',ARRAY[27178,27176,27173,27175,27172,27174,27177])


-- ========================================================================

CREATE OR REPLACE FUNCTION biosql.delete_tree(INTEGER)
	RETURNS VOID AS

	$$

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
	
$$
LANGUAGE 'PLPGSQL';

--DROP FUNCTION biosql.delete_tree(INTEGER);

-- ========================================================================


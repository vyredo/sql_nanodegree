------------------------ USERS TABLE ---------------------------------------------------
-- create user from posts
WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	username_post AS (
		SELECT DISTINCT bp.username
		FROM bad_posts bp
	)
INSERT INTO users (
	username,
	login_time,
	created_at,
	updated_at
)
SELECT 
	username,
	(SELECT dt from random_time), 
	(SELECT dt from random_time), 
    (SELECT dt from random_time)	
FROM username_post puv;

-- create user from votes
WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	votes AS (
		SELECT
			regexp_split_to_table(bp.upvotes, ',') username
		FROM bad_posts bp
		UNION
		SELECT
			regexp_split_to_table(bp.upvotes, ',') username
		FROM bad_posts bp
	)
INSERT INTO users (
	username,
	login_time,
	created_at,
	updated_at
)
SELECT 
	username,
	(SELECT dt from random_time), 
	(SELECT dt from random_time), 
    (SELECT dt from random_time)	
FROM votes
ON CONFLICT (username) DO NOTHING;

-- create user from comments
WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	username_comments AS (
		SELECT DISTINCT bc.username
		FROM bad_comments bc
	)
INSERT INTO users (
	username,
	login_time,
	created_at,
	updated_at
)
SELECT 
	username,
	(SELECT dt from random_time), 
	(SELECT dt from random_time), 
    (SELECT dt from random_time)	
FROM username_comments puv
ON CONFLICT (username) DO NOTHING;

----------------------------- TOPIC TABLE ----------------------------------------------
-- create topics
WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	topic AS (
		SELECT
		DISTINCT bp.topic
		FROM bad_posts bp	
	)
INSERT INTO topics (
	topic_name,
	description,
	created_at,
	updated_at
)
SELECT 
	t.topic,
	null,
	(SELECT dt from random_time), 
    (SELECT dt from random_time)	
FROM topic t;

-------------------------------- POSTS TABLE -------------------------------------------
-- create posts
WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	post_topic_user AS (
		SELECT 
			id post_id,
			t.topic_id,
			t.topic_name,
			u.user_id,
			bp.title,
			bp.url,
			bp.text_content
		from bad_posts bp
		JOIN users u
		ON u.username = bp.username
		JOIN topics t
		ON t.topic_name = bp.topic
	)
INSERT INTO posts (
	post_id,
	user_id,
	topic_id,
	title,
	url,
	text_content,
	created_at,
	updated_at
)
SELECT 
	ptu.post_id,
	ptu.user_id,
	ptu.topic_id,
	ptu.title,
	ptu.url,
	ptu.text_content,
	(SELECT dt from random_time), 
	(SELECT dt from random_time)	
FROM post_topic_user ptu
-- title is less than 100 characters
WHERE LENGTH(ptu.title) <= 100;


-------------------------------- VOTES TABLE -------------------------------------------
-- create upvotes only
WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	upvotes AS (
		SELECT
			regexp_split_to_table(bp.upvotes, ',') username,
			bp.title
		FROM bad_posts bp
	),
	post_user_vote AS (
		SELECT 
			p.post_id,
			p.title,
			u.user_id,
			u.username
		FROM upvotes
		JOIN posts p ON p.title = upvotes.title
		JOIN users u ON u.username = upvotes.username
	) 
INSERT INTO votes (
	user_id,
	post_id,
	score,
	created_at,
	updated_at
)
SELECT 
	puv.user_id,
	puv.post_id,
	1,
	(SELECT dt from random_time), 
    (SELECT dt from random_time)	
FROM post_user_vote puv;

-- create downvote only


-- create downvote only
WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	downvotes AS (
		SELECT
			regexp_split_to_table(bp.downvotes, ',') username,
			bp.title
		FROM bad_posts bp
	),
	post_user_vote AS (
		SELECT 
			p.post_id,
			p.title,
			u.user_id,
			u.username
		FROM downvotes
		JOIN posts p ON p.title = downvotes.title
		JOIN users u ON u.username = downvotes.username
	) 
INSERT INTO votes (
	user_id,
	post_id,
	score,
	created_at,
	updated_at
)
SELECT 
	puv.user_id,
	puv.post_id,
	-1,
	(SELECT dt from random_time), 
    (SELECT dt from random_time)	
FROM post_user_vote puv;



------------------------------ COMMENTS TABLE ---------------------------------------------
-- create new comments

WITH random_time AS (
		SELECT 
            FLOOR(random() * (1609430400-1546272000+1) + 1546272000) as dt),
	comment_user_post AS (
		SELECT 
			bc.id comment_id,
			u.user_id,
			p.post_id,
			bc.text_content
		FROM bad_comments bc
		JOIN posts p
		ON bc.post_id = p.post_id
		JOIN users u
		ON u.username = bc.username
	)
INSERT INTO comments (
	comment_id,
	user_id,
	post_id,
	parent_comment_id,
	comment_text,
	created_at,
	updated_at
) 
SELECT 
	cup.comment_id,
	cup.user_id,
	cup.post_id,
	null,
	cup.text_content,
	(SELECT dt from random_time), 
    (SELECT dt from random_time)	
FROM comment_user_post cup;

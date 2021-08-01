
----------------------------------------------------------------------------	
-- List all users who haven’t logged in in the last year.
CREATE INDEX login_time ON users (login_time);

SELECT *
FROM users
WHERE login_time < 1577808000 -- 1577808000 is Jan/01/2020
ORDER BY login_time ;

----------------------------------------------------------------------------
-- List all users who haven’t created any post. 
-- primary key of users is indexed
with user_post AS (
    SELECT u.user_id
    FROM users u
    JOIN posts p
    ON p.user_id = u.user_id
)
SELECT *
FROM users u
JOIN user_post up
ON NOT u.user_id = up.user_id;

----------------------------------------------------------------------------
-- Find a user by their username.
CREATE INDEX username ON users (username VARCHAR_PATTERN_OPS);

SELECT * 
FROM users
WHERE username = '';

----------------------------------------------------------------------------
-- List all topics that don’t have any posts.
-- primary key of topics is indexed
with topic_post AS (
    SELECT t.topic_id
    FROM topics t
    JOIN posts p
    ON t.topic_id = p.topic_id
)
SELECT *
FROM topics t
JOIN topic_post tp
ON NOT t.topic_id = tp.topic_id;

----------------------------------------------------------------------------
-- Find a topic by its name.
CREATE INDEX topic_name ON topics (topic_name VARCHAR_PATTERN_OPS);
SELECT *
FROM topics 
WHERE topic_name = '';

----------------------------------------------------------------------------
-- List the latest 20 posts for a given topic.
CREATE INDEX latest_post_by_topic ON posts (topic_id, created_at);
SELECT *
FROM posts p
JOIN topics t
ON p.topic_id = t.topic_id
WHERE t.topic_name = ''
ORDER BY p.created_at DESC
LIMIT 20;

----------------------------------------------------------------------------
-- List the latest 20 posts made by a given user.
CREATE INDEX latest_post_by_user ON posts (user_id, created_at);
SELECT *
FROM posts p
JOIN users u
ON u.user_id = p.user_id
WHERE u.username = ''
ORDER BY p.created_at DESC
LIMIT 20;

----------------------------------------------------------------------------
-- Find all posts that link to a specific URL, for moderation purposes. 
CREATE INDEX post_url ON posts (url VARCHAR_PATTERN_OPS);

SELECT *
FROM posts p
WHERE p.url = '';

----------------------------------------------------------------------------
-- List all the top-level comments (those that don’t have a parent comment) for a given post.
-- primary key of comments is indexed 
SELECT * 
FROM comments c
WHERE c.parent_comment_id IS NULL;

----------------------------------------------------------------------------
-- List all the direct children of a parent comment.
CREATE INDEX parent_comment_id ON comments (parent_comment_id);

SELECT * 
FROM comments c
WHERE c.parent_comment_id = 0;

----------------------------------------------------------------------------
-- List the latest 20 comments made by a given user.
CREATE INDEX comment_user_id ON comments (user_id, created_at);

SELECT * 
FROM comments c
JOIN users u
ON u.user_id = c.user_id
WHERE u.username = ''
LIMIT 20;

----------------------------------------------------------------------------
-- Compute the score of a post, defined as the difference between the number of upvotes and the number of downvotes
CREATE INDEX vote_score ON votes (score);

SELECT SUM(v.score)
FROM votes v
WHERE v.post_id = 3;
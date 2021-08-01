CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(25) UNIQUE NOT NULL,
	login_time INT,
	--timestamp
	created_at INT,
	updated_at INT
);
ALTER TABLE users ADD CONSTRAINT required_username CHECK (LENGTH(username) > 0);

CREATE TABLE topics (
	topic_id SERIAL PRIMARY KEY,
	topic_name VARCHAR(30) UNIQUE NOT NULL,
	description TEXT,
	-- timestamp
	created_at INT,
	updated_at INT
);
ALTER TABLE topics ADD CONSTRAINT  required_topic_name CHECK (LENGTH(topic_name) > 0);


CREATE TABLE posts (
	post_id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	url VARCHAR(2000) DEFAULT NULL,
	text_content TEXT DEFAULT NULL,
	CONSTRAINT "url_or_text"
		CHECK(url IS NOT NULL AND text_content IS NULL OR
			  url IS NULL AND text_content IS NOT NULL),
    -- relation
	user_id INT REFERENCES users (user_id) ON DELETE SET NULL,
	topic_id INT REFERENCES topics (topic_id) ON DELETE CASCADE,
	-- timestamp
	created_at INT,
	updated_at INT
);

ALTER TABLE posts ADD CONSTRAINT required_title CHECK (LENGTH(title) > 0);

CREATE TABLE votes (
	vote_id SERIAL PRIMARY KEY,
	score SMALLINT NOT NULL,
	--relation
	user_id INT,
	FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL,
	post_id INT,
	FOREIGN KEY (post_id) REFERENCES posts (post_id) ON DELETE CASCADE,
	-- timestamp
	created_at INT,
	updated_at INT
);
ALTER TABLE votes ADD CONSTRAINT post_user_only_once UNIQUE (user_id, post_id);
	
CREATE TABLE comments (
	comment_id SERIAL PRIMARY KEY,
	comment_text TEXT ,
	--relation
	post_id INT,
	FOREIGN KEY (post_id) REFERENCES posts (post_id) ON DELETE CASCADE,
	parent_comment_id INT,
	FOREIGN KEY (comment_id) REFERENCES comments (comment_id) ON DELETE CASCADE,
	user_id INT,
	FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL,
	-- timestamp
	created_at INT,
	updated_at INT
);
ALTER TABLE comments ADD CONSTRAINT required_comment_text CHECK (LENGTH(comment_text) > 0);

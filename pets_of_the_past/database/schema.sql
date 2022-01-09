CREATE DATABASE pets_at_peace;

--cremember to connect =)

CREATE TABLE pets (
    id SERIAL PRIMARY KEY,
    name TEXT,
    image_url TEXT,
    --description TEXT,
    user_id INTEGER
);

INSERT INTO
pets (name, image_url)
VALUES ( 'Ginger', 'https://i.imgur.com/xw46Ob1.jpg' );

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT,
    password_digest TEXT
);

create table comments (
    id SERIAL PRIMARY KEY,
    pet_id INTEGER,
    body TEXT,
    user_id INTEGER ,
    created_at TIMESTAMP
);


--get likes by using a new table  this will have a post id and user id  you can see if the user has already liked the post (select * from likes where post id = user)
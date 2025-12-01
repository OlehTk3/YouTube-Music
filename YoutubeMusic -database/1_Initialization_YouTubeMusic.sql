create database YouTubeMusicDB

use YouTubeMusicDB

CREATE TABLE Artist (
    artist_id INT PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(50),
    genre VARCHAR(50),
    birth_year date,
    biography varchar(max)
);

CREATE TABLE Album (
    album_id INT PRIMARY KEY,
    title VARCHAR(100),
    release_year INT,
    cover_url VARCHAR(255),
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);

CREATE TABLE Song (
    song_id INT PRIMARY KEY,
    title VARCHAR(100),
    duration INT,
    release_date DATE,
    language VARCHAR(50),
    album_id INT,
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
);

CREATE TABLE UserAccount (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    password VARCHAR(100),
    country VARCHAR(50),
    birth_date DATE,
    gender VARCHAR(10),
    registration_date DATE
);

CREATE TABLE Playlist (
    playlist_id INT PRIMARY KEY,
    name VARCHAR(100),
    created_at DATE,
    privacy_status VARCHAR(20),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id)
);

CREATE TABLE PlaylistItem (
    playlist_item_id INT PRIMARY KEY,
    added_at DATE,
    position_number INT,
    playlist_id INT,
    song_id INT,
    FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
    FOREIGN KEY (song_id) REFERENCES Song(song_id)
);

CREATE TABLE UserLikesSong (
    like_id INT PRIMARY KEY,
    liked_at DATE,
    user_id INT,
    song_id INT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id),
    FOREIGN KEY (song_id) REFERENCES Song(song_id)
);

CREATE TABLE Comment (
    comment_id INT PRIMARY KEY,
    content TEXT,
    posted_at DATETIME,
    user_id INT,
    song_id INT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id),
    FOREIGN KEY (song_id) REFERENCES Song(song_id)
);

CREATE TABLE Subscription (
    subscription_id INT PRIMARY KEY,
    type VARCHAR(20),
    start_date DATE,
    end_date DATE,
    payment_method VARCHAR(50),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id)
);

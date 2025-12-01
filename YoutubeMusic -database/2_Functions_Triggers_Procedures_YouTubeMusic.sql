/*Функции
1. Функция за броене на лайковете на песен*/
CREATE FUNCTION GetSongLikes(@song_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @likes INT;
    SELECT @likes = COUNT(*) FROM UserLikesSong WHERE song_id = @song_id;
    RETURN @likes;
END;

-- Проверка за песен с ID = 50
SELECT dbo.GetSongLikes(50) AS LikesCount;



/*2. Функция за проверка дали даден потребител има Premium абонамент*/
CREATE FUNCTION IsPremiumUser(@user_id INT)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    IF EXISTS (
        SELECT 1 FROM Subscription
        WHERE user_id = @user_id AND type = 'Premium'
    )
        SET @result = 1;
    RETURN @result;
END;

-- Проверка за потребител с ID = 5
SELECT dbo.IsPremiumUser(5) AS IsPremium;

-- Проверка за потребител с ID = 2
SELECT dbo.IsPremiumUser(2) AS IsPremium;



/*Съхранени процедури
1. Процедура за намиране 5 TopLikedSongs*/
CREATE PROCEDURE TopLikedSongs
AS
BEGIN
    SELECT TOP 5 
           s.song_id, 
           s.title, 
           COUNT(ul.like_id) AS likes_count
    FROM Song s
    JOIN UserLikesSong ul ON s.song_id = ul.song_id
    GROUP BY s.song_id, s.title
    ORDER BY likes_count DESC, s.song_id ASC;
END;

-- Извикване на процедурата
EXEC TopLikedSongs;

/*2. Процедура за връщане на всички песни в даден плейлист*/
CREATE PROCEDURE GetPlaylistSongs
    @playlist_id INT
AS
BEGIN
    SELECT s.song_id, s.title, s.duration, s.release_date
    FROM PlaylistItem pi
    JOIN Song s ON pi.song_id = s.song_id
    WHERE pi.playlist_id = @playlist_id
    ORDER BY pi.position_number;
END;

-- Извикване на процедурата за плейлист с ID = 5
EXEC GetPlaylistSongs @playlist_id = 5;

/*Тригери
1. Тригър за автоматично задаване на дата при нов лайк*/
CREATE TRIGGER trg_SetLikeDate
ON UserLikesSong
AFTER INSERT
AS
BEGIN
    UPDATE UserLikesSong
    SET liked_at = GETDATE()
    WHERE like_id IN (SELECT like_id FROM inserted);
END;

-- Вмъкваме нов лайк без да задаваме дата
INSERT INTO UserLikesSong (like_id, user_id, song_id)
VALUES (201, 1, 10);

-- Проверяваме дали тригерът е попълнил датата
SELECT like_id, user_id, song_id, liked_at
FROM UserLikesSong
WHERE like_id = 201;

/*2.Тригър: автоматично задаване на текуща дата при добавяне на нов коментар*/
CREATE TRIGGER trg_SetCommentDate
ON Comment
AFTER INSERT
AS
BEGIN
    UPDATE Comment
    SET posted_at = GETDATE()
    WHERE comment_id IN (SELECT comment_id FROM inserted);
END;

-- Вмъкваме нов коментар без да задаваме дата
INSERT INTO Comment (comment_id, content, user_id, song_id)
VALUES (101, 'Test trigger comment', 2, 15);

-- Проверяваме дали тригерът е попълнил датата
SELECT comment_id, content, posted_at, user_id, song_id
FROM Comment
WHERE comment_id = 101;










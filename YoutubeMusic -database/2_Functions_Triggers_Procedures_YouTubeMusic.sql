/*Съхранени процедури
1. Процедура за намиране 5 TopLikedSongs*/

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('UserAccount','Song','UserLikesSong','Comment','Playlist','PlaylistItem');




CREATE OR ALTER PROCEDURE TopLikedSongs
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

-- Èçâèêâàíå íà ïðîöåäóðàòà
EXEC TopLikedSongs;

/*2. Ïðîöåäóðà çà âðúùàíå íà âñè÷êè ïåñíè â äàäåí ïëåéëèñò*/
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

-- Èçâèêâàíå íà ïðîöåäóðàòà çà ïëåéëèñò ñ ID = 5
EXEC GetPlaylistSongs @playlist_id = 5;

-- Ìîæåø äà ïðîáâàø è ñ äðóã ïëåéëèñò
EXEC GetPlaylistSongs @playlist_id = 10;

/*Ôóíêöèè
1. Ôóíêöèÿ çà áðîåíå íà ëàéêîâåòå íà ïåñåí*/
CREATE FUNCTION GetSongLikes(@song_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @likes INT;
    SELECT @likes = COUNT(*) FROM UserLikesSong WHERE song_id = @song_id;
    RETURN @likes;
END;

-- Ïðîâåðêà çà ïåñåí ñ ID = 50
SELECT dbo.GetSongLikes(50) AS LikesCount;

-- Ìîæåø äà ïðîáâàø è ñ äðóãà ïåñåí
SELECT dbo.GetSongLikes(1) AS LikesCount;


/*2. Ôóíêöèÿ çà ïðîâåðêà äàëè äàäåí ïîòðåáèòåë èìà Premium àáîíàìåíò*/
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

-- Ïðîâåðêà çà ïîòðåáèòåë ñ ID = 5
SELECT dbo.IsPremiumUser(5) AS IsPremium;

-- Ïðîâåðêà çà ïîòðåáèòåë ñ ID = 2
SELECT dbo.IsPremiumUser(2) AS IsPremium;


/*Òðèãåðè
1. Òðèãúð çà àâòîìàòè÷íî çàäàâàíå íà äàòà ïðè íîâ ëàéê*/
CREATE TRIGGER trg_SetLikeDate
ON UserLikesSong
AFTER INSERT
AS
BEGIN
    UPDATE UserLikesSong
    SET liked_at = GETDATE()
    WHERE like_id IN (SELECT like_id FROM inserted);
END;

-- Âìúêâàìå íîâ ëàéê áåç äà çàäàâàìå äàòà
INSERT INTO UserLikesSong (like_id, user_id, song_id)
VALUES (201, 1, 10);

-- Ïðîâåðÿâàìå äàëè òðèãåðúò å ïîïúëíèë äàòàòà
SELECT like_id, user_id, song_id, liked_at
FROM UserLikesSong
WHERE like_id = 201;

/*2.Òðèãúð: àâòîìàòè÷íî çàäàâàíå íà òåêóùà äàòà ïðè äîáàâÿíå íà íîâ êîìåíòàð*/
CREATE TRIGGER trg_SetCommentDate
ON Comment
AFTER INSERT
AS
BEGIN
    UPDATE Comment
    SET posted_at = GETDATE()
    WHERE comment_id IN (SELECT comment_id FROM inserted);
END;

-- Âìúêâàìå íîâ êîìåíòàð áåç äà çàäàâàìå äàòà
INSERT INTO Comment (comment_id, content, user_id, song_id)
VALUES (101, 'Test trigger comment', 2, 15);

-- Ïðîâåðÿâàìå äàëè òðèãåðúò å ïîïúëíèë äàòàòà
SELECT comment_id, content, posted_at, user_id, song_id
FROM Comment
WHERE comment_id = 101;






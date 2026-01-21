CREATE DATABASE Music
USE Music

CREATE TABLE Albums
(
    AlbumID INT NOT NULL,
    AlbumName NVARCHAR(100) NOT NULL,
    CreatedDate SMALLDATETIME NOT NULL,
    Price MONEY NOT NULL
)

CREATE TABLE Artists
(
    ArtistID INT NOT NULL,
    ArtistName NVARCHAR(100) NOT NULL
)

CREATE TABLE Songs
(
    SongID INT NOT NULL,
    SongName NVARCHAR(100) NOT NULL,
    ArtistID INT NOT NULL
)

CREATE TABLE AlbumSong
(
    SongID INT NOT NULL,
    AlbumID INT NOT NULL
)

ALTER TABLE Songs
ADD CONSTRAINT PK_Songs PRIMARY KEY (SongID)

ALTER TABLE Albums
ADD CONSTRAINT PK_Albums PRIMARY KEY (AlbumID)

ALTER TABLE Artists
ADD CONSTRAINT PK_Artists PRIMARY KEY (ArtistID)

ALTER TABLE AlbumSong
ADD CONSTRAINT PK_AlbumSong PRIMARY KEY (AlbumID,SongID)

ALTER TABLE Songs
ADD CONSTRAINT FK_Songs_Artists
FOREIGN KEY(ArtistID)
REFERENCES Artists(ArtistID)

ALTER TABLE AlbumSong
ADD CONSTRAINT FK_AlbumSong_Songs
FOREIGN KEY(SongID)
REFERENCES Songs(SongID)

ALTER TABLE AlbumSong
ADD CONSTRAINT FK_AlbumSong_Albums
FOREIGN KEY(AlbumID)
REFERENCES Albums(AlbumID)

ALTER TABLE Albums
ADD CONSTRAINT CHK_Albums CHECK (CreatedDate >= '1990-01-01' AND CreatedDate <= GETDATE())

ALTER TABLE Artists
ADD CONSTRAINT UQ_Artists_ArtistName UNIQUE (ArtistName)

INSERT INTO Artists
VALUES
    (1, 'Trong Tan'),
    (2, 'Dang Duong'),
    (3, 'Anh Tho'),
    (4, 'Viet Hoan'),
    (5, 'Lan Anh')

INSERT INTO Songs
VALUES
    (1, 'Bai ca Ha Noi', 1),
    (2, 'Hat ve cay lua hom nay', 1),
    (3, 'Gui em chiec non bai tho', 1),
    (4, 'Ho Bien', 2),
    (5, 'Tinh ca', 2),
    (6, 'Me yeu con', 3),
    (7, 'Dau chan trong rung', 3),
    (8, 'Tinh ca', 4),
    (9, 'Tinh em', 4),
    (10, 'Tinh ta bien bac dong xanh', 4),
    (11, 'Me yeu con', 5),
    (12, 'Trang chieu', 5)

INSERT INTO Albums
VALUES
    (1, 'Viet Nam que huong toi', '2001-01-02', 10),
    (2, 'Tinh ca', '2001-03-12', 15),
    (3, 'Tuyen chon nu ca sy', '2003-04-12', 20)

INSERT INTO AlbumSong
VALUES
    (1, 1),
    (1, 2),
    (1, 4),
    (1, 10),
    (2, 3),
    (2, 5),
    (2, 6),
    (2, 8),
    (2, 9),
    (3, 11),
    (3, 7),
    (3, 12)

UPDATE Songs
SET
    SongName = 'Giai dieu to quoc'
WHERE SongName = 'Tinh ca'

UPDATE AlbumSong
SET AlbumID = (
    SELECT AlbumID
FROM Albums
WHERE AlbumName = 'Viet Nam que huong toi'
)
WHERE AlbumID = (
    SELECT AlbumID
    FROM Albums
    WHERE AlbumName = 'Tinh ca'
)
    AND SongID IN (
    SELECT SongID
    FROM Songs
    WHERE SongName = 'Giai dieu to quoc'
);

UPDATE Albums
SET
    Price = Price + Price * 0.1
WHERE CreatedDate <= '2002-01-01'

DELETE FROM AlbumSong
WHERE SongID IN (
    SELECT SongID
FROM Songs
WHERE ArtistID = (
        SELECT ArtistID
FROM Artists
WHERE ArtistName = 'Lan Anh'
    )
)

DELETE FROM Songs
WHERE ArtistID = (
    SELECT ArtistID
FROM Artists
WHERE ArtistName = 'Lan Anh'
)

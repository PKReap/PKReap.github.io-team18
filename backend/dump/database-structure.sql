DROP SCHEMA MusicLibrary;
CREATE SCHEMA IF NOT EXISTS MusicLibrary;

USE MusicLibrary;

CREATE TABLE
    IF NOT EXISTS Users (
        Username VARCHAR(50) NOT NULL UNIQUE,
        UserPassword VARCHAR(65) NOT NULL,
        UserType ENUM("Admin", "Artist", "User") NOT NULL,
        IsDeleted BOOLEAN NOT NULL DEFAULT FALSE,
	    UserLevel INT NOT NULL DEFAULT 0,
        PlaylistLimit INT NOT NULL DEFAULT 5,
        PRIMARY KEY (Username)
    );


CREATE TABLE
    IF NOT EXISTS Playlists (
        PlaylistID INT NOT NULL AUTO_INCREMENT,
        Username VARCHAR(50) NOT NULL,
        PlaylistName VARCHAR(50) NOT NULL,
        SizeLimit INT DEFAULT 10,
        IsDeleted BOOLEAN NOT NULL DEFAULT FALSE,
        PRIMARY KEY (PlaylistID),
        FOREIGN KEY (Username) REFERENCES Users(Username)
    );

CREATE TABLE
    IF NOT EXISTS Libraries (
        PRIMARY KEY (LibraryID),
        ArtistName VARCHAR(50) NOT NULL,
        LibraryID INT NOT NULL AUTO_INCREMENT,
        LibraryName VARCHAR(200) NOT NULL,
        IsDeleted BOOLEAN NOT NULL DEFAULT FALSE,
        FOREIGN KEY (ArtistName) REFERENCES Users(Username)
    );


CREATE TABLE
    IF NOT EXISTS Tracks (
        PRIMARY KEY (TrackID),
        TrackID INT NOT NULL AUTO_INCREMENT,
        TrackName VARCHAR(200) NOT NULL,
        ArtistName VARCHAR(50) NOT NULL,
        LibraryName VARCHAR(200) NOT NULL,
        AverageRating DECIMAL(3,2) DEFAULT 0,
        TrackGenre VARCHAR(50),
        Link VARCHAR(500) NOT NULL,
        IMG VARCHAR(500) NOT NULL,
        IsDeleted BOOLEAN NOT NULL DEFAULT FALSE
    );

CREATE TABLE
    IF NOT EXISTS Playlist_Tracks (
        PRIMARY KEY (PTID),
        PTID INT NOT NULL AUTO_INCREMENT,
        PlaylistID INT NOT NULL,
        TrackID INT NOT NULL,
        IsDeleted BOOLEAN NOT NULL DEFAULT FALSE,
        FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
        FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID)
    );

CREATE TABLE
    IF NOT EXISTS Library_Tracks (
        PRIMARY KEY (LTID),
        LTID INT NOT NULL AUTO_INCREMENT,
        LibraryID INT NOT NULL,
        TrackID INT NOT NULL,
                IsDeleted BOOLEAN NOT NULL DEFAULT FALSE,

        FOREIGN KEY (LibraryID) REFERENCES Libraries(LibraryID),
		FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID)
    );

CREATE TABLE 
    IF NOT EXISTS TrackRatings (
        PRIMARY KEY (RatingID),
        RatingID INT NOT NULL AUTO_INCREMENT,
        TrackID INT NOT NULL,
        Rating INT DEFAULT 0,
        IsDeleted BOOLEAN NOT NULL DEFAULT FALSE,
        Username VARCHAR(50) NOT NULL,
        FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID),
        FOREIGN KEY (Username) REFERENCES Users(Username)
    );

INSERT INTO Users (Username, UserPassword, UserType) VALUES ("Artist1", "0f9776d02808a35d76bb18b6215b091cb592806b913469e1e9413b45406edc71", "Artist");
INSERT INTO Users (Username, UserPassword, UserType) VALUES ("User1", "625089b9a6aea286ad1795d1f877928741d702e38e4be85417b5558160e58914", "User");
INSERT INTO Users (Username, UserPassword, UserType) VALUES ("Admin1", "c4d478fa208d534cc1265bc69b7802f3c29375f3ff5aaea5b4636fcae4229c40", "Admin");

INSERT INTO Libraries (LibraryName, ArtistName) VALUES ("Dance Dance Revolution", "Artist1");
INSERT INTO Libraries (LibraryName, ArtistName) VALUES ("Electric Boogaloo", "Artist1");




delimiter //
CREATE TRIGGER calc_avg_rating_update 
    AFTER UPDATE ON TrackRatings
    FOR EACH ROW
    BEGIN
        UPDATE Tracks
        SET AverageRating = (SELECT AVG(Rating) FROM TrackRatings WHERE TrackID = NEW.TrackID AND IsDeleted = FALSE AND Rating != 0)
        WHERE TrackID = NEW.TrackID;
    END; //
delimiter ;


INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Dubstep", "Artist1", "Electronic", "https://www.bensound.com/bensound-music/bensound-dubstep.mp3", "Dance Dance Revolution", "https://www.bensound.com/bensound-img/dubstep.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (1, 1);

INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Better Days", "Artist1", "Contry","https://www.bensound.com/bensound-music/bensound-betterdays.mp3", "Electric Boogaloo", "https://www.bensound.com/bensound-img/betterdays.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (2, 2);
 
INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Funny Song", "Artist1", "Parody","https://www.bensound.com/bensound-music/bensound-funnysong.mp3", "Electric Boogaloo", "https://www.bensound.com/bensound-img/betterdays.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (2, 3);

INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Slow Motion", "Artist1", "Ambiance", "https://www.bensound.com/bensound-music/bensound-slowmotion.mp3", "Electric Boogaloo", "https://www.bensound.com/bensound-img/sunny.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (2, 4);

INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Adventure", "Artist1", "Ambiance", "https://www.bensound.com/bensound-music/bensound-adventure.mp3", "Dance Dance Revolution","https://www.bensound.com/bensound-img/energy.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (1, 5);

INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Inspire", "Artist1", "Ambiance", "https://www.bensound.com/bensound-music/bensound-inspire.mp3", "Dance Dance Revolution", "https://www.bensound.com/bensound-img/indiebox.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (1, 6);  

INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Evolution", "Artist1", "Ambiance", "https://www.bensound.com/bensound-music/bensound-evolution.mp3", "Dance Dance Revolution", "https://www.bensound.com/bensound-img/slowmotion.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (1, 7);

INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Piano Moment", "Artist1", "Classical",  "https://www.bensound.com/bensound-music/bensound-pianomoment.mp3", "Electric Boogaloo", "https://www.bensound.com/bensound-img/clearday.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (2, 8);

INSERT INTO Tracks (TrackName, ArtistName, TrackGenre, Link, LibraryName, IMG) 
VALUES("Dance", "Artist1", "Pop", "https://www.bensound.com/bensound-music/bensound-dance.mp3", "Electric Boogaloo", "https://www.bensound.com/bensound-img/evolution.jpg");
INSERT INTO Library_Tracks (LibraryID, TrackID) VALUES (2, 9);

INSERT INTO Playlists(PlaylistName, Username) VALUES ("Playlist1", "User1");

INSERT INTO Playlist_Tracks (PlaylistID, TrackID) VALUES (1, 1);

INSERT INTO TrackRatings (Username, TrackID, Rating) VALUES ("User1", 1, 0);
INSERT INTO TrackRatings (Username, TrackID, Rating) VALUES ("User1", 2, 0);
INSERT INTO TrackRatings (Username, TrackID, Rating) VALUES ("User1", 3, 0);
INSERT INTO TrackRatings (Username, TrackID, Rating) VALUES ("User1", 4, 0);
INSERT INTO TrackRatings (Username, TrackID, Rating) VALUES ("User1", 5, 0);
CREATE VIEW Playlist_Tracks_View AS
    SELECT Playlist_Tracks.PlaylistID, Playlist_Tracks.TrackID, Tracks.TrackName, Tracks.ArtistName, Tracks.TrackGenre, Tracks.Link, Tracks.LibraryName, Tracks.IMG,
    Playlist_Tracks.IsDeleted
    FROM Playlist_Tracks
    INNER JOIN Tracks ON Playlist_Tracks.TrackID = Tracks.TrackID;
    
CREATE VIEW Library_Tracks_View AS
    SELECT Library_Tracks.LibraryID, Library_Tracks.TrackID, Tracks.TrackName, Tracks.ArtistName, Tracks.TrackGenre, Tracks.Link, Tracks.LibraryName, Tracks.AverageRating, Tracks.IMG, Library_Tracks.IsDeleted
    FROM Library_Tracks
    INNER JOIN Tracks ON Library_Tracks.TrackID = Tracks.TrackID;

delimiter //
CREATE TRIGGER on_rating_change
    AFTER UPDATE ON TrackRatings
    FOR EACH ROW
    BEGIN
    UPDATE Users
        SET PlaylistLimit = 5 + FLOOR((SELECT COUNT(Username) FROM TrackRatings WHERE Username = NEW.Username AND Rating > 0 AND IsDeleted = False) / 5)
        WHERE Username = NEW.Username;
    END; //
delimiter ;


INSERT TrackRatings (Username, TrackID, Rating) VALUES ("Admin1", 1, 0);
UPDATE TrackRatings SET Rating = 3 WHERE Username = "Admin1" AND TrackID = 1;


SELECT * FROM Tracks;

ALTER TABLE Users MODIFY UserPassword VARCHAR(65) NOT NULL;

UPDATE Users SET UserPassword = "0f9776d02808a35d76bb18b6215b091cb592806b913469e1e9413b45406edc71" WHERE Username = "Admin1";

UPDATE Users SET UserPassword = "742ebf46c0773cb3f7299d02839ca3b66f70be91f0576fa24cc800bcc0ca8cc7" WHERE Username = "User1";

UPDATE Users SET UserPassword = "625089b9a6aea286ad1795d1f877928741d702e38e4be85417b5558160e58914" WHERE Username = "Artist1";

-- SET ALL RATINGS TO 1
SELECT * FROM Playlist_Tracks_View;

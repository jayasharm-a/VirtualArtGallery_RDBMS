
--CODING  CHALLENGE - 5 (VIRTUAL ART GALLERY)


CREATE DATABASE Art_Gallery;

use Art_Gallery;

-- Create the Artists table
CREATE TABLE Artists (
ArtistID INT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Biography TEXT,
Nationality VARCHAR(100));
-- Create the Categories table
CREATE TABLE Categories (
CategoryID INT PRIMARY KEY,
Name VARCHAR(100) NOT NULL);
-- Create the Artworks table
CREATE TABLE Artworks (
ArtworkID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
ArtistID INT,
CategoryID INT,
Year INT,
Description TEXT,
ImageURL VARCHAR(255),
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));
-- Create the Exhibitions table
CREATE TABLE Exhibitions (
ExhibitionID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL,
StartDate DATE,
EndDate DATE,
Description TEXT);
-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
ExhibitionID INT,
ArtworkID INT,
PRIMARY KEY (ExhibitionID, ArtworkID),
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));




-- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');
-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');
-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\s powerful anti-war mural.', 'guernica.jpg');
-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');
-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);



--Solve the below queries:

--1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and
--list them in descending order of the number of artworks.

select A.Name, COUNT(B.ArtworkID) as ArtworkCount from Artists A
LEFT JOIN Artworks B ON A.ArtistID = B.ArtistID
GROUP BY A.Name ORDER BY ArtworkCount DESC


--2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order
--them by the year in ascending order.

SELECT A.Title FROM Artworks A
JOIN Artists B ON A.ArtistID = B.ArtistID
WHERE B.Nationality IN ('Spanish', 'Dutch') ORDER BY A.Year ASC

--3. Find the names of all artists who have artworks in the 'Painting' category, and the number of
--artworks they have in this category.

SELECT B.Name, COUNT(A.ArtworkID) AS ArtworkCount FROM Artists B
JOIN Artworks A ON B.ArtistID = A.ArtistID
JOIN Categories ON A.CategoryID = Categories.CategoryID
WHERE Categories.Name = 'Painting' GROUP BY B.Name

--4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their
--artists and categories. 

SELECT A.Title, Artists.Name AS Artist, Categories.Name AS Category FROM Artworks A
JOIN ExhibitionArtworks E ON A.ArtworkID = E.ArtworkID
JOIN Exhibitions ON E.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON A.ArtistID = Artists.ArtistID
JOIN Categories ON A.CategoryID = Categories.CategoryID
WHERE Exhibitions.Title = 'Modern Art Masterpieces'

--5. Find the artists who have more than two artworks in the gallery.

SELECT A.Name, COUNT(B.ArtworkID) AS ArtworkCount FROM Artists A
LEFT JOIN Artworks B ON A.ArtistID = B.ArtistID
GROUP BY A.Name HAVING COUNT(B.ArtworkID)>2

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and
--'Renaissance Art' exhibitions

SELECT A.Title FROM Artworks A
JOIN ExhibitionArtworks E ON A.ArtworkID = E.ArtworkID
JOIN Exhibitions S ON E.ExhibitionID = S.ExhibitionID
WHERE S.Title IN ('Modern Art Masterpieces', 'Renaissance Art')
GROUP BY A.Title HAVING COUNT(DISTINCT S.Title)= 2


--7. Find the total number of artworks in each category

SELECT C.Name, COUNT(A.ArtworkID) AS ArtworkCount
FROM Categories C LEFT JOIN Artworks A ON C.CategoryID = A.CategoryID
GROUP BY C.Name

--8. List artists who have more than 3 artworks in the gallery.

SELECT A.Name, COUNT(B.ArtworkID) AS ArtworkCount
FROM Artists A JOIN Artworks B ON A.ArtistID = B.ArtistID
GROUP BY A.Name
HAVING COUNT(B.ArtworkID) > 3

--9. Find the artworks created by artists from a specific nationality (e.g., Spanish).


SELECT A.Title, B.Name, B.Nationality
FROM Artworks A
JOIN Artists B ON A.ArtistID = B.ArtistID
WHERE B.Nationality = 'Spanish'

--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.

SELECT e.Title, e.StartDate, e.EndDate
FROM Exhibitions e JOIN ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID
JOIN Artworks a ON ea.ArtworkID = a.ArtworkID
JOIN Artists lt ON a.ArtistID = lt.ArtistID
WHERE lt.Name = 'Vincent van Gogh' AND lt.Name = 'Leonardo da Vinci'

--11. Find all the artworks that have not been included in any exhibition.

SELECT * FROM Artworks a
LEFT JOIN ExhibitionArtworks ea ON a.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL

--12. List artists who have created artworks in all available categories.


SELECT a.ArtistID, a.Name
FROM Artists a WHERE not EXISTS (SELECT DISTINCT c.CategoryID FROM Categories c WHERE  EXISTS (
SELECT * FROM Artworks aw
WHERE aw.ArtistID = a.ArtistID AND aw.CategoryID = c.CategoryID))

--13. List the total number of artworks in each category.

SELECT c.CategoryID, c.Name, COUNT(*) AS TotalArtworks
FROM Categories c LEFT JOIN Artworks a ON c.CategoryID = a.CategoryID
GROUP BY c.CategoryID, c.Name

--14. Find the artists who have more than 2 artworks in the gallery.

SELECT a.ArtistID, a.Name, COUNT(*) AS TotalArtworks
FROM Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(*) > 2;

--15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.


SELECT c.CategoryID, c.Name, AVG(aw.Year) AS AvgYear
FROM Categories c JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name
HAVING COUNT(aw.ArtworkID) > 1;

--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.


SELECT aw.ArtworkID, aw.Title
FROM Artworks aw JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces';

--17. Find the categories where the average year of artworks is greater than the average year of all artworks.

SELECT c.CategoryID, c.Name, AVG(aw.Year) AS AvgYear
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.CategoryID, c.Name
HAVING AVG(aw.Year) > (SELECT AVG(Year) FROM Artworks);


--18. List the artworks that were not exhibited in any exhibition.

SELECT aw.ArtworkID, aw.Title
FROM Artworks aw
LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL;


--19. Show artists who have artworks in the same category as "Mona Lisa."

SELECT a.ArtistID, a.Name FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID WHERE aw.CategoryID IN (
SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa') AND a.ArtistID != (SELECT ArtistID FROM Artworks WHERE Title = 'Mona Lisa');

--20. List the names of artists and the number of artworks they have in the gallery.


SELECT a.ArtistID, a.Name, COUNT(aw.ArtworkID) AS TotalArtworks
FROM Artists a LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name;

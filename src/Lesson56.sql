CREATE TABLE Publishers(
            PublisherID SERIAL PRIMARY KEY,
            Name VARCHAR(100)
);

CREATE TABLE Books(
            BookID SERIAL PRIMARY KEY,
            Title VARCHAR(100),
            PublicationYear INT,
            PublisherID INT,
            FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);

CREATE TABLE Authors(
            AuthorID SERIAL PRIMARY KEY,
            FirstName VARCHAR(100),
            LastName VARCHAR(100)
);

CREATE TABLE BookAuthors(
            BookID INT,
            AuthorID INT,
            PRIMARY KEY (BookID, AuthorID),
            FOREIGN KEY (BookID) REFERENCES Books(BookID),
            FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

INSERT INTO Publishers (Name) VALUES
            ('Эксмо'),
            ('АСТ'),
            ('Манн, Иванов и Фербер');

INSERT INTO Authors (FirstName, LastName) VALUES
            ('Лев', 'Толстой'),
            ('Фёдор', 'Достоевский'),
            ('Александр', 'Пушкин'),
            ('Михаил', 'Булгаков');

INSERT INTO Books (Title, PublicationYear, PublisherID) VALUES
            ('Война и мир', 1985, 1),         -- Книга издана Эксмо
            ('Преступление и наказание', 1990, 2), -- Книга издана АСТ
            ('Евгений Онегин', 1978, 3),     -- Книга издана МИФ
            ('Мастер и Маргарита', 1995, 1); -- Книга издана Эксмо

INSERT INTO BookAuthors (BookID, AuthorID) VALUES
            (1, 1), -- Лев Толстой написал "Войну и мир"
            (2, 2), -- Фёдор Достоевский написал "Преступление и наказание"
            (3, 3), -- Александр Пушкин написал "Евгения Онегина"
            (4, 4); -- Михаил Булгаков написал "Мастера и Маргариту"

-- Добавим пример с несколькими авторами для одной книги
INSERT INTO BookAuthors (BookID, AuthorID) VALUES
    (1, 4); -- Предположим, что Михаил Булгаков также участвовал в написании "Войны и мира"
--(пример для демонстрации связи многие-ко-многим)

SELECT
    b.Title AS BookTitle,
    p.Name AS PublisherName
FROM
    Books b
        JOIN
    Publishers p ON b.PublisherID = p.PublisherID;
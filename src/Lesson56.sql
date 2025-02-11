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

ALTER TABLE Books ADD COLUMN Price DECIMAL(10, 2);

-- Заполняем поле price для существующих книг
UPDATE Books SET Price = 500 WHERE BookID = 1;
UPDATE Books SET Price = 450 WHERE BookID = 2;
UPDATE Books SET Price = 300 WHERE BookID = 3;
UPDATE Books SET Price = 600 WHERE BookID = 4;

SELECT
    AVG(Price) AS AveragePrice,
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice
FROM Books;

SELECT
    a.FirstName || ' ' || a.LastName AS AuthorName,
    COUNT(*) AS BookCount
FROM Authors a
         JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID
GROUP BY a.AuthorID, a.FirstName, a.LastName;

SELECT
    a.FirstName || ' ' || a.LastName AS AuthorName,
    COUNT(*) AS BookCount,
    AVG(b.Price) AS AveragePrice
FROM Authors a
         JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID
         JOIN Books b ON ba.BookID = b.BookID
GROUP BY a.AuthorID, a.FirstName, a.LastName;

SELECT
    a.FirstName || ' ' || a.LastName AS AuthorName
FROM Authors a
         LEFT JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID
WHERE ba.BookID IS NULL;

SELECT
    a.FirstName || ' ' || a.LastName AS AuthorName
FROM Authors a
         LEFT JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID
GROUP BY a.AuthorID, a.FirstName, a.LastName
HAVING COUNT(ba.BookID) = 0;

-- Для таблицы Books (внешний ключ PublisherID)
ALTER TABLE Books
    DROP CONSTRAINT IF EXISTS fk_publisher_id,
    ADD CONSTRAINT fk_publisher_id
        FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
            ON DELETE SET NULL;

-- Для таблицы BookAuthors (внешний ключ BookID)
ALTER TABLE BookAuthors
    DROP CONSTRAINT IF EXISTS fk_book_id,
    ADD CONSTRAINT fk_book_id
        FOREIGN KEY (BookID) REFERENCES Books(BookID)
            ON DELETE CASCADE;

-- Для таблицы BookAuthors (внешний ключ AuthorID)
ALTER TABLE BookAuthors
    DROP CONSTRAINT IF EXISTS fk_author_id,
    ADD CONSTRAINT fk_author_id
        FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
            ON DELETE RESTRICT;

ALTER TABLE Publishers
    ALTER COLUMN Name SET NOT NULL,
    ADD CONSTRAINT unique_publisher_name UNIQUE (Name);

ALTER TABLE Books
    ALTER COLUMN Title SET NOT NULL,
    ADD CONSTRAINT check_publication_year CHECK (PublicationYear > 0),
    ADD CONSTRAINT check_price CHECK (Price > 0),
    ALTER COLUMN Price SET DEFAULT 0;

ALTER TABLE Authors
    ALTER COLUMN FirstName SET NOT NULL,
    ALTER COLUMN LastName SET NOT NULL;

-- Удаление издательства "Эксмо". Проверка ON DELETE SET NULL
DELETE FROM Publishers WHERE PublisherID = 1;
-- Результат: В таблице Books поле PublisherID для книг, изданных "Эксмо", станет NULL.

-- Удаление книги "Война и мир". Проверка ON DELETE CASCADE
DELETE FROM Books WHERE BookID = 1;
-- Результат: Запись в таблице BookAuthors, связанная с этой книгой, также будет удалена.

-- Попытка удаления автора Льва Толстого. Проверка ON DELETE RESTRICT
DELETE FROM Authors WHERE AuthorID = 1;
-- Результат: Ошибка, так как автор связан с книгой.

-- Попытка добавить книгу с отрицательной ценой. Проверка CHECK
INSERT INTO Books (Title, PublicationYear, PublisherID, Price)
VALUES ('Новая книга', 2023, 2, -100);
-- Результат: Ошибка, так как цена должна быть больше 0.

CREATE TABLE Hierarchy (
                           ID SERIAL PRIMARY KEY,          -- Уникальный идентификатор записи
                           Name VARCHAR(100) NOT NULL,     -- Название категории или имя сотрудника
                           ParentID INT,                   -- Ссылка на родительскую запись
                           FOREIGN KEY (ParentID) REFERENCES Hierarchy(ID) ON DELETE CASCADE -- Внешний ключ для связи с самой собой
);

INSERT INTO Hierarchy (Name, ParentID) VALUES
                                           ('Генеральный директор', NULL),        -- Верхний уровень
                                           ('Заместитель гендиректора', 1),       -- Подчиненный генеральному директору
                                           ('Отдел разработки', 2),               -- Подразделение под заместителем
                                           ('Тимлид', 3),                         -- Руководитель команды
                                           ('Программист', 4),                    -- Член команды
                                           ('Отдел маркетинга', 2),               -- Подразделение под заместителем
                                           ('Маркетолог', 6);                     -- Член отдела маркетинга


CREATE TABLE Product(
            "productID" BIGINT GENERATED ALWAYS AS IDENTITY,
            "productName" VARCHAR(100),
            "price" DECIMAL(10,2)
);

CREATE TABLE Customer(
            "customerID" BIGINT GENERATED ALWAYS AS IDENTITY,
            "firstName" VARCHAR(50),
            "lastName" VARCHAR(50),
            email VARCHAR(90),
            city VARCHAR(50)
);

CREATE TABLE Order(
            "orderID" BIGINT GENERATED ALWAYS AS IDENTITY,
            "customerID" BIGINT,
            "productID" BIGINT,
            "quantity" BIGINT,
            "orderDate" DATE
);

INSERT INTO Customer (firstName, lastName, email, city) VALUES
            ('Сергеев', 'Сергей', 'sergeev@yandex.ru', 'Москва'),
            ('Александров', 'Александр', 'alex@yandex.ru','Cургут'),
            ('Иванов', 'Иван', 'ivanov@yandex.ru', 'Ленинград');

UPDATE Customer
SET lastName = 'Максим'
WHERE customerID = 1;

UPDATE Customer
SET city = 'Санкт-Петербург'
WHERE city = 'Ленинград';

DELETE FROM Customer
WHERE customerID = 2;

SELECT * FROM Customer;

SELECT * FROM Customer
WHERE city = 'Санкт-Петербург'
ORDER BY lastName;
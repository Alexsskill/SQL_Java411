CREATE TABLE Product(
                        "ProductID" BIGINT,
                        "ProductName" VARCHAR(100),
                        "Price" DECIMAL(10,2)
);

CREATE TABLE Customer(
                         "CustomerID" BIGINT,
                         "FirstName" VARCHAR(50),
                         "LastName" VARCHAR(50),
                         Email VARCHAR(100)
);

CREATE TABLE Order(
                      "OrderID" BIGINT,
                      "CustomerID" BIGINT,
                      "ProductID" BIGINT,
                      "Quantity" BIGINT,
                      "OrderDate" DATE
);
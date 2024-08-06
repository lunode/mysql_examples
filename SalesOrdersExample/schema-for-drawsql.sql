CREATE DATABASE SalesOrdersExample;

USE SalesOrdersExample;

CREATE TABLE Categories (
    CategoryID int NOT NULL DEFAULT 0,
    CategoryDescription nvarchar(75) NULL,
    PRIMARY KEY (CategoryID)
);

CREATE TABLE Customers (
    CustomerID int NOT NULL,
    CustFirstName nvarchar(25) NULL,
    CustLastName nvarchar(25) NULL,
    CustStreetAddress nvarchar(50) NULL,
    CustCity nvarchar(30) NULL,
    CustState nvarchar(2) NULL,
    CustZipCode nvarchar(10) NULL,
    CustAreaCode smallint NULL DEFAULT 0,
    CustPhoneNumber nvarchar(8) NULL,
    PRIMARY KEY (CustomerID)
);

CREATE TABLE Employees (
    EmployeeID int NOT NULL,
    EmpFirstName nvarchar(25) NULL,
    EmpLastName nvarchar(25) NULL,
    EmpStreetAddress nvarchar(50) NULL,
    EmpCity nvarchar(30) NULL,
    EmpState nvarchar(2) NULL,
    EmpZipCode nvarchar(10) NULL,
    EmpAreaCode smallint NULL DEFAULT 0,
    EmpPhoneNumber nvarchar(8) NULL,
    EmpBirthDate date NULL,
    PRIMARY KEY (EmployeeID)
);

CREATE TABLE Order_Details (
    OrderNumber int NOT NULL DEFAULT 0,
    ProductNumber int NOT NULL DEFAULT 0,
    QuotedPrice decimal(15, 2) NULL DEFAULT 0,
    QuantityOrdered smallint NULL DEFAULT 0,
    PRIMARY KEY (OrderNumber, ProductNumber),
    FOREIGN KEY (OrderNumber) REFERENCES Orders(OrderNumber),
    FOREIGN KEY (ProductNumber) REFERENCES Products(ProductNumber)
);

CREATE TABLE Orders (
    OrderNumber int NOT NULL DEFAULT 0,
    OrderDate date NULL,
    ShipDate date NULL,
    CustomerID int NULL DEFAULT 0,
    EmployeeID int NULL DEFAULT 0,
    PRIMARY KEY (OrderNumber),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Product_Vendors (
    ProductNumber int NOT NULL DEFAULT 0,
    VendorID int NOT NULL DEFAULT 0,
    WholesalePrice decimal(15, 2) NULL DEFAULT 0,
    DaysToDeliver smallint NULL DEFAULT 0,
    PRIMARY KEY (ProductNumber, VendorID),
    FOREIGN KEY (ProductNumber) REFERENCES Products(ProductNumber),
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID)
);

CREATE TABLE Products (
    ProductNumber int NOT NULL DEFAULT 0,
    ProductName nvarchar(50) NULL,
    ProductDescription nvarchar(100) NULL,
    RetailPrice decimal(15, 2) NULL DEFAULT 0,
    QuantityOnHand smallint NULL DEFAULT 0,
    CategoryID int NULL DEFAULT 0,
    PRIMARY KEY (ProductNumber),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Vendors (
    VendorID int NOT NULL,
    VendName nvarchar(25) NULL,
    VendStreetAddress nvarchar(50) NULL,
    VendCity nvarchar(30) NULL,
    VendState nvarchar(2) NULL,
    VendZipCode nvarchar(10) NULL,
    VendPhoneNumber nvarchar(15) NULL,
    VendFaxNumber nvarchar(15) NULL,
    VendWebPage text NULL,
    VendEMailAddress nvarchar(50) NULL,
    PRIMARY KEY (VendorID)
);

CREATE TABLE ztblMonths (
    MonthYear nvarchar(15) NOT NULL,
    YearNumber smallint NOT NULL,
    MonthNumber smallint NOT NULL,
    MonthStart date NOT NULL,
    MonthEnd date NOT NULL,
    January smallint NOT NULL DEFAULT 0,
    February smallint NOT NULL DEFAULT 0,
    March smallint NOT NULL DEFAULT 0,
    April smallint NOT NULL DEFAULT 0,
    May smallint NOT NULL DEFAULT 0,
    June smallint NOT NULL DEFAULT 0,
    July smallint NOT NULL DEFAULT 0,
    August smallint NOT NULL DEFAULT 0,
    September smallint NOT NULL DEFAULT 0,
    October smallint NOT NULL DEFAULT 0,
    November smallint NOT NULL DEFAULT 0,
    December smallint NOT NULL DEFAULT 0,
    PRIMARY KEY (YearNumber, MonthNumber)
);

CREATE TABLE ztblPriceRanges (
    PriceCategory nvarchar(20) NOT NULL,
    LowPrice decimal(15, 2) NULL,
    HighPrice decimal(15, 2) NULL,
    PRIMARY KEY (PriceCategory)
);

CREATE TABLE ztblPurchaseCoupons (
    LowSpend decimal(15, 2) NOT NULL,
    HighSpend decimal(15, 2) NULL,
    NumCoupons smallint NULL DEFAULT 0,
    PRIMARY KEY (LowSpend)
);

CREATE TABLE ztblSeqNumbers (
    Sequence int NOT NULL DEFAULT 0,
    PRIMARY KEY (Sequence)
);

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    IsAdmin BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    [Mobile] [nvarchar](15) NULL,
    [Address] [nvarchar](255) NULL,
    [Gender] [nvarchar](10) NULL
);

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(18, 2) NOT NULL,
    ImageUrl VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    DeletedAt DATETIME
);

CREATE TABLE UserWatchlist (
    WatchlistID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    AddedAt DATETIME DEFAULT GETDATE(),
    RemovedAt DATETIME
);

CREATE TABLE ProductComments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    CommentText NVARCHAR(MAX) NOT NULL,
    RatingScore INT CHECK (RatingScore BETWEEN 1 AND 5),
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE ProductViews (
    ViewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    UserID INT NULL FOREIGN KEY REFERENCES Users(UserID),
    ViewDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE ProductStatistics (
    StatisticID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    TotalViews INT DEFAULT 0,
    TotalComments INT DEFAULT 0,
    TotalWatchlistAdds INT DEFAULT 0,
    LastUpdated DATETIME DEFAULT GETDATE()
);
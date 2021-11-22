use master; 
GO
-- CLose client connections
ALTER DATABASE Souvenirs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
drop database if exists Souvenirs; 
GO
create database Souvenirs; 
GO
use Souvenirs; 
GO

-- Create the most basic elements in the database
create table [Owner] (
    OwnerID int primary key identity(1,1),
    [Name] nvarchar(20) not null
    constraint uq_Owner_Name
        unique ([Name])
)

create table Category (
    CategoryID int primary key identity(1,1),
    [Name] nvarchar(50) not null,
    Description nvarchar(500) null
    constraint uq_Category_Name
        unique([Name])
)

create table TravelLocation (
    TravelLocationID int primary key identity(1,1),
    City nvarchar(50) null,
    Region nvarchar(50) null,
    Country nvarchar(50) null,
    Longitude float null,
    Latitude float null
    constraint uq_TravelLocation_City_Region_Country_Long_Lat
        unique(City, Region, Country, Longitude, Latitude)
)

-- Create the main souvenir table that links to the previous base tables plus adds other elements. 
-- Note: This is not a true bridge table where we would create a primary key from the combination of foreign keys.
-- The schema does not ensure a unique combination of foreign keys which is necessary (i.e. two souvenirs can have the
-- same owner, location, and category). 
create table Souvenir (
    SouvenirID int primary key identity(1,1),
    OwnerID int not null,
    TravelLocationID int not null,
    CategoryID int not null,
    [Name] nvarchar(200) not null,
    Description nvarchar(500) NULL,
    Weight float null,
    Price float null,
    DateObtained datetime2 null,
    constraint fk_Souvenir_FeatureID
        foreign key (OwnerID)
        references Owner(OwnerID),
    constraint fk_Souvenir_TravelLocationID
        foreign key (TravelLocationID)
        references TravelLocation(TravelLocationID),
    constraint fk_Souvenir_CategoryID
        foreign key (CategoryID)
        references Category(CategoryID)
)



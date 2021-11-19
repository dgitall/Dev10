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
    [Name] varchar(20) not null
)

create table Category (
    CategoryID int primary key identity(1,1),
    [Name] varchar(50) not null,
    Description varchar(500) null
)

create table TravelLocation (
    TravelLocationID int primary key identity(1,1),
    City varchar(50) null,
    Region varchar(50) null,
    Country varchar(50) null,
    Longitude float null,
    Latitude float null
)

create table Souvenir (
    SouvenirID int primary key identity(1,1),
    OwnerID int not null,
    TravelLocationID int not null,
    CategoryID int not null,
    [Name] varchar(200) not null,
    Description varchar(500) NULL,
    Weight int null,
    Price int null,
    DateObtained date null,
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

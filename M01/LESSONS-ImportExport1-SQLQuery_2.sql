
use master;
go
drop database if exists AirbnbNewYorkNormalized;
go
create database AirbnbNewYorkNormalized;
go
use AirbnbNewYorkNormalized;
go

create table NeighborhoodGroup (
    NeighborhoodGroupId int primary key identity(1,1),
    [Name] varchar(50) not null unique
);

create table Neighborhood (
    NeighborhoodId int primary key identity(1,1),
    [Name] varchar(50) not null,
    NeighborhoodGroupId int not null,
    constraint fk_Neighborhood_NeighborhoodGroupId
        foreign key (NeighborhoodGroupId)
        references NeighborhoodGroup(NeighborhoodGroupId),
    constraint uq_Name_NeighborhoodGroupId
        unique([Name], NeighborhoodGroupId)
);

create table Host (
    HostId int primary key identity(1,1),
    [Name] varchar(50) not null
);

create table RoomType (
    RoomTypeId int primary key identity(1,1),
    [Name] varchar(50) not null
);

create table Listing (
    ListingId int primary key identity(1,1),
    [Name] varchar(256) not null,
    HostId int not null,
    NeighborhoodId int not null,
    Latitude decimal(8,5) not null,
    Longitude decimal(8,5) not null,
    RoomTypeId int not null,  
    Price decimal(8,2) not null,
    MinimumNights int not null,
    NumberOfReviews int not null,
    LastReview date null,
    ReviewsPerMonth int null,
    CalculatedHostListingsCount int not null,
    Availability365 int not null
    constraint fk_Listing_HostId
        foreign key (HostId)
        references Host(HostId),
     constraint fk_Listing_NeighborhoodId
        foreign key (NeighborhoodId)
        references Neighborhood(NeighborhoodId),
     constraint fk_Listing_RoomTypeId
        foreign key (RoomTypeId)
        references RoomType(RoomTypeId)
);


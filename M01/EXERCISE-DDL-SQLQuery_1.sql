-- Create the basic schema for album/track/artist relationship
-- CAUTION!
-- only use this for schema design
use master; 
GO
-- CLose client connections
ALTER DATABASE Music SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
drop database if exists Music; 
GO
create database Music; 
GO
use Music; 
GO

-- Create Album table
create table Album (
    AlbumID int primary key IDENTITY(1, 1),
    Title varchar(25) not null,
    ReleaseDate date not null,
    LablelID int null
);

create table Artist (
    ArtistID int primary key identity(1, 1),
    [Name] varchar(25) not null
);

create table [Group] (
    GroupID int primary key identity(1,1),
    [Name] varchar(25) not null,
)

create table Track (
    TrackID int primary key identity(1, 1),
    [Name] varchar(20) not null,
    [Length] TIME null,
    Writers varchar (300) null
    
)
-- Bridge table tying artists to groups
create table ArtistGroup (
    GroupID int not null,
    ArtistID int not null, 
    -- What roles does the artist play in the group (e.g. vocals, guitar, sitar, bass, etc.)
    [Roles] varchar(50) null,
    constraint pk_ArtistGroup
        primary key (ArtistID, GroupID),
       constraint fk_ArtistGroup_ArtistId
        foreign key (ArtistId) 
        references Artist(ArtistId),
    constraint fk_ArtistGroup_GroupId
        foreign key (GroupId)
        references [Group](GroupId),
)

create table TrackAlbum (
    TrackID int not null,
    AlbumID int not null, 
    -- What track number is the track on the album
    [Order] int not null,
    constraint pk_TrackAlbum
        primary key (TrackID, AlbumID),
    constraint fk_TrackAlbum_TrackID
        foreign key (TrackID) 
        references Track(TrackID),
    constraint fk_TrackAlbum_AlbumID
        foreign key (AlbumID)
        references [Album](AlbumID),
);

-- Bridge table tying groups to tracks
create table GroupTrack (
    GroupID int not null,
    TrackID int not null, 
    constraint pk_GroupTrack
        primary key (TrackID, GroupID),
    constraint fk_GroupTrack_TrackID
        foreign key (TrackID) 
        references Track(TrackID),
    constraint fk_GroupTrack_GroupId
        foreign key (GroupId)
        references [Group](GroupId),
);

-- Bridge table tying groups to tracks
create table FeaturingTrack (
    ArtistID int not null,
    TrackID int not null, 
    constraint pk_FeaturingTrack
        primary key (TrackID, ArtistID),
    constraint fk_FeaturingTrack_TrackID
        foreign key (TrackID) 
        references Track(TrackID),
    constraint fk_FeaturingTrack_ArtistID
        foreign key (ArtistID)
        references [Artist](ArtistID),
);
use master; 
GO
-- CLose client connections
ALTER DATABASE BobRoss SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
drop database if exists BobRoss; 
GO
create database BobRoss; 
GO
use BobRoss; 
GO

use BobRoss

create table Episode (
    EpisodeID int primary key identity(1,1),
    Title varchar(100) not null
)

create table Season (
    SeasonID int primary key identity(1,12),
    Title varchar(10) not null
)

create table Feature (
    FeatureID int primary key identity(1,1),
    [Name] varchar(25) not null,
    Description varchar(250) null
)

create table FrameMaterial (
    FrameMaterialID int primary key identity(1,1),
    [Name] varchar(25) not null,
    Description varchar(250) null
)

create table FrameShape (
    FrameShapeID int primary key identity(1,1),
    [Name] varchar(25) not null,
)

create table Frame (
    FrameID int primary key identity(1,1),
    [Name] varchar(20),
    Description varchar(230),
    FrameMaterialID int null,
    FrameShapeID int null,
    constraint fk_Frame_FrameMaterialID
        foreign key (FrameMaterialID)
        references FrameMaterial(FrameMaterialID),
    constraint fk_Frame_FrameShapeID
        foreign key (FrameShapeID)
        references FrameShape(FrameShapeID)
)

alter table Episode
    add FrameID int null;

alter table Episode
    add constraint fk_Episode_FrameID
            foreign key (FrameID)
            references Frame(FrameID);


create table SeasonEpisode (
    SeasonID int not null,
    EpisodeID int not null,
    constraint pk_SeasonEpisode
        primary key(SeasonID, EpisodeID),
    constraint fk_SeasonEpisode_SeasonID
        foreign key (SeasonID)
        references Season(SeasonID),
    constraint fk_SeasonEpisode_EpisodeID
        foreign key (EpisodeID)
        references Episode(EpisodeID)
);

create table EpisodeFeature (
    FeatureID int not null,
    EpisodeID int not null,
    constraint pk_EpisodeFeature
        primary key(FeatureID, EpisodeID),
    constraint fk_EpisodeFeature_FeatureID
        foreign key (FeatureID)
        references Feature(FeatureID),
    constraint fk_EpisodeFeature_EpisodeID
        foreign key (EpisodeID)
        references Episode(EpisodeID)
);


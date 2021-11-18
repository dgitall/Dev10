
-- CAUTION!
-- only use this for schema design
use master; 
GO
-- CLose client connections
ALTER DATABASE FieldAgent SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
drop database if exists FieldAgent; 
GO
create database FieldAgent; 
GO
use FieldAgent; 
GO


-- Create Tables and relationships
create table Agency (
    AgencyID int primary key IDENTITY(1, 1),
    ShortName varchar(25) not null,
    LongName varchar(250) not null
);

create table [Location] (
    LocationID int primary key identity(1, 1),
    [Name] varchar(25) not null,
    [Address] varchar(125) not null,
    City varchar(50) not null,
    CountryCode varchar(5) not null,
    PostalCode varchar(15) not null,
    AgencyID int not null,
    constraint fk_Location_AgencyId
        foreign key (AgencyID)
        references Agency(AgencyID)
);

create table Agent (
    AgentID int primary key identity(1, 1),
    FirstName varchar(25) not null,
    MiddleName varchar(25) null,
    LastName varchar(25) not null,
    DOB date null,
    Identifier varchar(50) not null,
    ActivationDate date not null,
    IsActive bit not null default 1,
    AgencyId int not null,
    constraint fk_Agent_AgencyID
        foreign key (AgencyId)
        references Agency(AgencyId),
    constraint uq_AgentIdentifier_AgencyId
        unique (Identifier, AgencyId)
)

-- The bridget table between agency and agent
create table AgencyAgent (
    AgencyId int not null,
    AgentId int not null,
    -- Moved to the bridge table
    Identifier varchar(50) not null,
    ActivationDate date not null,
    IsActive bit not null default 1,
    -- Creates a plural primary key of both the Agency and Agent IDs
    constraint pk_AgencyAgent
        primary key (AgencyId, AgentId),
    -- The plural primary keys are set to foreign keys, too, since they point outward
    constraint fk_AgencyAgent_AgencyId
        foreign key (AgencyId) 
        references Agency(AgencyId),
    constraint fk_AgencyAgent_AgentId
        foreign key (AgentId)
        references Agent(AgentId),
    -- moved from agency
    constraint uq_AgencyAgent_Identifier_AgencyId
        unique (Identifier, AgencyId)
);

-- Remove the stuff from Agent that we moved into the bridge table
alter table Agent
    drop constraint 
        uq_AgentIdentifier_AgencyId,
        fk_Agent_AgencyId,
        DF__Agent__IsActive__2A4B4B5E,

    column 
        AgencyId,
        IsActive,
        ActivationDate,
        Identifier;

alter table Agent
    alter column FirstName varchar(50) not null;

alter table Agent
    alter column LastName varchar(50) not null;

alter table Agent
    add HeightInInches int not null;

create table Alias (
    AliasID int primary key identity(1, 1),
    AliasName varchar(50) not null,
    Persona varchar(300) null,
    AgentId int not NULL,
    constraint fk_Alias_AgentID
        foreign key (AgentID)
        references Agent(AgentID),
    constraint uq_Alias_AliasName
        unique (AliasName, AgentID)
);

create table Mission (
    MissionId int primary key identity(1,1),
    CodeName varchar(50) not null,
    Notes varchar(max),
    StartDate date not null,
    ProjectedEndDate date not null,
    ActualEndDate date null,
    OperationalCost decimal(10,2) not null,
    AgencyId int not null,
    constraint fk_Mission_AgencyId
        foreign key(AgencyId)
        references Agency(AgencyId)
);

-- zero or more agents can be assigned to a mission so mission/agent relationship is many-to-many
-- Create a bridge table
create table MissionAgent (
    MissionId int not null,
    AgentId int not null,
    constraint pk_MissionAgent
        primary key(MissionId, AgentId),
    constraint fk_MissionAgent_MissionId
        foreign key (MissionId)
        references Mission(MissionId),
    constraint fk_MissionAgent_AgentId
        foreign key (AgentId)
        references Agent(AgentId)
);

-- Create a Security CLearance and link it to the Agent via the AgencyAgent table
create table SecurityClearance (
    SecurityClearanceId int primary key identity(1,1),
    -- In brackets because Name is a SQL keyword
    [Name] varchar(50) not null
);
alter table AgencyAgent
    add SecurityClearanceId int not null;

alter table AgencyAgent
    add constraint fk_AgencyAgent_SecurityClearanceId
        foreign key (SecurityClearanceId)
        references SecurityClearance(SecurityClearanceId);
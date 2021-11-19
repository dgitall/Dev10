use FieldAgent
insert into Agency (ShortName, LongName)
    values ('NSA', 'National Security Agency');
insert into Agency (ShortName, LongName)
    values ('ACME', 'Agency to Classify & Monitor Evildoers');
    -- Note that the AgencyID auto increments with each add. This because we defined that as
    -- and identy in the DDL
select * from Agency

-- Can insert multiple lines in the same call
use FieldAgent
insert into Agent 
    (FirstName, MiddleName, LastName, DOB, HeightInInches) 
    values
    ('Hazel','C','Sauven','1954-09-16',76),
    ('Claudian','C','O''Lynn','1956-11-09',41),
    ('Winn','V','Puckrin','1999-10-21',60),
    ('Kiab','U','Whitham','1960-07-29',52),
    ('Min','E','Dearle','1967-04-18',44),
    ('Urban','H','Carwithen','1996-12-22',58),
    ('Ulises','B','Muhammad','2008-04-01',80),
    ('Phylys','Y','Howitt','1979-03-28',68);
SELECT * FROM Agent

-- The column list can be omitted if it matches every column in a table
-- DON'T DO - it's bad form and should be fixed wherever you run into it
use FieldAgent
insert into SecurityClearance values ('Top Secret');
SELECT * FROM SecurityClearance

-- The insert statement data can come from a select statement. Here we associate all agencies to all agents
-- using a cross join. The results are inserts in to the AgencyAgent table
use FieldAgent
insert into AgencyAgent 
    (AgencyId, AgentId, Identifier, SecurityClearanceId, ActivationDate)
        select
            Agency.AgencyId,                             -- AgencyId
            Agent.AgentId,                               -- AgentId
            -- Unique identifier made by mergine AgencyID and AgentID
            concat(Agency.AgencyId, '-', Agent.AgentId), -- Identifier
            1,                                           -- SecurityClearanceId
            -- Make the activation date on their 10th birthday
            dateadd(year, 10, Agent.DOB)                 -- ActivationDate
        from Agency
        cross join Agent;
SELECT * FROM AgencyAgent

-- update some of the columns for Agency 1 and Agent 7
use FieldAgent
update Agency set
    LongName = 'Nascent Science Agency'
where AgencyId = 1;
update Agent set
    MiddleName = 'K',
    DOB = '2002-04-09'
where AgentId = 7;

-- update the relationship between agent 1 and agency 1 in the bridge table
use FieldAgent
update AgencyAgent set
    Identifier = '003',
    ActivationDate = '2012-9-19',
    IsActive = 0
where AgencyId = 1
and AgentId = 1;
SELECT * FROM AgencyAgent
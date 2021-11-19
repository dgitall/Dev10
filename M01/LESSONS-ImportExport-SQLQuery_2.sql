SELECT * FROM [TempListing ]

-- Need to pull data from the temp listing imported from the non-normalized database
-- The steps below will select pieces of that data out and place it in the correct tables
-- in the normalized database.

-- Room Types
-- test select to find all of the unique room types
SELECT distinct RoomType
from TempListing

-- Do an insert using that selection to fill out the room type table
-- The select pulls out the names of different room types. This puts that into the Name in RoomType table
-- NOTE: The ID is an identity so it auto fills with incrementing values and we don't add it.
insert into RoomType ([Name])    
    select distinct RoomType
    from TempListing;
-- Confirm.
select * from RoomType;

-- Host
-- Test select to find the distinct hosts
SELECT DISTINCT HostId, HostName 
FROM [TempListing ]

-- Do an insert with the unique host information
-- Note: We have to turn on the ability to set the primary keys for the table
-- so we can load the HostId into that primary key. IT MUST BE TURNED OFF
-- Note: check the HostName to see if there is a NULL value and insert [Unknown] instead
SET IDENTITY_INSERT Host ON;

insert into Host (HostId, [Name])
    select distinct HostId, isnull(HostName, '[Unknown]')
    from TempListing;

SET IDENTITY_INSERT Host OFF;
SELECT * FROM Host                                     

-- Neighborhood Group
-- Test query
select distinct NeighborhoodGroup
from TempListing;

-- Insert
insert into NeighborhoodGroup ([Name])
    select distinct NeighborhoodGroup
    from TempListing;
SELECT * FROM NeighborhoodGroup

-- Neighborhood
-- This requires a foreign key which means we can't just directly import the distinct neighborhood names. 
-- To do this, JOIN the TempListing with the NeighborhoodGroup by the group name (NeighborhoodGroup in TempListing
-- and Name in the NeighborhoodGroup table). After that is joined, we can get the Neighborhood name and the
-- associated NeighborhoodGroupId
select distinct l.Neighborhood, ng.NeighborhoodGroupId
from TempListing l
inner join NeighborhoodGroup ng on l.NeighborhoodGroup = ng.Name;
-- Insert.
-- This takes the query we did before and inserts into the Name and NeighborhoodID (foreign key) in the table
insert into Neighborhood ([Name], NeighborhoodGroupId)
    select distinct l.Neighborhood, ng.NeighborhoodGroupId
    from TempListing l
    inner join NeighborhoodGroup ng on l.NeighborhoodGroup = ng.Name;
SELECT * FROM Neighborhood

-- Listings
-- This pulls all the final pieces together and requires some JOINs with TempListing
-- HostId - No join needed because it is in the table
-- RoomTypeID -- Need to join with RoomType to get
-- Neighborhood - Need to join with NeighborhoodGroup and Neighborhood to make sure the name and group match the neighborhood
-- There is a null value in the listing name in TempListing. Use isnull test to change to [Unknown]
-- The TempListing.LastReview and TempListing.ReviewsPerMonth were imported as varchars because of the 'NULL' literal value. 
--      However, when we bring the data into the Listing table, we want to convert them to date and int. The conversion
--      also includes converting the literal 'NULL' into a true null
-- Note: Turn on setting the primary key. MUST TURN OFF

-- Confirm the select
    select
        l.ListingId,
        isnull(l.Name, '[Unknown]'),
        l.HostId,
        n.NeighborhoodId,
        l.Latitude,
        l.Longitude,
        rt.RoomTypeId,
        l.Price,
        l.MinimumNights,
        l.NumberOfReviews,
        convert(date, nullif(l.LastReview, 'NULL'), 23),
        nullif(l.ReviewsPerMonth, 'NULL'),
        l.CalculatedHostListingsCount,
        l.Availability365
    from TempListing l
    inner join NeighborhoodGroup ng on l.NeighborhoodGroup = ng.Name
    inner join Neighborhood n on l.Neighborhood = n.Name
        -- Prevents a duplicate neighborhood name in different groups.
        and ng.NeighborhoodGroupId = n.NeighborhoodGroupId
    inner join RoomType rt on l.RoomType = rt.Name;

    --Not completed. One more step to go
--1
-- Insert some albums into the music database
use Music
insert into Artist 
    (Name) 
    values
    ('Beyonce'),
    ('Jay-Z'),
    ('Frank Ocean'),
    ('Jack White'),
    ('Kendrick Lamar');
SELECT * FROM Artist

use Music
insert into Album 
    (Title, ReleaseDate) 
    values
    ('Beyonce', '2013-12-13'),
    ('Lemonade', '2016-08-23'),
    ('Blonde','2016-08-20');
SELECT * FROM Album

use Music
insert into Track 
    (Name, Writers, Length) 
    values
    ('Pretty Hurts', 'Beyoncé Knowles, Joshua Coleman, Sia Furler', '4:17'),
    ('Drunk in Love', 'Knowles, Brian Soko, Jerome Harmon, Shawn Carter, Andre Eric Proctor, Rasool Díaz, Timothy Mosley, Noel Fisher', '5:23'),
    ('Super-Power', 'Knowles, Pharrell Williams, Frank Ocean', '4:36');
SELECT * FROM Track

SELECT * FROM Results
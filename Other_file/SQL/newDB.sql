DROP DATABASE IF EXISTS moviedb;
CREATE DATABASE moviedb;

USE moviedb;
set global innodb_flush_log_at_trx_commit=2;
/*
* Movie information selection code is in java file
* Populate moviedb database with movie-data.sql
*/
create table movies (
id varchar(10) not null,
title varchar(100) not null,
year int not null,
director varchar(100) not null,
primary key (id),
FULLTEXT(title)
);

create table stars (
id varchar(10) not null,
name varchar(100) not null,
birthYear int,
primary key (id),
FULLTEXT(name)
);

create table stars_in_movies (
starId varchar(10) not null,
movieId varchar(10) not null,
foreign key (starId) references stars(id),
foreign key (movieId) references movies(id)
);

create table genres (
id int not null AUTO_INCREMENT,
name varchar(32) not null,
primary key (id)
);

create table genres_in_movies (
genreId int not null,
movieId varchar(10) not null,
foreign key (genreId) references genres(id),
foreign key (movieId) references movies(id)
);

create table creditcards (
id varchar(20) not null,
firstName varchar(50) not null,
lastName varchar(50) not null,
expiration date not null,
primary key (id)
);

create table customers (
id int not null AUTO_INCREMENT,
firstName varchar(50) not null,
lastName varchar(50) not null,
ccId varchar(20) not null,
address varchar(200) not null,
email varchar(50) not null,
password varchar(20),
primary key (id),
foreign key (ccId) references creditcards(id)
);

create table sales (
id int not null AUTO_INCREMENT,
customerId int not null,
movieId varchar(10) not null,
saleDate date not null,
primary key (id),
foreign key (customerId) references customers(id),
foreign key (movieId) references movies(id)
);

create table ratings (
movieId varchar(10) not null,
rating float not null,
numVotes int not null,
foreign key (movieId) references movies(id)
);

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_star`(in star_name varchar(100), in star_dob int(11))
BEGIN

declare max_star_id varchar(10) default null;
declare star_id varchar(10) default null;
declare star_exist varchar(32) default null;
declare default_year int(11) default null;

set star_id = (select stars.id from stars where stars.name = star_name);


-- insert a new star record if not exist
if star_id is null then
set max_star_id = (select max(id) from stars);

if max_star_id is null then
set max_star_id = "nm9423090";
set max_star_id = cast(SUBSTRING(max_star_id,3) as unsigned);
set max_star_id = max_star_id + 1;
set star_id = concat("nm",cast(max_star_id as char));
else
set max_star_id = cast(SUBSTRING(max_star_id,3) as unsigned);
set max_star_id = max_star_id + 1;
set star_id = concat("nm",cast(max_star_id as char));
end if;

if star_dob <> -1 then
insert into stars(id, name, birthYear) values(star_id, star_name, star_dob);
else
insert into stars(id, name, birthYear) values(star_id, star_name, default_year);
end if;
select 'Update movie record successfully';
end if;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_movie`(in movie_title varchar(100), in movie_year int(11), in movie_director varchar(100), in movie_star varchar(100), in movie_genre varchar(32))
BEGIN
declare max_movie_id varchar(10) default null;
declare max_star_id varchar(10) default null;
declare max_genre_id int(10) default -1;

declare movie_id varchar(10) default null;
declare star_id varchar(10) default null;
declare genre_id int(10) default -1;

declare star_exist varchar(32) default null;
declare genre_exist varchar(10) default null;

set movie_id = (select movies.id from movies where movies.title = movie_title);
set star_id = (select stars.id from stars where stars.name = movie_star);
set genre_id = (select genres.id from genres where genres.name = movie_genre);




if movie_title ="" or  movie_director="" or movie_genre="" then
select 'Please input all required fields' as warning;

else

if movie_id is null then
set max_movie_id = (select max(id) from movies);
if max_movie_id is null then
set max_movie_id = "tt0499470";
end if;

set max_movie_id = cast(SUBSTRING(max_movie_id,3) as unsigned);
set max_movie_id = max_movie_id + 1;

set movie_id = concat("tt0", cast(max_movie_id as char));
insert into movies(id, title, year, director) values(movie_id, movie_title, movie_year, movie_director);

if movie_star <> "n/a" then

if star_id is null then
set max_star_id = (select max(id) from stars);
if max_star_id is null then
set max_star_id = "nm9423090";
end if;

set max_star_id = cast(SUBSTRING(max_star_id,3) as unsigned);
set max_star_id = max_star_id + 1;

set star_id = concat("nm", cast(max_star_id as char));
insert into stars(id, name) values(star_id, movie_star);
end if;


insert into stars_in_movies(starId, movieId) values(star_id, movie_id);
end if;


if movie_genre<>'unknown' then
if genre_id is null then
set max_genre_id = (select max(id) from genres);
if max_genre_id is null then
set max_genre_id = 30;
end if;

set max_genre_id = max_genre_id + 1;

set genre_id = max_genre_id;
insert into genres(id, name) values(genre_id, movie_genre);

end if;

insert into genres_in_movies(genreId, movieId) values(genre_id, movie_id);
end if;
select 'Insert new movie record successfully' as warning;


else

if star_id is null then
set max_star_id = (select max(id) from stars);
if max_star_id is null then
set max_star_id = "nm9623090";
end if;

set max_star_id = cast(SUBSTRING(max_star_id,3) as unsigned);
set max_star_id = max_star_id + 1;

set star_id = concat("nm", cast(max_star_id as char));
insert into stars(id, name) values(star_id, movie_star);


insert into stars_in_movies(starId, movieId) values(star_id, movie_id);

else
set star_exist = (select stars.name from movies, stars, stars_in_movies
where movies.id = stars_in_movies.movieId and stars_in_movies.starId = stars.id and stars.id = star_id and movies.id = movie_id);
select star_exist;
select movie_star;

if star_exist is null then

insert into stars_in_movies(starId, movieId) values(star_id, movie_id);
end if;
end if;

if movie_genre<>'unknown' then
if genre_id is null then
set max_genre_id = (select max(id) from genres);
if max_genre_id is null then
set max_genre_id = 30;
end if;

set max_genre_id = max_genre_id + 1;
set genre_id = max_genre_id;

insert into genres(id, name) values(genre_id, movie_genre);
insert into genres_in_movies(genreId, movieId) values(genre_id, movie_id);


else
set genre_exist = (select distinct genres.name from movies, genres, genres_in_movies
where movies.id = genres_in_movies.movieId and genres_in_movies.genreId = genres.id and genres.id = genre_id and movies.id = movie_id);


if genre_exist is null then

insert into genres_in_movies(genreId, movieId) values(genre_id, movie_id);
end if;
end if;
end if;
select 'Update movie record successfully';

end if;
end if;
END$$
DELIMITER ;

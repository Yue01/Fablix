-- MySQL dump 10.13  Distrib 5.6.39, for macos10.13 (x86_64)
--
-- Host: localhost    Database: moviedb
-- ------------------------------------------------------
-- Server version	5.6.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'moviedb'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_movie` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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




if movie_title ="" or  movie_director="" or movie_genre="" or movie_year = -1 then
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_star` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_star`(in star_name varchar(100), in star_dob int(11))
BEGIN

declare max_star_id varchar(10) default null;
declare star_id varchar(10) default null;
declare star_exist varchar(32) default null;
declare default_year int(11) default null;

set star_id = (select stars.id from stars where stars.name = star_name);



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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-02-22 23:09:30

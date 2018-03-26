DROP DATABASE IF EXISTS moviedb;
CREATE DATABASE moviedb; 

USE moviedb;
/*
* Movie information selection code is in java file
* Populate moviedb database with movie-data.sql
*/
create table movies (
id varchar(10) not null,
title varchar(100) not null,
year int not null,
director varchar(100) not null,
primary key (id)
);

create table stars (
id varchar(10) not null,
name varchar(100) not null,
birthYear int,
primary key (id)
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

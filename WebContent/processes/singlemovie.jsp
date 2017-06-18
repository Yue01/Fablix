<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import = "java.io.*, java.sql.*" %><%@ page import = "org.json.*" %><%@ page import="java.util.ArrayList"%>
<%
// Create Connection
Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false","root", "idiotking22");

// Retrieve search data and set up queries
String singleMovieID = ""; 
singleMovieID = request.getParameter( "movieID" );
// Query
PreparedStatement getMovie = connection.prepareStatement("SELECT * FROM movies WHERE id = ?;");

getMovie.setString(1, singleMovieID);


ResultSet movie = getMovie.executeQuery();
JSONObject movieJson = new JSONObject();
while ( movie.next() )
{
	String trailer = "";	
	int movieID = movie.getInt(1);
	String title = movie.getString(2);
	int year = movie.getInt(3);
	String dir = movie.getString(4);
	String banner = movie.getString(5);
	trailer = movie.getString(6);
	if(trailer != null){
		trailer = trailer.replace("watch?v=", "embed/");
	};
	
	//GET stars for this movie 
	Statement getStars = connection.createStatement();
	ResultSet starSet = getStars.executeQuery(
	"select distinct s.id, s.first_name, s.last_name from movies m inner join stars_in_movies sm on m.id = sm.movie_id inner join stars s on s.id = sm.star_id where m.id = " + singleMovieID
	);
	ArrayList<JSONObject> stars = new ArrayList<JSONObject>();
	while(starSet.next()){
		JSONObject star = new JSONObject();
		star.put("starID", starSet.getInt(1));
		star.put("name", starSet.getString(2) + " " + starSet.getString(3));
		stars.add(star);
	}
	
	//GET genres for this movie
	Statement getGenres = connection.createStatement();
	ResultSet genreSet = getGenres.executeQuery(
	"select distinct g.id, g.name from movies m inner join genres_in_movies gm on m.id = gm.movie_id_1 inner join genres g on g.id = gm.genre_id where m.id = " + singleMovieID		
	);
	ArrayList<JSONObject> genres  = new ArrayList<JSONObject>();
	while(genreSet.next()){
		JSONObject genre = new JSONObject();
		genre.put("genreID", genreSet.getInt(1));
		genre.put("genreName", genreSet.getString(2));
		genres.add(genre);
	}
	
	
	//Construct Movie Json Object
	movieJson.put("movieID", movieID);
	movieJson.put("title", title);
	movieJson.put("year", year);
	movieJson.put("director", dir);
	movieJson.put("stars", stars);
	movieJson.put("genres", genres);
	movieJson.put("trailer", trailer);
	movieJson.put("banner", banner);
}

response.getWriter().write(movieJson.toString());
%>
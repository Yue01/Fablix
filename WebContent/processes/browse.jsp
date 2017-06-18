<%@ page import = "java.io.*, java.sql.*" %> 
<%@ page import = "org.json.*" %>
<%@ page import="java.util.ArrayList"%>
<%
if(session.getAttribute("name") == null || request.getParameter("browse") == null){
	response.sendRedirect(request.getContextPath()); 
}
// Create Connection
Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false","root", "idiotking22");

// Retrieve search data and set up queries
String byTitle = ""; 
byTitle = request.getParameter( "browseTitle" );
String byGenre = "";
byGenre = request.getParameter( "browseGenre" );


// Query
PreparedStatement getMovies = connection.prepareStatement( "SELECT distinct m.* FROM movies m WHERE m.title LIKE ? AND m.id IN (SELECT distinct movie_id_1 FROM genres_in_movies WHERE genre_id IN" 
																+ "(SELECT distinct id FROM genres WHERE name LIKE ?));"
	     														);

getMovies.setString(1, byTitle+"%");
getMovies.setString(2, "%"+byGenre+"%");

ResultSet movies = getMovies.executeQuery();
ArrayList<JSONObject> movieList = new ArrayList<JSONObject>();

while ( movies.next() )
{
	JSONObject movieJson = new JSONObject();
	JSONObject movieTitle = new JSONObject();
	
	int movieID = movies.getInt(1);
	String title = movies.getString(2);
	int year = movies.getInt(3);
	String dir = movies.getString(4);
	
	//GET stars for this movie 
	Statement getStars = connection.createStatement();
	ResultSet starSet = getStars.executeQuery(
	"select distinct s.id, s.first_name, s.last_name from movies m inner join stars_in_movies sm on m.id = sm.movie_id inner join stars s on s.id = sm.star_id where m.id = " + movieID
	);
	ArrayList<JSONObject> stars = new ArrayList<JSONObject>();
	while(starSet.next()){
		JSONObject star = new JSONObject();
		star.put("starID", starSet.getInt(1));
		star.put("name", starSet.getString(3) + ", "+ starSet.getString(2));
		stars.add(star);
	}
	
	//GET genres for this movie
	Statement getGenres = connection.createStatement();
	ResultSet genreSet = getGenres.executeQuery(
	"select distinct g.name from movies m inner join genres_in_movies gm on m.id = gm.movie_id_1 inner join genres g on g.id = gm.genre_id where m.id = " + movieID		
	);
	ArrayList<String> genres  = new ArrayList<String>();
	while(genreSet.next()){
		genres.add(genreSet.getString(1));
	}
	
	//Construct a title Json Object
	movieTitle.put("id", movieID);
	movieTitle.put("name", title);
	
	//Construct Movie Json Object
	movieJson.put("movieID", movieID);
	movieJson.put("title", movieTitle);
	movieJson.put("year", year);
	movieJson.put("director", dir);
	movieJson.put("stars", stars);
	movieJson.put("genres", genres);
	
	//Add to the Movie-list
	movieList.add(movieJson);
}
response.getWriter().write(movieList.toString());
%>
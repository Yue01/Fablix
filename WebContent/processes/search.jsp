
<%@ page import = "java.io.*, java.sql.*, java.util.logging.*" %><%@ page import = "org.json.*" %><%@ page import="java.util.ArrayList"%><%// Create Connection
long totalStartTime = System.nanoTime();
long jdbcExecTime = 0;
long totalExecTime = 0;
long startTime = 0;
long endTime = 0;

if(session.getAttribute("name") == null || request.getParameter("search") == null){
	response.sendRedirect(request.getContextPath()); 
}
startTime = System.nanoTime();
Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false","root", "idiotking22");
endTime = System.nanoTime();
jdbcExecTime += endTime - startTime;

// Retrieve search data and set up queries
ArrayList<String> parameters = new ArrayList<String>();
String movieTitle = ""; 
movieTitle = request.getParameter( "movieTitle" );
String yearProduced = "";
yearProduced = request.getParameter( "yearProduced" );
String director = "";
director = request.getParameter( "director" );
String firstName = "";
firstName = request.getParameter( "firstName" );
String lastName = "";
lastName = request.getParameter( "lastName" );

// Query
startTime = System.nanoTime();
PreparedStatement getMovieIDs = connection.prepareStatement("select distinct m.* from movies m "+
"inner join stars_in_movies sm on m.id = sm.movie_id "+
"inner join stars s on s.id = sm.star_id "+ 
"where m.title like ? and m.year like ? and m.director like ? and s.first_name like ? and s.last_name like ?");

getMovieIDs.setString(1, "%"+movieTitle+"%");
getMovieIDs.setString(2, "%"+yearProduced+"%");
getMovieIDs.setString(3, "%"+director+"%");
getMovieIDs.setString(4, "%"+firstName+"%");
getMovieIDs.setString(5, "%"+lastName+"%");

ResultSet movies = getMovieIDs.executeQuery();
endTime = System.nanoTime();
jdbcExecTime += endTime - startTime;


ArrayList<JSONObject> movieList = new ArrayList<JSONObject>();
while(movies.next()){
	JSONObject movieJson = new JSONObject();
	
	startTime = System.nanoTime();
	int movieID = movies.getInt(1);
	endTime = System.nanoTime();
	jdbcExecTime += endTime - startTime;
	
	JSONObject titleObj = new JSONObject();
	titleObj.put("id", movieID);
	titleObj.put("name", movies.getString(2));

	
	startTime = System.nanoTime();
	int year = movies.getInt(3);
	String dir = movies.getString(4);
	endTime = System.nanoTime();
	jdbcExecTime += endTime - startTime;
	
	
	//GET stars for this movie 
	startTime = System.nanoTime();
	Statement getStars = connection.createStatement();
	ResultSet starSet = getStars.executeQuery(
	"select distinct s.id, s.first_name, s.last_name from movies m inner join stars_in_movies sm on m.id = sm.movie_id inner join stars s on s.id = sm.star_id where m.id = " + movieID
	);
	endTime = System.nanoTime();
	jdbcExecTime += endTime - startTime;
	
	ArrayList<JSONObject> stars = new ArrayList<JSONObject>();
	while(starSet.next()){
		String starName = "";
		String starID = "";
		
		startTime = System.nanoTime();
		starName = starSet.getString(3) + ", " + starSet.getString(2);
		starID = starSet.getString(1);
		endTime = System.nanoTime();
		jdbcExecTime += endTime - startTime;
		
		JSONObject star = new JSONObject();
		star.put("starID", starID);
		star.put("name", starName);
		stars.add(star);
	}
	getStars.close();
	starSet.close();
	
	
	//GET genres for this movie
	startTime = System.nanoTime();
	Statement getGenres = connection.createStatement();
	ResultSet genreSet = getGenres.executeQuery(
	"select distinct g.name from movies m inner join genres_in_movies gm on m.id = gm.movie_id_1 inner join genres g on g.id = gm.genre_id where m.id = " + movieID		
	);
	endTime = System.nanoTime();
	jdbcExecTime += endTime - startTime;
	ArrayList<String> genres  = new ArrayList<String>();
	while(genreSet.next()){
		genres.add(genreSet.getString(1));
	}
	genreSet.close();
	getGenres.close();
	//Construct Movie Json Object
	movieJson.put("movieID", movieID);
	movieJson.put("title", titleObj);
	movieJson.put("year", year);
	movieJson.put("director", dir);
	movieJson.put("stars", stars);
	movieJson.put("genres", genres);
	
	//Add to the Movie-list
	movieList.add(movieJson);
}if(session.getAttribute("search") != null){
	session.removeAttribute("search");
	session.invalidate(); 
}

movies.close();
getMovieIDs.close();

response.getWriter().write(movieList.toString()); 
long totalEndTime = System.nanoTime();
totalExecTime = totalEndTime - totalStartTime;
Logger logger = Logger.getLogger("MyLog");
FileHandler fh;

try{
	File currentDirectory = new File(new File(".").getAbsolutePath());
	
	String path = this.getClass().getClassLoader().getResource("").getPath();
	System.out.println(System.getProperty("user.home"));
	//Replace the file path with where you want the log file to go.
	fh = new FileHandler("C:/Users/Aaron Aung/Desktop/Task3/MyLogFile.log", true);
	logger.addHandler(fh);
	SimpleFormatter formatter = new SimpleFormatter();
	fh.setFormatter(formatter);
	
	logger.info("(TS): " + totalExecTime + " nanosecs | (TJ): " + jdbcExecTime + " nanosecs");
	fh.close();
}catch (SecurityException e) {  
    e.printStackTrace();  
} catch (IOException e) {  
    e.printStackTrace();  
}
%>

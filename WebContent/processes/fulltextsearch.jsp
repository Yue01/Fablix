<%@ page import = "java.io.*, java.sql.*" %><%@ page import = "org.json.*" %><%@ page import="java.util.ArrayList"%>
<%

Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false","root", "idiotking22");

String movieTitle = ""; 
movieTitle = request.getParameter( "movieTitle" );

// Parse Movie Title
String searchableTitle = "";

// Or split by regular space depends on how movieTitle is printed
// if ( movieTitle.contains( "%20" ) ) (if movie title returns %20 as the space)
if( movieTitle.contains( " " ) )
{
	// String[] movieTitleSplit = movieTitle.split("(?:\\s+|%20)+"); (%20)
	String[] movieTitleSplit = movieTitle.split("\\s+");
	for( int i = 0; i < movieTitleSplit.length; ++i )
	{
		searchableTitle += (movieTitleSplit[i] + "*");
		
		if ( i != (movieTitleSplit.length -1) )
		{
			searchableTitle += " ";
		}
	}
}
else
{
	searchableTitle = movieTitle + "*";
}

PreparedStatement getMovieTitles = connection.prepareStatement("SELECT * FROM movies WHERE MATCH (title) AGAINST (? IN BOOLEAN MODE);");
getMovieTitles.setString(1, searchableTitle);
ResultSet movies = getMovieTitles.executeQuery();

ArrayList<JSONObject> movieList = new ArrayList<JSONObject>();
while( movies.next() )
{
	JSONObject movieJson = new JSONObject();
	String title = movies.getString(2);
	movieJson.put("title", title);
	movieList.add(movieJson);
}

if(session.getAttribute("search") != null){
	session.removeAttribute("search");
	session.invalidate(); 
}
response.getWriter().write(movieList.toString()); 
%>

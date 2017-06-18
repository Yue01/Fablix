<%@ page import = "java.io.*, java.sql.*, java.util.*, java.text.DateFormat, java.text.SimpleDateFormat, java.util.Date" %><%@ page import = "org.json.*" %><%@ page import="java.util.ArrayList"%><%
// Create Connection
Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false","root", "idiotking22");

String firstName = "";
firstName = request.getParameter( "firstName" );
String lastName = "";
lastName = request.getParameter( "lastName" );
String cardNumber = "";
cardNumber = request.getParameter( "cardNumber" );
String expDate = "";
expDate = request.getParameter( "expDate" );
String movieIDs = "";
movieIDs = request.getParameter( "movieIDs" );

// Query
PreparedStatement psSale = connection.prepareStatement( "SELECT * FROM creditcards WHERE  first_name = ? AND last_name = ? AND id = ? AND expiration = ? ;" );
psSale.setString( 1, firstName );
psSale.setString( 2, lastName );
psSale.setString( 3, cardNumber );
psSale.setString( 4, expDate );

ResultSet rsSale = psSale.executeQuery();
JSONObject saleJson = new JSONObject();
saleJson.put( "status", "failure" );

// If customer does not exist, this would not execute
while( rsSale.next() )
{
	saleJson.put( "status", "success" );
	
	// Get the customer ID from the name
	PreparedStatement getCustomerID = connection.prepareStatement("SELECT c.id FROM customers c where first_name = ? and last_name = ?");
	getCustomerID.setString(1, firstName);
	getCustomerID.setString(2, lastName);
	ResultSet rsCustomerID = getCustomerID.executeQuery();
	int customerID = 0;
	while(rsCustomerID.next()){
		customerID = rsCustomerID.getInt(1);
	}
	if(customerID == 0){
		saleJson.put("status", "failure");
		break;
		//return;
	}
	
	// Split movieIDs and put data in a map to keep track of quantity
	String[] movieIdSplit = movieIDs.split( "," );
	Map<String, Integer> movieIdMap = new HashMap<String, Integer>();
	for ( String mId : movieIdSplit )
	{
		if( !( movieIdMap.containsKey( mId ) ) )
		{
			movieIdMap.put( mId, 1 );
		}
		else
		{
			int count = movieIdMap.get( mId );
			count++;
			movieIdMap.put( mId, count );
		}
	}
	
	// Loop through movieIdMap and put data in JSON object and insert into sales table
	// Get today's date
	DateFormat dateFormat = new SimpleDateFormat( "yyyy-MM-dd" );
	Date date = new Date();
	String todaysDate = dateFormat.format( date );
	
	// saleInfo - for saleJson
	JSONObject saleInfo = new JSONObject();
	
	// Insert sale info into JSON object
	String custName = firstName + " " + lastName;
	saleInfo.put( "custName", custName );
	saleInfo.put( "saleDate", todaysDate );
	
	// Insert saleInfo into saleJson
	saleJson.put( "saleInfo", saleInfo );
	
	// moviesBought - Update the sales table and insert into the JSON object
	ArrayList<JSONObject> moviesBought = new ArrayList<JSONObject>();
	//Statement insertIntoSales = connection.createStatement();
	for ( Map.Entry<String, Integer>pair : movieIdMap.entrySet() )
	{
		String movieId = pair.getKey();
	    // Insert data into sales table
	    for (int i =0; i < pair.getValue(); i++)
	    {
			PreparedStatement query = connection.prepareStatement("INSERT INTO sales (customer_id, movie_id_2, sale_date) VALUES (? , ? , ?)");
			query.setInt(1, customerID);
			query.setString(2, movieId);
			query.setString(3, todaysDate);
			query.executeUpdate();
	    }
			
		
		// Get the movie title from movie id as a String
		PreparedStatement getTitle = connection.prepareStatement("SELECT m.title from movies m WHERE id = ?");
		getTitle.setString(1, movieId);
		ResultSet rsMovieTitle = getTitle.executeQuery();
		String movieTitle = "";
		while(rsMovieTitle.next()){
			movieTitle = rsMovieTitle.getString(1);
		}
		// Insert moviesBought into JSON
		JSONObject tempMovie = new JSONObject();
		tempMovie.put( "name", movieTitle );
		int quantity = pair.getValue();
		tempMovie.put( "quantity", quantity);
		moviesBought.add( tempMovie );
	}
	saleInfo.put( "moviesBought", moviesBought );
}
response.getWriter().write(saleJson.toString());
%>
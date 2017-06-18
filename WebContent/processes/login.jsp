<%@ page import = "java.io.*, java.sql.*" %> 
<%@ page import = "org.json.*" %>
<%@ page import = "java.util.ArrayList"%>

<%
//Create Connection
Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false","root", "idiotking22");

//Handle request parameters/perform queries
String password = request.getParameter("password");
String email = request.getParameter("email");
Statement s = connection.createStatement();
PreparedStatement ps = connection.prepareStatement("select * from customers where email = ? and password = ?");
ps.setString(1, email);
ps.setString(2, password);

ResultSet rs = ps.executeQuery();
String loggedInUser = "";
while(rs.next()){
	loggedInUser = rs.getString(2);	
}

JSONObject json = new JSONObject();
json.put("status", "failure");
if(loggedInUser != ""){ // change to ( !( loggedInUser.equal( "" ) ) ){ 
	json.put("status", "success");
	json.put("name", loggedInUser);
	
	ArrayList<JSONObject> moviesInCart = new ArrayList<JSONObject>();
	HttpSession sessionVar = request.getSession();
	sessionVar.setAttribute("name", loggedInUser);
	sessionVar.setAttribute("moviesInCart", moviesInCart);
}


//Response to ajax
response.getWriter().write(json.toString());

%>
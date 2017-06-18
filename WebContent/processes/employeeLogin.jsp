<%@ page import = "java.io.*, java.sql.*" %> 
<%@ page import = "org.json.*" %>

<%
//Create Connection
Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false", "root", "");

//Handle request parameters/perform queries
String password = request.getParameter("emp_password");
String email = request.getParameter("emp_email");
Statement s = connection.createStatement();
PreparedStatement ps = connection.prepareStatement("select * from employees where email = ? and password = ?");
ps.setString(1, email);
ps.setString(2, password);

ResultSet rs = ps.executeQuery();
String loggedInUser = "";
while(rs.next()){
	loggedInUser = rs.getString(3);	
}

JSONObject json = new JSONObject();
json.put("status", "failure");
if(loggedInUser != ""){ // change to ( !( loggedInUser.equal( "" ) ) ){ 
	json.put("status", "success");
	json.put("name", loggedInUser);
	//HttpSession sessionVar = request.getSession();
	//sessionVar.setAttribute("name", loggedInUser);
}


//Response to ajax
response.getWriter().write(json.toString());

%>
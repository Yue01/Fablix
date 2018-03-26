<%@ page language="java" import = "java.util.*, java.sql.*, java.io.* " contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<style>
body,h1,h5,p,td {font-family: "Raleway", sans-serif}
body, html {height: 100%}
/* .bgimg {
/*   	background-image: url('./localfiles/movie1.jpg');  */ 
    min-height: 100%;
    background-position: center;
    background-size: cover;
} */
.aa {font-family: "Raleway", sans-serif}
</style>
<title>Insert title here</title>
</head>
<body>

<%
   String cus = (String)session.getAttribute("useremail");
%>

<div class="w3-top">
  <div class="w3-bar w3-black w3-card">
    <a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <a href="main.jsp" class="w3-bar-item w3-button w3-padding-large">HOME</a>
    <a href="login.jsp?funcID=quit" class="w3-btn w3-padding-large w3-hover-red w3-hide-small w3-right"><i class="fa fa-close"></i></a> 
	<a class="w3-bar-item w3-padding-large w3-right">Welcome! <%=cus %></a>

</div>
</div>
	<br></br>
<center>	
<h1>Thanks for your purchase!</h1>
<% 

				String fn = (String)request.getParameter("disfn");
				String ln = (String)request.getParameter("disln");
                Map<String, Integer> cur1 = (Map)session.getAttribute("cartmap");
                
                %>
				<table border='1'>
				<tr>
				<td>Items</td><td>Quantity</td>
				<%
				for(Map.Entry<String,Integer> entry: cur1.entrySet()){
					String cn =entry.getKey();
					int cv = entry.getValue();
			     %>
				<tr><td><%=cn %></td><td> <%=cv %></td></tr>
				<% 
				}
				//insert into sales;
				Date date = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String createdate = sdf.format(date);
				
				//sql
				
			  String loginUser = "root";
			  String loginPassword = "qwertyu";
			  String loginUrl = "jdbc:mysql://localhost:3306/usercc";
			  try {
			  	Class.forName("com.mysql.jdbc.Driver").newInstance();
			  	}catch(Exception e) {
			  	out.println("can't load mysql driver");
			  	out.println(e.toString());
			  }
			  Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
			  PreparedStatement stmt = null;
			  stmt = conn.prepareStatement("insert into sales (firstname, lastname, time) values (?, ?, ? )");
			  stmt.setString(1, fn);
			  stmt.setString(2, ln);
			  stmt.setString(3, createdate);
			  stmt.execute();
			  stmt.close();
			  conn.close();
 
				
				
				Map<String , Integer> cur = new HashMap<>();
				session.setAttribute("cartmap", cur);
				    
				%>
<table>
					<form id="backtomain" ACTION="main.jsp"  METHOD="get">
				    <INPUT id ="Back_to_Main" TYPE="Submit" VALUE="Back to Main ">
					</form>
</center>
</body>
</html>
<%@ page language="java" import = "java.util.*, java.sql.*, java.io.* " contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
    <a href="shopcart.jsp" class="w3-btn w3-padding-large w3-hover-red w3-hide-small w3-right"><i class="fa fa-shopping-cart"></i></a>
	<a class="w3-bar-item w3-padding-large w3-right">Welcome! <%=cus %></a>

</div>
</div>
	<br></br>

<%
    String s_sid = (String)request.getParameter("starid");
%>

<% 
	String loginUser = "root";
	String loginPassword = "qwertyu";
	String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		}catch(Exception e) {
		out.println("can't load mysql driver");
		out.println(e.toString());
	}
	Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
	Statement st1 = conn.createStatement();
	String sql = "select s.name, s.birthYear from stars as s where s.id = '"+s_sid+"'";
	ResultSet rs1 = st1.executeQuery(sql);
	while(rs1.next()){
		String s_name = rs1.getString("s.name");
		String s_birthYear = rs1.getString(2);
		%>
			
	<div class="w3-container w3-panel w3-animate-zoom">
		<div class="w3-card-4">
		<header class="w3-container w3-black" style="height:60%">
      			<h3><%=s_name %></h3>
   		 </header>
   		 
   		 <div class="w3-container w3-light-grey">  
   		 <hr>
   		 <span>Birthday:<%=s_birthYear %> </span>
		 <hr>
	     <span>Movie:&nbsp</span>
		<%
		Statement st2 = conn.createStatement();
		String sql2 = "select m.title, m.id from movies as m, stars_in_movies as sim where m.id=sim.movieId and sim.starId = '"+s_sid+"'";
		ResultSet rs2 = st2.executeQuery(sql2);
		while(rs2.next()){
			String m_title  = rs2.getString("m.title");
			String m_id = rs2.getString("m.id");
			%>
			<a href="singlemovie.jsp?movieid=<%=m_id %>"><%=m_title %></a> &nbsp
			<% 
		}
		st2.close();
		rs2.close();
	}
	conn.close();
	st1.close();
	rs1.close();
	
%>
<br></br>
<div>
<div>
</body>
</html>
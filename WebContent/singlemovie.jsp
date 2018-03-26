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
    String m_id = (String)request.getParameter("movieid");
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
    String sql = "SELECT m.id, m.title, m.year, m.director FROM movies AS m WHERE m.id = '"+ m_id + "'";
	ResultSet rs1 = st1.executeQuery(sql);
	while(rs1.next()){
		String mtitle = rs1.getString("m.title");
		String myear = rs1.getString("m.year");
		String mdirector = rs1.getString("m.director");
		%>
	<div class="w3-container w3-panel w3-animate-zoom">
		<div class="w3-card-4">
			<header class="w3-container w3-black" style="height:60%">
      			<h3><a href="singlemovie.jsp?movieid=<%=m_id %>"><%=mtitle %></a></h3>
   		 	</header>
   		 	
   		 	<div class="w3-container w3-light-grey">    		 		
      		<hr>
    			<span>Director: <%=mdirector %> &nbsp  Year: <%=myear %> &nbsp Id: <%=m_id %> </span>
    			<hr>
    			<span>Genres:&nbsp</span>
    			
    
		<%
		 String sqlGenre = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = '" + m_id +"' AND gim.genreId = g.id";
	    Statement stmtGenre = conn.createStatement();
		ResultSet rsGenre = stmtGenre.executeQuery(sqlGenre);
		while(rsGenre.next()){
			String g_name = rsGenre.getString("g.name");
			String g_id = rsGenre.getString("g.id");%>
			<a href="main.jsp?&genreid=<%=g_id %>"><%=g_name %></a> &nbsp
			
		<% 
		}
		stmtGenre.close();
		rsGenre.close();
		String sqlStar = "SELECT s.id, s.name FROM stars_in_movies AS sim, stars AS s WHERE sim.movieId = '" + m_id +"' AND sim.starId = s.id";
	    Statement stmtStar = conn.createStatement();
		ResultSet rsStar = stmtStar.executeQuery(sqlStar);%>
		
		<hr/>
		<span>Stars:&nbsp</span>
		<%
		while(rsStar.next()){
			String s_id = rsStar.getString("s.id");
			String s_name = rsStar.getString("s.name");%>
			<a href="singlestar.jsp?starid=<%=s_id %>"><%=s_name %></a>  &nbsp
		<% }
		rsStar.close();
		stmtStar.close();
		%>
		<br/><br/>
		<form id="addtocart" ACTION="shopcart.jsp"  ALIGN="right" METHOD="get">
		<input name="addcart" type="hidden" value= "<%=mtitle %>">

		<INPUT id ="add" TYPE="Submit" VALUE="add">
		</form>
		<% 
	}
	conn.close();
	st1.close();
	rs1.close();
	
%>
</div>
</div>
</body>
</html>
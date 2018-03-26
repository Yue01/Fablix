<%@ page language="java"  contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Using jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!-- include jquery autocomplete JS  -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.devbridge-autocomplete/1.4.7/jquery.autocomplete.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
body,h1,h5,p,td,input {font-family: "Raleway", sans-serif}
body, html {height: 100%}
    min-height: 100%;
    background-position: center;
    background-size: cover;
} */
.aa {font-family: "Raleway", sans-serif}
</style>
<title>Movie List</title>
<link rel="stylesheet" href="style.css">
</head>
<%
   String cus = (String)session.getAttribute("useremail");
%>
<body>

<div class="w3-top">
  <div class="w3-bar w3-black w3-card">
    <a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <a href="main.jsp" class="w3-bar-item w3-button w3-padding-large">HOME</a>
    <div class="w3-dropdown-hover w3-hide-small">
    
      <button class="w3-padding-large w3-button" title="More">BROWSE <i class="fa fa-caret-down"></i></button>     
      <div class="w3-dropdown-content  w3-card-4 " style="width:100px">
      <% 
				String loginUser1 = "root";
				String loginPassword1 = "qwertyu";
				String loginUrl1 = "jdbc:mysql://localhost:3306/moviedb";
				try {
					Class.forName("com.mysql.jdbc.Driver").newInstance();
					}catch(Exception e) {
					out.println("can't load mysql driver");
					out.println(e.toString());
				}
				Connection conn4 = DriverManager.getConnection(loginUrl1, loginUser1, loginPassword1);
				Statement st4 = conn4.createStatement();
				String sql4 = "select g.id, g.name from genres as g ";
				ResultSet rs4 = st4.executeQuery(sql4);
				while(rs4.next()){
					String g_id = rs4.getString("g.id");
					String g_name = rs4.getString("g.name");
				%>
				  <a href="main.jsp?genreid=<%=g_id %>&flag=<%="1"%>" class="w3-bar-item w3-button"><%=g_name %></a> &nbsp
				<% 
				}
				conn4.close();
				st4.close();
				rs4.close();
	%>
      </div>
    </div>

    <% if(session.isNew()){
		session.setAttribute("isLogin", "0");%>
		<jsp:forward page="login.jsp">
			<jsp:param name="funcID" value="2"/>
		</jsp:forward><%
	}
	else if(session.getAttribute("isLogin").equals("1")){
			String s_title = request.getParameter("title");
		    String s_year = request.getParameter("year");
		    String s_director = request.getParameter("director");
		    String s_star = request.getParameter("star");
		    String genreId = request.getParameter("genreid");
		    String initial = request.getParameter("initial");
		    String title_cap = request.getParameter("titlecapital");
		    String sort_title = request.getParameter("titlesort");
		    String sort_year = request.getParameter("yearsort");
		    String limit = request.getParameter("limit");
		    String offset = request.getParameter("offset");
			String loginUser = "root";
		    String loginPassword = "qwertyu";
		    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		    
		    String sqlMovie ="";
		    
		    
	/* 	    String usersearch = request.getParameter("usersearch"); */
		    String query = request.getParameter("query");
		    
	    try {
	    		Class.forName("com.mysql.jdbc.Driver").newInstance();
	    	}catch(Exception e) {
		    	out.println("can't load mysql driver");
		    	out.println(e.toString());
	    }
	    
	    Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
	    Connection conn1 = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
	    Statement stmt = conn.createStatement();
	    Statement stmt1 = conn1.createStatement();
	    
	    String sql = "SELECT m.id, m.title, m.year, m.director" + 
	    	" FROM movies AS m, genres_in_movies AS gim, genres AS g, stars_in_movies AS sim, stars AS s" + 
	    	" WHERE m.id = gim.movieId AND gim.genreId = g.id AND m.id = sim.movieId AND sim.starId = s.id";

	    
	    String sql1 = "";
 	   if(query!=null){
     		ArrayList<String> tokens  = new ArrayList<String>(Arrays.asList(query.trim().split(" ")));
		      for(int i = 0; i < tokens.size(); i++)
		      {
		      		 sqlMovie += "+" + tokens.get(i).trim() + "* ";
		      }
        sqlMovie = sqlMovie.trim();  
	    sql1 = "SELECT distinct m.id, m.title, m.year, m.director" +
	    		" FROM movies AS m, stars_in_movies AS sim, stars AS s " +
	    		" WHERE MATCH (title) AGAINST ('" + sqlMovie +"' IN BOOLEAN MODE)" + 
	    		" AND m.id = sim.movieId AND sim.starId = s.id";
	    System.out.println(sqlMovie);  
	    }  
 	   
	   
	    
	    if(limit == null || "null".equals(limit)){
		    	limit = "10";
	    }
	    if(offset == null || "null".equals(offset)){
		    	offset = "0";
	    }
	    
		String nextOffset = "" + (Integer.parseInt(offset) + Integer.parseInt(limit));
		String prevOffset = "" + (Integer.parseInt(offset) - Integer.parseInt(limit));
		
		if(Integer.parseInt(prevOffset) < 0){
			prevOffset = "0";
		}
	    if (!"".equals(s_title) && !"null".equals(s_title) && s_title != null){
		    	sql = sql + " AND m.title LIKE '%" + s_title + "%'";
	    }
	    if (!"".equals(s_year) && !"null".equals(s_year) && s_year != null){
		    	sql = sql + " AND m.year = '" + s_year + "'";
	    }
	    if (!"".equals(s_director) && !"null".equals(s_director) && s_director != null){
		    	sql = sql + " AND m.director LIKE '%" + s_director + "%'";
	    }
	    if (!"".equals(s_star) && !"null".equals(s_star) && s_star != null){
		    	sql = sql + " AND s.name LIKE '%" + s_star + "%'";
	    }
	    if (!"".equals(genreId) && !"null".equals(genreId) && genreId != null){
	   	 	sql = sql + " AND g.id = '" + genreId +"'";
	    }
	    if (!"".equals(initial) && !"null".equals(initial) && initial != null){
	    		sql = sql + " AND m.title LIKE '" + initial + "%'";
	    }
		    sql = sql + " GROUP BY m.id, m.title, m.year, m.director";
	    
	    if("asc".equals(sort_title)){
		    	sql = sql + " ORDER BY m.title ASC";
	    }
	    else if("desc".equals(sort_title)){
		    	sql = sql + " ORDER BY m.title DESC";
	    }
	    else if("asc".equals(sort_year)){
		    	sql = sql + " ORDER BY m.year ASC";
	    }
	    else if("desc".equals(sort_year)){
		    	sql = sql + " ORDER BY m.year DESC";
	    }
	    
	    sql = sql + " LIMIT " + limit;
	    sql = sql + " OFFSET " + offset;
	    ResultSet rs;
	    
	    System.out.println("-------------------");
/* 	    System.out.println(usersearch); */
	    System.out.println(sql1);
	    
	    if(query != null) {
	    	 	rs = stmt1.executeQuery(sql1);
	    	 	System.out.println("Executing sql1");
	    	 	System.out.println(sql1);
	    } else {
	    		rs = stmt.executeQuery(sql);
	    		System.out.println("Executing sql");
	    		System.out.println(sql);
	    }
	    
	
	    if("none".equals(sort_title)){%>
	    
	    <a href="main.jsp?titlesort=asc&yearsort=none&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">title</a>
	    <% }
	    else if("asc".equals(sort_title)){%>
	    <a href="main.jsp?titlesort=desc&yearsort=none&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">title&#8593</a>
	     <% }
	    else if("desc".equals(sort_title)){%>
	    <a href="main.jsp?titlesort=asc&yearsort=none&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">title&#8595</a>
	    <% }
	    else{%>
	    <a href="main.jsp?titlesort=asc&yearsort=none&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">title</a>
	    <% }%>
	    &nbsp 
	    <%if("none".equals(sort_year) || sort_year == null){%>
	    <a href="main.jsp?titlesort=none&yearsort=asc&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">year</a>
	    <% }
	    else if("asc".equals(sort_year)){%>
	    <a href="main.jsp?titlesort=none&yearsort=desc&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">year&#8593</a>
	     <% }
	    else if("desc".equals(sort_year)){%>
	    <a href="main.jsp?titlesort=none&yearsort=asc&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">year&#8595</a>
	    <% }
	    else{%>
	    <a href="main.jsp?titlesort=none&yearsort=asc&limit=<%=limit %>&offset=0&title=<%=s_title %>&year=<%=s_year %>&director=<%=s_director %>&star=<%=s_star %>&genreid=<%=genreId %>&initial=<%=initial %>" class="w3-bar-item w3-button w3-padding-large">year</a>
	    <% }%>
	 

	   
   <div class="topsearch w3-right w3-padding"> 
 	    <form action="main.jsp?"> 
	    		<input name="query" id="autocomplete" size="45" placeholder="Search.."/>
    			<script src="search.js"></script>
	      <button type="submit" class="w3-button w3-hover-red w3-hide-small"><i class="fa fa-search"></i></button>
		  <a href="login.jsp?funcID=quit" class="w3-button w3-hover-red w3-hide-small w3-right"><i class="fa fa-close"></i></a>   	
		  <a href="shopcart.jsp" class="w3-button w3-hover-red w3-hide-small w3-right"><i class="fa fa-shopping-cart"></i></a>
 	    </form>
  	</div>
    
  </div>
</div>
<br></br>

    <%while (rs.next()) {
        String m_title = rs.getString("m.title");
        String m_id = rs.getString("m.id");
        String m_year = rs.getString("m.year");
        String m_director = rs.getString("m.director");%>
        
        <div class="w3-container w3-panel w3-animate-zoom">
        <br/>
        <div class="w3-card-4">
        
        <header class="w3-container w3-black" style="height:60%">
      		<h3><a href="singlemovie.jsp?movieid=<%=m_id %>"><%=m_title %></a></h3>
    		</header>
    		
    		<div class="w3-container w3-light-grey">    		 		
      		<hr>
    			<span>Director: <%=m_director %> &nbsp  Year: <%=m_year %> &nbsp Id: <%=m_id %> </span>
    			<hr>
    			<span>Genres:&nbsp</span>
        <% String sqlGenre = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = '" + m_id +"' AND gim.genreId = g.id";
	    Statement stmtGenre = conn.createStatement();
		ResultSet rsGenre = stmtGenre.executeQuery(sqlGenre);
		
		while(rsGenre.next()){
			String g_name = rsGenre.getString("g.name");
			%>
			<%=g_name %> &nbsp
		<% 
		}
		rsGenre.close();
		stmtGenre.close();
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
		<input name="addcart" type="hidden" value= "<%=m_title%> ">
		<INPUT id ="add" TYPE="Submit" VALUE="add">
		<br></br>
		</form>
		</div>
		</div>
  </div>
  
</div>



<!-- Menu Modal -->
<div id="menu" class="w3-modal w3-animate-opacity" >
  <div class="w3-modal-content w3-animate-zoom w3-large">
    <div class="w3-container w3-black w3-display-container w3-large">
      <span onclick="document.getElementById('menu').style.display='none'" class="w3-button w3-display-topright w3-large">x</span>
      <h1 ALIGN="center">Welcome to myFlix!</h1>
    </div>
   	   
	 <!-- Form starts from here -->
	 
	  <FORM id="searchres" ACTION="main.jsp" METHOD="POST">
	  		 <div class="w3-section w3-padding-128">
		  <p>
		  <label><b>Title</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Username" id="title" name="title">
          </p>
          <p>
          <label><b>Year</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Year" id="title" name="year">
          </p>
          <p>
          <label><b>Director</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Director" id="director" name="director">
          </p>
          <p>
          <label><b>Stars Name</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Stars Name" id="stars" name="star">
          </p>

	        <center>
	        <td><INPUT id ="search" TYPE="Submit" VALUE="search"><td>   
	        </center>     	        	        
	       </tr>
<!-- 	    </table> -->
			</div>
	    <br>
	  </FORM>
    	</div>
  </div>
</div>


 <div id="search" class="w3-modal">
    <div class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px">


      <FORM id="searchres" ACTION="main.jsp" METHOD="POST">
        <div class="w3-section">
          <label><b>Title</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Username" id="title" name="title" >
          <label><b>Year</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Year" id="title" name="year">
          <label><b>Director</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Director" id="director" name="director">
          <label><b>Stars Name</b></label>
          <input class="w3-input w3-border w3-margin-bottom" type="text" placeholder="Enter Stars Name" id="stars" name="star">
          
          <label><b>Password</b></label>
          <input class="w3-input w3-border" type="password" placeholder="Enter Password" name="psw" required>
          <button class="w3-button w3-block w3-green w3-section w3-padding" type="submit">Login</button>
          <input class="w3-check w3-margin-top" id ="search" type="Submit" VALUE="search"> Search
        </div>
      </form>
    </div>
  </div>



   
    <% }
    rs.close();
    stmt.close();
    stmt1.close();
    conn1.close();
	conn.close();%>
	
<div>
	
	<div>
	<center>
		<% 
		String all = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		for(int i=0;i<all.length();i++){
		String cur = all.valueOf(all.charAt(i));
		%>
		<a href="main.jsp?initial=<%=cur %>&flag=<%="2"%>"><%=cur %></a> &nbsp
		
		<% 	
	}
%>
	</center>
	</div>
	

</div>

</div>

 <div>
 
 <center>
 <table>
 
 <td>
 <% 
	if(Integer.parseInt(offset) > 0){ %>
		<form method="get">
	    	<input name="titlesort" type="hidden" value=<%=sort_title%>>
			<input name="yearsort" type="hidden" value=<%=sort_year%>>
	    	<input name="limit" type="hidden" value=<%=limit%>>
			<input name="offset" type="hidden" value=<%=prevOffset%>>
			<input name="title" type="hidden" value=<%=s_title%>>
			<input name="year" type="hidden" value=<%=s_year%>>
			<input name="director" type="hidden" value=<%=s_director%>>
			<input name="star" type="hidden" value=<%=s_star%>>
			<input name="genreid" type="hidden" value=<%=genreId%>>
			<input name="initial" type="hidden" value=<%=initial%>>
			<button class="w3-btn w3-black w3-padding-small" type="submit">Prev</button>
		</form>
	<%}
	%>
</td>

<td>	
 <form id="itemForm" method="get">
    	<input name="titlesort" type="hidden" value=<%=sort_title%>>
		<input name="yearsort" type="hidden" value=<%=sort_year%>>
    		<select id="sel" name="limit" value="25">
			<option value="10">10</option>
			<option value="25">25</option>
			<option value="50">50</option>
			<option value="100">100</option>
		</select>
		<input name="offset" type="hidden" value=<%=offset%>>
		<input name="title" type="hidden" value=<%=s_title%>>
		<input name="year" type="hidden" value=<%=s_year%>>
		<input name="director" type="hidden" value=<%=s_director%>>
		<input name="star" type="hidden" value=<%=s_star%>>
		<input name="genreid" type="hidden" value=<%=genreId%>>
		<input name="initial" type="hidden" value=<%=initial%>>
		<button class="w3-btn w3-black w3-padding-small" type="submit">Results per Page</button>
</form>

</td>
	
<td>
	<form method="get">
    	<input name="titlesort" type="hidden" value=<%=sort_title%>>
		<input name="yearsort" type="hidden" value=<%=sort_year%>>
    	<input name="limit" type="hidden" value=<%=limit%>>
		<input name="offset" type="hidden" value=<%=nextOffset%>>
		<input name="title" type="hidden" value=<%=s_title%>>
		<input name="year" type="hidden" value=<%=s_year%>>
		<input name="director" type="hidden" value=<%=s_director%>>
		<input name="star" type="hidden" value=<%=s_star%>>
		<input name="genreid" type="hidden" value=<%=genreId%>>
		<input name="initial" type="hidden" value=<%=initial%>>
		<button class="w3-btn w3-black w3-padding-small" type="submit">Next</button>
	</form>
</td>
</table>
</center>
</div>
<% 
	}
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2"/>
	</jsp:forward><%
}%>

</body>
</html>
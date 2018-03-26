<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Operation Panel</title>
</head>
<body>
<%
   String cus = (String)session.getAttribute("useremail");
%>

<div align="right">
<h5>Welcome! <%=cus %></h5>
		<form id="employee" ACTION="dashboard.jsp"  METHOD="POST">
		<INPUT class="w3-button w3-black" id ="employeejump" TYPE="Submit" VALUE="log out">
	    <input name="eflag" type="hidden" value="3">
		</form>
</div>
<center>
<div>
<table>
<tr>
					            <h3 class="modal-title">Insert A New Star</h3>
					            <form action="operation.jsp" id="insertStarForm">
						                
						                <div>
						                <label for="title">Star Name</label>
						                <input type="text" name="starName" id="starName" placeholder="e.g. John">
						              </div>			
						                

					  	              <div >
						                <label for="title">Date Of Birth(Optional)</label>
						                <input type="text" name="starDob" id="starDob" placeholder="e.g. YYYY-MM-DD">
						              </div>	
						              	        	    <input name="fun" type="hidden" value="1">
					          <div>
										 <INPUT id ="insertStars" class="buttons btn btn-lg" style="background-color: #bd5555; color: white;
										 border: none;" TYPE="Submit" VALUE="INSERT STAR">
					          </div>
					            </form>


</tr>
<tr>

		    <div class="modal fade" data-backdrop='static' id="movieModal">
			      <div class="modal-dialog" role="document">
				        <div class="modal-content">
					          <div class="modal-header">
					            <h3 class="modal-title">Update Movie Information</h3>
					          </div>
					          <div class="modal-body">
					            <form action="operation.jsp" METHOD="POST" id="insertMovieForm">
						                
						              <div class="form-group">
						                <label for="title">Movie Title</label>
						                <input class="form-control" type="text" name="movieTitle" id="movieTitle" placeholder="e.g. Star Wars">
						              </div>
						
						              <div class="form-group">
						                <label for="title">Year</label>
						                <input class="form-control" type="text" name="movieYear" id="movieYear" placeholder="e.g. 1998">
						              </div>						              

					  	              <div class="form-group">
						                <label for="title">Director</label>
						                <input class="form-control" type="text" name="movieDirector" id="movieDirector" placeholder="e.g. Allan Poe">
						              </div>	
					  	            
					  	              <div class="form-group">
						                <label for="title">Star Full Name</label>
						                <input class="form-control" type="text" name="starName" id="starName" placeholder="e.g. Ryan Gosling">
						              </div>	
						              <div class="form-group">
						                <label for="title">Genre</label>
						                <input class="form-control" type="text" name="genreName" id="genreName" placeholder="e.g. Horror">
						              </div>
						              <input name="fun" type="hidden" value="2">
						               <div class="modal-footer">
 										 <INPUT id ="updateMovie" class="buttons btn btn-lg" style="background-color: #07468E; color: white;
									  border: none;" TYPE="Submit" VALUE="UPDATE MOVIE">
					          </div>
					            </form>
					           
					          </div>
					          
				        </div>
			      </div>
		    </div>
</tr>
<tr><td>
<div>
					<form id="showmeta" ACTION="operation.jsp"  METHOD="post">
					<input name="fun" type="hidden" value="3">
					<INPUT id ="showmetadata" TYPE="Submit" VALUE="ShowMetaData">
					</form>
</div>
</td>
<td>
<div>
					<form id="showmeta" ACTION="operation.jsp"  METHOD="post">
					<input name="fun" type="hidden" value="4">
					<INPUT id ="closemetadata" TYPE="Submit" VALUE="CloseMetaData">
					</form>
</div>
</td>
</tr>
<tr>
<%
String loginUser = "root";
String loginPassword = "qwertyu";
String loginUrl = "jdbc:mysql://172.31.24.248:3306/moviedb?autoReconnect=true&amp;useSSL=false&amp;cachePrepStmts=true";


String catalog = null;
String schemaPattern = null;
String tableNamePattern = null;
String columnNamePattern = null;
String[] types = null;
Connection myConn = null;
ResultSet myRs = null;
ResultSet myRs2 = null;
ResultSet myRs3 = null;
Statement st = null;
if("3".equals(request.getParameter("fun"))){
try {
	// 1. Get a connection to database
    myConn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);

	// 2. Get metadata
	DatabaseMetaData databaseMetaData = myConn.getMetaData();

	myRs = databaseMetaData.getTables(catalog, schemaPattern, tableNamePattern,
			types);
%>
	<table style="width:40%" border="2px"> 
	<tr><td style="width:40%"><%="Tables" %></td><td><%="Columns" %></td><td><%="Types" %></td></tr>
	<%
	while (myRs.next()) {
            String s = myRs.getString("TABLE_NAME");
		%>	
		  <tr>
		    <td style="width:40%"><%=s %></td>
		  <td>
		<%  
		myRs2 =  databaseMetaData.getColumns(catalog, schemaPattern, s, columnNamePattern);
		
	 	while(myRs2.next()){
	 		String c = myRs2.getString("COLUMN_NAME");
	 		%>
		  <%=c %><br>

	 	<%
	 	}
	 	%></td>
	  	<td>
	  	
		
	<% 
	st = myConn.createStatement();
	String sql = "select * from "+s+" ";
	myRs3 = st.executeQuery(sql);
	ResultSetMetaData resultSetMetaData = myRs3.getMetaData();
	for(int i=1; i<=resultSetMetaData.getColumnCount(); i++) {
		String cur = resultSetMetaData.getColumnTypeName(i) ;
		%>
		<%=cur %><br>
		<% 
	}
	%></td></tr>
	<% 
		
	}
	%>
	</table>
	<%
	

} catch (Exception exc) {
	exc.printStackTrace();
} 
if (myRs != null) {
	myRs.close();
}
if (myRs2 != null) {
	myRs.close();
}
if (myRs3 != null) {
	myRs.close();
}
if (st != null) {
	st.close();
}
if(myConn !=null){
	myConn.close();
}
}

%>
</tr>
</table>
</div>
</center>
<%
if("1".equals(request.getParameter("fun"))){
	//firstly: generate a id by add 1 to the greatest id
	
	String s_id = null;
	try{
		Connection Con = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
		Statement st2 = Con.createStatement();
		String sql2 = "select s.id from stars as s order by id desc limit 1";
		ResultSet myRs4 = st2.executeQuery(sql2);
		while(myRs4.next()){
			s_id = myRs4.getString("s.id");
		}
		//split and add
		int len = s_id.length();
		String num = s_id.substring(2,len);
		int n = Integer.parseInt(num);
		n = n + 1;
		String ori =String.valueOf(n);
		s_id = "nm" + ori;
	}catch (Exception exc1) {
		exc1.printStackTrace();
	} 
  
    	
	//String id = request.getParameter("starid");
	String Name = request.getParameter("starName");
	String Dob = request.getParameter("starDob");
	int dob = Integer.parseInt(Dob);
	
	  try {
	  		Class.forName("com.mysql.jdbc.Driver").newInstance();
	  	} catch (Exception e) {
	  	out.println("can't load mysql driver");
	  	out.println(e.toString());
	  }
	  Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
	  PreparedStatement stmt = null;
	  stmt = conn.prepareStatement("insert into stars (id, name, birthYear ) values (?, ?, ? )");
	  stmt.setString(1, s_id);
	  stmt.setString(2, Name);
	  stmt.setInt(3, dob);  
	  stmt.execute();
  %>

	<script language= "javascript">
			alert("Insert Success!");
	</script>
<%
  stmt.close();
  conn.close();
}

if("2".equals(request.getParameter("fun"))){
	
	String movieTitle = request.getParameter("movieTitle");
	String year = request.getParameter("movieYear");
	int movieYear;
	if(year.equals("") || year == null){
		movieYear = -1;
	} else {
		movieYear = Integer.parseInt(year);
	}
	
	String movieDirector = request.getParameter("movieDirector");
	String starName = request.getParameter("starName");
	String genreName = request.getParameter("genreName");
	
	try{
		Connection Con = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
 		String sql3 = "{CALL add_movie(?,?,?,?,?)}"; 
		/* String sql3 = "{CALL add_movie( ' " +movieTitle +" ' ,  " + movieYear+"  , ' " +starName+ " ' , ' " +genreName+" ' )}"; */
		
		CallableStatement st3 = Con.prepareCall(sql3);
		st3.setString(1, movieTitle);
		st3.setInt(2, movieYear);
		st3.setString(3, movieDirector);
		st3.setString(4, starName);
		st3.setString(5, genreName);
		st3.execute();
		
		st3.close();
		Con.close();
	}catch (Exception exc1) {
		exc1.printStackTrace();
	} 

  %>

	<script language= "javascript">
			alert("Update Success!");
	</script>
<%
  
}
%>



</body>
</html>
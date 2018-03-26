<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Dashboard</title>
</head>

<script language= "javascript">
     function checkvalid(){
       var curmail= employ.email.value;
       var curpwd=  employ.password.value;
       if(curmail==""){
         alert("Invalid email address!");
         return false;
       }
       else if(curpwd==""){
         alert("Invalid password!");
         return false;
       }
     }
</script> 

<body>
<div id="signin" class="w3-modal">
      <h1 ALIGN="center">Employee Login!</h1>
    </div>
   	   <FORM id="employ" ACTION="dashboard.jsp" onsubmit="return checkvalid()" METHOD="POST">
	     <table name="mytable" align="center">
	       <tr>
	         <td style="text-align:right">Email:</td>
	         <td><INPUT id="email" TYPE="TEXT" NAME="email"></td>
	       </tr>
	        <tr></tr><tr></tr><tr></tr>
	        <tr>
	          <td style="text-align:right">PassWord:</td>
	        <td><INPUT id="password" TYPE="PASSWORD" NAME="password"></td>
	        	    <input name="eflag" type="hidden" value="1">
	       </tr>
	    </table><br>
	    <center>
	      <INPUT id ="signinbutton" class="button white small" style="color:black" TYPE="Submit" VALUE="Sign in">
	      <br></br>
	    </center>
	  </FORM>   
  </div>
</div>
</div>

<% 
if("1".equals(request.getParameter("eflag"))){
	String userEmail = request.getParameter("email");
	String userPassword = request.getParameter("password");
	
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
    Statement stmt = conn.createStatement();
    String sql = "SELECT * FROM employees AS e WHERE e.email ='" + userEmail + "' AND e.password ='" + userPassword +"'";
    ResultSet rs = stmt.executeQuery(sql);
    if(rs.next()){
    	session.setAttribute("useremail", userEmail);
    	%>
		<jsp:forward page="operation.jsp"/><%
    }
    else{
     	%>
    	<jsp:forward page="dashboard.jsp">
			<jsp:param name="eflag" value="0"/>
		</jsp:forward>
    		<%

    }
    rs.close();
    stmt.close();
    conn.close();
}else if("3".equals(request.getParameter("eflag"))){
	session.invalidate();
	%>
<jsp:forward page="dashboard.jsp">
  <jsp:param name="eflag" value="0"/>
 </jsp:forward>
	<%
}

%>

<div>







</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<!-- <script src='https://www.google.com/recaptcha/api.js'></script> -->
<head></head>
<title>W3.CSS Template</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1,h5,p,td {font-family: "Raleway", sans-serif}
body, html {height: 100%}
 .bgimg {
    	background-image: url('./localfiles/movie2.jpeg'); 
    min-height: 100%;
    background-position: center;
    background-size: cover;
} 
</style>
<script language= "javascript">
     function checkvalid(){
       var curmail= inha.email.value;
       var curpwd=  inha.password.value;
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
<div class="bgimg w3-display-container w3-text-white">
<div>
<!-- entry to the dash board is added here! -->
<br>
		<form id="employee" ACTION="dashboard.jsp"  METHOD="POST">
		<INPUT class="w3-button w3-black" id ="employeejump" TYPE="Submit" VALUE="Dashboard">
	    <input name="eflag" type="hidden" value="0">
		</form>
</div>
    
  <div class="w3-display-topright w3-container w3-xlarge">
    <p><button onclick="document.getElementById('signin').style.display='block'" class="w3-button w3-black">Sign In</button>
    <button onclick="document.getElementById('signup').style.display='block'" class="w3-button w3-black">Sign Up</button></p>
  </div>
  
  <div class="w3-display-middle">
    <h1 class="w3-jumbo w3-animate-top">myFlix</h1>
    <hr class="w3-border-grey" style="margin:auto;width:40%">
    <p class="w3-large w3-center">Come for what you love.</p>
    <p class="w3-large w3-center">Stay for what you discover.</p>
  </div>
  
  <div class="w3-display-bottomleft">

    <p class="w3-large w3-center">copyright © You Hao, Qiu Yue</p>
  </div>
  
  
</div>

<!-- Menu Modal -->
<div id="signin" class="w3-modal">
  <div class="w3-modal-content w3-animate-zoom">
    <div class="w3-container w3-black w3-display-container">
      <span onclick="document.getElementById('signin').style.display='none'" class="w3-button w3-display-topright w3-large">x</span>
      <h1 ALIGN="center">Welcome to myFlix!</h1>
    </div>
   	   <FORM id="inha" ACTION="/cs122b-winter18-team-44/login.jsp" onsubmit="return checkvalid()" METHOD="POST">
	  			<input name="funcID" type="hidden" value="1">
	     <table name="mytable" align="center">
	       <tr>
	         <td style="text-align:right">Email:</td>
	         <td><INPUT id="email" TYPE="TEXT" NAME="email"></td>
	       </tr>
	        <tr></tr><tr></tr><tr></tr>
	        <tr>
	          <td style="text-align:right">PassWord:</td>
	        <td><INPUT id="password" TYPE="PASSWORD" NAME="password"></td>
	       </tr>
	    </table><br>
	    <center>
	      <INPUT id ="signinbutton" class="button white small" style="color:black" TYPE="Submit" VALUE="Sign in">
	  
	      
	      <br></br>
<!-- 	      <div data-theme="dark" class="g-recaptcha" data-sitekey="6LcW-UYUAAAAAPrMpZzI_J4dOU7d0AC4yC7BgU2z"></div> -->
	    </center>
	  </FORM>   
  </div>
</div>
<!-- 
<div id="signup" class="w3-modal">
  <div class="w3-modal-content w3-animate-zoom">
    <div class="w3-container w3-black w3-display-container">
      <span onclick="document.getElementById('signup').style.display='none'" class="w3-button w3-display-topright w3-large">x</span>
      <h1 ALIGN="center">Please register!</h1>
    </div>
   	   <FORM id="outha" ACTION="/cs122b-winter18-team-44/servlet/login.jsp" METHOD="POST">
	  			<input name="funcID" type="hidden" value="3">
	     <table name="mytable" align="center">
	       <tr>
	         <td style="text-align:right">Email:</td>
	         <td><INPUT id="email" TYPE="TEXT" NAME="email"></td>
	       </tr>
	        <tr></tr><tr></tr><tr></tr>
	        <tr>
	          <td style="text-align:right">PassWord:</td>
	        <td><INPUT id="password" TYPE="PASSWORD" NAME="password"></td>
	       </tr>
	    </table><br>
	    <center>
	      <INPUT id ="signinbutton" class="button white small" style="color:black" TYPE="Submit" VALUE="Sign Up">
	      <br></br>
	      <div data-theme="dark" class="g-recaptcha" data-sitekey="6LcW-UYUAAAAAPrMpZzI_J4dOU7d0AC4yC7BgU2z"></div>
	    </center>
	  </FORM>   
  </div>
</div> -->

<% 
String isLogin = null;
isLogin = (String)session.getAttribute("isLogin");
if("quit".equals(request.getParameter("funcID"))){
	session.invalidate();
	%>
<script language= "javascript">
         alert("Bye!");
</script>
<jsp:forward page="login.jsp">
  <jsp:param name="funcID" value="0"/>
 </jsp:forward>
	<%
}else if("1".equals(isLogin)){%>
	<jsp:forward page="main.jsp"/><%
}else {session.setAttribute("isLogin", "0");
if("1".equals(request.getParameter("funcID"))){
	String userEmail = request.getParameter("email");
	String userPassword = request.getParameter("password");
	
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
    Statement stmt = conn.createStatement();
    String sql = "SELECT * FROM user AS c WHERE c.email ='" + userEmail + "' AND c.password ='" + userPassword +"'";
    ResultSet rs = stmt.executeQuery(sql);
    if(rs.next()){
    	session.setAttribute("isLogin", "1");
    	session.setAttribute("useremail", userEmail);
    	Map<String, Integer> cartmap = new HashMap<>();
    	session.setAttribute("cartmap", cartmap);%>
		<jsp:forward page="main.jsp"/><%
    }
    else{
     	%>
    	<script language= "javascript">
    	         alert("Sorry! Incorrect email or password!");
    	</script>
    		<%

    }
    rs.close();
    stmt.close();
    conn.close();
}
//signup function
if("3".equals(request.getParameter("funcID"))){
	String userEmail = request.getParameter("email");
	String userPassword = request.getParameter("password");
	
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
  stmt = conn.prepareStatement("insert into user (email, password) values (?, ? )");
  stmt.setString(1, userEmail);
  stmt.setString(2, userPassword);
  stmt.execute();
  %>

	<script language= "javascript">
			alert("Congrats! Registration Success!");
	</script>
<%
  stmt.close();
  conn.close();
}
if("2".equals(request.getParameter("funcID"))){
%>
<script language= "javascript">
         alert("Login first!");

</script>
<% 
}
}

%>

<div>


</div>

</body>

</html>
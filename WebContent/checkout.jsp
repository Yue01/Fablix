<%@ page language="java" import = "java.util.*, java.sql.*, java.io.* " contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
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
<title>CheckOut</title>
</head>
<body>
	
<script language= "javascript">
     function checkvalid(){
       var curcn= usercheck.creditnum.value;
       var curep= usercheck.expdate.value;
       var curfn= usercheck.fn.value;
       var curln= usercheck.ln.value;
       
       if(curcn==""){
         alert("Invalid Credit Card!");
         return false;
       }
       else if(curep==""){
         alert("Invalid Expiration Date!");
         return false;
       }
       else if(curfn==""){
           alert("First Name Please!");
           return false;
         }
       else if(curln==""){
           alert("Last Name Please!");
           return false;
         }
       
     }
</script> 

<div class="w3-top">
  <div class="w3-bar w3-black w3-card">
    <a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <a href="main.jsp" class="w3-bar-item w3-button w3-padding-large">HOME</a>

</div>
</div>
	<br></br>
	<br></br>
<%
				//这里加bar,主页(房子图标),用户名,logout功能

				String now = (String)request.getParameter("check");
				if(now.equals("1")||now=="1"){
					%>
					
					<div class="w3-card-4 w3-border">
						  <div class="w3-container w3-black">
						    <h2>Please input creditcard information</h2>
						  </div>
						  <form class="w3-container" id="usercheck" ACTION="checkout.jsp" METHOD="post" onsubmit="return checkvalid()">
						    <p>      
						    <label class="w3-text"><b>Credit Number</b></label>
						    <input class="w3-input w3-border" id="creditnum" TYPE="TEXT" NAME="creditnum"></p>
						    <p>      
						    <label class="w3-text"><b>Expiration Date</b></label>
						    <input class="w3-input w3-border" id="expdate" TYPE="TEXT" NAME="expdate"></p>
						    <input name="check" type="hidden" value=<%="2"%>>
						    <p>      
						    <label class="w3-text"><b>First Name</b></label>
						    <input class="w3-input w3-border" id="fn" TYPE="TEXT" NAME="fn"></p>
						    <p>      
						    <label class="w3-text"><b>Last Name</b></label>
						    <input class="w3-input w3-border" id="ln" TYPE="TEXT" NAME="ln"></p>
						    <p>
						    <center>
						    <INPUT id ="checkout" TYPE="Submit" VALUE="Submit"></center></p>
					  </form>
					</div>

					  <% 
				}else if(now.equals("2") || now == "2"){
						String creditnum = (String)request.getParameter("creditnum");
						String expdate = (String)request.getParameter("expdate");
						String fn = (String)request.getParameter("fn");
						String ln = (String)request.getParameter("ln");
						
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
					    String sql = "SELECT * FROM creditcard AS c WHERE c.credit ='" + creditnum + "' AND c.exp ='" + expdate +"' and c.first = '"+ fn +"' and c.last = '"+ln +"'";
					    ResultSet rs = stmt.executeQuery(sql);
					    if(rs.next()){
					    %>
					    <center>
					    
					    <div class="w3-container w3-margin">
					    
					    <div class="w3-container w3-grey">
						    <h2>Please check again!</h2>
						  <form class="w3-container" id="usercheck" ACTION="display.jsp" METHOD="get" onsubmit="return checkvalid()">
						    <p>      
						    <label class="w3-text"><b>Credit Number: </b></label>
						    <label class="w3-text"><b><%=creditnum %></b></label>
							</p>
						    <p>      
						    <label class="w3-text"><b>Expiration Date: </b></label>
						    <label class="w3-text"><b><%=expdate %></b></label>
						    </p>
						    <p>      
						    <label class="w3-text"><b>First Name: </b></label>
						    <label class="w3-text"><b><%=fn %></b></label>
						    </p>
						    <p>      
						    <label class="w3-text"><b>Last Name: </b></label>
						    <label class="w3-text"><b><%=ln %></b></label>
						    </p>
						    <p>
						    <center>
						    <input name="disfn" type="hidden" value="<%=fn %>">
							<input name="disln" type="hidden" value="<%=ln %>">
						    <INPUT id ="checkout" TYPE="Submit" VALUE="Continue to proceed"></center></p>
					  </form>
					
						    

						</center>
	 					<%
					    }else{
							%>
							<h1>not correct</h1>
							<% 
						}
							
					    conn.close();
					    stmt.close();
					    rs.close();
				}    
					
					
					
					
					
					
	
				



%>
</body>
</html>
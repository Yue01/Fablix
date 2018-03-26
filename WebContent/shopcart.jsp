<%@ page language="java"  contentType="text/html; charset=UTF-8"
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
<title>Insert title here</title>
</head>



<body>

<div class="w3-top">
  <div class="w3-bar w3-black w3-card">
    <a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <a href="main.jsp" class="w3-bar-item w3-button w3-padding-large">HOME</a>




<%      
try {
		//for this page functions:
       String addmovie = (String)request.getParameter("addcart");  
       String delmovie = (String)request.getParameter("deletecart");
       String modmovie = (String)request.getParameter("modifynum");
       String modmoviename = (String)request.getParameter("modifyname");
       
       if(addmovie!=null){
       Map<String, Integer> cur = (Map)session.getAttribute("cartmap");
       if(cur.containsKey(addmovie)){
    	   cur.put(addmovie, (cur.get(addmovie))+1);
       }else{
    	   cur.put(addmovie, 1);
       }
       session.setAttribute("cartmap", cur);
       }
       
       if(delmovie!=null){
       Map<String, Integer> cur2 = (Map)session.getAttribute("cartmap");
       if(cur2.get(delmovie)<=1){
    	   cur2.remove(delmovie);
       }else{
    	   cur2.put(delmovie, (cur2.get(delmovie))-1);
       }
       session.setAttribute("cartmap", cur2);
       }
       
       if(modmovie == ""){
       
       } else if(modmovie!=null){
       Map<String, Integer> cur3 = (Map)session.getAttribute("cartmap");
           int num =Integer.parseInt(modmovie);
           if(num<=0){
        	   cur3.remove(modmoviename);
           }else{
        	   cur3.put(modmoviename,num);
           }           
               session.setAttribute("cartmap", cur3);
       }
       
       
       Map<String, Integer> cur1 = (Map)session.getAttribute("cartmap");
       if(cur1==null || cur1.size()<1)
       { 
		    	 %>
				</div>
				</div>
				<br></br>
				<br></br>
		    	 <center>
		    	 <h4> Oops! You haven't added anything yet!</h4>
		    	 </center>
		    	 <% 
           
       }else{
    	   %>
			<a href="checkout.jsp?check=1" class="w3-btn w3-padding-large w3-hover-red w3-hide-small w3-right"><i class="material-icons">local_shipping</i></a>
			</div>
			</div>
				<br></br>
				<br></br>

<center>
<table border='1'>
<tr>
<td>Movie_title</td><td>Quantity</td>
    	   <%
		for(Map.Entry<String,Integer> entry: cur1.entrySet()){
			String cn =entry.getKey();
			int cv = entry.getValue();
			%>
			<tr><td><%=cn %></td><td> <%=cv %></td>
			<td>	
					<form id="addtocart" ACTION="shopcart.jsp"  METHOD="get" onsubmit="return checkmod()">
					<input name="modifynum" type="text">
					<input name="modifyname" type="hidden" value= "<%=cn %>">
					<INPUT id ="Modify" TYPE="Submit" VALUE="Modify">
					</form>
			
			
			</td>
			<td>
					<form id="delfromcart" ACTION="shopcart.jsp"  METHOD="get">
					<input name="deletecart" type="hidden" value= "<%=cn %>">
					<INPUT id ="Delete" TYPE="Submit" VALUE="Delete">
					</form>
			</td>
			</tr>
			<% 
	    }
    	  
	    
   	   %>
			
		<% 
      }
} catch (Exception e) {
	// TODO: handle exception
}
      
%>


</table>
</center>



</div>
</div>

</body>
</html>
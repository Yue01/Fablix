<%
	if(session.getAttribute("name") != null){
		response.sendRedirect("home.jsp"); 
	}
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Fablix | Login</title>

    <link href="assets/bootstrap-4.0.0-alpha.6-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/login.css">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="plugins/toastr/toastr.min.css">

    <script src="assets/jquery-3.2.1/jquery-3.2.1.js"></script>
    <script src="assets/jquery-3.2.1/jquery-3.2.1.min.js"></script>
    <script src="assets/bootstrap-4.0.0-alpha.6-dist/js/tether.min.js"></script>
    <script src="assets/bootstrap-4.0.0-alpha.6-dist/js/bootstrap.min.js"></script>
    <script src="plugins/toastr/toastr.min.js"></script>
  </head>
  <body>
  	<div id= "background"></div>
  	<div class="container-fluid" id="login">
  		
  		<h1 id= "header" class="text-center" style="">Welcome to Fablix </h1>

		<form id="loginForm" method="post">
		  <div class="form-group">
		    <input type="email" class="input-md form-control text-center" id="email" name="email" placeholder="Email Address">
		  </div>
		  <div class="form-group">
		    <input type="password" class="input-md form-control text-center" id="password" name="password" placeholder="Password">
		  </div>
		  <div class="form-group text-center">
		  	<button id= "submitBtn" type="submit" class="btn btn-md btn-primary">Login</button>
		  </div>
		
		  <p id="loginStats" class='text-center'></p>
		</form>
  	</div>
  </body>

 <script type="text/javascript">
	$("#submitBtn").on("click", function(e){
		e.preventDefault();
		var formVars = $("#loginForm").serialize();
		$.ajax({
			url: "processes/login.jsp",
			type: "POST",
			data: formVars,
			success: function(response){
				var loggedInUser = JSON.parse(response);
				if(loggedInUser.status == "failure"){
					toastr.error("Incorrect email or password.");
				} else{
					window.location = "home.jsp?user="+loggedInUser.name;
				} 
			}
		})
	})
</script>
</html>



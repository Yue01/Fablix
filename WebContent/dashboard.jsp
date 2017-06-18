<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Employee | Dashboard</title>

    <link href="assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/dashboard.css">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="plugins/toastr/toastr.min.css">
    <link href="plugins/datepicker/bootstrap-datepicker.min.css" rel="stylesheet">
    
    <script src="assets/jquery-3.2.1/jquery-3.2.1.js"></script>
    <script src="assets/jquery-3.2.1/jquery-3.2.1.min.js"></script>
    <script src="assets/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script src="plugins/toastr/toastr.min.js"></script>
    <script src="plugins/datepicker/bootstrap-datepicker.min.js"></script>
</head>
<body>
	<div id= "background"></div>
  		<h1 id= "header" class="text-center" style="">Employee Dashboard</h1>
	<!--  INSERTSTARS MODAL -->
		    <div class="modal fade" data-backdrop='static' id="starModal">
			      <div class="modal-dialog" role="document">
				        <div class="modal-content">
					          <div class="modal-header">
					            <h3 class="modal-title">Insert A New Star</h3>
					          </div>
					          <div class="modal-body">
					            <form action="" id="insertStarForm">
						                
						              <div class="form-group">
						                <label for="title">First Name</label>
						                <input class="form-control" type="text" name="starFirstName" id="starFirstName" placeholder="e.g. John">
						              </div>
						
						              <div class="form-group">
						                <label for="title">Last Name</label>
						                <input class="form-control" type="text" name="starLastName" id="starLastName" placeholder="e.g. Doe">
						              </div>						              

					  	              <div class="form-group">
						                <label for="title">Date Of Birth</label>
						                <input class="form-control" type="text" name="starDob" id="starDob" placeholder="e.g. YYYY-MM-DD">
						              </div>	
					  	            
					  	              <div class="form-group">
						                <label for="title">Photo URL</label>
						                <input class="form-control" type="text" name="starPhotoUrl" id="starPhotoUrl" placeholder="e.g. www.example.com">
						              </div>	
					            </form>
					          </div>
					          <div class="modal-footer">
					            	<button type="button" class="btn btn-primary" id="addStarToDatabase" data-dismiss="modal">Add</button>
					            	<button type="button" class="btn btn-secondary" id="closeAddStarToDatabase" data-dismiss="modal">Close</button>
					          </div>
				        </div>
			      </div>
		    </div>
		
		
     <!-- STAR CONFIRMATION MODAL STARTS HERE -->
     <div class="modal fade" data-backdrop = "static" id="confirmationPage">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Confirmation Page
            </h3>
          </div>
          <div id='confirmBody' class="modal-body">
	          
          </div>
          <div class="modal-footer">
     		<button id="return" class='btn btn-md btn-primary' data-dismiss="modal">Return to site</button>
          </div>
        </div>
      </div>
     </div>
     
          <!-- Movie CONFIRMATION MODAL STARTS HERE -->
     <div class="modal fade" data-backdrop = "static" id="movieConfirmationPage">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Confirmation Page
            </h3>
          </div>
          <div id='movieConfirmBody' class="modal-body">
	          
          </div>
          <div class="modal-footer">
     		<button id="return" class='btn btn-md btn-primary' data-dismiss="modal">Return to site</button>
          </div>
        </div>
      </div>
     </div>			
     
     <!-- METADATA DISPLAY MODAL STARTS HERE -->
     <div class="modal fade" data-backdrop = "static" id="metadataPage">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Metadata
            </h3>
          </div>
          <div id='metadataBody' class="modal-body">
	          
          </div>
          <div class="modal-footer">
     		<button id="return" class='btn btn-md btn-primary' data-dismiss="modal">close</button>
          </div>
        </div>
      </div>
     </div>		


	<!--  Add movie MODAL -->
		    <div class="modal fade" data-backdrop='static' id="movieModal">
			      <div class="modal-dialog" role="document">
				        <div class="modal-content">
					          <div class="modal-header">
					            <h3 class="modal-title">Update Movie Information</h3>
					          </div>
					          <div class="modal-body">
					            <form action="" id="insertMovieForm">
						                
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
					            </form>
					          </div>
					          <div class="modal-footer">
					            	<button type="button" class="btn btn-primary" id="addMovieToDatabase" data-dismiss="modal">Add</button>
					            	<button type="button" class="btn btn-secondary" id="closeAddMovieToDatabase" data-dismiss="modal">Close</button>
					          </div>
				        </div>
			      </div>
		    </div>
		
	<!-- BUTTONS! -->
	<div class="text-center">
        <button id="insertStars" class="buttons btn btn-lg" style="background-color: #bd5555; color: white;
  border: none;" data-toggle="modal" data-target="#starModal">INSERT STAR</button>
        <button id="metadata" class="buttons btn btn-lg" style="background-color: #64b59d; color: white;
  border: none;" data-toggle="modal" data-target="#metadataPage">METADATA</button>
  	<button id="updateMovie" class="buttons btn btn-lg" style="background-color: #07468E; color: white;
  border: none;" data-toggle="modal" data-target="#movieModal">UPDATE MOVIE</button>
      </div>
</body>

<script>
$(document).ready(function(){
	$("#insertStarsForm input").each(function(index, element){
		element.value = "";
	});
	$("#addStarToDatabase").on("click", function(){
		var formVars = $("#insertStarForm").serialize();
		console.log(formVars);
		$.ajax({
			url: "processes/EmployeeInsertStars.jsp",
			type: "POST",
			data: formVars,
			success: function(data){
				console.log(data);
				var confirmation = JSON.parse(data);
				var confirmationBody = "";
				if(confirmation.status == "failure"){
					toastr.error("Information Mismatch: Unable to insert star");
				}else{
					confirmationBody += "<h4> "+ confirmation.name + " has been added! </h4><hr>";
					$("#confirmBody").html(confirmationBody);
					$("#confirmationPage").modal();
				}
			}
		})
	})
})
</script>



<script>
$(document).ready(function(){
	$("#insertStarsForm input").each(function(index, element){
		element.value = "";
	});
	$("#metadata").on("click", function(){
		$.ajax({
			url: "processes/EmployeeMetadata.jsp",
			type: "POST",
			data: 'json',
			success: function(result){
				console.log(result);
				var confirmation = JSON.parse(result);
				var metadataBody = "";
				$.each(confirmation, function(i, v){
					metadataBody += "<h6> Table Name: "+ v.table + ", Attribute: " + v.attribute + ", Type: " + v.type + "</h6><hr>";

				});
				$("#metadataBody").html(metadataBody);
				$("#metadataPage").modal();
			}
		})
	})
})
</script>



<script>
$(document).ready(function(){
	$("#addMovieToDatabase").on("click", function(){
		var formVars = $("#insertMovieForm").serialize();
		console.log(formVars);
		$.ajax({
			url: "processes/add_movie.jsp",
			type: "POST",
			data: formVars,
			success: function(data){
				console.log(data);
				var confirmation = JSON.parse(data);
				var confirmationBody = "";
				if(confirmation.status == "failure"){
					toastr.error("Information Mismatch: Unable to update movie");
				}else{
					confirmationBody += "<h4> "+ confirmation.movieName + " has been added! </h4><hr>";
					$("#movieConfirmBody").html(confirmationBody);
					$("#movieConfirmationPage").modal();
				}
			}
		})
	})
})
</script>
</html>
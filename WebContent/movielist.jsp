<%@ page import = "java.io.*, java.sql.*" %> 
<%@ page import = "org.json.*" %>
<%@ page import="java.util.ArrayList"%>
<%
if(session.getAttribute("name") == null || (request.getParameter("browse") == null && request.getParameter("search") == null)){
	response.sendRedirect(request.getContextPath()); 
}
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
   
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Fablix | Let's Tour</title>

    <link href="assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/movielist.css">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link href="assets/DataTables-1.10.15/media/css/jquery.dataTables.min.css" rel='stylesheet'>
    <link href="plugins/datepicker/bootstrap-datepicker.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="plugins/toastr/toastr.min.css">
    
    <script src="assets/jquery-3.2.1/jquery-3.2.1.js"></script>
    <script src="assets/jquery-3.2.1/jquery-3.2.1.min.js"></script>
    <script src="assets/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script src="assets/DataTables-1.10.15/media/js/jquery.dataTables.min.js"></script>
    <script src="plugins/datepicker/bootstrap-datepicker.min.js"></script>
    <script src="plugins/toastr/toastr.min.js"></script>
  </head>
  <script src= "js/cart.js"></script>
  <script src= "js/star-movie.js"></script>
<body>
	<!--  MOVIE PAGE MODAL STARTS HERE  -->
	<div class="modal fade" data-backdrop = "static" id="moviePage">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Movie Page
            </h3>
          </div>
          <div class="modal-body">
	          <div class="row">
	          	<div id="movBanner" class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
	          		<img src="https://images-na.ssl-images-amazon.com/images/M/MV5BM2FmZGIwMzAtZTBkMS00M2JiLTk2MDctM2FlNTQ2OWYwZDZkXkEyXkFqcGdeQXVyNDYyMDk5MTU@._V1_SY1000_CR0,0,666,1000_AL_.jpg" style="width:100%" alt="">
	          	</div>
	          	<div class="col-lg-7 col-md-7 col-sm-7 col-xs-7" >
					<ul class="list-group">
		          	  <li id="movID" class="list-group-item"></li>
					  <li id="movTitle" class="list-group-item"></li>
					  <li id="movYear" class="list-group-item"></li>
					  <li id="movDir" class="list-group-item"></li>
					  <li id="movGenres" class="list-group-item">Genres - <a href="#">Action</a>, Thriller, Suspense</li>
					  <li id="movStars" class="list-group-item"></li>
					</ul>
	          	</div>
	          </div>
	          <hr>
	          <h3>Trailer Video</h3>
	          <div class="row" style="margin-top: 3%">
	      		<div id="movTrailer" class="col-lg-12">
	      			<iframe id="trailer" width="100%" height="400px" src="//www.youtube.com/embed/bD7bpG-zDJQ" frameborder="0"></iframe>
	      		</div>
	      	  </div>
          </div>
          <div class="modal-footer">
          	<button id="addToCart" class="movieCloseModal btn btn-md btn-primary" data-dismiss="modal">Add to Cart</button>
          	<button class="movieCloseModal btn btn-md btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- STAR PAGE STARTS HERE  -->
     <div class="modal fade" data-backdrop = "static" id="starPage">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Star Page
            </h3>
          </div>
          <div class="modal-body">
	          <div class="row">
	          	<div id="starPicture" class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
	          		<img src="https://images-na.ssl-images-amazon.com/images/M/MV5BOTI0NjczMjIwMV5BMl5BanBnXkFtZTYwNzYwNDIz._V1_.jpg" style="width:100%" alt="">
	          	</div>
	          	<div class="col-lg-7 col-md-7 col-sm-7 col-xs-7" >
					<ul class="list-group">
		          	  <li id="starID" class="list-group-item"></li>
					  <li id="starName" class="list-group-item"></li>
					  <li id="starDOB" class="list-group-item"></li>
					  <li id="starMovies" class="list-group-item"></li>
					</ul>
	          	</div>
	          </div>
          </div>
          <div class="modal-footer">
          	<button class="starCloseModal btn btn-md btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- SHOPPING CART STARTS HERE -->
    <div class="modal fade" data-backdrop = "static" id="cartPage">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Shopping Cart
            </h3>
          </div>
          <div class="modal-body">
          	
	          <div class="row">
	          	<h3 class="text-center">Empty Cart !</h3>
	          	<p class='text-center text-warning'> Mr. Cart feels empty. We should feed him some <b>Fablix-ous</b> movies. </p>
	          </div>
          </div>
          <div class="modal-footer">
     		<button id='startBrowsing' class='btn btn-md btn-primary' data-dismiss="modal">Return to site</button>

          </div>
        </div>
      </div>
    </div>
    <!-- CONFIRMATION MODAL STARTS HERE -->
     <div class="modal fade" data-backdrop = "static" id="confirmationPage">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Confirmation Page
            </h3>
          </div>
          <div id="confirmBody" class="modal-body">
	          
          </div>
          <div class="modal-footer">
     		<button id="return" class='btn btn-md btn-primary' data-dismiss="modal">Return to site</button>
          </div>
        </div>
      </div>
     </div>

	<!-- CHECK OUT MODAL STARTS HERE -->
	<div class="modal fade" data-backdrop = "static" id="checkOutModal">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Checkout Movies
            </h3>
          </div>
          <div class="modal-body">
	          <form action="" id="checkOutForm">
	          <label for="title">Name</label>
	          <div class="row form-group form-inline" style='padding: 0px 15px'>
                <input class="form-control" style="width: 48%; margin-right: 2%" type="text" name="firstName" id="firstName" placeholder="First Name">
                <input class="form-control" style="width: 48%; margin-left: 1%" type="text" name="lastName" id="lastName" placeholder="Last Name">
              </div>
              <div class="form-group">
                <label for="title">Card Number</label>
                <input class="form-control" type="text" name="cardNumber" id="cardNumber" placeholder="9999 9999 9999 9999">
              </div>
              
              <label for = "expDate">Expiration Date</label>
              <div class="form-group">
			    <input name="expDate"  id="expDate" type="text" placeholder="Click to select a date" class="form-control">
			  </div>
            </form>
          </div>
          <div class="modal-footer">
     		<button id='proceed' class='btn btn-md btn-primary' data-dismiss="modal">Proceed Checkout</button>
     		<button id="cancel" class='btn btn-md btn-default' data-dismiss="modal">Cancel</button>
          </div>
        </div>
      </div>
    </div>
	<h1 id="header" class='text-center'>
		<button id="goHome" class = "btn btn-lg btn-primary" style="float:left">
			<span class="glyphicon glyphicon-arrow-left" style="float:left; color: white; margin-right:10px"></span>
		  Home</button>
		<span id="headerText">
		<% out.print("Enjoy your tour, " + session.getAttribute("name") + "!"); %>
		</span>
		<button id="openCart" class = "btn btn-lg btn-primary" style="float:right">
			<span class="glyphicon glyphicon-shopping-cart" style="float:left; color: white; margin-right:10px"></span>
		  Cart</button>
	</h1>
	<div class="container-fluid" style="margin-bottom: 5%">
		<table id='movieTable' class="table table-striped table-bordered table-order-column">
			<thead>
				<tr>
					<th>ID</th>
					<th>Movie Title</th>
					<th>Year Produced</th>
					<th>Director</th>
					<th>Genres</th>
					<th>Stars</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</body>
<script>
	var movielist = JSON.parse(unescape("<% out.print(request.getParameter("movielist"));%>"));
	console.log(movielist);
	$(document).ready(function(){
		$("#movieTable").dataTable({
			"data": movielist,
			"aoColumns": [
				{"mData": "movieID"},
				{"mData": "title"},
				{"mData": "year"},
				{"mData": "director"},
				{"mData": "genres[, ]"},
				{"mData": "stars"},
			],
			"columnDefs":[
				{
					'targets': 1,
					'data': 'title',
					'render': function(data, type, full, meta){
						return "<a href='#' data-toggle='popover' title='Movie Info' class= 'titleClick' onClick='titleClick("+data.id+")' data-movie-id="+ data.id + ">"+ data.name + "</a>"; 
					}
				},
				{
					'targets':5,
					'data':'stars',
					'render': function(data, type, full, meta){
						var tags = ""
		    			for(var i = 0; i < data.length; i++){
		    				tags += "<a href= '#'  class='starClick' onClick='starClick("+data[i].starID+")' data-star-id="+ data[i].starID+" >" + data[i].name + "<br></a>";
		    			}
		    			return tags;
					}
				}
			]
		})
	});
	
	$("#openCart").on('click', function(){
		var cart = <% out.print(session.getAttribute("moviesInCart")); %>
		var cartBody = "";
		var movieIDs = "";
		if(cart.length != 0){
			for(var i = 0; i < cart.length; i++){
				var quantity = cart[i].quantity;
				for(var n = 0; n < quantity ; n++){
					movieIDs += cart[i].movieID;
					if(n < quantity-1){
						movieIDs += ",";
					}
				}	
				cartBody += '<div class="row">'+
	      	'<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">' +
	      		'<img src="'+ cart[i].banner +'" style="width:100%" alt="">'+
	      	'</div>' +
	      	'<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">' +
	      		'<ul class="list-group">'+
	          	  '<li class="list-group-item">Movie ID - '+ cart[i].movieID + '</li>'+
				  '<li class="list-group-item">Movie Title - '+ cart[i].title + '</li>'+
				  '<li class="list-group-item">Quantity - '+ cart[i].quantity+ '</li>'+
				'</ul>'+
	      	'</div>' +
	      	'<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">' +
	      		'<p>Add / Remove</p>'+
	      		'<button class="btn btn-md btn-success">' +
	      			'<span data-movie='+escape(JSON.stringify(cart[i]))+' class="addCart glyphicon glyphicon-plus"></span>' +
				'</button>'+
	      		'<button class="btn btn-md btn-danger">'+
	      			'<span data-movie='+escape(JSON.stringify(cart[i]))+' class="removeCart glyphicon glyphicon-minus"></span>' +
	      		'</button>'+
	      	'</div>'+
	  	  '</div>';
	  	  		if(i < cart.length-1){
	  	  			cartBody += "<hr>";
	  	  			movieIDs += ",";
	  	  		}	
			}
			cartBody += '<input type="hidden" data-ids= "'+movieIDs+'" id="movieIDs">';
			$("#movieIDs").data("ids", movieIDs);
			$("#cartPage .modal-body").html(cartBody);
			$('#cartPage .modal-footer').html('<button id="checkOut" class="btn btn-md btn-primary" data-dismiss="modal">Checkout</button><button class="btn btn-md btn-success" id="save" data-dismiss="modal">Save Cart</button>');
		}
		$("#save").on("click", function(){
			location.reload();
		})
		$("#cartPage").modal();
	})
	
$(document).ready(function(){
	var movieData = {};
	$(".titleClick").hover(function(){
		var movieID = $(this).data("movie-id");
		var stars = "";
		$.ajax({
			url: "processes/singlemovie.jsp",
			type: "POST",
			data: {"movieID": movieID},
			async: false,
			success: function(data){
				console.log(JSON.parse(data));
				movieData = JSON.parse(data);
				
			}
		});
		
		for(var i =0; i < movieData.stars.length; i++){
			stars += movieData.stars[i].name;
			if(i != movieData.stars.length-1){
				stars += ", ";
			}
		}
		
	  	$(this).popover({
	        html: true,
	        trigger: 'manual',
	        container: $(this).attr('id'),
	        placement: 'right',
	        content: '<div class="col-lg-5 col-md-5 col-sm-5 col-xs-5">' +
	      		'<img src="'+ movieData.banner +'" style="width:100%; margin-bottom: 10px !important" alt="">'+

	      	'</div>' +
	      	'<div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">' +
	      		'<ul class="list-group" style="margin-bottom: 10px !important">'+
	          	  '<li class="list-group-item">Released - '+ movieData.year + '</li>'+
				  '<li class="list-group-item">Stars - '+ stars + '</li>'+
				  '<li class="list-group-item">Director - '+ movieData.director+ '</li>'+
				'</ul>'+
				'<button class="btn btn-sm btn-primary" id="addToCartBtn" style="width:100%">Add to Cart</button>' +
	      	'</div>'
	        
	    }).on("mouseenter", function () {
	        var _this = this;
	        $(this).popover("show");
	        $(this).siblings(".popover").on("mouseleave", function () {
	            $(_this).popover('hide');
	        });
	    }).on("mouseleave", function () {
	        var _this = this;
	        setTimeout(function () {
	            if (!$(".popover:hover").length) {
	                $(_this).popover("hide")
	            }
	        }, 100);
	    });
	});
  	$(document).on("click", "#addToCartBtn", function(){
  		addToCart(movieData);
  		$('#cartPage').modal();
  	})
});
	
</script>
<script src= "js/movielist.js"></script>


<%@ page import = "java.io.*, java.sql.*" %> 
<%@ page import = "org.json.*" %>
<%@ page import="java.util.ArrayList"%>
<%

if(session.getAttribute("name") == null){
	response.sendRedirect(request.getContextPath()); 
}
/* Dynamically loading genres */	
//Create Connection

Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false","root", "idiotking22");

Statement getGenres = connection.createStatement();
ResultSet genreSet = getGenres.executeQuery("select name from genres");

ArrayList<String> genres = new ArrayList<String>();
while(genreSet.next()){
	genres.add(genreSet.getString(1));
}
Statement s = connection.createStatement();
ResultSet movies = s.executeQuery("select * from movies");

ArrayList<JSONObject> movieList = new ArrayList<JSONObject>();
while(movies.next()){
	JSONObject movieJson = new JSONObject();
	
	int movieID = movies.getInt(1);
	
	JSONObject titleObj = new JSONObject();
	titleObj.put("id", movieID);
	titleObj.put("name", movies.getString(2));

	int year = movies.getInt(3);
	String dir = movies.getString(4);
	
	//GET stars for this movie 
	Statement getStars = connection.createStatement();
	ResultSet starSet = getStars.executeQuery(
	"select distinct s.id, s.first_name, s.last_name from movies m inner join stars_in_movies sm on m.id = sm.movie_id inner join stars s on s.id = sm.star_id where m.id = " + movieID
	);
	ArrayList<JSONObject> stars = new ArrayList<JSONObject>();
	while(starSet.next()){
		String starName = "";
		String starID = "";
		starName = starSet.getString(3) + ", " + starSet.getString(2);
		starID = starSet.getString(1);
		JSONObject star = new JSONObject();
		star.put("starID", starID);
		star.put("name", starName);
		stars.add(star);
	}
	
	//GET genres for this movie
	Statement getGenre = connection.createStatement();
	ResultSet genreResult = getGenre.executeQuery(
	"select distinct g.name from movies m inner join genres_in_movies gm on m.id = gm.movie_id_1 inner join genres g on g.id = gm.genre_id where m.id = " + movieID		
	);
	ArrayList<String> allGenres  = new ArrayList<String>();
	while(genreResult.next()){
		allGenres.add(genreResult.getString(1));
	}
	
	//Construct Movie Json Object
	movieJson.put("movieID", movieID);
	movieJson.put("title", titleObj);
	movieJson.put("year", year);
	movieJson.put("director", dir);
	movieJson.put("stars", stars);
	movieJson.put("genres", genres);
	
	//Add to the Movie-list
	movieList.add(movieJson);
}
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Fablix | Main</title>

    <link href="assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/home.css">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="plugins/toastr/toastr.min.css">
    <link href="plugins/datepicker/bootstrap-datepicker.min.css" rel="stylesheet">
    <link href="assets/jquery-3.2.1/jquery-ui.css" rel="stylesheet">
    <link href="assets/flexselect/flexselect.css" rel = "stylesheet">
    
   
    <script src="assets/jquery-3.2.1/jquery-3.2.1.js"></script>
    <script src="assets/jquery-3.2.1/jquery-ui.js"></script>
    <script src="assets/flexselect/jquery.flexselect.js"></script>
   	<script src="assets/flexselect/liquidmetal.js"></script>
   	<script src="assets/jquery-getChar.js"></script>
    <script src="assets/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script src="plugins/toastr/toastr.min.js"></script>
    <script src="plugins/datepicker/bootstrap-datepicker.min.js"></script>
  </head>

  <style>
    .navbar-nav>li>a{
      color: #e5edf9 !important;
      font-size: 17px ;
    }
    
    .navbar-nav>li>a:hover{
    	color:#a9a9a9 !important;
    }
    .navbar-nav>li{
      margin: 3%;
    }
    .navbar{
      border-radius: 0px !important;
    }
    
  </style>
  <body>
  	<div id="scrollTop">
  		<span id="scrollTop" class = "glyphicon glyphicon-menu-up gi-5x" aria-hidden="true"></span>
  	</div>
  	<!-- SHOPPING CART MODAL -->
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
	          	<p class='text-center text-warning'> Mr. Cart feels empty. Let's feed him some <b>Fablix-ous</b> movies. </p>
	          </div>
          </div>
          <div class="modal-footer">
     		<button id="startBrowsing" class='btn btn-md btn-primary' data-dismiss="modal">Return to site</button>
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
          <div id='confirmBody' class="modal-body">
	          
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
			  
			  <input type="hidden" id="movieIDs" data-ids="">
            </form>
          </div>
          <div class="modal-footer">
     		<button id='proceed' class='btn btn-md btn-primary' data-dismiss="modal">Proceed Checkout</button>
     		<button id="cancel" class='btn btn-md btn-default' data-dismiss="modal">Cancel</button>
          </div>
        </div>
      </div>
    </div>
    <div class="modal fade" data-backdrop='static' id="searchModal">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Advanced Search 
            </h3>
          </div>
          <div class="modal-body">
            <form action="" id="searchForm">
              <div class="form-group">
                <label for="title">Movie Title</label>
                <input class="form-control" type="text" name="movieTitle" id="movieTitle" placeholder="e.g. Spider Man">
              </div>
                
              <div class="form-group">
                <label for="title">Year Produced</label>
                <input class="form-control" type="text" name="yearProduced" id="yearProduced" placeholder="e.g. 2007">
              </div>

              <div class="form-group">
                <label for="title">Director</label>
                <input class="form-control" type="text" name="director" id="director" placeholder="e.g. Sam Raimi">
              </div>

              <label for="title">Star</label>
      
                <div class="row form-group form-inline" style='padding: 0px 15px'>
                <input class="form-control" style="width: 48%; margin-right: 2%" type="text" name="firstName" id="firstName" placeholder="First Name">
                <input class="form-control" style="width: 48%; margin-left: 1%" type="text" name="lastName" id="lastName" placeholder="Last Name">
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" id="searchBtn" data-dismiss="modal">Search</button>
            <button type="button" class="btn btn-secondary" id="closeSearch" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>

    <div class="modal fade" data-backdrop = "static" id="browseModal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Browse Movies</h3>
          </div>
          <div class="modal-body">
            <label for="browseTitle">Browse by Title</label>
            <select class="form-control" name="browseTitle" id="browseTitle">
              <option value="">None</option>
              <option value="0">0</option>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
              <option value="6">6</option>
              <option value="7">7</option>
              <option value="8">8</option>
              <option value="9">9</option>
              <option value="A">A</option>
              <option value="B">B</option>
              <option value="C">C</option>
              <option value="D">D</option>
              <option value="E">E</option>
              <option value="F">F</option>
              <option value="G">G</option>
              <option value="H">H</option>
              <option value="I">I</option>
              <option value="J">J</option>
              <option value="K">K</option>
              <option value="L">L</option>
              <option value="M">M</option>
              <option value="N">N</option>
              <option value="O">O</option>
              <option value="P">P</option>
              <option value="Q">Q</option>
              <option value="R">R</option>
              <option value="S">S</option>
              <option value="T">T</option>
              <option value="U">U</option>
              <option value="V">V</option>
              <option value="W">W</option>
              <option value="X">X</option>
              <option value="Y">Y</option>
              <option value="Z">Z</option>
            </select>
            <br>
            <label for="browseGenre">Browse by Genre</label> 
            <select class="form-control" name="browseGenre" id="browseGenre">
				<option value="">None</option>
				<%for(String genre: genres){
					out.print("<option value="+genre+">"+genre+"</option>");	
				} %>
			</select>
          </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-primary" id="browseBtn" data-dismiss="modal">Browse</button>
              <button type="button" class="btn btn-secondary" id="closeBrowse" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>

<!-- NAV BAR SECTION  -->
<nav class="navbar navbar-inverse" style="margin-bottom:0; border:none">
  <div class="container-fluid">
    <div class="navbar-header" style="width:35%">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#" ><img style="width: 130px" src="img/icon-white.png" alt=""></a>
    </div>
    <div class="collapse navbar-collapse"  id="myNavbar">
      <ul class="nav navbar-nav " style="width:35%">
        <li><a id="home" href="#">Home</a></li>
        <li><a id="about" href="#">About</a></li>
        <li><a id="getStarted" href="#">Get Started</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right" style="width:20%">
        <li><a href="#" id="displayCart"><span class="glyphicon glyphicon-shopping-cart"></span> Cart</a></li>
        <li><a href="#" id="logout"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>
	<div class="modal fade text-center" id="cartPage">
	  <div class="modal-dialog">
	    <div class="modal-content">
	    </div>
	  </div>
	</div>

    <div class="container-fluid" id="section1">
      <h1 id="header1" class='text-center'><% out.print("Hello " + session.getAttribute("name") + "!"); %></h1>
      <!-- <div class="row form-inline text-center">
	      <select class= "form-control input-lg" style="width: 25%; margin-right: 1%" id ="flexSelect"></select>
	      <button class='btn btn-lg' id='autoComplete'>Search Movie</button>
	      
      </div> -->
      <div class ="row form-inline text-center">
	      <input class="form-control input-lg" style="width: 25%; margin-right: 1%" id = "searchMovBox" list="searchedMoviesAC">
	      <datalist id="searchedMoviesAC"></datalist> 
	      <ul class = "text-center" id="movs" style="background:white; width: 25%; margin: auto"></ul>
	      <button class='btn btn-lg' id='autoComplete'>Search Movie</button>
      </div>

    <!--   <div class="text-center">
        <button class="option btn btn-lg" id="aboutBtn" data-toggle="collapse" data-target="#collapseAbout">Get to Know Fablix!</button>
        <button class="option btn btn-lg" id="goToSection2" data-toggle="modal">Get Started!</button>
      </div> -->
      <div id="aboutSection" class="container" style="padding-top:20%">
        <div class="row text-center">
          <h1 style="color: white; margin: 3%">
            GET TO KNOW US
          </h1>
          <div class="col-lg-6 col-lg-offset-3">
            <div class="well" >
              Lorem ipsum dolor sit amet, quot explicari omittantur has ei, ei nec autem everti cetero. Vim ubique suavitate definitiones ut. Cum ut modus salutandi necessitatibus.
            </div>
          </div>
        </div>
        <div class="row text-center" style="margin: 0% 25%">
          <h2 style="color: white; margin-bottom: 7%">
            FABLIX TEAM
          </h2>
          <div class="col-lg-4 col-md-4"><img style="width: 70%" src="img/profiles/jlaw.png" alt="">
            <p style="margin-top:10%; color: #f5f5f5">Jonathan Law</p>
            <hr style ="margin:5px">
            <p style="color: #f5f5f5">Product Manager</p>
          </div>
          <div class="col-lg-4 col-md-4"><img style="width: 70%" src="img/profiles/aaron.png" alt="">
            <p style="margin-top:10%; color: #f5f5f5">Aaron Aung</p>
            <hr style ="margin:5px">
            <p style="color: #f5f5f5">Lead Developer</p>
          </div>
          <div class="col-lg-4 col-md-4"><img style="width: 70%" src="img/profiles/raymond.png" alt="">
            <p style="margin-top:10%; color: #f5f5f5">Raymond Sy</p>
            <hr style ="margin:5px">
            <p style="color: #f5f5f5">UI/UX Designer</p>
          </div>
        </div>
      </div>
    </div>

  	<div class="container-fluid" id="getStartedSection">
      <div id="background"></div>
  		<h1 id= "header2" class="text-center" style="">Ready for a Tour?</h1>
      <div class="text-center">
        <button id="search" class="buttons btn btn-lg" style="background-color: #bd5555; color: white;
  border: none;" data-toggle="modal" data-target="#searchModal">SEARCH</button>
        <button id="browse" class="buttons btn btn-lg" style="background-color: #64b59d; color: white;
  border: none;" data-toggle="modal" data-target="#browseModal">BROWSE</button>
      </div>
    </div>
  </body>
  
<script src = "js/home.js"></script>
<script src = "js/cart.js"></script>
<script src = "js/star-movie.js"></script>
<script>
$("#displayCart").on('click',function(){
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
  	  			movieIDs += ",";
  	  			cartBody += "<hr>";
			}	
		}
		cartBody += '<input type="hidden" data-ids= "'+movieIDs+'" id="movieIDs">';
		$("#movieIDs").data("ids", movieIDs);
		$("#cartPage .modal-body").html(cartBody);
		$('#cartPage .modal-footer').html('<button id="checkOut" class="btn btn-md btn-primary" data-dismiss="modal">Checkout</button><button class="btn btn-md btn-success" id="save" data-dismiss="modal">Save Cart</button>');
	}
	$("#cartPage").modal();
})


var movieTitle = "";
var movieNames = [];
var namesAndID = [];

var allMovies = <% out.print(movieList);%>;
for(var i =0; i < allMovies.length; i++){
	var movieString = allMovies[i].title.name;
	movieNames.push( movieString);
}

for(var i =0; i < allMovies.length; i++){
	var name = allMovies[i].title.name;
	var id = allMovies[i].movieID;
	var nameID = {"name": name, "id":id};
	namesAndID.push(nameID);
}

console.log(namesAndID);

/* $("#searchBox").autocomplete({
	source: movieNames
})
 */
 /* $(function () {
	    var availableTags = movieNames;


	    // Overrides the default autocomplete filter function to search for matched on atleast 1 word in each of the input term's words
	    $.ui.autocomplete.filter = function (array, terms) {
	        arrayOfTerms = terms.split(" ");
	        var term = $.map(arrayOfTerms, function (tm) {
	             return $.ui.autocomplete.escapeRegex(tm);
	        }).join('|');
	       var matcher = new RegExp("\\b" + term, "i");
	        return $.grep(array, function (value) {
	           return matcher.test(value.label || value.value || value);
	        });
	    };

	    $("#searchBox").autocomplete({
	        source: availableTags,
	        multiple: true,
	        mustMatch: false
	        /*,source: function (request, response) {
	            // delegate back to autocomplete, but extract the last term
	            //response($.ui.autocomplete.filter(
	            //availableTags, request.term.split(" ")));
	        },
	    });


	});*/

/* var someList = movieNames;
$('#searchBox').autocomplete({
    source: function(request, response) {
        var term = request.term;
        var data = handleAutocomplete(term); //your custom handling
        response(data);
    }
});

function recursiveListUpdate(someList, keywords) {
    newList = [];
    someList.forEach(function(element) {
        if (element.toLowerCase().indexOf(keywords[counter].toLowerCase()) >= 0) {
            newList.push(decodeURI(element)); //if any %20, etc symbols
        }
    });
    counter++;
    if (counter == keywords.length) {
        return newList;
    }
    return recursiveListUpdate(newList, keywords);
}


function handleAutocomplete(term) {
    var str = term; // get the "keywords"
    var keywordsFromNameInput = str.split(" "); // split them into a list
    counter = 0; // set counter for keywords.lenght
    // recursively get new list that contains the give keywords no matter the order
    return recursiveListUpdate(someList, keywordsFromNameInput);
} */


var searchedMovies = [];
$("#searchMovBox").on("input", function(e){
	$("#movs").empty();
	var movieTitle = $("#searchMovBox").val();
	$.ajax({
		url: "processes/fulltextsearch.jsp",
		type: "POST",
		data: {"movieTitle": movieTitle},
		success: function(response) {
			var data = JSON.parse(response);
			console.log("Data:" , data);
			var datalist = "";
			for(var i = 0; i < data.length; i++){
				/* datalist += '<option data-value="'+ data[i].title + '">'+data[i].title+'</option>'; */
				datalist += '<li id="' +data[i].title+ '">'+ data[i].title+'</li>';
			}
			$("#movs").html(datalist);
			/* console.log("datalist: ", datalist); */
		}
	});
})

$(document).on('click', "li", function(){
	var movname= $(this).attr("id");
	$("#searchMovBox").val(movname);
	$("#movs").empty();
})

/* $("#searchBox").keyup(function(e){
	
	if($.getChar(e) < 48 && $.getChar(e) != 8 && $.getChar(e) != 32){
		return; 
	}
	if($.getChar(e) == 8){
		movieTitle = movieTitle.slice(0, -1);
	}
	var character = String.fromCharCode($.getChar(e));
	if($.getChar(e) != 8){
		movieTitle += character;
	}
	console.log("MOVIE TITLE PASSED: ", movieTitle);
	$.ajax({
		url: "processes/fulltextsearch.jsp",
		type: "POST",
		data: {"movieTitle": movieTitle},
		success: function(response) {
			var data = JSON.parse(response);
			console.log("Data:" , data);
			var datalist = "";
			for(var i =0; i < data.length; i++){
				datalist += '<option value="'+ data[i].title + '">';
			}
			$("#searchedMovies").html(datalist);
		}
	});
}) */

$("#autoComplete").on("click", function(){
	var movieName = $("#searchMovBox").val();
	var movieID = null;
	for(var i = 0; i < namesAndID.length; i++){
		if(namesAndID[i].name == movieName){
			movieID = namesAndID[i].id;
		}
	};
	if(movieID == null){
		toastr.error("No such movie exists.")
	}
	
	$.ajax({
		url: "processes/singlemovie.jsp",
		type: "POST",
		data: {"movieID" : movieID},
		success: function(data){
			console.log(JSON.parse(data).year);
			$(document).ready(function(){
				var moviedata = JSON.parse(data);
				var title = {"name": moviedata.title, "id":moviedata.movieID};
				var searchParam = [{"title": title, "year": moviedata.year, "director": moviedata.director, "genres":[], "stars":moviedata.stars, "movieID": moviedata.movieID}]
				var json = JSON.stringify(searchParam);
				var escaped = (escape(json));
				var url = 'movielist.jsp?search=true';
				var form = $("<form action=" + url + " method='post'>" +
				  "<input type='text' name='movielist' value='" + escaped + "'/>" +
				  '</form>');
				$('body').append(form);
				
				form.submit();	
			});	
		}
	})
});

</script>
</html>



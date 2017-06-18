/*HANDLE MODAL TRANSITIONS FOR STAR & MOVIE PAGES */

function titleClick(movID){
	$(".starClick").unbind();
	$(".titleClick").unbind();
	$("#addToCart").unbind();
	$.ajax({
		url: "processes/singlemovie.jsp",
		type: "POST",
		data: {movieID: movID },
		success: function(data){
			var movieData = JSON.parse(data);
			var starsInfo = "";
			for(var i = 0; i < movieData.stars.length; i++){
				starsInfo += "<a class='starClick' data-star-id="+ movieData.stars[i].starID+" >" + movieData.stars[i].name + "</a>";
				starsInfo += i == movieData.stars.length-1 ? "" : ", ";
			};
			var genresInfo = "";
			for(var i = 0; i < movieData.genres.length; i++){
				genresInfo += "<a class='genreClick' data-genre-name="+ movieData.genres[i].genreName+" >" + movieData.genres[i].genreName + "</a>";
				genresInfo += i == movieData.genres.length-1 ? "" : ", ";
			};
			$("#movID").html("ID - " + movieData.movieID);
			$("#movTitle").html("Title - "+ movieData.title);
			$("#movDir").html("Director - "+ movieData.director);
			$("#movYear").html("Year Produced - "+ movieData.year);
			$("#movGenres").html("Genres - " + genresInfo);
			$("#movStars").html("Stars - " + starsInfo);
			$("#movBanner").html('<img src="' + movieData.banner+'" style="width:100%" alt="This movie does not have a banner.">')
			$("#movTrailer").html('<iframe width="100%" height="320px" src="'+ movieData.trailer + '" frameborder="0"></iframe>')
			
			$("#moviePage").modal("show");
			$(".starClick").on('click',function(){
				var starID = $(this).data("star-id");
				starClick(starID);
				$("#moviePage").modal("toggle");
			})
			$(".genreClick").on('click',function(){
				var browse = {"browseTitle" :"",
						"browseGenre" : $(this).data("genre-name")};
				$.ajax({
					url: "processes/browse.jsp?browse=true",
					type: "POST",
					data: browse,
					success: function(data){
						$(document).ready(function(){
						var escaped = (escape(data));
							var url = 'movielist.jsp?browse=true';
							var form = $("<form action=" + url + " method='post'>" +
							  "<input type='text' name='movielist' value='" + escaped + "'/>" +
							  '</form>');
							$('body').append(form);
							
							form.submit();	
						});
					},
					error: function(request, error){
						console.log("ERROR");
					}
				})
			})
			$("#addToCart").on("click", function(){
				addToCart(movieData);
				$("#cartPage").modal();
			})
		}
	})
}

function starClick(sID){
	$(".starClick").unbind();
	$(".titleClick").unbind();
	$.ajax({
		url: "processes/singlestar.jsp",
		type: "POST",
		data: {starID: sID},
		success: function(data){
			var starData = JSON.parse(data);
			var moviesInfo = "";
			for(var i = 0; i < starData.movies.length; i++){
				moviesInfo += "<a class='titleClick' data-movie-id="+ starData.movies[i].movieID+" >" + starData.movies[i].title + "</a>";
				moviesInfo += i == starData.movies.length-1 ? "" : ", ";
			};
			
			$("#starID").html("ID - "+ starData.starID);
			$("#starName").html("Name - "+ starData.name);
			$("#starDOB").html("Date of Birth - "+ starData.dob);
			$("#starMovies").html("Movies - "+ moviesInfo);
			$("#starPicture").html('<img src="'+ starData.pictureLink+'" style="width:100%" alt="">')
			
			$("#starPage").modal("show");
			$(".titleClick").on('click',function(){
				var movieID = $(this).data("movie-id");
				titleClick(movieID);
				$("#starPage").modal("toggle");
			})
			
			
		},
		error: function(request, error){
			console.log("ERROR");
		}
	})
}
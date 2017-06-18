/*HOME PAGE JAVASCRIPT FILE
 * Page slides + Button click controls + Modal Controls*/

$("#about").on("click", function(){
    $('html, body').animate({
      scrollTop: $("#aboutSection").offset().top+220
    }, 1000);
    return false;
});

$("#getStarted").on("click", function(){
    $('html, body').animate({
      scrollTop: $("#getStartedSection").offset().top+220
    }, 1000);
    return false;
}); 
  
$("#logout").on('click', function(){
	window.location = "processes/logout.jsp";
});

$("#searchBtn").on('click', function(e){
	var formEmpty = true;
	$("#searchForm input").each(function(index, element){
			if(element.value !== '')
				formEmpty = false;
	});
	$("#test").html("THIS IS A TEST!");
	if(formEmpty){
		toastr.error("Please enter an input to search for movies.");
		return false;
	}
	var formVars = $("#searchForm").serialize();
	$.ajax({
		url: "processes/search.jsp?search=true",
		type: "POST",
		data: formVars,
		success: function(data){
			$(document).ready(function(){
			var escaped = (escape(data));
				var url = 'movielist.jsp?search=true';
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
	$("#searchForm")[0].reset();
});

$("#browseBtn").on("click", function(){
	
	var browse = {"browseTitle" : $("#browseTitle").val(),
			"browseGenre" : $("#browseGenre").val()};
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
	$("#browseTitle").val("");
	$("#browseGenre").val("");
})

$("#closeBrowse").on("click", function(){
	$("#browseTitle").val("");
	$("#browseGenre").val("");
})

$("#closeSearch").on("click", function(){
	$("#searchForm")[0].reset();
})

$(document).ready(function(){
	$("#scrollTop").on("click", function(){
		$('html, body').animate({
		      scrollTop: $("#header1").offset().top - 400
		}, 1000);
	    return false;
	})
})


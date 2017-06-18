/*ADD/REMOVE MOVIE FROM CART FUNCTIONS*/

function removeFromCart(movieData){
	$(".addCart").unbind();
	$(".removeCart").unbind();
	var movieIDs = "";
	$.ajax({
		url:"processes/cart.jsp?action=remove",
		type:"POST",
		data: {"movieData": JSON.stringify(movieData)},
		success: function(data){
			var cart = JSON.parse(data);
			var cartBody = "";
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
			if(cart.length == 0){
				cartBody = '<div class="row"><h3 class="text-center">Empty Cart !</h3><p class="text-center text-warning"> Mr. Cart feels empty. Let\'s feed him some <b>Fablix-ous</b> movies. </p></div>'
				$("#cartPage .modal-footer").html("<button class='btn btn-md btn-primary'  data-dismiss='modal'>Return to site</button>")
			}
			$("#cartPage .modal-body").html(cartBody);
			$("#save").on("click", function(){
				location.reload();
			})
			
		},
		error: function(request, error){
			console.log("ERROR");
		}
	})
}

function addToCart(movieData){
	$(".addCart").unbind();
	$(".removeCart").unbind();
	$('#cartPage .modal-footer').html('<button id="checkOut" class="btn btn-md btn-primary" data-dismiss="modal">Checkout</button><button class="btn btn-md btn-success" id="save" data-dismiss="modal">Save Cart</button>');
	var movieIDs = "";
	$.ajax({
		url: "processes/cart.jsp?action=add",
		type: "POST",
		data: {"movieData": JSON.stringify(movieData)},
		success: function(data){
			var cart = JSON.parse(data);
			var cartBody = "";
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
			$("#save").on("click", function(){
				location.reload();
			})
		},
		error: function(request, error){
			console.log("ERROR");
		}
	})
}

$(document).ready(function(){
	$(document).on("click", ".addCart", function(event){
	    addToCart(JSON.parse(unescape($(this).data("movie")))); 
	});
	$(document).on("click", ".removeCart", function(event){
		removeFromCart(JSON.parse(unescape($(this).data("movie")))); 
	});
	$(document).on("click", "#checkOut", function(event){
		$("#checkOutModal").modal();
	})
	$(document).on('click', "#startBrowsing", function(event){
		location.reload();
	})
})

$(document).ready(function(){
	$("#expDate").datepicker({
		format: "yyyy-mm-dd",
	}).on('change', function(){
        $('.datepicker').hide();
    });
})

$(document).ready(function(){
	$("#proceed").on("click", function(){
		var formVars = $("#checkOutForm").serialize()+"&movieIDs="+$("#movieIDs").data("ids");
		console.log(formVars);
		$.ajax({
			url: "processes/sale.jsp",
			type: "POST",
			data: formVars,
			success: function(data){
				console.log(data);
				var confirmation = JSON.parse(data);
				var confirmationBody = "";
				if(confirmation.status == "failure"){
					toastr.error("Information Mismatch: Unable to procceed with Checkout");
				}else{
					confirmationBody += "<h4>Congratulations " + confirmation.saleInfo.custName + ", your order has been placed.</h4><hr><h5>Order Summary</h5>";
					var movies = confirmation.saleInfo.moviesBought;
					for(var i = 0; i < movies.length; i++){
						confirmationBody+= '<ul class="list-group"><li class="list-group-item" style="padding:1% !important"> Movie Title - ' + movies[i].name + '</li>';
						confirmationBody+= '<li class="list-group-item" style="padding:1% !important"> Quantity - ' + movies[i].quantity + '</li></ul>';
					}
					$("#confirmBody").html(confirmationBody);
					$("#confirmationPage").modal();
				}
			}
		})
	})
})
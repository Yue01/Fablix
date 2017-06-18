/*MOVIELIST PAGE JAVASCRIPT
button clicks + actions */

$("#goHome").on('click', function(){
	window.location = "home.jsp";
})

$(".starCloseModal").on('click', function(){
	$('iframe').attr('src', $('iframe').attr('src'));
	$("#starPage .modal-body").scrollTop(0);
})
$(".movieCloseModal").on('click', function(){
	$('iframe').attr('src', $('iframe').attr('src'));
	$("#moviePage .modal-body").scrollTop(0);
})


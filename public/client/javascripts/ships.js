
$(function() {
	ships_height();
	ships_div_scroll_top();
})

$(window).resize(function() {
	ships_height();
});

function ships_height(){
	height = $(window).height()
	$(".ships_div").css("height", height-120)
}

function ships_div_scroll_top(){
	// document.getElementById("ships_div").scrollTop = document.getElementById("ships_div").scrollHeight;
}
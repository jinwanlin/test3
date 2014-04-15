// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery-1.10.2.min
//= require jquery_ujs
//= require bootstrap.min

//= require ships
//= require order_item



$(function(){
	$(".price_input").blur(function(){
		$(this).closest('form').submit();
	})
	
	$('#searchKey').typeahead({
	    source: function (query, process) {
	        return $.get('/products/search.json', { query: query }, function (data) {
							return process(data)
	        });
	    }
	});
	
	
	
	
	
	
	

	$("#searchKey").focus(function() {
		if($("#searchKey").val() == ""){
			$("#history").css("display", "block");

		}
	});
	
	$("#searchKey").blur(function() {
		t=setTimeout("hidden()",100);  //休眠300毫秒再执行这行 
	});
	
	
	$("#searchKey").keyup(function(event) {
		if($("#searchKey").val() == ""){
			$("#history").css("display", "block");
			cc();
		}else{
			t=setTimeout("hidden()",100);  //休眠300毫秒再执行这行 
		}
	})
	
	$("#history li a").click(function(){
		key = $(this).html();
		$("#searchKey").val(key)
	})
	


	
})


function hidden(){
	$("#history").css("display", "none");
}


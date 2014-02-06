$(function(){
	$(".dropdown-menu button").click(change_order);
	
	$('#product_search').typeahead({
	    source: function (query, process) {
	        return $.get('/products/search.json', { query: query }, function (data) {
							return process(data)
	        });
	    }
	});
	
	$("#ship_sn").val("").focus();
	
	$("#new_ship").submit(function(e){
		e.preventDefault();
		try {
		   $(this).ajaxSubmit();
		}catch(exception){
		}finally {
		}
		
		setTimeout(function(){
			$("#ship_sn").val("").focus()
		},1);
	})
	
})


function change_order(){
	alert(2)
	$.ajax({
		type: "POST",
		url: "/order_items.js",
		data: { "order_item[product_id]": $(this).parent().attr("product_id"), "order_item[order_amount]": $(this).html() }
	})

	$(this).siblings(".product_is_bye").removeClass("product_is_bye")
	if($(this).html()!="0"){
		$(this).addClass("product_is_bye")
	}
}
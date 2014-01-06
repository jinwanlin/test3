$(function(){
	$(".order_item_amount").click(function(){
		$.ajax({
			type: "POST",
			url: "/order_items.js",
			data: { "order_item[product_id]": $(this).attr("id"), "order_item[order_amount]": $(this).val() }
		})
	})
	
	$('#product_search').typeahead({
	    source: function (query, process) {
	        return $.get('/products/search.json', { query: query }, function (data) {
							return process(data)
	        });
	    }
	});
	
	$("#ship_sn").val("").focus()
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


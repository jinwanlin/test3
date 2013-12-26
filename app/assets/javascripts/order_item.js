$(function(){
	$(".order_item_amount").change(function(){
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
	
	
})

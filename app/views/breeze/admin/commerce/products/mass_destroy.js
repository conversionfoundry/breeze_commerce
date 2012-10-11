var js_products_array = <%= raw @products.to_json %>;
$.each(js_products_array, function(index, product) { 
  $('#product_' + product._id).fadeOut(function() { $(this).remove(); });
});
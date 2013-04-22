# Event triggers
$("input.btn-add_to_cart").live "click", (event) ->
  if $($(this)[0].form).valid()
    $(document).trigger "breezeCommerceAddToCart", $(this)

# Post to the provided URL with the specified parameters.
post = (path, parameters) ->
  form = $("<form></form>")
  form.attr "method", "post"
  form.attr "action", path
  $.each parameters, (key, value) ->
    field = $("<input></input>")
    field.attr "type", "hidden"
    field.attr "name", key
    field.attr "value", value
    form.append field
  # The form needs to be a part of the document in
  # order for us to be able to submit it.
  $(document.body).append form
  form.submit()

# Product Pagination
$(document).ready ->
  $(".product_pagination a").live "click", (event) ->
    page_number = $(this).attr("href") #.split('=')[1] // TODO: need a more robust way to get the page number for the link
    product_list_id = $(this).parents("div.products").data("product-list-id")
    $.ajax
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
      type: "GET"
      url: "products"
      data:
        product_list_id: product_list_id
        page: page_number
      dataType: "script"
    event.preventDefault()





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
      url: "/products"
      data:
        product_list_id: product_list_id
        page: page_number
      dataType: "script"
    event.preventDefault()


# When a property is selected, send the current set of properties to filters
$(".breeze-commerce-product ul.options input[type=radio]").on "click", (e) ->
  product_div = $(this).closest(".breeze-commerce-product")
  product_id = product_div.data("product-id")

  # Get all checked options. Should be one per property.
  option_ids = []
  product_div.find("ul.options input[type=radio]:checked").each (index) ->
    option_ids.push $(this).val()

  filterVariants(product_id, option_ids)

  $(this).closest("li").siblings().removeClass "active"
  $(this).closest("li").addClass "active"

# When a property is selected, send the current set of properties to filters
$(".breeze-commerce-product select").on "change", (e) ->
  product_div = $(this).closest(".breeze-commerce-product")
  product_id = product_div.data("product-id")

  # Get all checked options. Should be one per property.
  option_ids = []
  product_div.find("select option:selected").each (index) ->
    option_ids.push $(this).val()

  filterVariants(product_id, option_ids)

filterVariants = (product_id, option_ids) ->
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")

    url: "/variants/filter"
    dataType: "html"
    type: "GET"
    data:
      product_id: product_id
      option_ids: option_ids

    success: (result) ->
      eval result

    error: (result) ->
      eval result

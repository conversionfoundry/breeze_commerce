cartAjax = (url, data, method="PUT") ->
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
    url: url
    dataType: "html"
    type: method
    data: data
    success: (result) ->
      eval result
    error: (result) ->
      eval result

# Update the order immediately when line item quantities change in the cart
$(".line_item-quantity").live 'change', (event) ->
  if $(this).val() is 0
    # Check whether to remove the line item entirely
    if confirm("Remove the line item?")
      $(this).siblings(".remove").click()
    else
      # Update the line item to quantity of 1
      $(this).val 1
      url = "/orders/" + $(this).data("order-id") + "/line_items/" + $(this).data("line-item-id")
      data =
        line_item:
          quantity: 1
        update_order_total: true
      cartAjax(url, data)
  else
    # Update the line item
    url = "/orders/" + $(this).data("order-id") + "/line_items/" + $(this).data("line-item-id")
    data =
      line_item:
        quantity: $(this).val()
      update_order_total: false
    cartAjax(url, data)

$(".line_item-customer_message").on 'change', (event) ->
  url =  "/orders/" + $(this).data("order-id") + "/line_items/" + $(this).data("line-item-id")
  data = 
    line_item:
      customer_message: $(this).val() 
  cartAjax(url, data)

# Update the order immediately when shipping method changes in the cart
$('input[name="order[shipping_method_id]"]').on 'change', (event) ->
  url = "/orders/" + $(this).data("order-id")
  data =
    order:
      shipping_method_id: $(this).val()
  cartAjax(url, data)

# Update the order immediately when shipping method changes in the cart
$("#order_coupon_code").on 'change', (event) ->
  url = "/orders/" + $(this).data("order-id") + "/redeem_coupon"
  data =
    code: $(this).val()
  cartAjax(url, data)

# Country selection
$('#edit_order #country').live 'change', (event) ->
  # url = "/shipping_methods"
  url = "/orders/" + $(this).data("order-id")
  # data =
  #   country_id: $(this).val()
  #   order_id: $(this).data('order-id')
  data =
    order:
      country_id: $(this).val()
  cartAjax(url, data)

$(document).ready ->
  $("#edit_order").find("input.line_item-customer_message").each (index) ->
    $(this).rules("add", {required: true})
    $(this).rules("add", {maxlength: $(this).data("character-limit")})

  $("#edit_order").validate
    rules:
      "order[line_items_attributes][0][customer_message]": 
        required: true
        maxlength: $(this).find("input#order_line_items_attributes_0_customer_message").data("character-limit")
    highlight: (label) ->
      $(label).closest(".control-group").removeClass("success").addClass "error"
    success: (label) ->
      label.append("").closest(".control-group").removeClass("error").addClass "success"


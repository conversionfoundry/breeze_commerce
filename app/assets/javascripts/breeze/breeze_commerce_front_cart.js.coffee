# Update the order immediately when line item quantities change in the cart
$(".line_item-quantity").live 'change', (event) ->
  if $(this).val() is 0
    # Check whether to remove the line item entirely
    if confirm("Remove the line item?")
      $(this).siblings(".remove").click()
    else
      # Update the line item to quantity of 1
      $(this).val 1
      # TODO: DRY up this code: it's the same as below except for quantity
      $.ajax
        beforeSend: (xhr) ->
          xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        url: "/orders/" + $(this).data("order-id") + "/line_items/" + $(this).data("line-item-id")
        dataType: "html"
        type: "PUT"
        data:
          line_item:
            quantity: 1
          update_order_total: true
        success: (result) ->
          eval result
        error: (result) ->
          eval result
  else
    # Update the line item
    $.ajax
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
      url: "/orders/" + $(this).data("order-id") + "/line_items/" + $(this).data("line-item-id")
      dataType: "html"
      type: "PUT"
      data:
        line_item:
          quantity: $(this).val()
        update_order_total: false
      success: (result) ->
        eval result
      error: (result) ->
        eval result

$(document).ready ->
  $("#edit_order").validate
    highlight: (label) ->
      $(label).closest(".control-group").removeClass("success").addClass "error"
    success: (label) ->
      label.append("").closest(".control-group").removeClass("error").addClass "success"
  $("#edit_order").find("input.line_item-customer_message").each (index) ->
    $(this).rules("add", {required: true})
    $(this).rules("add", {maxlength: $(this).data("character-limit")})

$(".line_item-customer_message").on 'change', (event) ->
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
    url: "/orders/" + $(this).data("order-id") + "/line_items/" + $(this).data("line-item-id")
    dataType: "html"
    type: "PUT"
    data:
      line_item:
        customer_message: $(this).val()
    success: (result) ->
      eval result
    error: (result) ->
      eval result


# Update the order immediately when shipping method changes in the cart
$(".radio-shipping_method").live 'change', (event) ->
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
    url: "/orders/" + $(this).data("order-id")
    dataType: "html"
    type: "PUT"
    data:
      order:
        shipping_method_id: $(this).val()
    success: (result) ->
      eval result
    error: (result) ->
      eval result

$(document).ready ->
  $("#edit_order").validate
    rules:
      "order[line_items_attributes][0][customer_message]": 
        required: true
        maxlength: $(this).find("input#order_line_items_attributes_0_customer_message").data("character-limit")
    highlight: (label) ->
      $(label).closest(".control-group").removeClass("success").addClass "error"
    success: (label) ->
      label.append("").closest(".control-group").removeClass("error").addClass "success"

# Update the order immediately when shipping method changes in the cart
$("#order_coupon_code").on 'change', (event) ->
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
    url: "/orders/" + $(this).data("order-id") + "/redeem_coupon"
    dataType: "html"
    type: "PUT"
    data:
      code: $(this).val()
    success: (result) ->
      eval result
    error: (result) ->
      eval result
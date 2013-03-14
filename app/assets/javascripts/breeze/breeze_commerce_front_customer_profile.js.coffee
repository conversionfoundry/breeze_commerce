if $('#edit_customer').length > 0 # i.e. if we're on the shopping cart page

  # Copy the shipping address to the billing address
  duplicateAddress = ->
    $("#customer_shipping_address_attributes_name").val $("#customer_billing_address_attributes_name").val()
    $("#customer_shipping_address_attributes_address").val $("#customer_billing_address_attributes_address").val()
    $("#customer_shipping_address_attributes_city").val $("#customer_billing_address_attributes_city").val()
    $("#customer_shipping_address_attributes_state").val $("#customer_billing_address_attributes_state").val()
    $("#customer_shipping_address_attributes_postcode").val $("#customer_billing_address_attributes_postcode").val()
    selected = $("#customer_billing_address_attributes_country option:selected").val()
    $("#customer_shipping_address_attributes_country option[value='" + selected + "']").attr "selected", "selected"
    $("#customer_shipping_address_attributes_phone").val $("#customer_billing_address_attributes_phone").val()
    false

  clearShippingAddress = ->
    $("#customer_shipping_address_attributes_name").val ""
    $("#customer_shipping_address_attributes_address").val ""
    $("#customer_shipping_address_attributes_city").val ""
    $("#customer_shipping_address_attributes_state").val ""
    $("#customer_shipping_address_attributes_postcode").val ""
    $ "#customer_shipping_address_attributes_country option[value=\"\"]"
    $("#customer_shipping_address_attributes_phone").val ""
    false

  $("#btn-edit_customer_profile").on "click", (event) ->
    event.preventDefault()
    $(".customer-show").slideUp()
    $(".customer-edit").slideDown()

  $("#btn-show_customer_profile").on "click", (event) ->
    event.preventDefault()
    $(".customer-show").slideDown()
    $(".customer-edit").slideUp()

  $(document).ready ->
    $("#edit_customer").validate
      highlight: (label) ->
        $(label).closest(".control-group").removeClass("success").addClass "error"
      success: (label) ->
        label.append("").closest(".control-group").removeClass("error").addClass "success"

  $("#edit_customer #same").on "change", () ->
    if $(this).attr("checked")
      duplicateAddress()
      $("fieldset.address-shipping.address").slideUp()
    else
      clearShippingAddress()
      $("fieldset.address-shipping.address").slideDown()

  $("fieldset.address-billing.address").find("input, textarea, select").on "change", () ->
    if $("#edit_customer #same").attr("checked")
      duplicateAddress()
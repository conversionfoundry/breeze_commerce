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

# Shopping Cart
$(document).ready ->
  
  # Update the order immediately when line item quantities change in the cart
  $(".line_item-quantity").change ->
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
        success: (result) ->
          eval result
        error: (result) ->
          eval result

  # Update the order immediately when shipping method changes in the cart
  $(".radio-shipping_method").change ->
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




# Checkout Form
$(document).ready ->
  $("#new_customer").validate
    # onkeyup: false,
    errorElement: "span"
    errorClass: "help-inline"
    highlight: (label) ->
      $(label).closest(".control-group").removeClass("success").addClass "error"
    success: (label) ->
      label.append("").closest(".control-group").removeClass("error").addClass "success"

  $("#checkout-form").validate
    # onkeyup: false,
    errorElement: "span"
    errorClass: "help-inline"
    highlight: (label) ->
      $(label).closest(".control-group").removeClass("success").addClass "error"
    success: (label) ->
      label.append("").closest(".control-group").removeClass("error").addClass "success"


  
  
  
  # Step 1 - Sign In 
  
  
  # Step 2 - Shipping 
  
  # Step 3 
  
  # Update billing address fields depending on whether it's the same as shipping address
  
  # Step 4 
  
  # Show/hide password field for new accounts
  
  # Going back 
  
  # Validate the fields for one step (i.e. not the whole form)
  validateStep = (stepName) ->
    stepValid = true
    $(stepName + " input").add(stepName + " textarea").add(stepName + " select").each (index) ->
      stepValid = false  unless $(this).valid() is 1
    stepValid
  
  # Return a nicely-formatted address
  # addressType is 'shipping' or 'billing'
  formatAddress = (addressType) ->
    address = ""
    address += $("#order_" + addressType + "_address_name").val() + "<br />"
    address += $("#order_" + addressType + "_address_address").val().replace(/\n\r?/g, '<br />') + "<br />"
    address += $("#order_" + addressType + "_address_city").val() + " "
    address += $("#order_" + addressType + "_address_state").val() + "<br />"
    address += $("#order_" + addressType + "_address_postcode").val() + "<br />"
    address += $("#order_" + addressType + "_address_country").val() + "<br />"
    address += "Contact Phone " + $("#order_" + addressType + "_address_phone").val()
    address
  
  # Copy the shipping address to the billing address
  duplicateAddress = ->
    $("#order_billing_address_name").val $("#order_shipping_address_name").val()
    $("#order_billing_address_address").val $("#order_shipping_address_address").val()
    $("#order_billing_address_city").val $("#order_shipping_address_city").val()
    $("#order_billing_address_state").val $("#order_shipping_address_state").val()
    $("#order_billing_address_postcode").val $("#order_shipping_address_postcode").val()
    selected = $("#order_shipping_address_country option:selected").val()
    $("#order_billing_address_country option[value='" + selected + "']").attr "selected", "selected"
    $("#order_billing_address_phone").val $("#order_shipping_address_phone").val()
    false

  change = (from, to, summaryHtml) ->
    $(panels[from]).children(".checkout-body").slideUp()
    $(panels[from]).children(".checkout-header").removeClass "active"
    $(panels[from]).children(".checkout-header").addClass "visited"
    $(panels[from]).children(".checkout-summary").slideDown()
    $(panels[to]).children(".checkout-body").slideDown()
    $(panels[to]).children(".checkout-header").addClass "active"
    $(panels[to]).children(".checkout-summary").slideUp()
    false

  currentStepIndex = ->
    element = $(panels.join()).children(".checkout-body").filter(":visible").first().parent().attr("id")
    panels.indexOf "#" + element

  # Panels for the checkout form
  panels = ["#sign-in", "#shipping", "#billing", "#confirmation"]

  # Starting status
  # ... depends on whether we have a customer already signed in
  if $("#sign-in").attr("data-customer_signed_in") is "true"
    # Hide first panel, show second
    $(panels.join()).children(".checkout-body").hide()
    $(panels[1]).children(".checkout-body").show()
    $(panels.slice(1).join()).children(".checkout-summary").hide()
  else
    # Hide all but first panel
    $(panels.slice(1).join()).children(".checkout-body").hide()
    $(panels.join()).children(".checkout-summary").hide()
  
  # Show/hide password field for returning customers
  $("#returning_customer").change ->
    if @checked 
      $('#continue-1b').hide()
    else
      $('#continue-1b').show()
    $("li#returning_customer_password").slideToggle @checked

  $('#button-sign_in').click (e) ->
    e.preventDefault()
    # customer = { email: 'test@example.com', password: 'test' }
    post(
      "/store/customer/sign_in"
      commit: "Sign in"
      authenticity_token: $('meta[name=csrf-token]').attr('content')
      utf8: "✓"
      'customer[email]': 'test@example.com'
      'customer[password]': 'test'
    )



  $("#continue-1a").click (event) ->
    change 0, 1

  $("#continue-1b").click (event) ->
    if $("#customer_email").valid()
      $("#order_email").val $("#customer_email").val()
      $("#guest_email").html $("#customer_email").val()
      return change(0, 1)
    false

  $("#continue-2").click (event) ->
    if validateStep("#shipping")
      duplicateAddress()
      $("#shipping .checkout-summary .summary").html formatAddress("shipping")
      return change(1, 2)
    false

  $("#same").change ->
    if $(this).attr("checked")
      duplicateAddress()
      $("#order_billing_address").slideUp()
    else
      $("#order_billing_address_name").val ""
      $("#order_billing_address_address").val ""
      $("#order_billing_address_city").val ""
      $("#order_billing_address_state").val ""
      $("#order_billing_address_postcode").val ""
      $ "#order_billing_address_country option[value=\"\"]"
      $("#order_billing_address_phone").val ""
      $("#order_billing_address").slideDown()

  $("#continue-3").click (event) ->
    if validateStep("#billing")
      $("#billing .checkout-summary .summary").html formatAddress("billing")
      return change(2, 3)
    false

  $("#create_new_account").change ->
    $("li#new_account_password").slideToggle @checked

  $("#continue-4").click (event) ->
    @form.submit()  if validateStep("#confirmation")
    false

  $("#edit-sign-in").click (event) ->
    change currentStepIndex(), 0

  $("#edit-shipping").click (event) ->
    change currentStepIndex(), 1

  $("#edit-payment").click (event) ->
    change currentStepIndex(), 2

  $("#changed-my-mind").click (event) ->
    change currentStepIndex(), 3

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
  console.log form
  # The form needs to be a part of the document in
  # order for us to be able to submit it.
  $(document.body).append form
  form.submit()

if $('#checkout-form').length > 0 # i.e. if we're on the shopping cart page

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

  clearBillingAddress = ->
    $("#order_billing_address_name").val ""
    $("#order_billing_address_address").val ""
    $("#order_billing_address_city").val ""
    $("#order_billing_address_state").val ""
    $("#order_billing_address_postcode").val ""
    $ "#order_billing_address_country option[value=\"\"]"
    $("#order_billing_address_phone").val ""
    false

  # Checkout Form
  validateStep = (stepName) ->
    stepValid = true
    $(stepName + " input").add(stepName + " textarea").add(stepName + " select").each (index) ->
      if $(this)[0].form == null
        # IE9 gets a null form.
        # Temporary shim to bypass client-side validation on IE9
        alert('Form is null.')
        stepValid = true
      else
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

  change = (from, to, summaryHtml) ->
    $(panels[from]).children(".checkout-body").slideUp()
    $(panels[from]).removeClass("active").addClass("visited")
    $(panels[from]).children(".checkout-summary").slideDown()
    $(panels[to]).children(".checkout-body").slideDown()
    $(panels[to]).addClass("active")
    $(panels[to]).children(".checkout-summary").slideUp()
    setTimeout (->
      alignCartWith( $(panels[to]) )
    ), 500
    false

  alignCartWith = (element) ->
    cart = $("#checkout-form .cart-container")
    if cart
      startOffset = cart.offset()
      endOffset = cart.offset()
      endOffset.top = element.offset().top
      $("#checkout-form .cart-container").css({position: 'absolute', margin: 0, top: startOffset.top, left: cart.offset().left}).animate({left: endOffset.left, top: endOffset.top}, 400)

  currentStepIndex = ->
    element = $(panels.join()).children(".checkout-body").filter(":visible").first().parent().attr("id")
    panels.indexOf "#" + element

  # Panels for the checkout form
  panels = ["#sign-in", "#shipping", "#billing", "#confirmation"]

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

  # Show/hide password field for returning customers
  $("#returning_customer").change ->
    if @checked 
      $('#continue-1b').hide()
    else
      $('#continue-1b').show()
    $("li#returning_customer_password").slideToggle @checked

  $('#button-sign_in').click (e) ->
    e.preventDefault()
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

  $("#continue-2").live "click", (event) ->
    if validateStep("#shipping")
      duplicateAddress()
      $("#shipping .checkout-summary .summary").html formatAddress("shipping")
      return change(1, 2)
    false

  $("#checkout-form #same").change ->
    if $(this).attr("checked")
      duplicateAddress()
      $("#order_billing_address").slideUp()
    else
      clearBillingAddress()
      $("#order_billing_address").slideDown()

  $("#continue-3").click (event) ->
    if validateStep("#billing")
      $("#billing .checkout-summary .summary").html formatAddress("billing")
      return change(2, 3)
    false

  $("#create_new_account").change ->
    $("li#new_account_password").slideToggle @checked

  $("#continue-4").click (event) ->
    # @form.submit()  if validateStep("#confirmation")
    $('form#checkout-form').submit()  if validateStep("#confirmation")
    false

  $("#edit-sign-in").click (event) ->
    change currentStepIndex(), 0

  $("#edit-shipping").click (event) ->
    change currentStepIndex(), 1

  $("#edit-payment").click (event) ->
    change currentStepIndex(), 2

  $("#changed-my-mind").click (event) ->
    change currentStepIndex(), 3

  $(document).ready ->
    # Starting status
    alignCartWith $(".panel.active")

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
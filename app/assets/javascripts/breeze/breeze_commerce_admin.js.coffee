# Show a form as a dialog, with OK and Cancel buttons
# TODO: Make this into a jQuery function
dialogForm = (id, title, data, method, setup_function = null) ->
  $("<div id=\"" + id + "\"></div>").html(data).dialog
    title: title
    modal: true
    width: 512
    resizable: false
    open: ->
      $("input", this)[0].focus()
      setup_function() if setup_function
    close: ->
      $(this).remove()
    buttons:
      Cancel: 
        text: 'Cancel'
        class: 'cancel'
        click: ->
          $(this).dialog "close"
      OK:
        text: 'Save'
        class: 'save'
        click: ->
          # Get form data
          form = $(this).children('form')
          form_url = form.attr('action')
          form_data = form.serializeObject()
          # Send form
          $.ajax
            beforeSend: (xhr) ->
              xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
            url: form_url
            dataType: "html"
            type: method
            data: form_data
            success: (result) ->
              eval result
            error: (result) ->
              eval result

# In some cases (e.g. product_images and variants (which also have images) we can't use AJAX submissions
dialogFormSynchronous = (id, title, data, setup_function = null) ->
  $("<div id=\"" + id + "\"></div>").html(data).dialog
    title: title
    modal: true
    width: 512
    resizable: false
    open: ->
      $("input", this)[0].focus()
      setup_function() if setup_function
    close: ->
      $(this).remove()
    buttons:
      Cancel: 
        text: 'Cancel'
        class: 'cancel'
        click: ->
          $(this).dialog "close"
      OK:
        text: 'Save'
        class: 'save'
        click: ->
          form = $(this).children('form')
          form.submit()


# Used to serialize form data as JSON
jQuery.fn.serializeObject = ->
  arrayData = @serializeArray()
  objectData = {}
  $.each arrayData, ->
    if @value?
      value = @value
    else
      value = ''
    if objectData[@name]?
      unless objectData[@name].push
        objectData[@name] = [objectData[@name]]
      objectData[@name].push value
    else
      objectData[@name] = value
  return objectData

# Countries
$(".new.country.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "country-details", "New Country", data, 'POST'
  e.preventDefault()
$(".countries .country-actions .edit.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "country-details", "Edit Country", data, 'PUT'
  e.preventDefault()

# Tags
$(".new.tag.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "tag-details", "New Tag", data, 'POST'
  e.preventDefault()
$(".tags .tag-actions .edit.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "tag-details", "Edit Tag", data, 'PUT'
  e.preventDefault()

# Line Items
$(".new.line_item.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "line_item-details", "New Line Item", data, 'POST'
  e.preventDefault()

# Product Images
# n.b. We can't upload images through javascript, so we have to do a normal form.submit
$(".new.product_image.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogFormSynchronous "product_image-details", "New Product Image", data
  e.preventDefault()

# Product Relationships
$(".new.relationship.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "relationship-details", "New Product Relationship", data, 'POST'
  e.preventDefault()
$(".relationships .relationship-actions .edit.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "relationship-details", "Edit Product Relationship", data, 'PUT'
  e.preventDefault()

# Shipping Methods
$(".new.shipping_method.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "shipping_method-details", "New Shipping Method", data, 'POST'
  e.preventDefault()
$("table.shipping_methods td.actions .edit.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogForm "shipping_method-details", "Edit Shipping Method", data, 'PUT'
  e.preventDefault()
# Show/hide extra controls for shipping methods
$('fieldset.shipping_method_types input[name=shipping_method_type]').live "click", (e) ->
  if $(this).val() == 'breeze/commerce/threshold_shipping_method'
    $('#threshold_shipping_method-details').slideDown()
  else
    $('#threshold_shipping_method-details').slideUp() 

# Variants
$(".new.variant.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogFormSynchronous "variant-details", "New Variant", data
  e.preventDefault()
$(".variants .variant-actions .edit.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogFormSynchronous "variant-details", "Edit Variant", data
  e.preventDefault()

# Variant Factory
$(".new.variant_factory.button").live "click", (e) ->
  $.get @href, (data) ->
    dialogFormSynchronous "variant_factory-details", "New Variant Factory", data
  e.preventDefault()

# Properties
$(".new.property.button").live "click", (e) ->
  $.get @href, (data) ->
    setup_function = =>
      new $.TextboxList("#property_option_names")
    dialogForm "property-details", "New Property", data, 'POST', setup_function
  e.preventDefault()
$(".properties .property-actions .edit.button").live "click", (e) ->
  $.get @href, (data) ->
    setup_function = =>
      new $.TextboxList("#property_option_names")
    dialogForm "property-details", "Edit Property", data, 'PUT', setup_function
  e.preventDefault()

# Orders
# Shipping and Billing status selectors in index.html
$("table.orders select.status").live "change", (e) ->
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
    url: "/admin/store/orders/" + $(this).data('order_id')
    type: "put"
    data: $(this).parent('form').serializeObject()

# Drag-and-drop sorting
$(document).ready ->
  $("table.shipping_methods tbody").sortable update: (e, ui) ->
    $.ajax
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
      url: "/admin/store/shipping_methods/reorder.js"
      type: "post"
      data: "_method=put&" + $(this).sortable("serialize")
  $("ul#product_images").sortable update: (e, ui) ->
    $.ajax
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
      url: "/admin/store/products/" + $(this).data('product_id') + "/product_images/reorder.js"
      type: "post"
      data: "_method=put&" + $(this).sortable("serialize")
  $("table.tags tbody").sortable update: (e, ui) ->
    $.ajax
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
      url: "/admin/store/tags/reorder.js"
      type: "post"
      data: "_method=put&" + $(this).sortable("serialize")
  $("table.variants tbody").sortable update: (e, ui) ->
    $.ajax
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
      url: "/admin/store/products/" + $(this).data('product_id') + "/variants/reorder.js"
      type: "post"
      data: "_method=put&" + $(this).sortable("serialize")


# Published toggles
$(document).ready ->
  # Variants on product page
  $("table.variants .published-toggle").live "mousedown", ->
    $checkbox = $(this).siblings(".variant-published")
    $checkbox.click().change()
    checked = $(this).siblings(".variant-published:checked").length > 0
    $(this).animate( {backgroundPosition: ((if checked then 0 else 100)) + "%"}, "slow", "easeInOutQuad" )
    id = $(this).closest("tr.variant").attr("data-id")
    product_id = $(this).closest("tr.variant").attr("data-product-id")
    $.ajax
      beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
      url: "/admin/store/products/" + product_id + "/variants/" + id + ".js"
      type: "post"
      dataType: "script"
      data: "_method=put&variant[published]=" + checked

  # Products on product page
  # Insert the toggle switch for product availability
  $('<div class="published-toggle"></div>').insertAfter("#product_published").css("background-position": ((if $("#product_published:checked").length > 0 then 0 else 100)) + "% 0%").mousedown (event) ->
    $("#product_published").click().change()
    $(this).animate
      "background-position": ((if $("#product_published:checked").length > 0 then 0 else 100)) + "%"
    , "slow", "easeInOutQuad"

# List Filters
$(".filters a").live "click", (e) ->
  $.get @href
  e.preventDefault()

# MultiSelect
$(document).ready ->
  $('.multiselect').multiSelect();

# Merchant notes for orders
$("div#order-notes #note-save").live "click", (e) ->
  e.preventDefault()
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
    url: "/admin/store/orders/" + $(this).data("order-id") + "/notes"
    dataType: "html"
    type: "POST"
    data:
      note:
        body_text: $("#note-new-body").val()
    success: (result) ->
      eval result
    error: (result) ->
      eval result

# Update slug for new products
$("#new_product #product_title").live "input", ->
  slug_field = $("#product_slug", $(this).closest("form"))
  slug_field.val $(this).val().toLowerCase().replace(/[^a-z0-9\-\_]+/g, "-").replace(/(^\-+|\-+$)/g, "")  if slug_field.length > 0 and not slug_field[0].modified

$("#new_product #product_slug").live "input", ->
  @modified = true

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

$("#new_order #same").live "change", (e) ->
  if $(this).attr("checked")
    duplicateAddress()
  else
    clearBillingAddress()

$("#order_shipping_address input, #order_shipping_address textarea, #order_shipping_address select").live "change", (e) ->
  if $("#new_order #same").attr("checked")
    duplicateAddress()

$("#order_billing_address input[type=text], #order_billing_address textarea, #order_billing_address select").live "change", (e) ->
  $("#new_order #same").attr("checked", null)


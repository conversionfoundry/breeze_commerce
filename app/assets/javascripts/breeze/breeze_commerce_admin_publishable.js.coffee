# Published toggles
updatePublishable = (publishSwitch, publishableName, url) ->
  checkbox = publishSwitch.siblings("input[type=checkbox].published")
  checkbox.click().change()
  isChecked = publishSwitch.siblings("input[type=checkbox].published:checked").length > 0
  $.ajax
    beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
    url: url
    type: "post"
    dataType: "script"
    data: "_method=put&" + publishableName + "[published]=" + isChecked

animatePublishSwitch = (publishSwitch, isChecked) ->
  if isChecked
    switchPosition = "0"
  else
    switchPosition = "100"
  publishSwitch.animate( {backgroundPosition: switchPosition + "%"}, "slow", "easeInOutQuad" )

# Coupons on coupon page
$("table.coupons .published-toggle").live "mousedown", ->
  id = $(this).closest("tr.coupon").attr("data-id")
  url = "/admin/store/coupons/" + id + ".js"
  updatePublishable($(this), "coupon", url)

# Variants on product page
$("table.variants .published-toggle").live "mousedown", ->
  id = $(this).closest("tr.variant").attr("data-id")
  product_id = $(this).closest("tr.variant").attr("data-product-id")
  url = "/admin/store/products/" + product_id + "/variants/" + id + ".js"  
  updatePublishable($(this), "variant", url)



$(document).ready ->
  # # Coupons on coupons index
  # $("table.coupons tr.coupon").each (index) ->
  #   id = $(this).data("id")
  #   switchHTML = '<div id="coupon_' + id + '_published_toggle" class="published-toggle"></div>'
  #   radioButton = $('#coupon_' + id + '_published')
  #   isChecked = radioButton.prop("checked")
  #   if isChecked
  #     switchPosition = "0"
  #   else
  #     switchPosition = "100"
  #   $(switchHTML).insertAfter(radioButton).css({'background-position': switchPosition + '% 0%'})


  # Products on product page
  # This one currently has no AJAX. It takes effect on product save.
  $('<div class="published-toggle"></div>').insertAfter("#product_published").css("background-position": ((if $("#product_published:checked").length > 0 then 0 else 100)) + "% 0%").mousedown (event) ->
    $("#product_published").click().change()
    $(this).animate
      "background-position": ((if $("#product_published:checked").length > 0 then 0 else 100)) + "%"
    , "slow", "easeInOutQuad"


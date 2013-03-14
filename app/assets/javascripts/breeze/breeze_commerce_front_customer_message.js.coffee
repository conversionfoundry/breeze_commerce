$(document).ready ->
  $(".new_line_item.requires_customer_message").validate
    rules:
      "line_item[customer_message]": 
        required: true
        maxlength: $(this).find("input.line_item_customer_message").data("character-limit")
    highlight: (label) ->
      $(label).closest(".control-group").removeClass("success").addClass "error"
    success: (label) ->
      label.append("").closest(".control-group").removeClass("error").addClass "success"
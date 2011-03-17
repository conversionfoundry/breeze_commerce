var panels = ['#sign-in', '#shipping-address', '#payment-information','#create-account','#finalise-order'];

$(function() { 
  $(panels.slice(1).join()).children('.checkout-body').hide();
  
  $('#continue-1').click(function(event) {
    $(this).closest('div.checkout-body').parent().children('div.checkout-summary').html('<p>Signed in as Guest.</p>');
    return change(0, 1);
  });

  $('#continue-2').click(function(event) {
    var firstError = true;
    var validator = $('#checkout-form').validate({
        rules: {
          'order[email]': { email: true }
        },
        errorPlacement: function(error, element) {
          if (firstError) {
            element.closest('li').callout({ 
              msg: "Please complete this required field",
              pointer: "left"
            });
            element.change(function(event) {
              if(!element.hasClass('error')) {
                element.closest('li').callout('hide');
              }
            });
            element.focus();
            firstError = false;
          }
        }
      });

    var valid = validator.form();
    if (valid) {
      return change(1, 2);
    }

    return false;
  });

  $('#continue-3').click(function(event) {
    return change(2, 3);
  });

  $('#continue-4a').click(function(event) {
    return change(3, 4);
  });

  $('#continue-4b').click(function(event) {
    return change(3, 4);
  });



  function change(from, to) {
    $(panels[from]).children('.checkout-body').slideUp();
    $(panels[from]).children('.checkout-header').removeClass('active');
    $(panels[to]).children('.checkout-body').slideDown();
    $(panels[to]).children('.checkout-header').addClass('active');
    return false;
  }
});

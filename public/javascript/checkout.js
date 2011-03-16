var panels = ['#sign-in', '#shipping-address', '#payment-information','#create-account','#finalise-order'];

$(function() { 
  $(panels.slice(1).join()).children('.checkout-body').hide();
      $('form').validate({
      rules: {
        "order[email]": "required"
      } 
    });
  
  $('#continue-1').click(function(event) {
    return change(0, 1);
  });

  $('#continue-2').click(function(event) {
    $('form').validate();
    return false;
     // $("li").callout({ show: true, msg:"What is this?" });
    //return change(1, 2);
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
    $(panels[from]).children('.checkout-body').fadeOut();
    $(panels[from]).children('.checkout-header').children('span').removeClass('active');
    $(panels[to]).children('.checkout-body').fadeIn();
    $(panels[to]).children('.checkout-header').children('span').addClass('active');
    return false;
  }
});

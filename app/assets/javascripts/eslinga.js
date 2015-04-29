
var ready = function() {

    $('.excess-height-bar').hide()

    $('#s-left').hover(function() {
        $('#s-left-overlay').fadeToggle("slow");
    });


    $('#s-right').hover(function() {
        $('#s-right-overlay').fadeToggle("slow");
    });

};

$( window ).scroll( function () {

      $window = $(window)

      if ( $window.scrollTop() > 250 ) {
        $('.height-bar').animate({margin: 0}, 1500, function() {
            $('.excess-height-bar').fadeIn(1000)
        })
      } 

});





$(document).ready(ready);
$(document).on('page:load', ready);
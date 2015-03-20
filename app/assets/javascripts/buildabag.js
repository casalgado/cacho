

var ready = function() {

    $('#config1').on('click', function(){
    	$('#top-image').css('backgroundImage', "url(/assets/top-image-04.png)")
    })

    $('#config2').on('click', function(){
    	$('#top-image').css('backgroundImage', "url(/assets/top-image-05.png)")
    })

    $('#config3').on('click', function(){
    	$('#top-image').css('backgroundImage', "none")
    })

    $('#config4').on('click', function(){
    	$('#top-image').css('backgroundImage', "url(/assets/top-image-05.png)")
    })

};



$(document).ready(ready);
$(document).on('page:load', ready);
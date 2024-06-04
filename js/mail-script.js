    // -------   Mail Send ajax

     $(document).ready(function() {
        var contact_form = $('#myForm'); // contact form
        var booking_form = $('#booking_form'); // contact form
        var submit = $('.submit-btn'); // submit button
        var submit_booking = $('.btn-boeking'); // submit button
        var alert = $('.alert-msg'); // alert div for show alert message

        // form submit event
        contact_form.on('submit', function(e) {
            e.preventDefault(); // prevent default form submit

            $.ajax({
                url: '/contact.php', // form action url
                type: 'POST', // form submit method get/post
                dataType: 'html', // request type html/json/xml
                data: contact_form.serialize(), // serialize form data
                beforeSend: function() {
                    alert.fadeOut();
                    submit.html('Sending....'); // change submit button text
                },
                success: function(data) {
                    alert.html(data).fadeIn(); // fade in response data
                    contact_form.trigger('reset'); // reset form
                    submit.attr("style", "display: none !important");; // reset submit button text
                },
                error: function(e) {
                    console.log(e)
                }
            });
        });

        booking_form.on('submit', function(e) {
            e.preventDefault(); // prevent default form submit

            $.ajax({
                url: 'booking.php', // form action url
                type: 'POST', // form submit method get/post
                dataType: 'html', // request type html/json/xml
                data: booking_form.serialize(), // serialize form data
                beforeSend: function() {
                    alert.fadeOut();
                    submit_booking.html('Sending....'); // change submit button text
                },
                success: function(data) {
                    alert.html(data).fadeIn(); // fade in response data
                    booking_form.trigger('reset'); // reset form
                    submit_booking.attr("style", "display: none !important");; // reset submit button text
                },
                error: function(e) {
                    console.log(e)
                }
            });
        });
    });
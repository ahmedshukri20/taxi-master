    // -------   Mail Send ajax

     $(document).ready(function() {
        var contact_form = $('#myForm'); // contact form
        var submit = $('.submit-btn'); // submit button
        var alert = $('.alert-msg'); // alert div for show alert message

        // form submit event
        contact_form.on('submit', function(e) {
            e.preventDefault(); // prevent default form submit

            $.ajax({
                url: 'contact.php', // form action url
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
    });
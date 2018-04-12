/**
 * Created by Abubakr on 4/12/2018.
 */
//= require jquery


WebFont.load({
    google: {"families":["Poppins:300,400,500,600,700","Roboto:300,400,500,600,700","Asap+Condensed:500"]},
    active: function() {
        sessionStorage.fonts = true;
    }
});

$(document).ready(function(){
    $('#payment-type').on('change', function() {
        if ( this.value == 'Credit')
        {
            $("#business").show();
        }
        else
        {
            $("#business").hide();
        }
    });

    $('#job_type').on('change', function() {
        if ( this.value == 'Fixed')
        {
            $("#business").show();
        }
        else
        {
            $("#business").hide();
        }
    });
});
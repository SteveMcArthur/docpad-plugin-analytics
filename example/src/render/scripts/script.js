/*global $ */
$(function(){
    $('#data-button').click(function(event){
        event.preventDefault();
        $.getJSON('/analytics/data/last30days',function(data){
            $('#results').html(JSON.stringify(data));
        });
    });
});
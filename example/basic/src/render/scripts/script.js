/*global $ */
$(function(){
    $('#data-button').click(function(event){
        event.preventDefault();
        $.getJSON('/analytics/data/uniquePageviews',function(data){
            $('#results pre').html(JSON.stringify(data,null,4));
        });
    });
});
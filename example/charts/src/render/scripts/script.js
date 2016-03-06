/*global $,document, Chart */
$(function () {

    if (!Chart) {
        alert("No Chart Object!!");
    }
    var barChart;
    var lineChart;


    function charts(data) {

        var labels = $.map(data.rows, function (item) {
            return item[0].substr(0,30);
        });
        var chartValues = $.map(data.rows, function (item) {
            return parseInt(item[1]);
        });
        var chartData = {
            labels: labels,
            datasets: [{
                fillColor: "rgba(151,187,205,0.5)",
                strokeColor: "rgba(151,187,205,0.8)",
                highlightFill: "rgba(151,187,205,0.75)",
                highlightStroke: "rgba(151,187,205,1)",
                data: chartValues
            }]
        };


        var ctx = document.getElementById("chart-bar").getContext("2d");
        barChart = new Chart(ctx).Bar(chartData);
        var ctx2 = document.getElementById("chart-line").getContext("2d");
        lineChart = new Chart(ctx2).Line(chartData);
    }



    $.getJSON('/analytics/data/uniquePageviews', function (data) {
        charts(data);
    });

    $('#btn-bar').click(function () {
        $('#btn-bar').addClass("active");
        $('#btn-line').removeClass("active");
        $('#chart-bar').removeClass('hidden');
        $('#chart-line').addClass('hidden');
    });

    $('#btn-line').click(function () {
        $('#btn-bar').removeClass("active");
        $('#btn-line').addClass("active");
        $('#chart-bar').addClass('hidden');
        $('#chart-line').removeClass('hidden');
    });

});
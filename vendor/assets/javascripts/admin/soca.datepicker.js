$(document).ajaxComplete(function()
{
    var date = new Date();
    date.setDate(date.getDate());
    $('.datetimepicker').datetimepicker(
    {
        format: "d/m/Y H:m",
        minDate: date
    });
});

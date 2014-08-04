$(document).ajaxComplete(function()
{
    $(".datepicker").datepicker(
    {
      format: "dd/mm/yyyy",
      startDate: "0"
    });
});
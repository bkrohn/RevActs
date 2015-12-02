$(function() {
  $("a").click(function() {      
    $(this).find(".new").addClass("hide");
  });

  $(".linkinfo").click(function() {
    $(this).parent().find('.new').addClass("hide");
  });  
})

function hideNews() {
  $(".new").addClass("hide");
}

function showNews() {
  $(".new").addClass("show");
}
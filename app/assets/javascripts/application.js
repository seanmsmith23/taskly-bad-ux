//
//= require jquery
//
//


$(function() {
  $( ".datepicker" ).datepicker();
});

$(document).ready(function(){
  $('.complete-button').mouseover(function(){
    $(this).toggleClass('something');
  });
  $('.delete-button').mouseover(function(){
    $(this).toggleClass('something-2');
  });
  $('.filter-button').mouseover(function(){
    $(this).toggleClass('something-3');
  });
  $('.search-button').mouseover(function(){
    $(this).toggleClass('something-3');
  });
  $('.logout').mouseover(function(){
    $(this).toggleClass('something-4');
    $('.hamster').toggleClass('hamster-fill').fadeIn('slow');
  });
});

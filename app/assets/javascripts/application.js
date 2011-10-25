// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(function() {
  // Signin Modal
  $( "#signin-modal" ).dialog({
    autoOpen: false,
    modal: true,
    title: 'Sign in',
    width: 400,
    height: 300,
    buttons: [
    {
        text: "Sign in",
        click: function() { $(this).dialog("close"); }
    }]
  });

  $( ".signin" )
    .click(function() {
      $( "#signin-modal" ).dialog( "open" );
  });

  // Submit Buttons
  $( "input:submit" ).button();

  // Account menu
  $(".account").click(function(e) {
    e.preventDefault();
    $("#account_menu").toggle();
    $(".account").toggleClass("menu-open");
  });

  $("#account_menu").mouseup(function() {
    return false
  });

  $(document).mouseup(function(e) {
    if($(e.target).parent("a.account").length==0) {
      $(".account").removeClass("menu-open");
      $("#account_menu").hide();
    }
  });            


});

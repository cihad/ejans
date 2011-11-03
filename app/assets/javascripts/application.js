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
  $( "input:submit, .add-line-item" ).button();

  // Checkbox Buttons
  $( ".styled-checkbox").button();

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
  
  // Add filter form
  $(".add-line-item").click(function() {
    $(this).parent().parent().find(".line-items").toggle();
    $(this).toggleClass("open");
  });

  $(".line-items").mouseup(function() { // Mouse Up Click
    return false
  });

});


function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}
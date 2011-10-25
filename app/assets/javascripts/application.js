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
    title: 'Giriş yap',
    width: 400,
    height: 300,
    buttons: [
    {
        text: "Giriş yap",
        click: function() { $(this).dialog("close"); }
    }]
  });

  $( ".signin" )
    .click(function() {
      $( "#signin-modal" ).dialog( "open" );
  });

  // Form effect
  // $(".page-form input, .page-form textarea").focus(function() {

  // $(this)
  //   .parent()
  //   .parent()
  //   .addClass("curFocus")
  //   .children("div")
  //   .toggle();
  // });
  // $(".page-form input, .page-form textarea").blur(function() {
  //   $(this)
  //     .parent()
  //     .parent()
  //     .removeClass("curFocus")
  //     .children("div")
  //     .toggle();
  // });
  $( "input:submit" ).button();
});

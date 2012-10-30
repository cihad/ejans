// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require turbolinks
//= require jquery_ujs
//= require jquery-ui/jquery.ui.core
//= require jquery-ui/jquery.ui.widget
//= require jquery-ui/jquery.ui.mouse
//= require jquery-ui/jquery.ui.position
//= require jquery-ui/jquery.ui.autocomplete
//= require jquery-ui/jquery.ui.sortable
//= require jquery-ui/jquery.ui.datepicker
//= require jquery-ui/jquery.ui.button
//= require jquery-ui/jquery.effects.core
//= require jquery-ui/jquery.effects.highlight
//= require bootstrap-alert
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-tooltip
//= require bootstrap-tab
//= require bootstrap-popover
//= require bootstrap-typeahead
//= require jquery-plugins/jquery.maxlength
//= require jquery-plugins/jquery.multiselect
//= require jquery-plugins/jquery.formoption
//= require jquery-plugins/jquery.multiselect.filter
//= require jquery-plugins/jquery.tablesorter
//= require tinymce-jquery
//= require geolocation
//= require field_configurations
//= require chained_select
//= require places
//= require not_found
//= require image
//= require modernizr.custom

$(function() {

  // Add filter form
  $(".add-group-item").click(function() {
    $(this).parent().parent().find(".group-item-body").toggle();
    $(this).toggleClass("open");
    $(this).parent().parent().toggleClass("opened-group-item");
  });

  $(".delete-group-item").click(function() {
    $(this).parent().parent().remove();
  });

  $(".line-items").mouseup(function() { // Mouse Up Click
    return false;
  });

  // Sms field char count
  $('textarea.limited').maxlength({
    'feedback' : '.chars-left' // note: looks within the current form
  });

  // TinyMCE
  $('.tinymce').tinymce({
    theme : "advanced",
    plugins : "lists,fullscreen,table,paste,advimage",
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,bullist,numlist,outdent,indent,link,unlink,visualaid,image,formatselect,fullscreen,code,pastetext",
    theme_advanced_buttons2 : "",
    theme_advanced_buttons3 : "",
    theme_advanced_blockformats : "p,h1,h2,h3,h4,h5,h6,blockquote,dt,dd,code",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "bottom",
    theme_advanced_resizing : true,
    entity_encoding : "raw",
    content_css : "/assets/application.css"
  });

  $('#overlay .btn-close').live('click', function() {
    $(this).closest('#static-modal').remove();
    $('body').removeClass('modal-open')
  });

  $('#message .alert').addClass('in');

  $("a[rel=popover]").popover({
    placement: 'bottom',
    trigger: 'hover',
    delay: {
      show: 0,
      hide: 0,
    }
  });

  $('a[rel=tooltip]').tooltip();

  $("input[type=submit]").filter($('[rel=popover]')).popover({
    placement: 'top',
    trigger: 'hover',
  });

  $('.sortable').sortable({
    axis: 'y',
    handle: ".handle",
    update: function() {
      return $.post($(this).data('update-url'), $(this).sortable('serialize'));
    }
  });
});

function remove_fields (link) {
  $(link).prev("input[type=hidden]").val("1");
  return $(link).closest(".fields").hide();
};

function add_fields (link, association, content) {
  var new_id, regexp;
  new_id = new Date().getTime();
  regexp = new RegExp("new_" + association, "g");
  return $(link).parent().before(content.replace(regexp, new_id));
};
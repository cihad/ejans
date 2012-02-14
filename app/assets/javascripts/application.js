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
//= require jquery_ujs
//= require jquery.pjax
//= require jquery-ui/jquery.ui.core
//= require jquery-ui/jquery.ui.widget
//= require jquery-ui/jquery.ui.mouse
//= require jquery-ui/jquery.ui.sortable
//= require jquery-ui/jquery.ui.datepicker
//= require jquery-ui/jquery.ui.button
//= require jquery-ui/jquery.effects.core
//= require jquery-ui/jquery.effects.highlight
//= require bootstrap/bootstrap-alerts
//= require bootstrap/bootstrap-dropdown
//= require bootstrap/bootstrap-modal
//= require bootstrap/bootstrap-scrollspy
//= require jquery-plugins/jquery.infieldlabel
//= require jquery-plugins/jquery.maxlength
//= require jquery-plugins/jquery.multiselect
//= require jquery-plugins/jquery.multiselect.filter
//= require jquery-plugins/jquery.tablesorter
//= require tinymce-jquery
//= require slide

$(document).ready(function() {
  $(".signin").click(function() {
      $( "#signin-modal" ).dialog("open");
  });

  // Submit Buttons
  $("input:submit, .add-line-item").button();

  // Checkbox Buttons
  $(".styled-checkbox").button();
  
  // Add filter form
  $(".add-line-item").click(function() {
    $(this).parent().parent().find(".line-items").toggle();
    $(this).toggleClass("open");
    $(this).parent().parent().toggleClass("opened-filters");
  });

  $(".line-items").mouseup(function() { // Mouse Up Click
    return false;
  });

  // Sms field char count
  $('textarea.limited').maxlength({
    'feedback' : '.chars-left' // note: looks within the current form
  });

  // Pjax
  $('a.data-remote, .breadcrumbs a').pjax('[data-pjax-container]');
  // $('[data-pjax-container]')
  //   .bind('start.pjax', function() { $('[data-pjax-container]').fadeOut(400) })
  //   .bind('end.pjax', function() { $('[data-pjax-container]').fadeIn(400) });
  // return $('form[method=get]:not([data-remote])').live('submit', function(event) {
  //   event.preventDefault();
  //   return $.pjax({
  //     container: '[data-pjax-container]',
  //     url: this.action + '?' + $(this).serialize()
  //   });
  // });

  if (history && history.pushState) {
    $(".pagination a").live("click", function(e) {
      $.getScript(this.href);
      history.pushState(null, document.title, this.href); 
      e.preventDefault();
    });

    $(window).bind("popstate", function() {
      $.getScript(location.href);
    });
  }

  $('.tinymce').tinymce({
    theme : "advanced",
    plugins : "fullscreen",
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,justifyleft,justifycenter,justifyright,bullist,numlist,link,unlink,image,formatselect,fullscreen",
    theme_advanced_buttons2 : "",
    theme_advanced_buttons3 : "",
    theme_advanced_blockformats : "p,h1,h2,h3,h4,h5,h6,blockquote,dt,dd,code",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "bottom",
    theme_advanced_toolbar_location : "external",
    theme_advanced_resizing : true,
  });

});


var add_fields, remove_fields;
remove_fields = function(link) {
  $(link).prev("input[type=hidden]").val("1");
  return $(link).closest(".fields").hide();
};

add_fields = function(link, association, content) {
  var new_id, regexp;
  new_id = new Date().getTime();
  regexp = new RegExp("new_" + association, "g");
  return $(link).parent().before(content.replace(regexp, new_id));
};
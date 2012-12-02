$(function() {
  $('.add-image').on('click', function(e) {
    e.preventDefault();
    $('#fields_image_image').click();
    $('#fields_image_image').change(function() {
      var view = {
        uploaded: false
      };
      var template = $('#template').html();
      var output = Mustache.render(template, view);
      $('.images').append(output);
      $(this).closest('form').submit();
    })
  });
});
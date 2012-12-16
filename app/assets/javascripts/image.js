$(function() {
  $('.add-image').on('click', function(e) {
    e.preventDefault();
    console.log('clicked');
    $('#image_image').click();
    $('#image_image').change(function() {
      console.log(this);
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
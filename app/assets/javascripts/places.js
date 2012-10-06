$(function(){
  $('form').on('click', '.destroy-place', function(e) {
    e.preventDefault();
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
  })

  $('.multiple-places').on('click', '.add-place', function(e) {
    console.log('clicked');
    e.preventDefault();
    $this = $(this);
    time = new Date().getTime();
    regexp = new RegExp($this.data('id'), 'g');
    $new_place = $($this.data('fields').replace(regexp, time)).appendTo('.places');
    $new_place.find('select').each(function(index, select) {
      $(this).attr('id', time + '_' + index);
    });
    $new_place.treeSelect();
  })
});
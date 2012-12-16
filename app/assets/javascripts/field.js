$(function(){
  $('#field_top_place_name').typeahead({
    source: function (query, process) {
        return $.get($('#field_top_place_name').data('source-url'), { query: query }, function (data) {
            return process(data);
        });
    }
  })
})
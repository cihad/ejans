(function($) {
  $.fn.treeSelect = function() {
    return this.each(function() {
      var self = this;
      var selects = $(self).find('select');
      var length = selects.size();
      selects.each(function(index, select) {
        if ( length - 1 != index ) {
          selects.eq(index+1).chained('#' + selects.eq(index).attr('id'));
        }
      })
    });
  };
})(jQuery);
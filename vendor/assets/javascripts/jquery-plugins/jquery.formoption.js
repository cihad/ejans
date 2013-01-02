function CheckBoxOption( input, fields ) {
  this.input = input;
  this.field_class = '.' + this.input.data('toggle');
  this.fields = $(this.field_class);

  var base = this;

  if (!(this.input.is(':checked'))) {
    this.fields.remove();
  };

  this.input.on('click', function() {
    if ($(this).is(':checked')) {
      $(this).closest('.control-group').after(base.fields);
      base.fields = $(base.field_class);
    } else {
      base.fields.remove();
    }
  });
};

function SelectOption( input ) {
  this.input = $(input);
  this.options = this.input.find('option');
  var base = this;

  this.hide_options();
  this.show_selected_fields();
  this.show_fields_by_click();
};

SelectOption.prototype.hide_options = function() {
  var base = this;
  base.options.each(function() {
    base.option_field_for(this).hide();
  });
}

SelectOption.prototype.option_field_for = function( option ) {
  return $("." + $(option).attr('value'));
}

SelectOption.prototype.show_selected_fields = function() {
  this.option_field_for(this.input.find('option:selected')).show();
}

SelectOption.prototype.show_fields_by_click = function() {
  var base = this;
  base.input.on('click', function() {
    base.hide_options();
    base.show_selected_fields();
  });
}
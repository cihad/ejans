function CheckBoxOption( input, fields ) {
  this.input = input;
  this.field_pref_name = this.input.data('toggle');
  this.field_class = '.' + this.field_pref_name + '-options';
  this.fields = $(this.field_class);

  var base = this;

  if (!(this.input.is(':checked'))) {
    this.fields.remove();
  };

  this.input.on('click', function() {
    if ($(this).is(':checked')) {
      $(this).closest('tr').after(base.fields);
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
    base.option_fields(this).hide();
  });
}

SelectOption.prototype.option_fields = function( option ) {
  return $('.' + $(option).attr('value'));
}

SelectOption.prototype.show_selected_fields = function() {
  $('.' + this.input.find('option:selected').attr('value')).show();
}

SelectOption.prototype.show_fields_by_click = function() {
  var base = this;
  base.input.on('click', function() {
    base.hide_options();
    base.show_selected_fields();
  });
}
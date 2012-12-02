require 'spec_helper'

describe "Field", js: true do
  let(:node_type) { Fabricate(:node_type) }
  let(:administrator) { node_type.administrators.first }

  before do
    administrator.make_admin!
    signin administrator
    visit node_type_fields_field_configurations_path(node_type)
  end

  Fields::FieldConfiguration.subclasses.each do |klass|
    describe "#{klass.name}" do
      specify { send(:"make_#{klass.field_type}_field") }
    end
  end
end
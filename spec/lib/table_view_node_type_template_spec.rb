require 'spec_helper'

describe TableViewNodeTemplate do
  describe "class methods" do
    subject { TableViewNodeTemplate }
    it ".row" do
      str = subject.row("sample_field") { "other_field" }
      doc = Nokogiri::HTML(str)
      str.should =~ /sample_field/
      str.should =~ /other_field/
      doc.css('tr').should_not be_blank
      doc.css('th').should_not be_blank
      doc.css('td').should_not be_blank
    end

    CustomFields::Fields::Default::Field.subclasses.each do |klass|
      it ".#{klass.type}" do
        str = subject.send(klass.type, "#{klass.type}_machine_name")
        str.should =~ /#{klass.type}_machine_name/
      end
    end

    it ".print_field" do
      CustomFields::Fields::Default::Field.subclasses.each do |klass|
        str = subject.print_field("#{klass.type}", "this_is_sample_machine_name")
        str.should =~ /this_is_sample_machine_name/
      end
    end
  end

  describe "instance methods" do
    let(:node_type) do
      Fabricate(:full_featured_node_type)
    end

    subject do
      TableViewNodeTemplate.new(node_type)
    end

    it "#to_s" do
      str = subject.to_s
      node_type.nodes_custom_fields.each do |field|
        str.should =~ /#{field.machine_name}/
      end
    end
  end
end
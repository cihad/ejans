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

    Fields::FieldConfiguration.subclasses.each do |klass|
      it ".#{klass.field_type}" do
        str = subject.send(klass.field_type, "#{klass.field_type}_machine_name")
        str.should =~ /#{klass.field_type}_machine_name/
      end
    end

    it ".print_field" do
      Fields::FieldConfiguration.subclasses.each do |klass|
        str = subject.print_field("#{klass.field_type}", "this_is_sample_machine_name")
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
      node_type.configs.each do |config|
        str.should =~ /#{config.machine_name}/
      end
    end
  end
end
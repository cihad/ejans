require 'spec_helper'

describe Features::FeatureConfiguration do
  let(:node_type) { Fabricate(:node_type) }
  let(:conf) { Fabricate.build(:conf) }
  let(:sample_class) { Features::MyNewFieldFeatureConfiguration }

  before do
    conf.node_type = node_type
    class Features::MyNewFieldFeatureConfiguration < Features::FeatureConfiguration; end
  end

  subject { conf }

  it { should respond_to :label }
  it { should respond_to :key_name }
  it { should respond_to :required }
  it { should respond_to :help_text }
  it { should respond_to :position }
  it { should respond_to :node_type }
  it { should respond_to :humanize_feature_name }
  it { should respond_to :feature_type }
  it { should respond_to :feature_class }
  it { should respond_to :partial_dir }
  it { should respond_to :machine_name }
  it { should respond_to :build_assoc! }

  context "class" do
    subject { conf.class }

    it { should respond_to :feature_types }
    it { should respond_to :to_feature }
    it { should respond_to :humanize }
    it { should respond_to :options_for_types }
    it { should respond_to :to_feature }

    it "#feature_types" do
      subject.feature_types.size.should == subject.subclasses.size
    end

    it "#to_feature" do
      subject.to_feature(sample_class)
        .should == "MyNewField"
    end

    it "#humanize" do
      subject.humanize(sample_class)
        .should == "My New Field"
    end

    it "#param_name" do
      subject.param_name(sample_class)
        .should == "features_my_new_field_feature_configuration"
    end

    it "#options_for_types" do
      subject.options_for_types.size.should == subject.subclasses.size
      subject.options_for_types.should be_kind_of Array
    end
  end
end

Features::FeatureConfiguration.feature_types.each do |type|
  describe "Features::#{type}FeatureConfiguration".constantize do
    let(:node_type) { Fabricate(:node_type) }
    let(:conf) { Fabricate.build(:"#{type.downcase}_fc") }

    before do
      conf.node_type = node_type
    end

    subject { conf }

    context "#data_for_node" do
      specify do
        subject.label = "Sample Feature"
        subject.data_for_node[:"#{subject.machine_name}_label"].should_not be_nil
      end
    end

    context "#key_data" do
      specify do
        subject
          .key_data
          .should == { :key_name => subject.key_name,
                       :machine_name => subject.machine_name }
      end
    end

    context "#conf_data" do
      specify do
        subject
          .conf_data[subject.id.to_s]
          .should_not be_nil
      end
    end

    context "#data_names" do
      specify do
        subject
          .data_names
          .should be_kind_of Array
      end
    end
  end
end
require 'spec_helper'

Features::Feature.feature_types.each do |type|
  describe "Features::#{type}Feature".constantize do
    let(:feature_class) { "Features::#{type}Feature".constantize }
    let(:node_type) { Fabricate(:node_type)}
    let(:node) { Fabricate.build(:node) }
    let(:conf) { Fabricate.build(:"#{type.downcase}_fc") }

    before do
      conf.node_type = node_type
      conf.save
      node.node_type = node_type
      node.save
    end

    subject { node.features.first }

    it { should respond_to :value }
    it { should respond_to :required? }
    it { should respond_to :add_error }
    it { should respond_to :node }

    context "#{type}Feature class" do
      subject { feature_class }

      it { should respond_to :to_feature }
      it { should respond_to :feature_types }
      it { should respond_to :get_method_from_conf }

      it "#to_feature" do
        subject.to_feature(subject).should == type
      end
    end

    it "#key_name" do
      subject.key_name.should == conf.key_name
    end

    it "#conf" do
      subject.conf.should == subject.feature_configuration
      subject.conf.should == conf
    end

    it "#required?" do
      subject.conf.required = true
      subject.should be_required
    end
  end
end
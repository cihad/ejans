require 'spec_helper'

describe Features::ListFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:conf) { Fabricate.build(:list_fc) }

  before do
    node_type.feature_configurations << conf
    conf.save
    3.times do
      conf.list_items << Fabricate(:list_item)
    end
    node.node_type = node_type
    node.save
    feature = node.features.first
    feature.send("#{conf.key_name}=", [conf.list_items.first])
  end

  subject do
    node.features.first
  end

  specify do
    subject.class.should respond_to :set_key
  end
  
  it { should respond_to :value }
  it { should respond_to conf.key_name }
  it { should respond_to :maximum_select }
  it { should be_valid }

  specify {
    subject.max.should == subject.maximum_select
  }

  context "should be exists has_and_belongs_to_many association by key_name" do
    specify do
      subject.class.
        reflect_on_association(conf.key_name).
        should_not be_nil
    end

    specify do
      subject.class.
        reflect_on_association(conf.key_name).
        name.should == conf.key_name
    end
  end

  context "#validations" do
    context "when list item is null" do
      before do
        #TODO
        subject.send("#{conf.key_name}").clear
      end

      specify { subject.should_not be_valid }
    end

    context "when list item count is greater than conf's maximum select count" do
      before do
        subject.send("#{conf.key_name}").push(conf.list_items)
      end

      specify { subject.should_not be_valid }
    end
  end
end

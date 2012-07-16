require 'spec_helper'

describe Features::ListFeatureConfiguration do
  let(:node_type) { Fabricate(:node_type) }
  let(:fc) { Fabricate.build(:feature_configuration) }

  before do
    fc.node_type = node_type
    fc.list_feature_configuration = Fabricate.build(:list_fc)
  end

  subject { fc.list_feature_configuration }

  it { should respond_to :maximum_select }
  it { should respond_to :list_items }
  it { should respond_to :build_assoc! }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  specify do
    subject.list_items.size.should == 5
  end

  specify do
    subject.parent.should == fc
  end

  specify do
    subject.type.should == "List"
  end

  specify do
    subject.should be_filterable
  end

  context "#feature_configuration" do
    subject { fc }

    before do
      subject.label = "Label for List Feature"
    end

    specify do
      subject.machine_name.should == "label_for_list_feature"
    end

    context "when save" do
      before do
        subject.save
      end

      specify do
        subject.value_name.should == "zero_list_items"
      end

      context "when multiple list feature" do
        before do
          @other_conf = Fabricate.build(:feature_configuration)
          @other_conf.list_feature_configuration = Fabricate.build(:list_fc)
          @other_conf.node_type = node_type
          @other_conf.save
        end

        specify do
          @other_conf.value_name.should_not == subject.value_name
        end

        specify do
          @other_conf.value_name.should == "one_list_items"
        end
      end
    end
  end

  context "#filter_query" do
    context "when params is empty" do
      let(:params) { {} }

      specify do
        subject.filter_query(params).should == {}
      end
    end

    context "when params is filled" do
      before do
        subject.save
      end

      let(:params) { { subject.machine_name => [subject.list_items.first.id.to_s] } }
      specify do
        subject.filter_query(params).should ==
          NodeQuery.new.in(
            :"features.list_feature.zero_list_item_ids" =>
              [subject.list_items.first.id]
          ).selector
      end
    end
  end

  context "when fc's filter is true" do
    before do
      fc.filter = true
      fc.save
    end

    specify { node_type.filters.should include(fc) }
  end
end
require 'spec_helper'

describe Features::FeatureConfiguration do

  let(:conf) { Fabricate.build(:conf) }

  subject { conf }

  it { should respond_to :label }
  it { should respond_to :key_name }
  it { should respond_to :required }
  it { should respond_to :help_text }
  it { should respond_to :position }
  it { should respond_to :node_type }

  specify { subject.class.should respond_to :feature_types }
  specify { subject.class.should respond_to :to_feature }
  specify { subject.class.should respond_to :humanize }
  specify { subject.class.should respond_to :options_for_types }
  specify { subject.class.should respond_to :to_feature }
end
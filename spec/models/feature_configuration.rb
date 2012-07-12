require 'spec_helper'

describe Features::FeatureConfiguration do
  
  let(:fc) { Fabricate.build(:feature_configuration) }

  before { fc.feature_configurations }

end
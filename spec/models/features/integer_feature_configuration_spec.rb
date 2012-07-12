require 'spec_helper'

describe Features::IntegerFeatureConfiguration do
  
  let(:ifc) { Fabricate.build(:integer_feature_configuration) }
  subject { ifc }

  it { should respond_to :minumum }
  it { should respond_to :maximum }
  it { should respond_to :filter_type }
  it { should respond_to :locale }
  it { should respond_to :significant }
  it { should respond_to :view_type }
  it { should respond_to :precision }
  it { should respond_to :unit }
  it { should respond_to :units }
  it { should respond_to :separator }
  it { should respond_to :delimiter }
  it { should respond_to :prefix }
  it { should respond_to :area_code }
  it { should respond_to :country_code }

  it "should save" do
    ifc.save
    binding.pry
  end


end
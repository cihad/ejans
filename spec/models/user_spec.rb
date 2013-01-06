require 'spec_helper'

describe User do
  let(:user) { Fabricate.build(:user) }

  subject { user }

  it { should be_valid }
  it { should respond_to :email }
end
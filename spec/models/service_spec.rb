# == Schema Information
#
# Table name: services
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  image       :string(255)
#

require 'spec_helper'

describe Service do

  # before { @service = FactoryGirl.build(:service) }
  # subject { @service }

  # it { should be_valid }
end

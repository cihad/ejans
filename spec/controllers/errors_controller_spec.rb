require 'spec_helper'

describe ErrorsController do

  it "#not_found" do
    get :not_found
    response.should be_not_found
  end

end
require 'spec_helper'

describe PlacesController do

  let(:place) { Fabricate(:place) }
  let(:admin) { Fabricate(:admin) }
  let(:place_attributes) { Fabricate.attributes_for(:place) }

  before do
    place
    signin admin
  end

  it "#index assign" do
    get :index
    assigns(:nodes).should == [place]
  end

  it "#index render" do
    get :index
    response.should render_template :index
  end

  it "#show assign" do
    get :show, id: place
    assigns(:node).should == place
  end

  it "#edit assign" do
    get :edit, id: place
    assigns(:node).should == place
  end

  it "#new assign" do
    get :new
    assigns(:node).should be_a_new Place
  end

  it "#create with valid attributes" do
    expect {
      post :create, place: place_attributes
    }.to change(Place, :count).by(1)
  end

  it "#create redirect to places path" do
    post :create, place: place_attributes
    response.should redirect_to places_path
  end

  it "#create with invalid attributes" do
    expect {
      post :create, place: place_attributes.merge(name: nil)
    }.to_not change(Place, :count)
  end

  it "#update with valid attributes" do
    put :update, id: place, place: place_attributes
    assigns(:node).should == place
  end

  it "#update change with valid attributes" do
    put :update, id: place, place: place_attributes.merge(name: "Changed Name")
    place.reload
    place.name.should == "Changed Name"
  end

  it "#update redirect with valid attributes" do
    put :update, id: place, place: place_attributes
    response.should redirect_to places_path
  end

  it "#update change with invalid attributes" do
    put :update, id: place, place: place_attributes.merge(name: nil)
    place.reload
    place.name.should_not be_nil
  end

  it "#update redirect with invalid attributes" do
    put :update, id: place, place: place_attributes.merge(name: nil)
    response.should redirect_to places_path
  end
end
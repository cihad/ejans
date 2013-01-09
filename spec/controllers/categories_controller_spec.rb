require 'spec_helper'

describe CategoriesController do

  let(:category) { Fabricate(:category) }
  let(:admin) { Fabricate(:admin) }
  let(:category_attributes) { Fabricate.attributes_for(:category) }

  before do
    category
    signin admin
  end

  it "#index assign" do
    get :index
    assigns(:nodes).should == [category]
  end

  it "#index render" do
    get :index
    response.should render_template :index
  end

  it "#show assign" do
    get :show, id: category
    assigns(:node).should == category
  end

  it "#edit assign" do
    get :edit, id: category
    assigns(:node).should == category
  end

  it "#new assign" do
    get :new
    assigns(:node).should be_a_new Category
  end

  it "#create with valid attributes" do
    expect {
      post :create, category: category_attributes
    }.to change(Category, :count).by(1)
  end

  it "#create redirect to categories path" do
    post :create, category: category_attributes
    response.should redirect_to categories_path
  end

  it "#create with invalid attributes" do
    expect {
      post :create, category: category_attributes.merge(name: nil)
    }.to_not change(Category, :count)
  end

  it "#update with valid attributes" do
    put :update, id: category, category: category_attributes
    assigns(:node).should == category
  end

  it "#update change with valid attributes" do
    put :update, id: category, category: category_attributes.merge(name: "Changed Name")
    category.reload
    category.name.should == "Changed Name"
  end

  it "#update redirect with valid attributes" do
    put :update, id: category, category: category_attributes
    response.should redirect_to categories_path
  end

  it "#update change with invalid attributes" do
    put :update, id: category, category: category_attributes.merge(name: nil)
    category.reload
    category.name.should_not be_nil
  end

  it "#update redirect with invalid attributes" do
    put :update, id: category, category: category_attributes.merge(name: nil)
    response.should redirect_to categories_path
  end
end
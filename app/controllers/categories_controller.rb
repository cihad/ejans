class CategoriesController < ApplicationController

  respond_to :js, only: [:edit, :show, :new, :destroy]

  def index
    @nodes = Category.roots
  end

  def show
    @node = Category.find(params[:id])
    respond_with @node
  end

  def edit
    @node = Category.find(params[:id])
    respond_with @node
  end

  def new
    @node = Category.new
    respond_with @node
  end

  def create
    @node = Category.new(params[:category])

    if @node.save
      redirect_to categories_path, notice: 'Successfully created.'
    else
      redirect_to categories_path, alert: 'Wrooongg.'
    end
  end

  def update
    @node = Category.find(params[:id])

    if @node.update_attributes(params[:category])
      redirect_to categories_path
    else
      redirect_to categories_path
    end
  end

  def destroy
    @node = Category.find(params[:id])
    @node.destroy
    respond_with @node
  end
end
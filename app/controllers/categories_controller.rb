class CategoriesController < ApplicationController
  respond_to :js, only: [:index, :destroy]

  def show
    @category = Category.find(params[:id])
  end

  def index
    @categories = Category.roots
    @event = params[:event] if params[:event]
    case @event
    when "show"
      @parent_category = Category.find(params[:parent_category_id])
      @child_categories = @parent_category.children
    when "add_child_categories"
      @parent_category = Category.find(params[:parent_category_id])
    when "add_category"
      @parent_category = Category.new
    end
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      redirect_to categories_path, notice: 'Successfully created.'
    else
      redirect_to categories_path, alert: 'Wrooongg.'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(params[:category])
      redirect_to categories_path
    else
      redirect_to categories_path(parent_category_id: params[:parent_category_id])
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
  end
end
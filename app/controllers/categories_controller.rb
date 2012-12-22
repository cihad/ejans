class CategoriesController < ApplicationController
  respond_to :js, only: [:index, :destroy]

  layout 'small', only: [:index]

  before_filter :category, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @items = Category.roots
    @event = params[:event] if params[:event]
    case @event
    when "show"
      @parent_item = Category.find(params[:parent_item_id])
      @child_items = @parent_item.children
    when "add_child_items"
      @parent_item = Category.find(params[:parent_item_id])
    when "add_item"
      @parent_item = Category.new
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
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to categories_path
    else
      redirect_to categories_path(parent_category_id: params[:parent_category_id])
    end
  end

  def destroy
    @category.destroy
  end

private

  def category
    @category = Category.find(params[:id])
  end

end
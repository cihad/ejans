class CategoriesController < ApplicationController
  before_filter :should_be_admin, only: [:index, :create, :edit, :update, :destroy]
  respond_to :js, only: [:index, :destroy]

  layout 'small', only: [:index]

  def show
    @category = Category.find(params[:id])
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

  private
  def should_be_admin
    unless current_user.try(:admin?)
      redirect_to root_path
    end
  end
end
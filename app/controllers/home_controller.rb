class HomeController < ApplicationController
  before_filter :find_place, only: [:index]
  layout "home"

  def index
  end
end

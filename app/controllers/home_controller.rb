class HomeController < ApplicationController
  
  def index
  end

  def close_slide
    session[:slide] = false
  end

end

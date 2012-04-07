class HomeController < ApplicationController
  def index
    @services = Service.all.find_all {|s| s.image? }.sort_by { rand }.slice(0, 9)
  end
end

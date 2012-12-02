class HomeController < ApplicationController
  before_filter :find_place, only: [:index]
  layout "home"
  respond_to :js

  def index
    @nodes = Node.or( { "zero_places.place_ids" => {"$in" => [@place.id]} },
                      { "one_places.place_ids" => {"$in" => [@place.id]} })

    @cities = Place.default_place.levels.take(2).last
    column_count = case @cities.size
                  when 1..10  then 1
                  when 11..40 then 2
                  when 41..60 then 3
                  else 4
                  end

    @groups_of = @cities.size / column_count
    @column_size = 140 + ((column_count - 1) * 160)
  end

  def show
    @place = Place.find(params[:id])
    set_place(@place)
    redirect_to home_index_path
  end
end
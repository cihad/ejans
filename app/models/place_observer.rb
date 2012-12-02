class PlaceObserver < Mongoid::Observer
  def before_save(place)
    geocode(place) if place.set_geocode? and !Rails.env.test?
  end

  protected
  def geocode(place)
    search = place.name
    search += ", #{place.parent.try(:name)}" if place.parent.present?
    geo = Geocoder.search(search).first
    if geo.try(:longitude) and geo.try(:latitude)
      place.coordinates = [geo.longitude, geo.latitude]
    end
  end
end
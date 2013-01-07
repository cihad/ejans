module LocationHelper
  def find_place
    @place = Place.near_sphere(lng_lat: lng_lat).first
  end

  def lng_lat
    @lng_lat ||=  get_lng_lat_from_cookie ||
                  get_lng_lat_from_request ||
                  Place.default_lng_lat
  end

  def lng_lat_cookie_present?
    cookies[:lng_lat].present?
  end

  def create_lng_lat_cookie(lng_lat = [])
    cookies[:lng_lat] = lng_lat.join('|')
    lng_lat.map(&:to_f)
  end

  def get_lng_lat_from_cookie
    cookies[:lng_lat].split('|').map(&:to_f) if cookies[:lng_lat].present?
  end

  def get_lng_lat_from_request
    # request.location is dependency by GeoCoder
    location = request.location
    lat = location.latitude
    lng = location.longitude
    unless (lat != "0" or lat.blank?) and (lon != "0" or lon.blank?)
      create_lng_lat_cookie([lng, lat])
      [lng, lat]
    end
  end

  def set_place(place)
    create_lng_lat_cookie(place.lng_lat)
  end

  def current_place
    Place.near_sphere(lng_lat: lng_lat).first
  end
end
module LocationHelper
  def find_place
    @place = Place.near_sphere(coordinates: coordinates).first
  end

  def coordinates
    @coordinates ||=  get_coordinates_from_cookie ||
                      get_coordinates_from_request ||
                      Place.default_coordinates
  end

  def coordinates_cookie_present?
    cookies[:coordinates].present?
  end

  def create_coordinates_cookie(coordinates = [])
    cookies[:coordinates] = coordinates.join('|')
    coordinates.map(&:to_f)
  end

  def get_coordinates_from_cookie
    cookies[:coordinates].split('|').map(&:to_f) if cookies[:coordinates].present?
  end

  def get_coordinates_from_request
    # request.location is dependency by GeoCoder
    location = request.location
    lat = location.latitude
    lon = location.longitude
    unless (lat != "0" or lat.blank?) and (lon != "0" or lon.blank?)
      create_coordinates_cookie([lat, lon])
      [lat, lon]
    end
  end

  def set_place(place)
    create_coordinates_cookie(place.coordinates)
  end

  def current_place
    Place.near_sphere(coordinates: coordinates).first
  end
end
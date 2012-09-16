module LocationHelper
  def find_place
    @place = Place.near(coordinates).first
  end

  def coordinates
    location = request.location
    @coordinates ||=  if get_coordinates_from_cookie
                       get_coordinates_from_cookie
                      elsif get_coordinates_from_request
                        get_coordinates_from_request
                      else
                        Place.default_coordinates
                      end
  end

  def coordinates_cookie_present?
    cookies[:coordinates].present?
  end

  def create_coordinates_cookie(coordinates = [])
    cookies[:coordinates] = coordinates.join('|')
    coordinates
  end

  def get_coordinates_from_cookie
    cookies[:coordinates].split('|') if cookies[:coordinates].present?
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
end
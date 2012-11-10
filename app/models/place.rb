class Place
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Geocoder::Model::Mongoid
  include Mongoid::FullTextSearch

  attr_accessor :childs

  field :coordinates, type: Array
  index({ coordinates: "2d" })

  field :name, type: String

  geocoded_by :name
  after_validation :geocode, if: :name_changed?

  fulltext_search_in :name

  default_scope order_by([:name, :asc])

  def lat_lng
    to_coordinates
  end

  def lng_lat
    coordinates
  end

  def level
    ancestors.size
  end

  def level_by_place(place)
    level - place.level
  end

  def self.world
    root
  end

  def hierarchical_name
    ancestors.map(&:name).push(name).join(' > ')
  end

  def childs=(text)
    text.split("\r\n").each do |name|
      unless name.blank?
        place = Place.new(name: name, parent: self)
        place.save
      end
    end
  end

  def levels
    levels = []
    arr = []
    lv = level
    traverse(:breadth_first) do |n|
      if lv == n.level
        arr << n
      else
        levels << arr
        arr = [] << n
        lv = n.level
      end
    end

    levels << arr
  end

  def self.default_coordinates
    [35.243322, 38.963745]
  end

  def self.default_place
    near_sphere(coordinates: default_coordinates).first
  end

  def nodes
    node_types = NodeType.where({'place_page_view' => { "$exists" => true  }})
    keynames = node_types.inject([]) do |a, node_type|
                  a << node_type.keynames.grep(/place/)
                end.flatten.uniq
    node_type_query = BlankCriteria.new.in(node_type_id: node_types.map(&:id))
    key_query = keynames.inject([]) do |a, keyname|
      a << { "features.#{keyname}_ids" => { "$in" => [self.id]}}
    end

    place_query = BlankCriteria.new.or(key_query)
    query = BlankCriteria.new.and(
              place_query.selector,
              node_type_query.selector,
              BlankCriteria.new.where(published: true).selector,
              BlankCriteria.new.where(approved: true).selector)
    Node.where(query.selector)
  end
end
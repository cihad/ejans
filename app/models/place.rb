class Place
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Geocoder::Model::Mongoid
  include Mongoid::FullTextSearch

  attr_accessor :childs

  field :coordinates, type: Array
  index({ coordinates: "2d" }, { min: -200, max: 200 })

  field :name, type: String
  geocoded_by :name
  after_validation :geocode, if: :name_changed?
  fulltext_search_in :name

  field :hierarchy, type: String

  def level
    ancestors.size
  end

  def level_by_place(place)
    level - place.level
  end

  # ["Sehir", "Ilce", "Mahalle"]
  def hierarchy_names
    root.hierarchy.split(',').map { |r| r.strip }
  end

  # ["sehir", "ilce", "mahalle"]
  def hierarcial_machine_names
    hierarchy_names.map { |r| r.parameterize }
  end

  # "Mahalle"
  def level_name
    hierarchy_names[ancestors_and_self.index(self)]
  end

  # "mahalle"
  def level_machine_name
    hierarcial_machine_names[ancestors_and_self.index(self)]
  end

  def bottom_level_names
    hierarchy_names[hierarchy_names.index(level_name)..-1]
  end

  def bottom_level_machine_names
    hierarchy_names[hierarchy_names.index(level_name)..-1].map { |r| r.parameterize }
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
    [39.7767, 30.5206]
  end

  def self.default_place
    near(default_coordinates).first
  end

  def nodes
    node_types = NodeType.where({'place_page_view' => { "$exists" => true  }})
    key_names = node_types.inject([]) do |a, node_type|
                  a << node_type.key_names.grep(/place/)
                end.flatten.uniq
    node_type_query = NodeQuery.new.in(node_type_id: node_types.map(&:id))
    key_query = key_names.inject([]) do |a, key_name|
      a << { "features.#{key_name}_ids" => { "$in" => [self.id]}}
    end

    place_query = NodeQuery.new.or(key_query)
    query = NodeQuery.new.and(place_query.selector, node_type_query.selector)
    Node.where(query.selector)
  end
end
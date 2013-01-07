class Place
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::FullTextSearch
  include Ejans::TreeLevels

  attr_reader :childs

  ## fields
  field :lng_lat, type: Array
  field :name, type: String

  ## validations
  validates_presence_of :name

  ## indexes
  index({ lng_lat: "2d" })

  ## behaviours
  fulltext_search_in :name

  ## scopes
  default_scope order_by([:name, :asc])

  ## callbacks
  after_save :create_child_places

  def lat_lng
    lng_lat.reverse
  end

  def level
    parent_ids.size
  end

  def self.world
    root
  end

  def set_geocode?
    name_changed? or lng_lat.blank?
  end

  def hierarchical_name
    ancestors.map(&:name).push(name).join(' > ')
  end

  def childs=(text)
    @childs = text.split("\n").map(&:strip).reject(&:blank?)
  end

  def self.default_lng_lat
    [35.243322, 38.963745]
  end

  def self.default_place
    near_sphere(lng_lat: default_lng_lat).first
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
              BlankCriteria.new.where(status: "published").selector)
    Node.where(query.selector)
  end

private
  
  def create_child_places
    Array(childs).each do |name|
      self.class.find_or_create_by(parent: self, name: name)
    end
  end
end
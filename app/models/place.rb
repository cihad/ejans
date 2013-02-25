class Place
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::FullTextSearch
  include Ejans::Tree

  ## fields
  field :lng_lat, type: Array
  field :name

  ## validations
  validates_presence_of :name

  ## indexes
  index({ lng_lat: "2d" })

  ## behaviours
  fulltext_search_in :name

  ## scopes
  # default_scope order_by([:name, :asc])

  def lat_lng
    lng_lat.reverse
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

  def self.default_lng_lat
    [35.243322, 38.963745]
  end

  def self.default_place
    near_sphere(lng_lat: default_lng_lat).first
  end

  def nodes
    @nodes ||= begin
      listed_node_type_ids = NodeType.only(:list_in_place_page, :name).
      where(list_in_place_page: true).
      map(&:id)

      Node.only(:custom_fields_recipe, :node_type_id, :title).
        where(:node_type_id.in => listed_node_type_ids).
        where(:"zero_places.place_ids".in => [id])
    end
  end
end
class Place
  include Mongoid::Document

  attr_accessor :childs

  # Fields
  field :name, type: String
  field :hierarchy, type: String

  # Associations
  has_many :child_places, class_name: 'Place', inverse_of: :parent_place
  belongs_to :parent_place, class_name: 'Place', inverse_of: :child_places

  embeds_one :location
  accepts_nested_attributes_for :child_places

  scope :top_places, where(parent_place: nil)

  # true or false
  def top_place?
    !parent_place?
  end

  # #<Place1>
  def top_place
    return self if top_place?
    top_hierarchy.first
  end

  # [#<Place1>, #<Place2>, #<Place3>, #<SELF>]
  def top_hierarchy
    return [self] if top_place?
    [parent_place.top_hierarchy, self].flatten
  end

  # ["Sehir", "Ilce", "Mahalle"]
  def hierarchial_names
    top_place.hierarchy.split(',').map { |r| r.strip }
  end

  # ["sehir", "ilce", "mahalle"]
  def hierarcial_machine_names
    hierarchial_names.map { |r| r.parameterize }
  end

  # "Mahalle"
  def level_name
    hierarchial_names[top_hierarchy.index(self)]
  end

  # "mahalle"
  def level_machine_name
    hierarcial_machine_names[top_hierarchy.index(self)]
  end

  def bottom_level_names
    hierarchial_names[hierarchial_names.index(level_name)..-1]
  end

  def bottom_level_machine_names
    hierarchial_names[hierarchial_names.index(level_name)..-1].map { |r| r.parameterize }
  end

  def childs=(text)
    text.split("\r\n").each do |name|
      Place.create(name: name, parent_place: self) unless name.blank?
    end
  end

  def level1
    child_places
  end

  [*2..5].each do |level|
    define_method "level#{level}" do 
      send("level#{level-1}").inject [] do |m, p|
      m << p.child_places if p.child_places?
      m
      end.flatten   
    end

    define_method "tree#{level-1}" do 
      array = []
      1.upto(level-1) { |i| array << send("level#{i}") }
      array
    end
  end
end
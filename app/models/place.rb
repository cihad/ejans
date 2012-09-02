class Place
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal

  attr_accessor :childs

  # Fields
  field :name, type: String
  field :hierarchy, type: String

  embeds_one :location

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
end
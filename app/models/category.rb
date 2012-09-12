class Category
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal

  attr_accessor :childs

  # Fields
  field :name, type: String
  before_destroy :delete_descendants

  def level
    ancestors.size
  end

  def level_by_place(place)
    level - place.level
  end

  def childs=(text)
    text.split("\r\n").each do |name|
      unless name.blank?
        taxonomy = self.class.new(name: name, parent: self)
        taxonomy.save
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
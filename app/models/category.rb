class Category
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Ejans::TreeLevels

  attr_accessor :childs

  ## fields
  field :name, type: String

  ## validations
  validates_presence_of :name

  ## callbacks
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
end
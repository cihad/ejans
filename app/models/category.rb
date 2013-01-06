class Category
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Ejans::TreeLevels

  attr_reader :childs

  ## fields
  field :name, type: String

  ## validations
  validates_presence_of :name

  ## callbacks
  before_destroy :delete_descendants
  after_save :create_child_categories

  def level
    parent_ids.size
  end

  def childs=(text)
    @childs = text.split("\n").map(&:strip).reject(&:blank?)
  end

private
  
  def create_child_categories
    Array(childs).each do |name|
      self.class.find_or_create_by(parent: self, name: name)
    end
  end

end
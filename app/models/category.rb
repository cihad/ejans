class Category
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Ejans::Tree

  ## fields
  field :name

  ## validations
  validates_presence_of :name

  ## callbacks
  before_destroy :delete_descendants

end
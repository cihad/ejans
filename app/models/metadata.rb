class Metadata

  include Mongoid::Document
  include Mongoid::FullTextSearch
  
  ## fields
  field :text

  ## validations
  validates_presence_of :text

  ## associations
  belongs_to :document, polymorphic: true

  ## behaviours
  fulltext_search_in :text

end
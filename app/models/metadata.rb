class Metadata
  include Mongoid::Document
  include Mongoid::FullTextSearch
  
  belongs_to :document, polymorphic: true
  field :text
  fulltext_search_in :text
end
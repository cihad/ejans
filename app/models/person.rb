class Person
  include Mongoid::Document

  cattr_accessor :ali

  field :name
  field :fields, default: []
  validates_presence_of :name

  # embeds_many :address

  def valid?(*args)
    super and PersonValidator.new(self).valid?
  end

  def addresses
    self[:addresses].map { |a| a["address"] }.map { |a| "http://addre.ss/" << a }
  end
end

class Address

  include Mongoid::Document

  embedded_in :person
  field :adress

end
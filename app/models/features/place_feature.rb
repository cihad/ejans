module Features
  class PlaceFeature < Feature
    include Mongoid::Document

    validate :presence_value

    # Singleton Methods
    def self.set_key(key_name)
      has_and_belongs_to_many :"#{key_name}", class_name: "Place", inverse_of: nil
    end

    def value
      send(key_name)
    end

    private
    def presence_value
      if required? and value.blank?
        add_error("#{key_name} bos birakilamaz.")
      end
    end
  end
end
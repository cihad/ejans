module Features
  class StringFeature < Feature
    include Mongoid::Document

    def self.set_key(key_name)
      field :"#{key_name}", type: String
    end

    def value
      send(key_name)
    end

    delegate :maximum_length, :minumum_length, to: :feature_configuration
    alias :max :maximum_length
    alias :min :minumum_length

    validate :presence_value
    validate :not_greater_than_maximum_length
    validate :not_less_than_minumum_length

    private
    def presence_value
      if required? and value.blank?
        add_error("#{key_name} bos birakilamaz.")
      end
    end

    def not_less_than_minumum_length
      if min and value.size < min
        add_error("#{min} degerinden kucuk olamaz.")
      end
    end

    def not_greater_than_maximum_length
      if max and value.size > max
        add_error("#{max} degerinden buyuk olamaz.")
      end
    end
  end
end
module Features
  class IntegerFeature < Feature
    include Mongoid::Document

    # Validates
    validate :presence_value
    validate :not_greater_than_maximum
    validate :not_less_than_minumum

    # Singleton Methods
    def self.set_key(key_name)
      field :"#{key_name}", type: Integer
    end

    def value
      send(conf.key_name)
    end

    def min
      conf.minumum
    end

    def max
      conf.maximum
    end

    private
    def presence_value
      if required? and value.blank?
        add_error("bos birakilamaz.")
      end
    end

    def not_greater_than_maximum
      if value.present? and max and value > max
        add_error("#{max} degerinden fazla olamaz.")
      end
    end

    def not_less_than_minumum
      if value.present? and min and value < min
        add_error("#{min} degerinden az olamaz.")
      end
    end    
  end
end
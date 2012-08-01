module Features
  class IntegerFeature < Feature
    include Mongoid::Document

    validate :presence_value
    validate :not_greater_than_maximum
    validate :not_less_than_minimum

    get_method_from_conf :minimum, :maximum
    alias :min :minimum
    alias :max :maximum

    def self.set_key(key_name)
      field :"#{key_name}", type: Integer
    end

    def fill_random!
      mi = min || 0
      ma = max || 10_000
      valid_value = Random.new.rand(mi..ma)
      self.value = valid_value
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

    def not_less_than_minimum
      if value.present? and min and value < min
        add_error("#{min} degerinden az olamaz.")
      end
    end    
  end
end
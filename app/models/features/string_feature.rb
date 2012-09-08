module Features
  class StringFeature < Feature

    get_method_from_conf :maximum_length, :minimum_length
    alias :max :maximum_length
    alias :min :minimum_length

    validate :presence_value
    validate :not_greater_than_maximum_length
    validate :not_less_than_minimum_length

    def self.set_specify(conf)
      field conf.key_name, type: String
    end

    def fill_random!
      mi = min || 1
      ma = max || 200
      valid_value = Faker::Lorem.paragraph.truncate(Random.new.rand(mi..ma))
      self.value = valid_value
    end

    private
    def presence_value
      if required? and value.blank?
        add_error("#{key_name} bos birakilamaz.")
      end
    end

    def not_less_than_minimum_length
      if value and min and value.size < min
        add_error("#{min} degerinden kucuk olamaz.")
      end
    end

    def not_greater_than_maximum_length
      if value and max and value.size > max
        add_error("#{max} degerinden buyuk olamaz.")
      end
    end
  end
end
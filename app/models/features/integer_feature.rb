module Features
  class IntegerFeature < Feature
    include ActionView::Helpers

    validate :presence_value
    validate :not_greater_than_maximum
    validate :not_less_than_minimum

    get_method_from_conf :minimum, :maximum
    alias :min :minimum
    alias :max :maximum

    def self.set_specify(conf)
      field conf.key_name, type: Integer
    end

    def data(conf_data)
      super
      {
        :"#{@machine_name}_value" => number_with_delimiter(@value, delimiter: @data[:"#{@machine_name}_delimiter"]),
        :"#{@machine_name}_prefix" => @data[:"#{@machine_name}_prefix"],
        :"#{@machine_name}_suffix" => @data[:"#{@machine_name}_suffix"],
        :"#{@machine_name}_min" => @data[:"#{@machine_name}_minimum"],
        :"#{@machine_name}_max" => @data[:"#{@machine_name}_maximum"]
      }
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
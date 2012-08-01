module Features
  class DateFeature < Feature
    include Mongoid::Document
    include Mongoid::MultiParameterAttributes

    # Validates
    validate :presence_value
    validate :start_and_end_date

    get_method_from_conf :start_year, :end_year

    def self.set_key(key_name)
      field key_name, type: Date
    end

    def fill_random!
      valid_date = Date.new(Random.new.rand(start_year...end_year), rand(11) + 1, rand(27) + 1)
      self.value = valid_date
    end

    private
    def presence_value
      if required? and not_defined?
        add_error("#{conf.label.parameterize} alani bos birakilamaz.")
      end
    end

    def start_and_end_date
      if !not_defined? && (value.year < start_year or
         value.year > end_year)
        add_error("Baslangic tarihinden kucuk ve bitis tarihinden kucuk olamaz")
      end
    end

    def not_defined?
      value.blank? or value == Date.new(1) 
    end
  end
end
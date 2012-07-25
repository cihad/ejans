module Features
  class DateFeature < Feature
    include Mongoid::Document
    include Mongoid::MultiParameterAttributes

    # Validates
    validate :presence_value
    validate :start_and_end_date

    def self.set_key(key_name)
      field key_name, as: :value, type: Date
    end

    private
    def presence_value
      if required? and not_defined?
        add_error("#{conf.label.parameterize} alani bos birakilamaz.")
      end
    end

    def start_and_end_date
      if !not_defined? && (value.year < conf.start_year or
         value.year > conf.end_year)
        add_error("Baslangic tarihinden kucuk ve bitis tarihinden kucuk olamaz")
      end
    end

    def not_defined?
      value.blank? or value == Date.new(1) 
    end
  end
end
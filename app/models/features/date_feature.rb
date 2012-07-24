module Features
  class DateFeature < Feature
    include Mongoid::Document
    include Mongoid::MultiParameterAttributes

    # Validates
    validate :presence_value
    validate :start_and_end_date

    field :value, as: @@key, type: Date

    private
    def presence_value
      if required? and not_defined?
        add_error("#{configuration.label.parameterize} alani bos birakilamaz.")
      end
    end

    def start_and_end_date
      if !not_defined? && (value.year < child_configuration.start_year or
         value.year > child_configuration.end_year)
        add_error("Baslangic tarihinden kucuk ve bitis tarihinden kucuk olamaz")
      end
    end

    def not_defined?
      value.blank? or value == Date.new(1) 
    end
  end
end
module FeatureForms
  class StringFeatureForm < FeatureForm
    def text_field?
      conf.row == 1 ? true : false
    end

    def row
      conf.row
    end

    def max
      conf.maximum_length
    end

    def min
      conf.minimum_length
    end
  end
end
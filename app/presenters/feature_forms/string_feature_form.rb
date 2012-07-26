module FeatureForms
  class StringFeatureForm < FeatureForm
    def text_field?
      conf.row == 1 ? true : false
    end

    def row
      conf.row
    end

    def max
      comf.maximum_length
    end

    def min
      conf.minumum_length
    end
  end
end
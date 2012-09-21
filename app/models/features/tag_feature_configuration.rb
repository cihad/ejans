module Features
  class TagFeatureConfiguration < FeatureConfiguration
    include Ejans::Features::Filterable

    def data_names
      super + [:"#{machine_name}_values"]
    end

    def filter_query(params = {})
      if params[machine_name].present?
        tags = params[machine_name].split(',').map(&:strip)
        NodeQuery.new.all(:"#{where}" => tags)
      else
        NodeQuery.new
      end
    end
  end
end
module Features
  class FeatureConfiguration
    include Mongoid::Document
    field :label, type: String
    field :required, type: Boolean
    field :help, type: String
    field :sort, type: Boolean
    field :filter, type: Boolean
    field :filter_weight, type: Integer
    field :value_name, type: String
    field :position, type: Integer
    belongs_to :node_type
    default_scope order_by([:position, :asc])

    FEATURE_TYPES = [:integer, :string]
    FEATURE_TYPES.each do |feature_type|
      embeds_one :"#{feature_type}_feature_configuration",
        class_name: "Features::#{feature_type.to_s.camelize}FeatureConfiguration"
      accepts_nested_attributes_for :"#{feature_type}_feature_configuration"
    end

    before_save :assign_value_name
    # TODO
    after_destroy :delete_features_from_nodes

    def configuration_object
      self.send(type)
    end
    
    def type
      self.reflect_on_all_associations(:embeds_one).map(&:key).inject("") do |s, assoc|
        s << assoc if self.send(assoc)
        s
      end
    end

    def feature_type
      arr = type.split("_")
      arr.pop
      arr.join("_")
    end

    def machine_name
      label.parameterize("_")
    end
    
    private
    def assign_value_name
      unless value_name
        value_names = node_type.feature_configurations.map(&:value_name)
        name = "#{feature_type.downcase}_value_0"
        while value_names.include?(name)
          name = name.next
        end
        self.value_name = name
      end
    end

    # TODO
    def delete_features_from_nodes
    end
  end
end
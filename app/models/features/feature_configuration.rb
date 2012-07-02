module Features
  class FeatureConfiguration
    include Mongoid::Document

    # Fields
    field :label, type: String
    field :required, type: Boolean
    field :help, type: String
    field :sort, type: Boolean
    field :filter, type: Boolean
    field :filter_weight, type: Integer
    field :value_name, type: String
    field :position, type: Integer

    # Scopes
    default_scope order_by([:position, :asc])

    # Associations
    belongs_to :node_type

    FEATURE_TYPES = [:integer, :string, :list, :date, :image, :place]
    FEATURE_TYPES.each do |feature_type|
      embeds_one :"#{feature_type}_feature_configuration",
        class_name: "Features::#{feature_type.to_s.camelize}FeatureConfiguration"
      accepts_nested_attributes_for :"#{feature_type}_feature_configuration"
    end

    # => self.value_name = "integer_value_name"
    before_save :assign_value_name
    # TODO
    after_destroy :delete_features_from_nodes

    # => #<Features::IntegerFeatureConfiguration _id: ...>
    def child
      self.send(type)
    end
    
    # => "integer_feature_configuration"
    def type
      self.reflect_on_all_associations(:embeds_one).map(&:key).inject("") do |s, assoc|
        s << assoc if self.send(assoc)
        s
      end
    end

    # => "integer_feature"
    def feature_type
      arr = type.split("_")
      arr.pop
      arr.join("_")
    end

    def feature_type=(type)
      self.send("build_#{type}_feature_configuration")
    end

    # => Features::IntegerFeature
    def feature_class
      "Features::#{feature_type.classify}".constantize
    end

    def add_value_to_feature!
      feature_class.add_value(value_name)
    end

    # if label = "Price"
    # => "price"
    def machine_name
      label.parameterize("_")
    end
    
    private

    # => self.value_name = "integer_value_0"
    # other example:
    # => self.value_name = "string_value_1"
    def assign_value_name
      unless value_name
        value_names = node_type.feature_configurations.map(&:value_name)
        case feature_type
        when "list_feature"
          name_prefix = 0
          while value_names.include?(name = "#{number_to_english[name_prefix]}_list_items")
            name_prefix = name_prefix.next
          end
        when "image_feature"
          name_prefix = 0
          while value_names.include?(name = "#{number_to_english[name_prefix]}_images")
            name_prefix = name_prefix.next
          end
        else
          name = "#{feature_type.downcase}_value_0"
          while value_names.include?(name)
            name = name.next
          end
        end
        self.value_name = name
      end
    end

    def number_to_english
      {
        0 => "zero",
        1 => "one",
        2 => "two",
        3 => "three",
        4 => "four",
        5 => "five",
        6 => "six",
        7 => "seven",
        8 => "eight",
        9 => "nine",
        10 => "ten"
      }
    end

    # TODO
    def delete_features_from_nodes
    end
  end
end
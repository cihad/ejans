module Features
  class FeatureConfiguration
    include Mongoid::Document

    attr_accessor :feature_type

    field :label, type: String
    field :key_name, type: Symbol
    field :required, type: Boolean
    field :help_text, type: String
    field :position, type: Integer

    default_scope order_by([:position, :asc])

    belongs_to :node_type

    before_save :assign_key_name

    def self.feature_types
      subclasses.map do |name|
        to_feature(name)
      end
    end

    def self.to_feature(class_name)
      name = class_name.to_s.demodulize.titleize.split(' ')
      name.pop(2)
      name.join
    end

    def self.humanize(class_name)
      to_feature(class_name).titleize
    end

    def self.param_name(type_class)
      type_class.to_s.underscore.sub('/', '_')
    end

    def self.options_for_types
      subclasses.map { |class_name| [humanize(class_name), class_name]  }
    end

    def humanize_feature_name
      self.class.humanize(self.class)
    end

    def feature_type
      humanize_feature_name.parameterize.gsub("-","_")
    end

    def feature_class
      "features/#{feature_type}_feature".camelize.classify
    end


    def partial_dir
      "features/#{feature_type.underscore}"
    end

    def machine_name
      label.parameterize("_")
    end
    
    private
    def where
      "features." + key_name.to_s
    end

    def assign_key_name
      unless key_name
        key_names = node_type.feature_configurations.map(&:key_name)
        # case feature_type
        # when "list_feature"
        #   name_prefix = 0
        #   while value_names.include?(name = "#{number_to_english[name_prefix]}_list_items")
        #     name_prefix = name_prefix.next
        #   end
        # when "image_feature"
        #   name_prefix = 0
        #   while value_names.include?(name = "#{number_to_english[name_prefix]}_images")
        #     name_prefix = name_prefix.next
        #   end
        # else
        #   name = "#{feature_type.downcase}_value_0"
        #   while value_names.include?(name)
        #     name = name.next
        #   end
        # end

        name = "#{feature_type.downcase}_value_0"
        while key_names.include?(name)
          name = name.next
        end
        self.key_name = name.to_sym
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
  end
end
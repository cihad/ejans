module Features
  class IntegerFeatureConfiguration
    include Mongoid::Document
    include Ejans::Features::FeatureConfigurationAbility
    include Ejans::Features::SingleValueFeatureConfiguration

    FILTER_TYPES = [:number_field, :range_with_number_field, :range_with_slider]

    # Fields
    field :minumum, type: Integer
    field :maximum, type: Integer
    field :filter_type, type: Symbol
    field :prefix, type: String
    field :suffix, type: String

    # Fields
    field :locale, type: Symbol
    field :significant, type: Boolean

    VIEW_TYPES = [ :number_to_currency,
                  :number_to_human,
                  :number_to_human_size,
                  :number_to_percentage,
                  :number_to_phone,
                  :number_with_delimiter,
                  :number_with_precision]
    field :view_type, type: Symbol

    field :precision, type: Integer, default: 2
    field :unit, type: String
    field :units, type: Symbol
    field :separator, type: String
    field :delimiter, type: String
    field :unit, type: String
    UNIT_TYPES = [:distance]
    field :area_code, type: Boolean
    field :country_code, type: Integer

    # Associations
    embedded_in :feature_view
    belongs_to :feature_configuration, class_name: "Features::FeatureConfiguration"

    # Associations
    embedded_in :feature_configuration, class_name: "Features::FeatureConfiguration"

    before_validation :empty_fields

    # Class Methods
    class << self

      # => [:locale, :precision, :unit, :separator, ...]
      def options
        return self.fields_for_options.inject([]) do |a, view_type|
                 type, options = view_type
                 a << type
               end
      end

      def options_for_view_types
        {
          number_to_currency:   [ :locale, :precision, :unit,
                                  :separator, :delimiter],
          number_to_human:      [ :locale, :precision, :significant,
                                  :delimiter, :units],
          number_to_human_size: [ :locale, :precision, :separator,
                                  :delimiter, :prefix],
          number_to_percentage: [ :locale, :precision, :separator,
                                  :delimiter],
          number_to_phone:      [ :area_code, :delimiter, :country_code],
          number_with_delimiter:[ :locale, :delimiter, :separator],
          number_with_precision:[ :locale, :precision, :significant,
                                  :separator, :delimiter]
        }
      end

      # => { locale: [:number_to_currency, :number_to_human,
      #                 :number_to_human_size, :number_to_percentage,
      #                 :number_with_delimiter, :number_with_precision],
      #      precision: ...
      #    }
      def view_types_for_options
        h = Hash.new { |h, k| h[k] = [] }
        options.each do |option|
          h[option] = VIEW_TYPES.inject([]) do |a, vt|
            a << vt if self.options_for_view_types[vt].include?(option)
            a
          end          
        end
        h
      end

      def fields_for_options
        {
          locale:       { field:    :select,
                          choices:  [:tr, :en]},
          precision:    { field: :number_field },
          unit:         { field: :text_field },
          separator:    { field: :text_field },
          delimiter:    { field: :text_field },
          significant:  { field: :check_box },
          units:        { field: :select,
                          choices: [:distance, :height, :weight, :volume] },
          prefix:       { field: :text_field },
          area_code:    { field: :check_box },
          country_code: { field: :number_field }
        }
      end

      # =>  {
      #       :number_to_currency => [:significant, :units,
      #                               :prefix, :area_code,
      #                               :country_code],
      #       :number_to_human => ...
      #     }
      def non_fields_for_view_types
        VIEW_TYPES.inject({}) do |h, view_type|
          h[view_type] = self.options - self.options_for_view_types[view_type]
          h
        end
      end

      def internal_object(field)
        self.fields.select { |k,v| k == field.to_s }.first.last
      end

      def field_type(field)
        internal_object(field).options[:type]
      end

      def default_value(field)
        internal_object(field).default_val
      end
    end

    def build_assoc!(node)
      if node.features.map(&:feature_configuration).include?(parent)
        feature = node.features.where(feature_configuration_id: parent.id.to_s).first
      else
        feature = node.features.build
        feature.feature_configuration = parent
        feature.send("build_#{feature_type}")
      end

      feature.child.class.add_value(value_name)
    end

    def type
      "Integer"
    end

    def filterable?
      true
    end

    def filter_query(params = ActiveSupport::HashWithIndifferentAccess.new)
      case filter_type
      when :number_field
        if params["#{machine_name}"].present?
          value = Integer(params["#{machine_name}"])
          NodeQuery.new.where(:"#{where}" => value).selector
        else
          {}
        end
      when :range_with_number_field, :range_with_slider
        if params["#{machine_name}_min"].present? or params["#{machine_name}_max"].present?
          value_min = params["#{machine_name}_min"].present? ? Integer(params["#{machine_name}_min"]) : minumum
          value_max = params["#{machine_name}_max"].present? ? Integer(params["#{machine_name}_max"]) : maximum
          NodeQuery.new.between( :"#{where}" => value_min..value_max).selector
        else
          {}
        end
      end
    end

    protected
    def empty_fields
      self.class.non_fields_for_view_types[view_type].each do |field|
        default_val = self.class.default_value(field)
        self.send("#{field}=", default_val)
      end
    end
  end
end
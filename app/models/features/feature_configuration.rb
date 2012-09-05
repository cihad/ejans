module Features
  class FeatureConfiguration
    include Mongoid::Document

    attr_accessor :feature_type

    field :label, type: String
    validates :label, presence: true
    field :key_name, type: Symbol
    field :required, type: Boolean
    field :help_text, type: String
    field :position, type: Integer, default: 1000

    scope :filters, where(filter: true)
    scope :sort_confs, where(sort: true)
    default_scope order_by([:position, :asc])

    belongs_to :node_type
    delegate :key_names, to: :node_type

    validate :same_label_name, on: :create
    after_destroy :destroy_features_from_nodes

    before_validation do
      label.strip!
    end

    before_save :set_key_name
    after_update :order_features

    class << self
      define_method(:filterable?) do
        included_modules.include?(Ejans::Features::Filterable) ? true : false
      end

      define_method(:sortable?) do
        included_modules.include?(Ejans::Features::Sortable) ? true : false
      end
    end

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
      "features/#{feature_type}_feature".camelize.classify.constantize
    end

    def partial_dir
      "features/#{feature_type.underscore}"
    end

    def machine_name
      label.parameterize("_")
    end

    #### For Node Presenter
    def data_names
      data_for_node.inject([]) do |arr, data|
        arr << data.first
      end
    end

    def conf_data
      { id.to_s => key_data.merge(data: data_for_node) }
    end

    def key_data
      { :key_name => key_name,
        :machine_name => machine_name }
    end

    def data_for_node
      { :"#{machine_name}_label" => label }
    end
    ####

    def build_assoc!(node)
      feature_class.set_key(key_name)
      if node.features.where(feature_configuration_id: self.id).exists?
        @feature = node.features.where(feature_configuration_id: self.id).first
      else
        @feature = node.features.build({}, feature_class)
        @feature.feature_configuration = self
      end
    end

    private
    def where
      "features.#{key_name}"
    end

    def same_label_name
      if new_record? and node_type.feature_configurations.select { |conf| !conf.new_record? }.map(&:label).include?(label)
        errors.add(:base, "Daha onceden eklenen bir label var. Ayni label 2 defa eklenemez.")
      end
    end

    def assign_key_name
      name = "#{feature_type}_value_0"
      while key_names.include?(name.to_sym)
        name = name.next
      end
      name
    end

    def set_key_name
      self.key_name = assign_key_name.to_sym unless key_name
    end

    def destroy_features_from_nodes
      node_type.nodes.each do |node|
        feature = node.features.where(feature_configuration_id: self.id).first
        feature.try(:destroy)
      end
    end

    def order_features
      if position_changed?
        node_type.nodes.each do |node|
          node.features = node.
            features.
            sort_by { |fea| fea.feature_configuration.position }
        end
      end
    end
  end
end
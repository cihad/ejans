require 'action_view'
module Fields
  class FieldConfiguration
    include Mongoid::Document

    field :label, type: String
    validates :label, presence: true
    field :keyname, type: Symbol
    field :required, type: Boolean
    field :help_text, type: String
    field :position, type: Integer, default: 1000

    scope :filters, where(filter: true)
    scope :sort_confs, where(sort: true)
    default_scope order_by([:position, :asc])

    embedded_in :node_type
    delegate :keynames, :machine_names, to: :node_type

    validate :same_label_name, on: :create
    after_destroy :destroy_fields_from_nodes

    before_validation do
      label.strip!
    end

    delegate :node_classify_name, to: :node_type

    before_save :set_conf_name
    # before_destroy :if_matching_view_data

    class << self
      define_method(:filterable?) do
        included_modules.include?(Ejans::Fields::Filterable) ? true : false
      end

      define_method(:sortable?) do
        included_modules.include?(Ejans::Fields::Sortable) ? true : false
      end
    end

    def self.field_types
      subclasses.map do |name|
        to_field(name)
      end
    end

    def self.field_name(class_name)
      name = class_name.to_s.demodulize.titleize.split(' ')
      name.pop(2)
      name.join("\s")
    end

    def self.field_class_style_name(class_name)
      field_name(class_name).gsub(" ", "")
    end

    def self.field_machine_name(class_name)
      field_class_style_name(class_name).underscore
    end

    def self.field_param_name(class_name)
      field_name(class_name).downcase.gsub("\s", "_")
    end

    def self.param_name(type_class)
      type_class.to_s.underscore.sub('/', '_')
    end

    def self.options_for_types
      subclasses.map { |class_name| [field_name(class_name), class_name]  }
    end

    def field_type
      self.class.field_machine_name(self.class)
    end

    def field_class_style_type_name
      self.class.field_class_style_name(self.class)
    end

    def node_klass
      node_classify_name.safe_constantize
    end

    def partial_dir
      "fields/#{field_type}"
    end

    def machine_name
      label.parameterize("_")
    end

    def self_data
      { machine_name.to_sym => self }
    end

    def load_node
      set_specifies
    end

    def matching_views
      return machine_names.inject([]) do |arr, name|
        node_type.views.each do |view|
          if m = view.node_template.match(name.to_s)
            arr << view
          end
        end
        arr
      end.uniq
    end

    private

    def same_label_name
      if new_record? and node_type.field_configurations.select { |conf| !conf.new_record? }.map(&:label).include?(label)
        errors.add(:base, "Daha onceden eklenen bir label var. Ayni label 2 defa eklenemez.")
      end
    end

    def assign_keyname
      name = "#{field_type}_value_0"
      while keynames.include?(name.to_sym)
        name = name.next
      end
      name
    end

    def set_conf_name
      self.keyname = assign_keyname.to_sym unless keyname
    end

    def destroy_fields_from_nodes
      node_type.nodes.each do |node|
        node.send("#{keyname}=", nil)
      end
    end

    def if_matching_view_data
      unless matching_views.blank?
        links = matching_views.inject([]) do |output, view|
          str = ActionController::Base.helpers.link_to "view##{view.id}",
                      Rails.application.routes.url_helpers.edit_node_type_views_view_path(node_type, view)
          output << str
        end

        links = links.join(", ")

        errors.add(:base, "Bu confu silmek icin once #{links} deki conf ile ilgili datayi silmelisiz.".html_safe)
        false
      else
        true
      end
    end
  end
end
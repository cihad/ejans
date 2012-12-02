module Views
  class View
    include Mongoid::Document
    include Mongoid::Timestamps

    field :position, type: Integer
    embedded_in :node_type
    default_scope order_by([:position, :asc])
    validate :view_count
    field :icon, type: String, default: "icon-align-justify"

    def self.views_types
      subclasses.each do |class_name|
        class_name.to_s.titleize.underscore
      end
    end

    def self.sub_classes
      arr = []
      arr += [self] unless self.superclass == Object
      arr += subclasses.inject([]) do |a, class_name|
        a << class_name.sub_classes
        a.flatten
      end
    end

    def self.param_name(type_class)
      type_class.to_s.underscore.sub('/', '_')
    end

    def self.options_for_types
      sub_classes.map { |class_name| [class_name.name.demodulize.titleize, class_name] }
    end

    def view_type
      self.class.name.demodulize.titleize
    end

    def partial_dir
      "views/#{view_type.underscore}"
    end

    def type
      self.class.to_s.titleize
    end

    private
    def view_count
      if self.node_type.views.size > 2
        errors.add(:base, "En fazla 2 view ekleyebilirsiniz.")
      end
    end
  end
end
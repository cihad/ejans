module Features
  class ListFeature < Feature
    include Mongoid::Document

    def self.set_key(key_name)
      has_and_belongs_to_many :"#{key_name}", class_name: "Features::ListItem"
    end

    def value
      send(conf.key_name).map(&:name).join(', ')
    end

    def max
      conf.maximum_select
    end

    validate :presence_value

    private
    def presence_value
      if required? and value.blank?
        add_error("Not should cihaaaaaddd!!")
      end
    end
  end
end

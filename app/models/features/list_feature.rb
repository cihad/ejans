module Features
  class ListFeature < Feature
    include Mongoid::Document

    validate :presence_value
    validate :selected_item_count

    get_method_from_conf :maximum_select
    alias :max :maximum_select

    def self.set_key(key_name)
      has_and_belongs_to_many :"#{key_name}", class_name: "Features::ListItem"
    end

    private
    def presence_value
      if required? and value.size == 0
        add_error("#{conf.label} alani bos birakilamaz.")
      end
    end

    def selected_item_count
      if value.size > max
        add_error("En fazla #{max} parca secebilirsiniz.")
      end
    end
  end
end

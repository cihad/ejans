module Features
  class ListFeature < Feature
    include Mongoid::Document

    validate :presence_value
    validate :selected_item_count

    get_method_from_conf :maximum_select
    alias :max :maximum_select

    def self.set_specify(conf)
      has_and_belongs_to_many conf.key_name, class_name: "Features::ListItem"
    end

    def data(conf_data)
      super
      if @data[:"#{@machine_name}_maximum_select"] > 1
        { :"#{@machine_name}_values" => @value }
      else
        { :"#{@machine_name}_value" => @value.first }
      end
    end

    def fill_random!
      ma = maximum_select || conf.list_items.size
      list_items = conf.list_items.shuffle.take(rand(ma) + 1)
      self.value = list_items
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

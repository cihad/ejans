module Features
  class TagFeature < Feature

    def self.set_specify(conf)
      field conf.key_name, type: Array, default: []

      send(:define_method, "#{conf.key_name}_tags=") do |tags|
        self.value = tags.split(',').map(&:strip)
      end

      send(:define_method, "#{conf.key_name}_tags") do
        self.send(conf.key_name).join(', ')
      end      
    end

    def data(conf_data)
      super
      { :"#{@machine_name}_values" => @value }
    end

    def fill_random!
      # todo
    end

    validate :presence_value

    private
    def presence_value
      if required? and value.size == 0
        add_error("#{conf.label} alaninda en az bir tag girmelisiniz.")
      end
    end
  end
end
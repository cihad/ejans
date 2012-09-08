module Features
  class PlaceFeature < Feature

    validate :presence_value
    validate :out_level

    get_method_from_conf :level
    get_method_from_conf :top_place

    def self.set_specify(conf)
      has_and_belongs_to_many conf.key_name, class_name: "Place", inverse_of: nil
    end

    def fill_random!
      # ids = %w(
      #   4fec352d0d75d8bf0800003b
      #   4fec356f0d75d8bf08000076
      #   4fec37770d75d8bf08000096
      # )
      # places = ids.inject([]) do |a, id|
      #   a << Place.find(id)
      # end
      # self.value = places.take(level)
      # plc = top_place
      # valid_value = []
      # level.times do
      #   plc = plc.child_places.shuffle.take(1)
      #   valid_value << plc
      # end
      # send.value.push(valid_value)
    end

    private
    def presence_value
      if required? and value.size != level
        add_error("#{key_name} bos birakilamaz.")
      end
    end

    def out_level
      unless inheritance?
        add_error("#{conf.label} agac yapida olmayan yerler var.")
      end
    end

    def inheritance?
      true
      # TODO
      # conf.top_place.send(conf.level).all? do |level_places|
      #   if level_places & value and 
      # end
    end
  end
end
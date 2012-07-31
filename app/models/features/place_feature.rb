module Features
  class PlaceFeature < Feature
    include Mongoid::Document

    validate :presence_value
    validate :out_level

    get_method_from_conf :level

    def self.set_key(key_name)
      has_and_belongs_to_many :"#{key_name}", class_name: "Place", inverse_of: nil
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
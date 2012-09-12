module Features
  class TreeCategoryFeature < Feature
    include Mongoid::Document

    validate :presence_value

    get_method_from_conf :category

    def self.set_specify(conf)
      has_and_belongs_to_many conf.key_name, class_name: "Category", inverse_of: nil
    end

    def fill_random!
      # TODO
    end

    private
    def presence_value
      if required? and value.blank?
        add_error("#{key_name} bos birakilamaz.")
      end
    end
  end
end
module Features
  class Feature
    include Mongoid::Document

    embedded_in :node
    belongs_to :feature_configuration,
      class_name: "Features::FeatureConfiguration"

    before_save :define_feature_configuration

    class << self
      def conf=(conf)
        @conf = conf
      end

      def conf
        @conf
      end

      def set_specifies(conf)
        self.conf = conf
        set_specify(conf)
      end

      def to_feature(class_name)
        name = class_name.to_s.demodulize.titleize.split(' ')
        name.pop
        name.join
      end

      def feature_types
        subclasses.map do |name|
          to_feature(name)
        end
      end
      
      def get_method_from_conf(*methods)
        methods.each do |method|
          define_method(method) do
            conf.send(method)
          end
        end
      end
    end

    get_method_from_conf :key_name, :required?

    def conf
      self.class.conf
    end

    def data(conf_data)
      @opts = conf_data[feature_configuration_id.to_s]
      @machine_name = @opts[:machine_name]
      @key_name = @opts[:key_name]
      @value = send(@key_name)
      @data = @opts[:data]
      { :"#{@machine_name}_value" => @value }
    end

    def value
      send(key_name)
    end

    def value=(value)
      self.send("#{key_name}=", value)
    end

    def add_error(message = "")
      errors.add(key_name, message)
      node.errors.add(:base, message)
    end

    private
    def define_feature_configuration
      self.feature_configuration =
        Features::FeatureConfiguration.find(feature_configuration.id)
    end
  end
end
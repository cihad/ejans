$:.unshift File.expand_path(File.dirname(__FILE__))

module CustomFields
  @@options = {
    :reserved_names => Mongoid.destructive_fields + %w(id _id send class)
  }

  def self.options=(options)
    @@options.merge!(options)
  end

  def self.options
    @@options
  end

  def self.reserved_names
    options[:reserved_names]
  end
end

require 'active_support'
require 'carrierwave/mongoid'
require 'custom_fields/extensions/mongoid/document'
require 'custom_fields/extensions/mongoid/factory'
require 'custom_fields/extensions/mongoid/relations/referenced/many'
require 'custom_fields/extensions/mongoid/relations/embedded/many'
require 'custom_fields/criteria'
require 'custom_fields/filterable'
require 'custom_fields/relationable'
require 'custom_fields/sortable'
require 'custom_fields/fields/default'
require 'custom_fields/fields/belongs_to'
require 'custom_fields/fields/boolean'
require 'custom_fields/fields/date'
require 'custom_fields/fields/has_many'
require 'custom_fields/fields/image'
require 'custom_fields/fields/integer'
require 'custom_fields/fields/place'
require 'custom_fields/fields/select'
require 'custom_fields/fields/string'
require 'custom_fields/fields/tag'
require 'custom_fields/fields/tree_category'
require 'custom_fields/source'
require 'custom_fields/target'
require 'custom_fields/target_helpers'

# Load all the translation files
# I18n.load_path += Dir[File.join(File.dirname(__FILE__), '..', 'config', 'locales', '*.yml')]
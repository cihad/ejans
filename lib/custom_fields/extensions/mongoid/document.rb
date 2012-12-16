# encoding: utf-8
module Mongoid
  module Document
    module ClassMethods #:nodoc:
      # The mongoid default document returns always false.
      # The documents with custom fields return true.
      #
      # @return [ Boolean ] False
      #
      def with_custom_fields?
        false
      end
      
    end
  end
end

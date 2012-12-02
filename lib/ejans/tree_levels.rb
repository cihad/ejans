module Ejans

  module TreeLevels

    extend ActiveSupport::Concern

    def levels
      @levels ||= begin
        @levels = []
        arr = []
        lv = level
        traverse(:breadth_first) do |n|
          if lv == n.level
            arr << n
          else
            @levels << arr
            arr = [] << n
            lv = n.level
          end
        end

        @levels << arr
        @levels
      end
    end

    def get_just_a_branch
      self.class.get_just_a_branch(self)
    end


    module ClassMethods

      def get_just_a_branch(item)
        if item.nil?
          return
        else
          [item.children.first, get_just_a_branch(item.children.first)].compact.flatten
        end
      end

    end

  end

end
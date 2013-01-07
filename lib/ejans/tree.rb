module Ejans::Tree
  extend ActiveSupport::Concern

  included do
    attr_reader :child_nodes
    after_save :create_child_nodes

    private
    def create_child_nodes
      Array(child_nodes).each do |name|
        self.class.find_or_create_by(parent: self, name: name)
      end
    end
  end

  def child_nodes=(text)
    @child_nodes = text.split("\n").map(&:strip).reject(&:blank?)
  end

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

  def level
    parent_ids.size
  end

  def levels_size
    levels.size
  end

  def levels_unless_self
    (@levels_unless_self = levels).shift unless @levels_unless_self
    @levels_unless_self
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
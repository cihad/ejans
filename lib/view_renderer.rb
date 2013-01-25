require 'erubis'

class ViewRenderer
  
  def initialize(template, context)
    @template = template
    @context = context
  end

  def evaluate
    eruby.evaluate(context)
  end
  alias :to_s :evaluate

  def context
    self.class.context(@context)
  end

  def eruby
    self.class.eruby(@template)
  end

  def self.context(context)
    Erubis::Context.new(context)
  end

  def self.eruby(template)
    Erubis::Eruby.new(template)
  end
end
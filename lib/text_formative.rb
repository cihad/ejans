class TextFormative
  include ActionView::Helpers

  def initialize(str, opts = { format: :simple })
    @str = str
    @formats =  opts[:formats] || begin
                  if standart_formats.include? opts[:format]
                    send(opts[:format])
                  end
                end
  end

  EMAIL_REGEX = /([\w+\-.]+@[a-z\d\-.]+\.[a-z]+)/i

  def to_mail
    @str = @str.gsub(EMAIL_REGEX, '<a href=\'mailto:\1\'>\1</a>').html_safe
  end

  def to_br_and_p
    @str = simple_format(@str).html_safe
  end

  def standart_formats
    [:plain, :simple]
  end

  def simple
    %w(to_br_and_p to_mail)
  end

  def plain
    []
  end

  def to_s
    @formats.each do |formative|
      send(formative.to_sym)
    end

    @str
  end
end
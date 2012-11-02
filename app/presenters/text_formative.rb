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

  # URL_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?)/i
  EMAIL_REGEX = /([\w+\-.]+@[a-z\d\-.]+\.[a-z]+)/i
  # IMAGE_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\.(?:gif|jpe?g|png|bmp))/i

  def to_mail
    @str = @str.gsub(EMAIL_REGEX, '<a href=\'mailto:\1\'>\1</a>')
  end

  def to_br_and_p
    @str = simple_format(@str)
  end

  def standart_formats
    [:simple]
  end

  def simple
    %w(to_br_and_p to_mail)
  end

  def to_s
    @formats.each do |formative|
      send(formative.to_sym)
    end

    @str.html_safe
  end
end
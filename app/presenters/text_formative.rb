class TextFormative
  include ActionView::Helpers

  def initialize(str, opts)
    @str = str
    @formats = opts[:formats] || send(opts[:format]) || simple
  end

  URL_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?)/i
  EMAIL_REGEX = /([\w+\-.]+@[a-z\d\-.]+\.[a-z]+)/i
  IMAGE_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\.(?:gif|jpe?g|png|bmp))/i

  def to_url
    @str = @str.gsub(URL_REGEX, '<a href=\'\1\'>\1</a>')
  end

  def to_mail
    @str = @str.gsub(EMAIL_REGEX, '<a href=\'mail_to:\1\'>\1</a>')
  end

  def to_br_and_p
    @str = simple_format(@str)
  end

  def to_img
    @str = @str.gsub(IMAGE_REGEX, '<img src=\'\1\' />')
  end

  def simple
    %w(to_url to_br_and_p to_mail)
  end

  def to_s
    @formats.each do |formative|
      send(formative.to_sym)
    end

    @str
  end
end
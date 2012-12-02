module TestHelpers
  def ensure_on(path)
    visit path unless current_path == path
  end

  def t(*args)
    I18n.t(*args)
  end

  def valid_attributes_for(fabricator)
    Fabricate.attributes_for(fabricator)
  end

  def change_with_custom_values(fabricator, attrs)
    valid_attributes = valid_attributes_for(fabricator)
    valid_attributes.each do |attr, value|
      attr = attr.to_sym
      valid_attributes[attr] = attrs[attr] if attrs[attr].present?
    end
    valid_attributes
  end

  def checkbox(checkbox, boolean = true)
    boolean ? check(checkbox) : uncheck(checkbox)
  end

  def mustache_render(file_path, variables)
    file = open(file_path)
    Mustache.render(file.read, variables)
  end

  def images_dir
    "#{Rails.root}/spec/support/images"
  end

  def alert
    page.driver.browser.switch_to.alert
  end
end
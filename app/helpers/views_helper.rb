module ViewsHelper
  def ace_editor(f, field, options = {})
    mode = options.delete(:mode) || "html"
    class_name = f.object.class.name.underscore.gsub('/', '_')
    selector = '#' + class_name + '_' + field.to_s
    area = field.to_s + "_editor";
    render 'views/shared/ace', area: area, mode: mode, selector: selector
  end
end
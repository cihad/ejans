class SortLinksPresenter

  attr_reader :params

  def initialize(sort_data, params, template)
    @sort_data = sort_data
    @params    = params
    @template  = template
  end

  def current_sort
    @current_sort ||= params.delete(:sort)
  end

  def current_direction
    @direction ||= params.delete(:direction)
  end

  def is_machine_name_current_sort?(machine_name)
    current_sort == machine_name.to_s
  end

  def direction_for(machine_name)
    if is_machine_name_current_sort?(machine_name)
      current_direction == "asc" ? "desc" : "asc"
    else
      "asc"
    end
  end

  def icon_for(machine_name)
    if is_machine_name_current_sort?(machine_name)
      current_direction == "asc" ? "icon-chevron-up" : "icon-chevron-down"
    else
      nil
    end
  end

  def sort_url(machine_name, direction)
    url_for(params.merge(sort: machine_name, direction: direction))
  end

  def to_s
    @sort_data.inject("") do |output, machine_label|
      machine_name, label = machine_label

      link_class = "btn btn-small"
      link_class << " active" if current_sort == machine_name.to_s

      icon = icon_for(machine_name)
      url = sort_url(machine_name, direction_for(machine_name))

      output << iconic_link_to(label, icon, url, class: link_class)
      output
    end.html_safe
  end

  def iconic_link_to(text = "", icon = "", *args)
    url = args.shift
    link_to url, *args do
      content_tag(:i, nil, class: icon) if icon.present?
      content_tag(:span, text) if text.present?
    end
  end

  def method_missing(method, *args)
    @template.send(method, *args)
  end

end
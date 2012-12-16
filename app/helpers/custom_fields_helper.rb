module CustomFieldsHelper
  def options_for_belongs_to_class_name
    NodeType.all.map do |nt|
      [nt.name, nt.klass_with_custom_fields(:nodes).to_s]
    end.compact
  end
end
module ControllerHelper
  def sort_fields(param, model, position_field = :position)
    param.each_with_index do |id, index|
      model.find(id).update_attribute(position_field, index+1)
    end
  end
end
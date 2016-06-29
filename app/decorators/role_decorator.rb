class RoleDecorator < Draper::Decorator
  delegate_all

  def permission action, model_class
    permission = permissions.find_by action: action, model_class: model_class
    permission.present? ? permission.id : nil
  end
end

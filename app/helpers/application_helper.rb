module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice then "success"
    when :alert then "danger"
    when :info then "info"
    when :warning then "warning"
    else "primary"
    end
  end
end

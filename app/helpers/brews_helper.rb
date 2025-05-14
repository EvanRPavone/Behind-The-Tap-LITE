module BrewsHelper
  def status_class(status)
    puts "!!!! Status received: #{status}" # For debugging
    case status
    when 'primary' then 'primary'
    when 'd_rest' then 'info'
    when 'lager' then 'secondary'
    when 'crash' then 'warning'
    when 'fined' then 'light'
    when 'carbed' then 'success'
    when 'completed' then 'danger'
    else 'secondary'  # Default color
    end
  end
end
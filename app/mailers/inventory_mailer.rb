class InventoryMailer < ApplicationMailer
  def low_stock_alert(company, ingredient)
    @company = company
    @ingredient = ingredient
    mail(to: company.admins.pluck(:email), subject: "Low Stock Alert for #{@ingredient.name}")
  end

  def job_failure_alert(company, error_message)
    @company = company
    @error_message = error_message
    mail(to: company.admins.pluck(:email), subject: 'Inventory Job Failure')
  end
end

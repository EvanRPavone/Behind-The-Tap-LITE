class ReduceInventoryJob < ApplicationJob
  queue_as :default

  def perform(brew_id)
    brew = Brew.find(brew_id)
    company = brew.company

    ActiveRecord::Base.transaction do
      brew.recipe.recipe_ingredients.each do |recipe_ingredient|
        ingredient = recipe_ingredient.ingredient
        amount_used = recipe_ingredient.amount

        # Check for sufficient stock
        if ingredient.amount < amount_used
          notify_low_stock(company, ingredient)
          raise ActiveRecord::Rollback, "Insufficient stock for #{ingredient.name}."
        end

        # Deduct the inventory
        ingredient.update!(amount: ingredient.amount - amount_used)

        # Deduct from container stock if applicable
        containers_to_deduct = (amount_used / ingredient.lb_per_bag).ceil
        if ingredient.containers < containers_to_deduct
          notify_low_stock(company, ingredient)
          raise ActiveRecord::Rollback, "Insufficient containers for #{ingredient.name}."
        end

        ingredient.update!(containers: ingredient.containers - containers_to_deduct)
      end
    end
  rescue ActiveRecord::Rollback => e
    notify_job_failure(company, e.message)
    raise
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Brew with ID #{brew_id} not found.")
    notify_job_failure(company, "Brew not found: #{e.message}")
    raise
  end

  private

  def notify_low_stock(company, ingredient)
    InventoryMailer.low_stock_alert(company, ingredient).deliver_now
  end

  def notify_job_failure(company, error_message)
    InventoryMailer.job_failure_alert(company, error_message).deliver_now
  end
end

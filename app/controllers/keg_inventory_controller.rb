class KegInventoryController < ApplicationController
  before_action :set_company

  def index
    # Group owned kegs by recipe name and aggregate sizes
    grouped_owned_kegs = @company.kegs.includes(:recipe).group_by { |keg| keg.recipe.name }
  
    @owned_kegs = grouped_owned_kegs.map do |name, kegs|
      {
        recipe_name: name,
        recipe_id: kegs.first.recipe.id, # Use the first recipe's ID for linking
        keg_sizes: {
          'Full Barrels' => kegs.sum { |k| k.size == 15.5 ? 1 : 0 },
          'Half Barrels' => kegs.sum { |k| k.size == 7.75 ? 1 : 0 },
          'Sixtels' => kegs.sum { |k| k.size == 5.16 ? 1 : 0 }
        }
      }
    end
  
    # Ensure all recipes appear in owned kegs, even without kegs
    all_recipes = @company.recipes.pluck(:name).uniq
    @owned_kegs = all_recipes.map do |recipe_name|
      existing_keg_data = @owned_kegs.find { |data| data[:recipe_name] == recipe_name } || { keg_sizes: { 'Full Barrels' => 0, 'Half Barrels' => 0, 'Sixtels' => 0 } }
      {
        recipe_name: recipe_name,
        recipe_id: @company.recipes.find_by(name: recipe_name).id, # Use any recipe ID with this name
        keg_sizes: existing_keg_data[:keg_sizes]
      }
    end
  
    # Group shared kegs by recipe name and aggregate sizes (only recipes with shared kegs)
    grouped_shared_kegs = @company.kegs.where.not(shared_from: nil).includes(:recipe, :company).group_by { |keg| keg.recipe.name }
  
    @shared_kegs = grouped_shared_kegs.map do |name, kegs|
      {
        recipe_name: name,
        recipe_id: kegs.first.recipe.id, # Use the first recipe's ID for linking
        shared_from: kegs.first.company.name, # Assuming all kegs in this group are shared from the same company
        keg_sizes: {
          'Full Barrels' => kegs.sum { |k| k.size == 15.5 ? 1 : 0 },
          'Half Barrels' => kegs.sum { |k| k.size == 7.75 ? 1 : 0 },
          'Sixtels' => kegs.sum { |k| k.size == 5.16 ? 1 : 0 }
        }
      }
    end
  end

  def show
    @recipe = @company.recipes.find(params[:recipe_id])
  
    # Kegs owned by the company (not shared)
    @kegs = @recipe.kegs.where(company_id: @company.id, shared_from: nil)
  
    # Shared kegs grouped by size and the company they are shared with
    @shared_kegs = @recipe.kegs.where(shared_from: @company.id).group(:size, :company_id).count.map do |(size, company_id), quantity|
      {
        size: size,
        quantity: quantity,
        shared_with: Company.find(company_id).name
      }
    end
  
    # Keg sizes for owned kegs
    @keg_sizes = {
      'Full Barrel' => @kegs.where(size: 15.5).count,
      'Half Barrel' => @kegs.where(size: 7.75).count,
      'Sixtel' => @kegs.where(size: 5.16).count
    }
  
    # Partner companies for sharing
    @partner_companies = @company.partnerships.includes(:partner).map(&:partner)
  end

  def share
    recipe = @company.recipes.find(params[:recipe_id])
    partner_company = Company.find(params[:share_with])
    keg_size = params[:keg_size].to_f
    quantity = params[:quantity].to_i
  
    # Find available kegs of the specified size
    available_kegs = recipe.kegs.where(company_id: @company.id, size: keg_size, shared_from: nil).limit(quantity)
  
    if available_kegs.count < quantity
      flash[:alert] = "Not enough available kegs of size #{keg_size} to share."
      redirect_to keg_inventory_show_path(company_name: @company.slug, recipe_id: recipe.id) and return
    end
  
    # Share the kegs
    Keg.transaction do
      available_kegs.each do |keg|
        keg.update!(company_id: partner_company.id, shared_from: @company.id)
      end
    end
  
    flash[:notice] = "#{quantity} keg(s) of size #{keg_size} shared with #{partner_company.name}."
    redirect_to keg_inventory_show_path(company_name: @company.slug, recipe_id: recipe.id)
  end
  

  def create_share
    # Perform the sharing action
    @recipe = @company.recipes.find(params[:recipe_id])
    shared_company = Company.find(params[:shared_company_id])
    quantity = params[:quantity].to_i
    keg_size = params[:keg_size].to_f

    # Validate available kegs
    available_kegs = @recipe.kegs.where(size: keg_size, company_id: @company.id, shared_from: nil).limit(quantity)
    if available_kegs.size < quantity
      flash[:alert] = "Not enough kegs of size #{keg_size} gallons available for sharing."
      redirect_to keg_inventory_path and return
    end

    # Update kegs to reflect sharing
    Keg.transaction do
      available_kegs.each do |keg|
        keg.update!(company_id: shared_company.id, shared_from: @company.id)
      end
    end

    flash[:notice] = "#{quantity} keg(s) of size #{keg_size} gallons shared with #{shared_company.name}."
    redirect_to keg_inventory_path
  end

  private

  def set_company
    @company = Company.find_by!(slug: params[:company_name])
  end
end

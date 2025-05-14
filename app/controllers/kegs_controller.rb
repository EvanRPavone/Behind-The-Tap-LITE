class KegsController < ApplicationController
  before_action :set_recipe, only: [:show]

  # Index: Displays keg inventory grouped by recipe
  def index
    @recipes_with_kegs = Recipe.joins(brews: :kegs)
                               .distinct
                               .select('recipes.id, recipes.name')
                               .map do |recipe|
      {
        id: recipe.id, # Include the ID for the recipe
        name: recipe.name,
        total_kegs: recipe.brews.joins(:kegs).count,
        total_volume: recipe.brews.joins(:kegs).sum(:size),
        full_barrels: recipe.brews.joins(:kegs).where(kegs: { size: 15.5 }).count,
        half_barrels: recipe.brews.joins(:kegs).where(kegs: { size: 7.75 }).count,
        sixtels: recipe.brews.joins(:kegs).where(kegs: { size: 5.16 }).count
      }
    end
  end

  # Show: Displays details for kegs grouped by recipe
  def show
    @recipe = Recipe.find(params[:id]) # Ensure `id` matches the recipe ID
    @kegs = Keg.joins(:brew).where(brews: { recipe_id: @recipe.id })
    @full_barrels = @kegs.where(size: 15.5).count
    @half_barrels = @kegs.where(size: 7.75).count
    @sixtels = @kegs.where(size: 5.16).count
    @total_volume = @kegs.sum(&:size)
  end

  # Share kegs with partner companies
  def share
    recipe = Recipe.find(params[:recipe_id])
    company = Company.find(params[:company_id])
    quantity = params[:quantity].to_i
    keg_size = params[:keg_size].to_f

    # Validate if enough kegs are available for sharing
    kegs_to_share = recipe.kegs.where(size: keg_size, shared: false).limit(quantity)
    if kegs_to_share.count < quantity
      flash[:alert] = "Not enough available kegs of size #{keg_size} gallons to share."
      redirect_to keg_path(recipe.id) and return
    end

    # Share the kegs
    Keg.transaction do
      kegs_to_share.each do |keg|
        KegShare.create!(keg: keg, company: company)
        keg.update!(shared: true)
      end
    end

    flash[:notice] = "#{quantity} keg(s) of size #{keg_size} gallons shared with #{company.name}."
    redirect_to keg_path(recipe.id)
  end

  private

  def set_recipe
    @recipe = Recipe.find_by(name: params[:recipe_name])
    if @recipe.nil?
      flash[:alert] = "Recipe not found."
      redirect_to kegs_path(company_name: params[:company_name])
    end
  end
end

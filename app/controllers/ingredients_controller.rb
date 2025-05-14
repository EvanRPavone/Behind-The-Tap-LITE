class IngredientsController < ApplicationController
  before_action :set_company
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]

  def index
    @ingredients = @company.ingredients
    @ingredients_by_category = @ingredients.group_by(&:category).sort_by do |category, _|
      Ingredient::CATEGORIES.index(category) || Ingredient::CATEGORIES.length
    end
  end

  def new
    @ingredient = @company.ingredients.build
  end

  def create
    @ingredient = @company.ingredients.build(ingredient_params)
    @ingredient.total_weight = @ingredient.calculate_total_weight
    if @ingredient.save
      redirect_to ingredients_path(company_name: @company.slug), notice: 'Ingredient was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ingredient.update(ingredient_params.merge(total_weight: @ingredient.calculate_total_weight))
      redirect_to ingredients_path(company_name: @company.slug), notice: 'Ingredient was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to ingredients_path(company_name: @company.slug), notice: 'Ingredient was successfully deleted.'
  end

  private

  def set_ingredient
    @ingredient = @company.ingredients.find(params[:id])
  end

  def set_company
    @company = Company.friendly.find(params[:company_name])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :category, :amount, :type_of_unit, :weight_per_unit, :total_weight, :unit_of_measurement, :brand)
  end
end

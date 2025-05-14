class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_company

  # GET /recipes
  def index
    @grouped_recipes = @company.recipes.order(size_bbl: :asc).group_by(&:size_bbl)  # Group recipes by size_bbl
    @recipes = @company.recipes.order(size_bbl: :asc)

    respond_to do |format|
      format.html  # This will render the Haml view
      format.json { render json: @recipes }  # This will respond with JSON
    end
  end

  # GET /recipes/:id
  def show
    @sorted_ingredients = @recipe.recipe_ingredients.joins(:ingredient).merge(Ingredient.sorted_by_category)
    respond_to do |format|
      format.html  # This will render the Haml view
      format.json { render json: @recipe }  # This will respond with JSON
    end
  end

  # GET /recipes/new
  def new
    @recipe = @company.recipes.build
    @recipe.recipe_ingredients.build
  
    gon.ingredientsOptions = @company.ingredients.map do |ingredient|
      "<option value='#{ingredient.id}'>#{ingredient.display_name}</option>"
    end.join
  end

  # POST /recipes
  def create
    @recipe = @company.recipes.build(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_path(@company, @recipe), notice: 'recipe was successfully created.' }
        format.json { render json: @recipe, status: :created }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /recipes/:id/edit
  def edit
    @recipe = @company.recipes.find(params[:id])

    # Pass all ingredients without categorization
    gon.ingredientsOptions = @company.ingredients.map do |ingredient|
      "<option value='#{ingredient.id}'>#{ingredient.display_name}</option>"
    end.join

  end

  # PATCH/PUT /recipes/:id
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_path(@recipe.company, @recipe), notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/:id
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'recipe was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = @company.recipes.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :target_abv, :size_bbl, recipe_ingredients_attributes: [:id, :ingredient_id, :amount, :unit_of_measurement, :_destroy])
  end

  def set_company
    if params[:company_name]
      @company = Company.friendly.find(params[:company_name]) # Using friendly_id
    elsif params[:company_id]
      @company = Company.find(params[:company_id])  # Fallback to company_id
    end
  end
end

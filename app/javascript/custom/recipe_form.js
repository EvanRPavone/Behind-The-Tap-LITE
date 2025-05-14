// recipe_form.js

import TomSelect from 'tom-select';
import 'tom-select/dist/css/tom-select.css';

// Wait for Turbolinks to load the page before running the script
document.addEventListener('turbo:load', function () {
  console.log("Recipe Form JS loaded");

  // Check if the recipe form exists
  const recipeForm = document.querySelector('#ingredient-fields');
  if (!recipeForm) return; // Exit if the recipe form is not present on the page

  // Initialize TomSelect for existing ingredient dropdowns
  document.querySelectorAll('.ingredient-select').forEach(function (select) {
    new TomSelect(select, {
      create: false, // Disable creation of new options
    });
  });

  // Add Ingredient functionality
  document.getElementById('add-ingredient').addEventListener('click', function (e) {
    e.preventDefault();
    let ingredientIndex = document.querySelectorAll('#ingredient-fields .ingredient-group').length;

    let newIngredientField = `
      <div class="ingredient-group d-flex align-items-center mb-2">
        <input type="hidden" name="recipe[recipe_ingredients_attributes][${ingredientIndex}][_destroy]" value="false">
        <div class="w-50 pe-2">
          <select name="recipe[recipe_ingredients_attributes][${ingredientIndex}][ingredient_id]" class="form-control ingredient-select">
            ${gon.ingredientsOptions}
          </select>
        </div>
        <div class="w-25 pe-2">
          <input type="number" name="recipe[recipe_ingredients_attributes][${ingredientIndex}][amount]" step="0.01" class="form-control" placeholder="Amount">
        </div>
        <div class="w-25 pe-2">
          <select name="recipe[recipe_ingredients_attributes][${ingredientIndex}][unit_of_measurement]" class="form-select">
            <option value="" disabled selected>Select Unit</option>
            <option value="oz">oz</option>
            <option value="lbs">lbs</option>
            <option value="grams">grams</option>
            <option value="kg">kg</option>
            <option value="bbl">bbl</option>
            <option value="gallons">gallons</option>
          </select>
        </div>
        <div class="w-auto">
          <button type="button" class="remove-ingredient btn btn-outline-danger">Remove</button>
        </div>
      </div>`;

    // Insert the new ingredient field into the DOM
    document.getElementById('ingredient-fields').insertAdjacentHTML('beforeend', newIngredientField);

    // Initialize TomSelect for the new dropdown
    const newSelect = document.querySelector(`select[name="recipe[recipe_ingredients_attributes][${ingredientIndex}][ingredient_id]"]`);
    new TomSelect(newSelect, {
      create: false, // Disable creation of new options
    });
  });
  // Remove Ingredient
  recipeForm.addEventListener('click', function (e) {
    if (e.target.classList.contains('remove-ingredient')) {
      e.preventDefault();

      // Find the closest ingredient group
      const ingredientGroup = e.target.closest('.ingredient-group');
      if (ingredientGroup) {
        console.log("Marking ingredient group for destruction:", ingredientGroup);

        // Mark the hidden `_destroy` input for removal
        const destroyInput = ingredientGroup.querySelector('input[type="hidden"][name*="_destroy"]');
        if (destroyInput) {
          destroyInput.value = '1'; // Mark for destruction
        }
  
        // Apply styles to visually hide the ingredient group
        ingredientGroup.style.opacity = '0.5'; // Dim the group for clarity
        ingredientGroup.style.pointerEvents = 'none'; // Disable interaction
        ingredientGroup.style.display = 'none'; // Fully hide it visually (if required)
  
        // Optional: Add a `marked-for-removal` class for better debugging or styling
        ingredientGroup.classList.add('marked-for-removal');
      } else {
        console.error("Ingredient group not found for remove button.");
      }
    }
  });


});

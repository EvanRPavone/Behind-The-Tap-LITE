import TomSelect from 'tom-select';
import 'tom-select/dist/css/tom-select.css';

document.addEventListener('turbo:load', function() {
  console.log("Brew Form");

  // Initialize TomSelect for 'Recipe in Tank' and 'Vessel' only if they exist
  const recipeInTankElement = document.querySelector('#brew_in_tank');
  const vesselElement = document.querySelector('#brew_vessel_id');

  if (recipeInTankElement) {
    new TomSelect(recipeInTankElement, {
      placeholder: "Select a recipe",
      searchField: 'name',
      create: false, // Disable creating new entries
    });
  }

  if (vesselElement) {
    new TomSelect(vesselElement, {
      placeholder: "Select a vessel",
      searchField: 'name',
      create: false, // Disable creating new entries
    });
  }
});

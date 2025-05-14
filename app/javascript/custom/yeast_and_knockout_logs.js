import TomSelect from 'tom-select';
import 'tom-select/dist/css/tom-select.css';

document.addEventListener('turbo:load', function() {
  console.log("Yeast and Knockout Form/Logs");

  // Initialize TomSelect for 'Yeast' only if it exists
  const yeastElement = document.querySelector('#yeast_and_knockout_log_yeast_id');

  if (yeastElement) {
    new TomSelect(yeastElement, {
      placeholder: "Select a yeast",
      searchField: 'name',
      create: false, // Disable creating new entries
    });
  }
});

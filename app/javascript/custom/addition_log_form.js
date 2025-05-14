import TomSelect from 'tom-select';
import 'tom-select/dist/css/tom-select.css';

document.addEventListener('turbo:load', function() {
  console.log("Addition Log Form");

  // Initialize TomSelect for 'Hop Addition 1' and 'Hop Addition 2' only if they exist
  const hopAddition1Element = document.querySelector('#addition_log_hop_addition_1_id');
  const hopAddition2Element = document.querySelector('#addition_log_hop_addition_2_id');

  if (hopAddition1Element) {
    new TomSelect(hopAddition1Element, {
      placeholder: "Select a hop for addition 1",
      searchField: 'name',
      create: false, // Disable creating new entries
    });
  }

  if (hopAddition2Element) {
    new TomSelect(hopAddition2Element, {
      placeholder: "Select a hop for addition 2",
      searchField: 'name',
      create: false, // Disable creating new entries
    });
  }
});

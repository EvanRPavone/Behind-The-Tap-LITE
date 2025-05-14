import TomSelect from 'tom-select';
import 'tom-select/dist/css/tom-select.css';

document.addEventListener("turbo:load", function () {
  new TomSelect("#company_partner_ids", {
    plugins: ['remove_button'],  // Allows users to remove selected items
    maxItems: null,  // Allows unlimited selections
    create: false,  // Disables creating new entries
    persist: false,
    hideSelected: true,
  });
});

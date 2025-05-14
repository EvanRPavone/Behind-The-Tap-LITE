// app/javascript/application.js

// Core Dependencies
import * as Turbo from "@hotwired/turbo"; // Correct Turbo Import for ESBuild
// import Turbolinks from "turbolinks"; // Turbolinks
import "bootstrap"; // Bootstrap core
import "@popperjs/core"; // Popper.js (required by Bootstrap)
import $ from "jquery"; // jQuery
// import TomSelect from 'tom-select';
import 'tom-select/dist/css/tom-select.default.css'; // Import TomSelect CSS

// Global Styles
import "./stylesheets/application.scss"; // Custom SCSS styles
import "./stylesheets/styles.css"; // Additional custom styles
import "@fortawesome/fontawesome-free/css/all.css"; // Font Awesome icons

// SB Admin 2 Scripts
// import "./custom/scripts"; // Custom SB Admin scripts

// Custom JavaScript Files
import "./custom/recipe_form"; 
import "./custom/brew_form"; 
import "./custom/brew_calculations"; 
import "./custom/addition_log_form"; 
import "./custom/yeast_and_knockout_logs";
import "./custom/company_form";

// Initialize Turbo
window.Turbo = Turbo;

// Make jQuery Available Globally
window.$ = window.jQuery = $;

// Function to Initialize Modals
function initializeModals() {
  console.log("🔄 Initializing Bootstrap modals...");

  document.querySelectorAll('[data-bs-toggle="modal"]').forEach((trigger) => {
    trigger.addEventListener("click", (event) => {
      const targetModalId = trigger.getAttribute("data-bs-target");
      const modalEl = document.querySelector(targetModalId);

      if (modalEl) {
        const modalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
        modalInstance.show();
      } else {
        console.error("❌ Modal not found: " + targetModalId);
      }
    });
  });
}

// Function to Initialize Tooltips
function initializeTooltips() {
  console.log("🛠 Initializing tooltips...");
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach((tooltipTriggerEl) => {
    new bootstrap.Tooltip(tooltipTriggerEl, {
      delay: { show: 0, hide: 100 }, // Show immediately
    });
  });
}

// Initialize everything on Turbo page load
document.addEventListener("turbo:load", () => {
  console.log("🔥 Turbo page load detected, initializing scripts...");
  initializeModals();
  initializeTooltips();
});

// Also initialize on first page load (for non-Turbo pages)
// document.addEventListener("DOMContentLoaded", () => {
//   console.log("✅ DOMContentLoaded: Ensuring modals & tooltips work...");
//   initializeModals();
//   initializeTooltips();
// });

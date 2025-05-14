document.addEventListener('turbolinks:load', function () {
  const originalGravInput = document.getElementById('brew_original_grav');
  const ogIsInput = document.getElementById('brew_og_is');
  const intSgOutput = document.getElementById('brew_int_sg');
  const currentSgOutput = document.getElementById('brew_current_sg');
  const estAbvOutput = document.getElementById('brew_est_abv');

  function calculateValues() {
    const originalGrav = parseFloat(originalGravInput.value);
    const ogIs = parseFloat(ogIsInput.value);

    if (!isNaN(originalGrav)) {
      const intSg = 1 + (originalGrav / (258.6 - ((originalGrav / 258.2) * 227.1)));
      console.log("Int SG Output");
      intSgOutput.value = intSg.toFixed(4);
    } else {
      intSgOutput.value = '';
    }

    if (!isNaN(ogIs)) {
      const currentSg = 1 + (ogIs / (258.6 - ((ogIs / 258.2) * 227.1)));
      console.log("OG IS Output");
      currentSgOutput.value = currentSg.toFixed(4);
    } else {
      currentSgOutput.value = '';
    }

    if (!isNaN(originalGrav) && !isNaN(ogIs)) {
      const intSg = parseFloat(intSgOutput.value);
      const currentSg = parseFloat(currentSgOutput.value);
      const estAbv = (76.08 * (intSg - currentSg) / (1.775 - intSg)) * (currentSg / 0.74);
      console.log("Est ABV Output")
      estAbvOutput.value = estAbv.toFixed(2);
    } else {
      estAbvOutput.value = '';
    }
  }

  originalGravInput?.addEventListener('input', calculateValues);
  ogIsInput?.addEventListener('input', calculateValues);
});

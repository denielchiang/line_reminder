export const HeroJS = {
  mounted() {
    // Change the interval as per your preference
    let intervalMSec = 50;

    // general program animation
    let generalCount = document.getElementById('general-count');
    let genCount = 0;
    let targetGenCount = parseInt(generalCount.textContent);

    let intervalId = setInterval(function() {
      genCount++;
      generalCount.textContent = genCount;
      if (genCount === targetGenCount) {
        clearInterval(intervalId);
      }
    }, intervalMSec);
   

    // advanced program animation
    let advancedCount = document.getElementById('advanced-count');
    let advCount = 0;
    let targetAdvCount = parseInt(advancedCount.textContent);

    let intervalAdvId = setInterval(function() {
      advCount++;
      advancedCount.textContent = advCount;
      if (advCount === targetAdvCount) {
        clearInterval(intervalAdvId);
      }
    }, intervalMSec);
    
    // companion program animation
    let companionCount = document.getElementById('companion-count');
    let comCount = 0;
    let targetComCount = parseInt(companionCount.textContent);

    let intervalComId = setInterval(function() {
      comCount++;
      companionCount.textContent = comCount;
      if (comCount === targetComCount) {
        clearInterval(intervalComId);
      }
    }, intervalMSec);
  }
}

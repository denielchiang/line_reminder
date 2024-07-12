export const HeroJS = {
    mounted() {
        // Change the interval as per your preference
        let intervalMSec = 50;

        // general program animation
        let generalCount = document.getElementById('general-count');
        let genCount = 0;
        let targetGenCount = parseInt(generalCount.textContent);

        if (targetGenCount > 0) {
            let intervalId = setInterval(function() {
                genCount++;
                generalCount.textContent = genCount;
                if (genCount === targetGenCount) {
                    clearInterval(intervalId);
                }
            }, intervalMSec);
        }

        // advanced program animation
        let advancedCount = document.getElementById('advanced-count');
        let advCount = 0;
        let targetAdvCount = parseInt(advancedCount.textContent);

        if (targetAdvCount > 0) {
            let intervalAdvId = setInterval(function() {
                advCount++;
                advancedCount.textContent = advCount;
                if (advCount === targetAdvCount) {
                    clearInterval(intervalAdvId);
                }
            }, intervalMSec);
        }

        // companion program animation
        let companionCount = document.getElementById('companion-count');
        let comCount = 0;
        let targetComCount = parseInt(companionCount.textContent);

        if (targetComCount > 0) {
            let intervalComId = setInterval(function() {
                comCount++;
                companionCount.textContent = comCount;
                if (comCount === targetComCount) {
                    clearInterval(intervalComId);
                }
            }, intervalMSec);
        }

        // companion 2H program animation
        let companion2HCount = document.getElementById('companion2H-count');
        let com2HCount = 0;
        let targetCom2HCount = parseInt(companion2HCount.textContent);

        if (targetCom2HCount > 0) {
            let intervalCom2HId = setInterval(function() {
                com2HCount++;
                companion2HCount.textContent = com2HCount;
                if (com2HCount === targetCom2HCount) {
                    clearInterval(intervalCom2HId);
                }
            }, intervalMSec);
        }
    }
}

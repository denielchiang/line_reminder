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

        // companion 2h program animation
        let companion2hCount = document.getElementById('companion2h-count');
        let com2hCount = 0;
        let targetCom2hCount = parseInt(companion2hCount.textContent);

        if (targetCom2hCount > 0) {
            let intervalCom2hId = setInterval(function() {
                com2hCount++;
                companion2hCount.textContent = com2hCount;
                if (com2hCount === targetCom2hCount) {
                    clearInterval(intervalCom2hId);
                }
            }, intervalMSec);
        }
    }
}

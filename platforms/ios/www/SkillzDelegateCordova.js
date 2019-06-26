/* eslint-disable no-console */
class SkillzDelegateCordova {
    constructor() {
        this.matchInfo = null;
        this.gameManager = null;
    }
    
    // void
    static onMatchWillBegin(matchInfoString) {
        // This block of code will be called when the user is about to begin a match.
        // You can use this match object to instantiate variables in your game.
        const matchInfoObject = JSON.parse(matchInfoString);
        
        const message = 'SkillzDelegateCordova: onMatchWillBegin was called. Here is the match information: '.concat(
                                                                                                                     JSON.stringify(matchInfoObject));
        console.log(message);
        
        this.matchInfo = matchInfoObject;
        
        const launchSkillzButton = document.getElementById('launch-skillz-button');
        launchSkillzButton.style.display = 'none';
        
        const gameRoot = document.getElementById('game-root');
        gameRoot.style.visibility = 'visible';
        
        if (this.gameManager == null) {
            console.log("SkillzDelegateCordova : New'ing up a GameManager");
            this.gameManager = new GameManager(4, KeyboardInputManager, HTMLActuator, LocalStorageManager);
        }
        
        this.gameManager.restart();
    }
    
    // void
    static onSkillzWillExit() {
        // This block of code will be called when the user exits out of the Skillz UI.
        console.log('SkillzDelegateCordova: onSkillzWillExit was called');
    }
    
    static getMatchInfo() {
        return this.matchInfo;
    }
}

new SkillzDelegateCordova();

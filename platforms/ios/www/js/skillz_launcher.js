/* eslint-disable */
const SKILLZ_GAME_ID = '5602';
const SKILLZ_ENVIRONMENT = 'SkillzSandbox';

function SkillzLauncher(InputManager) {
    this.inputManager = new InputManager;
    this.inputManager.on("launchSkillz", this.launchSkillz.bind(this));
  }

  // Launch Skillz
  SkillzLauncher.prototype.launchSkillz = function () {
    // GC this instance, as GameManager will use another.
    this.inputManager = undefined;

    SkillzCordova.skillzInit(SKILLZ_GAME_ID, SKILLZ_ENVIRONMENT);
    SkillzCordova.launchSkillz();
};

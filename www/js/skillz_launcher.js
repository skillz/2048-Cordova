/* eslint-disable */
function SkillzLauncher(InputManager) {
    this.inputManager = new InputManager;
    this.inputManager.on("launchSkillz", this.launchSkillz.bind(this));
  }

  // Launch Skillz
  SkillzLauncher.prototype.launchSkillz = function () {
    window.alert('TODO: Launch Skillz');
    const launchSkillzButton = document.getElementById('launch-skillz-button');
    launchSkillzButton.style.visibility = 'collapse';

    // GC this instance, as GameManager will use another.
    this.inputManager = undefined;
  };
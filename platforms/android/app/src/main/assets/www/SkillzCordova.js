/* eslint-disable no-undef */
/* eslint-disable no-console */

class SkillzCordova {
  // void
  static skillzInit(gameId, environment) {
    const response = r => {
      console.debug('SkillzCordova init successfully: %s', r);
    };
    const error = e => {
      console.debug('SkillzCordova init failed: %s', e);
    };

    const initAndroidCallbacks = function setupAndroidCallbacks() {
      const onMatchWillBeginSuccess = matchId => {
        SkillzDelegateCordova.onMatchWillBegin(matchId);
      };
      window.cordova.exec(
        onMatchWillBeginSuccess,
        () => {},
        'SkillzCordova',
        'callOnMatchWillBegin'
      );

      const onSkillzWillExitSuccess = () => {
        SkillzDelegateCordova.onSkillzWillExit();
      };
      window.cordova.exec(
        onSkillzWillExitSuccess,
        () => {},
        'SkillzCordova',
        'callOnSkillzWillExit'
      );
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'skillzInit', [gameId, environment]);
    if (window.device.platform === 'Android') {
      initAndroidCallbacks();
    }
  }

  // void
  static launchSkillz() {
    const response = r => {
      console.log('SkillzCordova launched successfully: %s', r);
    };
    const error = e => {
      console.log('SkillzCordova launched failed: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'launchSkillz', []);
  }

  // boolean
  static isMatchInProgress(completion) {
    const response = isMatchInProgress => {
      const isMatchInProgressBool = isMatchInProgress === 1;
      console.log('SkillzCordova isMatchInProgress: %s', isMatchInProgressBool);
      completion(isMatchInProgressBool);
    };
    const error = e => {
      console.log('SkillzCordova failed to call isMatchInProgress: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'isMatchInProgress', []);
  }

  // void
  // score: number, matchId: number
  static reportScore(score, matchId) {
    const response = r => {
      console.log('SkillzCordova reported score successfully: %s', r);
    };
    const error = e => {
      console.log('SkillzCordova failed to call reportScore: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'reportScore', [score, matchId]);
  }

  // void
  // score: number, matchId: number
  static updatePlayersCurrentScore(score, matchId) {
    const response = r => {
      console.log('SkillzCordova updated score successfully: %s', r);
    };
    const error = e => {
      console.log('SkillzCordova failed to call updatePlayersCurrentScore: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'updatePlayersCurrentScore', [
      score,
      matchId
    ]);
  }

  // void
  // matchId: number
  static abortMatch(matchId) {
    const response = r => {
      console.log('SkillzCordova aborted match successfully: %s', r);
    };
    const error = e => {
      console.log('SkillzCordova failed to call abortMatch: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'abortMatch', [matchId]);
  }

  // JSONObject
  static getMatchRules(completion) {
    const response = matchRules => {
      console.log('SkillzCordova matchRules: %s', JSON.stringify(matchRules));
      completion(matchRules);
    };
    const error = e => {
      console.log('SkillzCordova failed to call getMatchRules: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'getMatchRules', []);
  }

  // JSONObject
  static getMatchInfo(completion) {
    const response = matchInfo => {
      console.log('SkillzCordova matchInfo: %s', JSON.stringify(matchInfo));
      completion(matchInfo);
    };
    const error = e => {
      console.log('SkillzCordova failed to call getMatchInfo: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'getMatchInfo', []);
  }

  // JSONObject
  static getCurrentPlayer(completion) {
    const response = currentPlayer => {
      console.log('SkillzCordova currentPlayer: %s', JSON.stringify(currentPlayer));
      completion(currentPlayer);
    };
    const error = e => {
      console.log('SkillzCordova failed to call getCurrentPlayer: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'getCurrentPlayer', []);
  }

  // void
  // metaDataJsonString: string, isMatchInProgress: boolean
  static addMetaDataForMatchInProgress(metaDataJsonString, isMatchInProgress) {
    const response = r => {
      console.log('SkillzCordova called addMetaDataForMatchInProgress successfully: %s', r);
    };
    const error = e => {
      console.log('SkillzCordova failed to call addMetaDataForMatchInProgress: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'addMetaDataForMatchInProgress', [
      metaDataJsonString,
      isMatchInProgress
    ]);
  }

  // string
  static getSDKVersion(completion) {
    const response = SDKVersion => {
      console.log('SkillzCordova SDKVersion: %s', SDKVersion);
      completion(SDKVersion);
    };
    const error = e => {
      console.log('SkillzCordova failed to call getSDKVersion: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'getSDKVersion', []);
  }

  // number
  static getRandomNumber(completion) {
    const response = randomNumJSONObject => {
      const randomNum = randomNumJSONObject.value;
      console.log('SkillzCordova randomNum: %s', randomNum);
      completion(randomNum);
    };
    const error = e => {
      console.log('SkillzCordova failed to call getRandomNumber: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'getRandomNumber', []);
  }

  // float
  static getRandomFloat(completion) {
    const response = randomFloatJSONObject => {
      const randomFloat = randomFloatJSONObject.value;
      console.log('SkillzCordova randomFloat: %s', randomFloat);
      completion(randomFloat);
    };
    const error = e => {
      console.log('SkillzCordova failed to call getRandomFloat: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'getRandomFloat', []);
  }

  // number
  // min: number, max: number
  static getRandomNumberWithRange(min, max, completion) {
    const response = randomNumJSONObject => {
      const randomNum = randomNumJSONObject.value;
      console.log('SkillzCordova randomNum: %d', randomNum);
      completion(randomNum);
    };
    const error = e => {
      console.log('SkillzCordova failed to call getRandomNumberWithRange: %s', e);
    };

    window.cordova.exec(response, error, 'SkillzCordova', 'getRandomNumberWithRange', [min, max]);
  }
}

// eslint-disable-next-line no-new
new SkillzCordova();

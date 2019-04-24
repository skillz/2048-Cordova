package com.skillz.skillzcordova;

import android.app.Activity;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import com.skillz.Skillz;
import com.skillz.SkillzPlayer;
import com.skillz.model.MatchInfo;
import com.skillz.util.SkillzRandom;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class SkillzCordova extends CordovaPlugin {
    private static CordovaWebView cordovaWebView = null;
    private static String onMatchWillBeginCallBackId = null;
    private static String onSkillzWillExitCallBackId = null;

    static final String LAUNCH_SKILLZ = "launchSkillz";
    static final String REPORT_SCORE = "reportScore";
    static final String ABORT_MATCH = "abortMatch";
    static final String IS_MATCH_IN_PROGRESS = "isMatchInProgress";
    static final String GET_RANDOM_NUMBER = "getRandomNumber";
    static final String GET_RANDOM_FLOAT = "getRandomFloat";
    static final String GET_RANDOM_NUMBER_WITH_RANGE = "getRandomNumberWithRange";
    static final String UPDATE_PLAYERS_CURRENT_SCORE = "updatePlayersCurrentScore";
    static final String GET_MATCH_RULES = "getMatchRules";
    static final String GET_MATCH_INFO = "getMatchInfo";
    static final String ADD_METADATA_FOR_MATCH_IN_PROGRESS = "addMetadataForMatchInProgress";
    static final String GET_SDK_VERSION = "getSDKVersion";
    static final String GET_CURRENT_PLAYER = "getCurrentPlayer";
    static final String SKILLZ_INIT = "skillzInit";
    static final String ON_MATCH_WILL_BEGIN = "callOnMatchWillBegin";
    static final String ON_SKILLZ_WILL_EXIT = "callOnSkillzWillExit";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Activity gameActivity = cordova.getActivity();
        switch(action) {
            case LAUNCH_SKILLZ:
                this.launchSkillz(gameActivity, callbackContext);
                return true;
            case REPORT_SCORE:
                this.reportScore(gameActivity, args, callbackContext);
                return true;
            case ABORT_MATCH:
                this.abortMatch(gameActivity, args, callbackContext);
                return true;
            case IS_MATCH_IN_PROGRESS:
                this.isMatchInProgress(callbackContext);
                return true;
            case GET_RANDOM_NUMBER:
                this.getRandomNumber(callbackContext);
                return true;
            case GET_RANDOM_FLOAT:
                this.getRandomFloat(callbackContext);
                return true;
            case GET_RANDOM_NUMBER_WITH_RANGE:
                this.getRandomNumberWithRange(args, callbackContext);
                return true;
            case UPDATE_PLAYERS_CURRENT_SCORE:
                this.updatePlayersCurrentScore(gameActivity, args, callbackContext);
                return true;
            case GET_MATCH_RULES:
                this.getMatchRules(callbackContext);
                return true;
            case GET_MATCH_INFO:
                this.getMatchInfo(gameActivity, callbackContext);
                return true;
            case ADD_METADATA_FOR_MATCH_IN_PROGRESS:
                this.addMetaDataForMatchInProgress(args.getString(0), args.getBoolean(1), callbackContext);
                return true;
            case GET_SDK_VERSION:
                this.getSDKVersion(callbackContext);
                return true;
            case GET_CURRENT_PLAYER:
                this.getCurrentPlayer(gameActivity, callbackContext);
                return true;
            case SKILLZ_INIT:
                this.skillzInit(gameActivity, args, callbackContext);
                return true;
            case ON_MATCH_WILL_BEGIN:
                this.setUpOnMatchWillBegin(callbackContext);
                return true;
            case ON_SKILLZ_WILL_EXIT:
                this.setUpOnSkillzWillExit(callbackContext);
                return true;
            default:
                return false;
        }
    }

    private void launchSkillz(Activity activity, CallbackContext callbackContext) {
        Skillz.launch(activity);
        callbackContext.success("Launched Skillz");
    }

    private void reportScore(Activity activity, JSONArray args, CallbackContext callbackContext) {
        try {
            BigDecimal bigDecScore = new BigDecimal(args.getDouble(0));
            String matchId = args.getString(1);
            Skillz.reportScore(activity, bigDecScore, matchId);
            callbackContext.success(bigDecScore.toString());
        } catch (JSONException e) {
            callbackContext.error("Missing score or match id argument");
        }
    }

    private void abortMatch(Activity activity, JSONArray args, CallbackContext callbackContext) {
        try {
            String matchId = args.getString(0);
            Skillz.abortMatch(activity, matchId);
            callbackContext.success("Skillz Match aborted");
        } catch (JSONException e) {
            callbackContext.error("Expected match id argument.");
        }
    }

    private void isMatchInProgress(CallbackContext callbackContext) {
        int isMatchInProgress = Skillz.isMatchInProgress() ? 1 : 0;
        callbackContext.success(isMatchInProgress);
    }

    private void getRandomNumber(CallbackContext callbackContext) {
        try {
            SkillzRandom rand = new SkillzRandom();
            JSONObject response = new JSONObject();
            response.put("value", rand.nextInt());
            callbackContext.success(response);
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error(e.getMessage());
        }
    }

    private void getRandomFloat(CallbackContext callbackContext) {
        try {
            SkillzRandom rand = new SkillzRandom();
            JSONObject response = new JSONObject();
            response.put("value", rand.nextFloat());
            callbackContext.success(response);
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error(e.getMessage());
        }
    }

    private void getRandomNumberWithRange(JSONArray args, CallbackContext callbackContext) {
        if (args.length() < 2) {
            callbackContext.error("Not enough arguments");
        } else {
            try {
                float min = (float) args.getDouble(0);
                float max = (float) args.getDouble(1);
                SkillzRandom rand = new SkillzRandom();
                float value = min + (rand.nextFloat() * (max - min));
                JSONObject response = new JSONObject();
                response.put("value", value);
                callbackContext.success(response);
            } catch(JSONException e) {
                e.printStackTrace();
                callbackContext.error(e.getMessage());
            }
        }
    }

    private void updatePlayersCurrentScore(Activity activity, JSONArray args, CallbackContext callbackContext) {
        try {
            BigDecimal bigDecScore = new BigDecimal(args.getDouble(0));
            String matchId = args.getString(1);
            Skillz.updatePlayersCurrentScore(activity, bigDecScore, matchId);
            callbackContext.success(bigDecScore.toString());
        } catch (JSONException e) {
            callbackContext.error("Expected match id argument.");
        }
    }

    private void getMatchRules(CallbackContext callbackContext) {
        Map<String, String> rules = Skillz.getMatchRules();
        JSONObject jsonFormattedRules = new JSONObject(rules);
        callbackContext.success(jsonFormattedRules);
    }

    private JSONObject matchToJson(MatchInfo match) throws JSONException {
        JSONObject object = new JSONObject();
        object.put("matchDescription", match.getMatchDescription());
        object.put("entryCash", match.getEntryCash());
        object.put("entryPoints", match.getEntryPoints());
        object.put("id", match.getId());
        object.put("templateId", match.getTemplateId());
        object.put("name", match.getName());
        object.put("isCash", match.isCash());
        object.put("isSynchronous", match.isSynchronous());
        object.put("skillzDifficulty", match.getSkillzDifficulty());
        object.put("players", match.getPlayers());
        return object;
    }

    private void getMatchInfo(Activity activity, CallbackContext callbackContext) {
        try {
            MatchInfo match = Skillz.getMatchInfo(activity);
            JSONObject jsonFormattedMatch = this.matchToJson(match);
            callbackContext.success(jsonFormattedMatch);
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error(e.getMessage());
        }
    }

    private void addMetaDataForMatchInProgress(String data, boolean isMatchInProgress, CallbackContext callbackContext) {
        try {
            HashMap<String, Object> attributes = new HashMap<>();
            JSONObject jsonData = new JSONObject(data);
            Iterator<String> keys = jsonData.keys();

            while (keys.hasNext()) {
                String key = keys.next();
                Object value = jsonData.get(key);

                attributes.put(key, value);
            }
            Skillz.addMetadataForMatchInProgress(attributes, isMatchInProgress);
            callbackContext.success("Skillz meta data added");
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Invalid format for meta data");
        }
    }

    private void getSDKVersion(CallbackContext callbackContext) {
        String sdkVersion = Skillz.SDKVersionShort();
        if (sdkVersion != null) {
            callbackContext.success(sdkVersion);
        } else {
            callbackContext.error("sdk version not found");
        }
    }

    private void getCurrentPlayer(Activity activity, CallbackContext callbackContext) {
        SkillzPlayer player = Skillz.getPlayerDetails(activity);
        try {
            JSONObject playerObject = new JSONObject();
            playerObject.put("id", player.getUserId());
            playerObject.put("displayName", player.getUserName());
            playerObject.put("avatarURL", player.getAvatarUrl());
            playerObject.put("flagURL", player.getFlagUrl());
            playerObject.put("playerMatchId", player.getPlayerMatchId());
            playerObject.put("isCurrentPlayer", player.isCurrentPlayer());
            callbackContext.success(playerObject);
        } catch (JSONException e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void skillzInit(Activity activity, JSONArray args, CallbackContext callbackContext) {
        if (args.length() < 2) {
            callbackContext.error("Missing gameId or environment argument");
            return;
        }

        try {
            String gameId = args.getString(0);
            String environment = args.getString(1);
            String isProduction;
            if (environment.equals("SkillzSandbox")) {
                isProduction = "false";
            } else if (environment.equals("SkillzProduction")) {
                isProduction = "true";
            } else {
                callbackContext.error("Wrong environment argument. Use SkillzSandbox or SkillzProduction");
                return;
            }
            Skillz.setCrossplatformGameId(activity, gameId);
            Skillz.setCrossplatformGameEnvironment(activity, isProduction);
            Skillz.setCordovaDelegate(activity, this);
            callbackContext.success("Skillz Initialized");
        } catch(Exception e) {
            callbackContext.error(e.getMessage());
        }
    }

    private void setStaticCordovaWebView() {
        if (SkillzCordova.cordovaWebView == null) {
            SkillzCordova.cordovaWebView = this.webView;
        }
    }

    private void setUpOnMatchWillBegin(CallbackContext callbackContext) {
        setStaticCordovaWebView();
        SkillzCordova.onMatchWillBeginCallBackId = callbackContext.getCallbackId();
    }

    private void setUpOnSkillzWillExit(CallbackContext callbackContext) {
        setStaticCordovaWebView();
        SkillzCordova.onSkillzWillExitCallBackId = callbackContext.getCallbackId();
    }

    public static void onMatchWillBegin(String matchId) {
        if (SkillzCordova.onMatchWillBeginCallBackId != null) {
            PluginResult result = new PluginResult(PluginResult.Status.OK, matchId);
            result.setKeepCallback(true);
            SkillzCordova.cordovaWebView.sendPluginResult(result, SkillzCordova.onMatchWillBeginCallBackId);
        }
    }

    public static void onSkillzWillExit() {
        if (SkillzCordova.onSkillzWillExitCallBackId != null) {
            PluginResult result = new PluginResult(PluginResult.Status.OK);
            result.setKeepCallback(true);
            SkillzCordova.cordovaWebView.sendPluginResult(result, SkillzCordova.onSkillzWillExitCallBackId);
        }
    }
}

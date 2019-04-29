//
//  SkillzCordova.h
//  SkillzCordova
//
//  Created by Gabriel Firmacion on 8/7/18.
//
//

#import <Cordova/CDVPlugin.h>
#import <Skillz/Skillz.h>

@interface SkillzCordova : CDVPlugin <SkillzDelegate>
- (void)skillzInit:(CDVInvokedUrlCommand *) command;
- (void)launchSkillz:(CDVInvokedUrlCommand *) command;
- (void)isMatchInProgress:(CDVInvokedUrlCommand *) command;
- (void)reportScore:(CDVInvokedUrlCommand *) command;
- (void)updatePlayersCurrentScore:(CDVInvokedUrlCommand *) command;
- (void)abortMatch:(CDVInvokedUrlCommand *) command;
- (void)getMatchRules:(CDVInvokedUrlCommand *) command;
- (void)getMatchInfo:(CDVInvokedUrlCommand *) command;
- (void)getCurrentPlayer:(CDVInvokedUrlCommand *) command;
- (void)addMetaDataForMatchInProgress:(CDVInvokedUrlCommand *) command;
- (void)getSDKVersion:(CDVInvokedUrlCommand *) command;
- (void)getRandomNumber:(CDVInvokedUrlCommand *) command;
- (void)getRandomFloat:(CDVInvokedUrlCommand *) command;
- (void)getRandomNumberWithRange:(CDVInvokedUrlCommand *) command;
@end

//
//  SkillzCordova.m
//  SkillzCordova
//
//  Created by Gabriel Firmacion on 8/7/18.
//
//
#import "SkillzCordova.h"
#import <Skillz/Skillz.h>

@implementation SkillzCordova

- (void)tournamentWillBegin:(NSDictionary *)gameParameters
              withMatchInfo:(SKZMatchInfo *)matchInfo
{
    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    NSString *gameParametersJsonString = [matchInfo performSelector:@selector(JSONStringRepresentation:)
                                                         withObject:gameParameters];

    #pragma GCC diagnostic pop
    NSString* jsString = [NSString stringWithFormat:@"SkillzDelegateCordova.onMatchWillBegin('%@');", gameParametersJsonString];
    [self.commandDelegate evalJs:jsString];
}

- (void)skillzWillExit
{
    [self.commandDelegate evalJs:@"SkillzDelegateCordova.onSkillzWillExit();"];
}

- (void)skillzInit:(CDVInvokedUrlCommand*) command
{
    NSArray *commandParams = command.arguments;
    if ([commandParams count] < 2) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing gameId or environment argument"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }

    NSString *gameId = [command.arguments objectAtIndex:0];
    if ([gameId isKindOfClass:[NSNull class]]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Expected gameId argument."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSString *environment = [commandParams objectAtIndex:1];
    if ([environment isKindOfClass:[NSNull class]]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Expected environment argument."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    SkillzEnvironment skillzEnvironment;
    if ([environment isEqualToString:@"SkillzSandbox"]) {
        skillzEnvironment = SkillzSandbox;
    } else if ([environment isEqualToString:@"SkillzProduction"]) {
        skillzEnvironment = SkillzProduction;
    } else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Wrong environment argument. Use SkillzSandbox or SkillzProduction"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [[Skillz skillzInstance] initWithGameId:gameId
                            forDelegate:self
                        withEnvironment:skillzEnvironment
                              allowExit:YES];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Skillz Initialized"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)launchSkillz:(CDVInvokedUrlCommand*) command
{
    [[Skillz skillzInstance] launchSkillz];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Launched Skillz"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)isMatchInProgress:(CDVInvokedUrlCommand*)command
{
    BOOL istournamentinProgress = [[Skillz skillzInstance] tournamentIsInProgress];
    int isTournamentInProgressInt = istournamentinProgress ? 1 : 0;
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:isTournamentInProgressInt];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)reportScore:(CDVInvokedUrlCommand*)command
{
    NSArray *commandParams = command.arguments;
    if ([commandParams count] < 2) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing score or match id argument"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }

    NSNumber *score = [commandParams objectAtIndex:0];
    if ([score isKindOfClass:[NSNull class]]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Expected score argument."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSNumber *matchId = [commandParams objectAtIndex:1];
    if ([matchId isKindOfClass:[NSNull class]]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Expected match id argument."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [[Skillz skillzInstance] displayTournamentResultsWithScore:score
                                                   withMatchId:matchId
                                                withCompletion:^{
                                                    // Code in this block is called when exiting to Skillz
                                                    // and reporting the score.You may need to call a JS function that resets the state of your game.
                                                    // e.g.
                                                    // NSString* jsString = [NSString stringWithFormat:@"resetGame(\"%@\");", @""];
                                                    // [self.webView stringByEvaluatingJavaScriptFromString:jsString];
                                                }];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Reported Score"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)updatePlayersCurrentScore:(CDVInvokedUrlCommand*)command
{
    NSArray *commandParams = command.arguments;
    if ([commandParams count] < 2) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing score or match id argument"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }

    NSNumber *score = [commandParams objectAtIndex:0];
    if ([score isKindOfClass:[NSNull class]]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Expected score argument."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSNumber *matchId = [commandParams objectAtIndex:1];
    if ([matchId isKindOfClass:[NSNull class]]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Expected match id argument."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [[Skillz skillzInstance] updatePlayersCurrentScore:score
                                           withMatchId:matchId];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Updated Score"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)abortMatch:(CDVInvokedUrlCommand*)command
{
    NSArray *commandParams = command.arguments;
    if ([commandParams count] < 1) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing match id argument"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }

    NSNumber *matchId = [commandParams objectAtIndex:0];
    if ([matchId isKindOfClass:[NSNull class]]) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Expected match id argument."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    [[Skillz skillzInstance] notifyPlayerAbortWithMatchId:matchId
                                           WithCompletion:^{
      // Code in this block is called when exiting to Skillz
      // and aborting the match.You may need to call a JS function that resets the state of your game.
      // e.g.
      // NSString* jsString = [NSString stringWithFormat:@"resetGame(\"%@\");", @""];
      // [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    }];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Skillz Match aborted"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getMatchRules:(CDVInvokedUrlCommand*)command
{
    NSDictionary *matchRules = [Skillz getMatchRules];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:matchRules];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getMatchInfo:(CDVInvokedUrlCommand*)command
{
    SKZMatchInfo *matchInfo = [[Skillz skillzInstance] getMatchInfo];
    NSArray *players = [self convertPlayersToReadableObjects:matchInfo.players];
    NSMutableDictionary *matchInfoDict = [[NSMutableDictionary alloc]initWithCapacity:9];
    if (![[NSNumber numberWithInt:(int)matchInfo.id] isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:[NSNumber numberWithInt:(int)matchInfo.id] forKey:@"id"];
    }

    if (![matchInfo.matchDescription isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:matchInfo.matchDescription forKey:@"matchDescription"];
    }

    if (![matchInfo.entryCash isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:matchInfo.entryCash forKey:@"entryCash"];
    }

    if (![matchInfo.entryPoints isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:matchInfo.entryPoints forKey:@"entryPoints"];
    }

    if (![[NSNumber numberWithBool:matchInfo.isCash]  isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:[NSNumber numberWithBool:matchInfo.isCash] forKey:@"isCash"];
    }

    if (![[NSNumber numberWithBool:matchInfo.isSynchronous] isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:[NSNumber numberWithBool:matchInfo.isSynchronous] forKey:@"isSynchronous"];
    }

    if (![matchInfo.name isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:matchInfo.name forKey:@"name"];
    }

    if (![players isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:players forKey:@"players"];
    }

    if (![matchInfo.templateId isKindOfClass:[NSNull class]]) {
      [matchInfoDict setObject:matchInfo.templateId forKey:@"templateId"];
    }

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:matchInfoDict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (NSArray*)convertPlayersToReadableObjects:(NSArray*)players
{
    NSMutableArray *playersArray = [NSMutableArray array];
    for (id player in players) {
      SKZPlayer *skzplayer = player;
      NSMutableDictionary *playerInfoDict = [[NSMutableDictionary alloc]initWithCapacity:6];

      if (![skzplayer.id isKindOfClass:[NSNull class]]) {
        [playerInfoDict setObject:skzplayer.id forKey:@"id"];
      }

      if (![skzplayer.playerMatchId isKindOfClass:[NSNull class]]) {
        [playerInfoDict setObject:skzplayer.playerMatchId forKey:@"playerMatchId"];
      }

      if (![[NSNumber numberWithBool:skzplayer.isCurrentPlayer] isKindOfClass:[NSNull class]]) {
        [playerInfoDict setObject:[NSNumber numberWithBool:skzplayer.isCurrentPlayer] forKey:@"isCurrentPlayer"];
      }

      if (![skzplayer.avatarURL isKindOfClass:[NSNull class]]) {
        [playerInfoDict setObject:skzplayer.avatarURL forKey:@"avatarURL"];
      }

      if (![skzplayer.displayName isKindOfClass:[NSNull class]]) {
        [playerInfoDict setObject:skzplayer.displayName forKey:@"displayName"];
      }

      if (![skzplayer.flagURL isKindOfClass:[NSNull class]]) {
        [playerInfoDict setObject:skzplayer.flagURL forKey:@"flagURL"];
      }

      [playersArray addObject:playerInfoDict];
    }

    return playersArray;
}

- (void)getCurrentPlayer:(CDVInvokedUrlCommand*)command
{
    SKZPlayer *currentPlayer = [Skillz player];
    NSMutableDictionary *currentPlayerDict = [[NSMutableDictionary alloc]initWithCapacity:6];
    if (![currentPlayer.id isKindOfClass:[NSNull class]]) {
      [currentPlayerDict setObject:currentPlayer.id forKey:@"id"];
    }

    if (![currentPlayer.playerMatchId isKindOfClass:[NSNull class]]) {
      SKZMatchInfo *matchInfo = [[Skillz skillzInstance] getMatchInfo];
      NSArray *players = [self convertPlayersToReadableObjects:matchInfo.players];
        NSString *currentPlayerMatchId;
        for (NSObject* player in players)
        {
            if ([player valueForKey:@"isCurrentPlayer"]) {
                currentPlayerMatchId = [NSString stringWithFormat:@"%@",[player valueForKey:@"playerMatchId"]];
            }
        }
      [currentPlayerDict setObject:currentPlayerMatchId forKey:@"playerMatchId"];
    }

    if (![[NSNumber numberWithBool:currentPlayer.isCurrentPlayer] isKindOfClass:[NSNull class]]) {
      [currentPlayerDict setObject:[NSNumber numberWithBool:currentPlayer.isCurrentPlayer] forKey:@"isCurrentPlayer"];
    }

    if (![currentPlayer.avatarURL isKindOfClass:[NSNull class]]) {
      [currentPlayerDict setObject:currentPlayer.avatarURL forKey:@"avatarURL"];
    }

    if (![currentPlayer.displayName isKindOfClass:[NSNull class]]) {
      [currentPlayerDict setObject:currentPlayer.displayName forKey:@"displayName"];
    }

    if (![currentPlayer.flagURL isKindOfClass:[NSNull class]]) {
      [currentPlayerDict setObject:currentPlayer.flagURL forKey:@"flagURL"];
    }

    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:currentPlayerDict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)addMetaDataForMatchInProgress:(CDVInvokedUrlCommand*)command
{
    NSString *metaDataString = [command.arguments objectAtIndex:0];
    BOOL isMatchInProgress = [command.arguments objectAtIndex:1];

    if ([metaDataString isKindOfClass:[NSNull class]]) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid format for meta data"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }

    NSError *jsonError;
    NSData *objectData = [metaDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *metaDataDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];

    [[Skillz skillzInstance] addMetadata:metaDataDict forMatchInProgress:isMatchInProgress];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Added meta data"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getSDKVersion:(CDVInvokedUrlCommand*)command
{
    NSString *sdkVersion = [Skillz SDKShortVersion];
    if ([sdkVersion isKindOfClass:[NSNull class]]) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"sdk version not found"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:sdkVersion];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getRandomNumber:(CDVInvokedUrlCommand *)command
{
    NSMutableDictionary *randomNumDict = [[NSMutableDictionary alloc]initWithCapacity:1];
    [randomNumDict setObject:[NSNumber numberWithInt:(int)[Skillz getRandomNumber]] forKey:@"value"];
    if ([[randomNumDict valueForKey:@"value"] isKindOfClass:[NSNull class]]) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"getRandomNumber failed"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:randomNumDict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getRandomFloat:(CDVInvokedUrlCommand *)command
{
    NSMutableDictionary *randomFloatDict = [[NSMutableDictionary alloc]initWithCapacity:1];
    [randomFloatDict setObject:[NSNumber numberWithFloat:(float)[Skillz getRandomFloat]] forKey:@"value"];
    if ([[randomFloatDict valueForKey:@"value"] isKindOfClass:[NSNull class]]) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"getRandomFloat failed"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:randomFloatDict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getRandomNumberWithRange:(CDVInvokedUrlCommand *)command
{
    NSUInteger min = [[command.arguments objectAtIndex:0] integerValue];
    NSUInteger max = [[command.arguments objectAtIndex:1] integerValue];
    NSUInteger randomNum = [Skillz getRandomNumberWithMin:min andMax:max];
    NSMutableDictionary *randomNumDict = [[NSMutableDictionary alloc]initWithCapacity:1];
    [randomNumDict setObject:[NSNumber numberWithUnsignedInteger:randomNum] forKey:@"value"];
    if ([[randomNumDict valueForKey:@"value"] isKindOfClass:[NSNull class]]) {
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"getRandomNumberWithRange failed"];
      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
      return;
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:randomNumDict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end

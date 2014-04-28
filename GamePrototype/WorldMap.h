//
//  WorldMap.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <AVFoundation/AVFoundation.h>
#import "GamePrototype.h"
#import "SceneBattle.h"
#import "CommonImports.h"
#import "SystemMapMovement.h"
#import "GameData.h"
#import "BattleResult.h"

@interface WorldMap : GPGameScene <SystemMapMovementDelegate>

// Audio player da música de fundo
@property AVAudioPlayer *bgMusicPlayer;

// Guara os resultados da última batalha que o jogador enfrentou
@property BattleResult *battleResult;

// Metodo que chama a cena de batalha
- (void)goToBattle:(int)sceneType battleConfig:(BattleConfig*)config;

@end
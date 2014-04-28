//
//  MyScene.h
//  GamePrototype
//

//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GameData.h"
#import "GamePrototype.h"
#import <AVFoundation/AVFoundation.h>
#import "BattleConfig.h"

@interface SceneBattle : GPGameScene

// Node do background
@property SKSpriteNode *background;

// Configurações desta batalha
@property BattleConfig *battleConfig;

// Audio player da música de fundo
@property AVAudioPlayer *bgMusicPlayer;

// Troca o tipo de cena da batalha
- (void)setSceneType:(int)sceneType;

@end
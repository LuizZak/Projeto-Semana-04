//
//  MyScene.h
//  GamePrototype
//

//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GamePrototype.h"
#import "WorldMap.h"
#import "GameData.h"

@interface SceneBattle : GPGameScene

@property SKSpriteNode *background;

// Audio player da música de fundo
@property AVAudioPlayer *bgMusicPlayer;

// Troca o tipo de cena da batalha
- (void)setSceneType:(int)sceneType;

@end
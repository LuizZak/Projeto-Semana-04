//
//  GameData.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 15/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorldMap;

#define KEY_PLAYER_MAX_HEALTH @"playerMaxHealth"
#define KEY_PLAYER_HEALTH @"playerHealth"
#define KEY_PLAYER_SPAWN_X @"playerSpawnX"
#define KEY_PLAYER_SPAWN_Y @"playerSpawnY"
#define KEY_PLAYER_LEVEL @"playerLevel"
#define KEY_PLAYER_EXP @"playerExperience"
#define KEY_PLAYER_SKILLS @"playerSkills"
#define KEY_BATTLE_RESULT @"battleResult"

@interface GameData : NSObject

+ (GameData *) gameData;

// Atributos da fases
@property WorldMap* world; // WorldMap

// Os dados do jogo
@property NSMutableDictionary *data;

// Salvar a fase
- (void)saveWorld:(WorldMap *)map; // WorldMap

@end
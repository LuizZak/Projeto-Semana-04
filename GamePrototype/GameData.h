//
//  GameData.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 15/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorldMap;

#define KEY_PLAYER_HEALTH @"playerHealth"
#define KEY_PLAYER_SPAWN_X @"playerSpawnX"
#define KEY_PLAYER_SPAWN_Y @"playerSpawnY"

@interface GameData : NSObject

+ (GameData *) gameData;

// Atributos da fases
@property WorldMap* world; // WorldMap

// Os dados do jogo
@property NSMutableDictionary *data;

// Reinicia os dados do jogo para os iniciais
- (void)resetGameData;

// Salvar a fase
- (void)saveWorld:(WorldMap *)map; // WorldMap

@end
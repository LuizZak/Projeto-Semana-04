//
//  GameData.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 15/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorldMap;

@interface GameData : NSObject

+ (GameData *) gameData;

// Salvar a fase
- (void)saveWorld:(WorldMap *)map; // WorldMap

// Atributos da fases
@property WorldMap* world; // WorldMap

@end
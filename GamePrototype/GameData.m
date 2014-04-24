//
//  GameData.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 15/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GameData.h"

@implementation GameData

// Cria o singleton
+ (GameData *) gameData
{
    static GameData *gameData = nil;
    if (!gameData)
    {
        gameData = [[super allocWithZone:nil] init];
    }
    return gameData;
}

// Nao deixa que ele crie outra variavel gamedata
+ (id)allocWithZone: (struct _NSZone *)zone
{
    return [self gameData];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.data = [NSMutableDictionary dictionary];
        
        [self resetGameData];
    }
    return self;
}

- (void)resetGameData
{
    [self.data setObject:[NSNumber numberWithFloat:200] forKey:KEY_PLAYER_HEALTH];
    [self.data setObject:[NSNumber numberWithInt:3] forKey:KEY_PLAYER_SPAWN_X];
    [self.data setObject:[NSNumber numberWithInt:25] forKey:KEY_PLAYER_SPAWN_Y];
    [self.data setObject:[NSNumber numberWithInt:1] forKey:KEY_PLAYER_LEVEL];
    [self.data setObject:[NSNumber numberWithInt:0] forKey:KEY_PLAYER_EXP];
    
    // Player spawn point
}

// Salvar a fase WorldMap
-(void)saveWorld:(WorldMap *)map
{
    self.world = map;
}

@end
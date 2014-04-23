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
        
    }
    return self;
}

// Salvar a fase WorldMap
-(void)saveWorld:(WorldMap *)map
{
    self.world = map;
}

@end
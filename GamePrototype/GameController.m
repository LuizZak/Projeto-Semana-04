//
//  GameController.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GameController.h"
#import "GameData.h"

@implementation GameController

+ (GameController *) gameController
{
    static GameController *gameController = nil;
    if (!gameController)
    {
        gameController = [[super allocWithZone:nil] init];
    }
    return gameController;
}

+ (id)allocWithZone: (struct _NSZone *)zone
{
    return [self gameController];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        observers = [NSMutableArray array];
    }
    return self;
}

- (void)addObserver:(id<GameControllerObserver>)observer
{
    [observers addObject:observer];
}

- (void)removeObserver:(id<GameControllerObserver>)observer
{
    [observers removeObject:observer];
}

// Dá uma quantidade de XP para o player
- (void)givePlayerXP:(int)xp
{
    // Soma o XP do player
    int currentXP = [[[GameData gameData].data objectForKey:KEY_PLAYER_EXP] intValue];
    
    currentXP += xp;
    
    // Seta o XP
    [[GameData gameData].data setObject:[NSNumber numberWithInt:currentXP] forKey:KEY_PLAYER_EXP];
    
    // Notifica os observers
    for (id<GameControllerObserver> observer in observers)
    {
        if([observer respondsToSelector:@selector(gameControllerDidWinXP:)])
        {
            [observer gameControllerDidWinXP:currentXP];
        }
    }
    
    [self checkForLevelUp];
}

// Checa se o jogador upou de nível
- (void)checkForLevelUp
{
    int currentXP = [[[GameData gameData].data objectForKey:KEY_PLAYER_EXP] intValue];
    int currentLevel = [[[GameData gameData].data objectForKey:KEY_PLAYER_LEVEL] intValue];
    
    int levelCount = 5;
    int xpLevels[] = { 0, 100, 200, 400, 800, 1200 };
    int nextLevel;
    
    // Checa se o nível mudou de índice
    for(nextLevel = 0; nextLevel < levelCount; nextLevel++)
    {
        if(xpLevels[nextLevel] > currentXP)
        {
            // Subtrai 1, pois o nível atual indicado pelo índice é o próximo inalcancável
            nextLevel--;
            break;
        }
    }
    
    if(currentLevel < nextLevel)
    {
        // Atualiza o nível
        [[GameData gameData].data setObject:[NSNumber numberWithInt:nextLevel] forKey:KEY_PLAYER_LEVEL];
        
        // Notifica os observers
        for (id<GameControllerObserver> observer in observers)
        {
            if([observer respondsToSelector:@selector(gameControllerDidWinLevel:newLevel:)])
            {
                [observer gameControllerDidWinLevel:currentLevel newLevel:nextLevel];
            }
        }
    }
}

@end
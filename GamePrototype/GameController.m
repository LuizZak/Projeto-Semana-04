//
//  GameController.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GameController.h"

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

// Dá uma qunatidade de XP para o player
- (void)givePlayerXP:(int)xp
{
    int[] xpLevels = { 100, 200, 400, 800, 1200 };
    
    
}

@end
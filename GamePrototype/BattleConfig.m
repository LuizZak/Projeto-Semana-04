//
//  BattleConfig.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 26/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "BattleConfig.h"

@implementation BattleConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.enemiesArray = [NSMutableArray array];
    }
    return self;
}

@end
//
//  ComponentBattleState.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 22/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentBattleState.h"

@implementation ComponentBattleState

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.canAttack = YES;
    }
    return self;
}

- (id)initWithProjectilePoint:(CGPoint)point
{
    self = [super init];
    if (self)
    {
        self.canAttack = YES;
        self.projectilePoint = point;
    }
    return self;
}

@end
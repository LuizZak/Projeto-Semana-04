//
//  BattleActionPhysicalAttack.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "BattleComponentDamage.h"

@implementation BattleComponentDamage

- (id)initWithDamage:(CGFloat)damage
{
    self = [super init];
    if (self)
    {
        self.damage = damage;
    }
    return self;
}

@end
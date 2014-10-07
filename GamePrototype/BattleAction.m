//
//  BattleAction.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "BattleAction.h"

@implementation BattleAction

- (instancetype)init
{
    self = [super initWithNode:nil];
    if (self)
    {
        self.actionCharge = 20;
        self.actionDuration = 4;
        self.actionTargetType = BattleActionTarget_Friendly;
    }
    return self;
}

@end
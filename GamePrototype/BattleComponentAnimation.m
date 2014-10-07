//
//  BattleComponentAnimation.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "BattleComponentAnimation.h"

@implementation BattleComponentAnimation

- (id)initWithAnimationName:(NSString *)animationName
{
    self = [super init];
    if (self)
    {
        self.animationName = animationName;
    }
    return self;
}

@end
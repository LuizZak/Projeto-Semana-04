//
//  SystemMApMovement.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMapMovement.h"
#import "ComponentMovement.h"

@implementation SystemMapMovement

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleComponent([ComponentMovement class]));
    }
    
    return self;
}

@end
//
//  DraggableAttackComponent.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentDraggableAttack.h"

@implementation ComponentDraggableAttack

- (id)initWithSkillCooldown:(float)skillCooldown
{
    self = [super init];
    if (self)
    {
        self.skillCooldown = skillCooldown;
    }
    return self;
}

@end
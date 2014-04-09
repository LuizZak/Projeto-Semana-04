//
//  DraggableAttackComponent.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentDraggableAttack.h"

@implementation ComponentDraggableAttack

<<<<<<< HEAD

- (id)initWithSkillCooldown:(float)skillCooldown damage:(float)damage
=======
- (id)initWithSkillCooldown:(float)skillCooldown
>>>>>>> FETCH_HEAD
{
    self = [super init];
    if (self)
    {
        self.skillCooldown = skillCooldown;
        self.damage = damage;
    }
    return self;
}

@end
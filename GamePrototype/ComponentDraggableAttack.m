//
//  DraggableAttackComponent.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentDraggableAttack.h"

@implementation ComponentDraggableAttack

- (id)initWithSkillCooldown:(float)skillCooldown damage:(float)damage skillType:(SkillType)skillType startEnabled:(BOOL)startEnabled
{
    self = [super init];
    if (self)
    {
        self.skillCooldown = skillCooldown;
        self.damage = damage;
        self.skillType = skillType;
        
        if(!startEnabled)
        {
            self.currentCooldown = skillCooldown;
        }
    }
    return self;
}

- (id)initWithSkillCooldown:(float)skillCooldown damage:(float)damage skillType:(SkillType)skillType skillName:(NSString *)skillName startEnabled:(BOOL)startEnabled
{
    self = [self initWithSkillCooldown:skillCooldown damage:damage skillType:skillType startEnabled:startEnabled];
    if (self)
    {
        self.skillName = skillName;
    }
    return self;
}

@end
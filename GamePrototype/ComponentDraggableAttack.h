//
//  DraggableAttackComponent.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

typedef enum {
    SkillMelee,
    SkillFireball
} SkillType;

@interface ComponentDraggableAttack : GPComponent

@property CGPoint startPoint;
@property float currentCooldown;
@property float skillCooldown;
@property float damage;

@property SkillType skillType;

- (id)initWithSkillCooldown:(float)skillCooldown damage:(float)damage skillType:(SkillType)skillType startEnabled:(BOOL)startEnabled;

@end
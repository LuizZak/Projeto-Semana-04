//
//  DraggableAttackComponent.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

@interface ComponentDraggableAttack : GPComponent

@property CGPoint startPoint;
@property float currentCooldown;
@property float skillCooldown;

- (id)initWithSkillCooldown:(float)skillCooldown;

@end
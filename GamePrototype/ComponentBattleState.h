//
//  ComponentBattleState.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 22/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

@interface ComponentBattleState : GPComponent

// Diz se a entidade pode atacar ou não
@property BOOL canAttack;

// Ponto em que o projétil sai da entidade
@property CGPoint projectilePoint;

- (id)initWithProjectilePoint:(CGPoint)point;

@end
//
//  BattleActionPhysicalAttack.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GamePrototype.h"

/// Describes a battle action that deals damage to a character
@interface BattleComponentDamage : GPComponent

/// The damage the skill will deal
@property CGFloat damage;

- (id)initWithDamage:(CGFloat)damage;

@end
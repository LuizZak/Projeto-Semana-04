//
//  BattleComponentAnimation.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

/// Specifies the use of an animation on a combatant during battle
@interface BattleComponentAnimation : GPComponent

/// The name of the aniation to perform
@property NSString *animationName;

- (id)initWithAnimationName:(NSString*)animationName;

@end
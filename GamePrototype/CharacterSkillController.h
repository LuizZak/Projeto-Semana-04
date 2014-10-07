//
//  CharacterSkillController.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterSkill.h"

/// Performs common tasks related to character skill such as deal with animation and cooldowns
@interface CharacterSkillController : NSObject

/// Returns the time interval for a given character skill
+ (NSTimeInterval)timeIntervalForSkill:(CharacterSkill*)skill;

/// Returns the required ammount of action charge for a given character skill
+ (CGFloat)actionChargeForSkill:(CharacterSkill*)skill;

/// Returns the name of the animation for a given character skill
+ (NSString*)animationForSkill:(CharacterSkill*)skill;

/// Returns the name of the resource image for a given character skill
+ (NSString*)imageForSkill:(CharacterSkill*)skill;

/// Returns the name of the resource image for a given character skill type
+ (NSString*)imageForSkillType:(CharacterSkillType)skillType;

@end
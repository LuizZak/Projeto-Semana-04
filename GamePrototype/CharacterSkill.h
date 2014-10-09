//
//  CharacterSkill.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleAction.h"

/// Specifies the type of a CharacterSkill object
typedef enum CharacterSkillTypeEnum {
    /// Defines the skill as a physical attack skill
    CharacterSkillTypeAttack,
    /// Defines the skill as a casting spell skill
    CharacterSkillTypeSpell
} CharacterSkillType;

/// Specifies a skill a character can use
@interface CharacterSkill : NSObject

/// The unique identifier for this skill
@property NSInteger skillId;

/// Defines the charge required to perform the skill
@property CGFloat skillCharge;
/// Defines the time to wait while the skill is performed
@property NSTimeInterval skillDuration;
/// Defines the damage for the skill
@property CGFloat damage;

/// Defines a friednly name for the skill
@property NSString *skillName;

/// Defines the type of this skill
@property CharacterSkillType skillType;

- (id)initWithSkillId:(NSInteger)skillId charge:(CGFloat)charge duration:(NSTimeInterval)duration damage:(CGFloat)damage skillType:(CharacterSkillType)skillType skillName:(NSString*)skillName;

/// Generates and returns a battle action based on the status of this CharacterSkill
- (BattleAction*)generateBattleAction;

@end


#define CS_FIREBALL_1_ID 0
#define CS_FIREBALL_2_ID 1
#define CS_FIREBALL_3_ID 2
#define CS_FIREBALL_4_ID 3
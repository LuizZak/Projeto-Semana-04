//
//  CharacterSkillController.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "CharacterSkillController.h"

@implementation CharacterSkillController

/// Returns the time interval for a given character skill
+ (NSTimeInterval)timeIntervalForSkill:(CharacterSkill*)skill
{
    switch (skill.skillId)
    {
        case CS_FIREBALL_1_ID:
        case CS_FIREBALL_2_ID:
        case CS_FIREBALL_3_ID:
        case CS_FIREBALL_4_ID:
            return 0.5;
            break;
        
        default:
            break;
    }
    
    return 0;
}

/// Returns the required ammount of action charge for a given character skill
+ (CGFloat)actionChargeForSkill:(CharacterSkill*)skill
{
    switch (skill.skillId)
    {
        case CS_FIREBALL_1_ID:
            return 20;
        case CS_FIREBALL_2_ID:
            return 40;
        case CS_FIREBALL_3_ID:
            return 60;
        case CS_FIREBALL_4_ID:
            return 80;
            break;
            
        default:
            return 10;
            break;
    }
}

/// Returns the name of the animation for a given character skill
+ (NSString*)animationForSkill:(CharacterSkill*)skill
{
    switch (skill.skillId)
    {
        case CS_FIREBALL_1_ID:
        case CS_FIREBALL_2_ID:
        case CS_FIREBALL_3_ID:
        case CS_FIREBALL_4_ID:
            return @"FIREBALL";
            break;
            
        default:
            break;
    }
    
    return @"";
}

/// Returns the name of the resource image for a given character skill
+ (NSString*)imageForSkill:(CharacterSkill*)skill
{
    switch (skill.skillId)
    {
        case CS_FIREBALL_1_ID:
            return @"actionIcon-Magic1";
        case CS_FIREBALL_2_ID:
            return @"actionIcon-Magic2";
        case CS_FIREBALL_3_ID:
            return @"actionIcon-Magic3";
        case CS_FIREBALL_4_ID:
            return @"actionIcon-Magic3";
            break;
            
        default:
            break;
    }
    
    return @"";
}

/// Returns the name of the resource image for a given character skill type
+ (NSString*)imageForSkillType:(CharacterSkillType)skillType
{
    switch (skillType)
    {
        case CharacterSkillTypeAttack:
            return @"actionIconAttack";
        case CharacterSkillTypeSpell:
            return @"actionIconMagic";
        
        default:
            break;
    }
    
    return @"";
}

@end
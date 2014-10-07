//
//  CharacterSkill.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 07/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "CharacterSkill.h"
#import "CharacterSkillController.h"

@implementation CharacterSkill

- (id)initWithSkillId:(NSInteger)skillId cooldown:(float)skillCooldown damage:(float)damage skillType:(CharacterSkillType)skillType skillName:(NSString *)skillName
{
    self = [super init];
    
    if(self)
    {
        self.skillId = skillId;
        self.skillCooldown = skillCooldown;
        self.damage = damage;
        self.skillType = skillType;
        self.skillName = skillName;
    }
    
    return self;
}

- (BattleAction*)generateBattleAction
{
    BattleAction *action = [[BattleAction alloc] init];
    
    [action addComponent:[[BattleComponentDamage alloc] initWithDamage:self.damage]];
    [action addComponent:[[BattleComponentAnimation alloc] initWithAnimationName:[CharacterSkillController animationForSkill:self]]];
    
    action.actionCharge = [CharacterSkillController actionChargeForSkill:self];
    action.actionDuration = [CharacterSkillController timeIntervalForSkill:self];
    action.actionId = self.skillId;
    
    action.actionIconTexture = [SKTexture textureWithImageNamed:[CharacterSkillController imageForSkill:self]];
    action.actionCategoryIconTexture = [SKTexture textureWithImageNamed:[CharacterSkillController imageForSkillType:self.skillType]];
    
    action.actionType = self.skillType == CharacterSkillTypeAttack ? ActionTypeAttack : ActionTypeSkill;
    
    if(self.skillType == CharacterSkillTypeAttack || self.skillType == CharacterSkillTypeSpell)
    {
        action.actionTargetType = BattleActionTarget_Enemy;
    }
    
    return action;
}

@end
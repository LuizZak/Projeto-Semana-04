//
//  BattleAction.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePrototype.h"
// Import the components to minimize the import on other files
#import "BattleComponentAnimation.h"
#import "BattleComponentDamage.h"

/// Specifies a type of an action on a BattleAction object
typedef enum BattleActionTypeEnum {
    /// Defines the action as a physical attack action
    ActionTypeAttack,
    /// Defines the action as a castable spell
    ActionTypeSkill,
    /// Defines the action as an item use
    ActionTypeItem
} BattleActionType;

/// Specifies the type of characters that can be targeted by a BattleAction
typedef NS_OPTIONS(NSUInteger, BattleActionTarget) {
    /// Specifies friendly targets
    BattleActionTarget_Friendly = 1 << 0,
    /// Specifies enemy targets
    BattleActionTarget_Enemy = 1 << 1
};

/// Represents an aciton that a character can take in battle
@interface BattleAction : GPEntity

/// The unique identifier for the action
@property NSInteger actionId;

/// The type of this action
@property BattleActionType actionType;

/// The texture to use when visually representing this action
@property SKTexture* actionIconTexture;

/// The texture to use when visually representing this action's category
@property SKTexture* actionCategoryIconTexture;

/// The source of this action
@property id actionSource;

/// The targer of this action
@property id actionTarget;

/// The type of characters that can be targeted by this action
@property BattleActionTarget actionTargetType;

/// The time interval to wait while performing this action
@property NSTimeInterval actionDuration;

/// The charge required to perform this action
@property CGFloat actionCharge;

@end
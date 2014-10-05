//
//  BattleAction.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Specifies a type of an action on a BattleAction object
typedef enum BattleActionTypeEnum {
    /// Defines the action as a physical attack action
    ActionTypeAttack,
    /// Defines the action as a castable spell
    ActionTypeSkill,
    /// Defines the action as an item use
    ActionTypeItem
} BattleActionType;

/// Represents an aciton that a character can take in battle
@interface BattleAction : NSObject

/// The unique identifier for the action
@property NSInteger actionId;

/// The type of this action
@property BattleActionType actionType;

/// The time interval to wait while performing this action
@property NSTimeInterval actionDuration;

/// The charge required to perform this action
@property CGFloat actionCharge;

@end
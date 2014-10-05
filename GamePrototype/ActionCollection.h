//
//  ActionCollection.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleAction.h"

/// Defines a collection of actions, stored in a mutable set
@interface ActionCollection : NSObject

/// The collection of actions
@property NSMutableArray *actionList;

/// Adds an action to this ActionCollection
- (void)addAction:(BattleAction*)action;

/// Removes an action from this ActionCollection
- (void)removeAction:(BattleAction*)action;

/// Clears this list of actions
- (void)clearList;

/// Returns a list of actions that match the given battle action type
- (NSMutableArray*)actionsForType:(BattleActionType)actionType;

@end
//
//  ActionQueueView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BattleAction.h"

/// Enum used to define the context of an action leaving the ActionQueueManager
typedef enum ActionQueueIconRemoveEnum {
    /// Specifies a context in which the action is being chosen to be performed
    ActionQueueIconRemove_ActionPerformed,
    /// Specifies a context in which the action is being canceled
    ActionQueueIconRemove_ActionCanceled
} ActionQueueIconRemove;

@class ActionQueueManager;
/// Represents a view that displays the contents of an ActionQueueManager
@interface ActionQueueView : SKNode

/// The action queue manager that owns this ActionQueueView
@property ActionQueueManager* actionQueueManager;

/// Action icons still pending on the queue
@property NSMutableArray *actionIcons;

/// Updates the contents of this ActionQueueView
- (void)updateQueueView:(NSTimeInterval)timestep;

/// Called to notify when a new battle action has been queued
- (void)viewQueueAction:(BattleAction*)action;

/// Called to notify when an action on the queue has been dequeued
- (void)viewDequeueAction:(BattleAction*)action context:(ActionQueueIconRemove)context;

@end
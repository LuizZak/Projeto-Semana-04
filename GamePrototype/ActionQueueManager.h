//
//  ActionQueueManager.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleAction.h"

@class ActionBarManager;
@class ActionQueueView;
/// Handles the queuing of actions
@interface ActionQueueManager : NSObject

/// A queue of actions
@property NSMutableArray *actionQueue;

/// The action bar that owns this ActionQueueManager
@property ActionBarManager *actionBarManager;

/// The view binded to this ActionQueueManager
@property ActionQueueView *actionQueueView;

/// Returns the length of the current action queue
@property (readonly) NSInteger queueLength;

/// Returns a value that represents the sum of the charges needed by all the actions on this ActionQueueManager
@property (readonly) CGFloat totalQueueCharge;

/// Updates this ActionQueueManager
- (void)update:(NSTimeInterval)timestep;

/// Queues an action on this ActionQueueManager
- (void)queue:(BattleAction*)action;

/// Dequeues and returns an action from this ActionQueueManager
- (BattleAction*)dequeue;

/// Returns the next action on this ActionQueueManager without dequeing it
- (BattleAction*)peek;

/// Returns whether the given battle can be queued
- (BOOL)canQueue:(BattleAction*)action;

/// Removes a given action from this ActionQueueManager
- (void)removeAction:(BattleAction*)action;

@end
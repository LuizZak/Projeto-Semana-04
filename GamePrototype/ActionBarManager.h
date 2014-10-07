//
//  ActionBarManager.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionRunner.h"
#import "ActionQueueManager.h"
#import "ActionRunTimer.h"
#import "ActionBarView.h"
#import "ActionQueueView.h"

/// Manages an action bar, being able to queue actions and charge a bar to perform them
@interface ActionBarManager : NSObject

/// The current charge of the bar
@property CGFloat charge;

/// The bar's total charge
@property CGFloat totalCharge;

/// The rate at which this ActionBarManager should replenish the charge
@property CGFloat chargeRate;

/// The last action that was run on this ActionBarView
@property BattleAction *lastAction;

/// Returns a value ranging from [0 - 1] that describes the percentage of the charge of this ActionBarManager
@property (readonly) CGFloat chargePercentage;

/// The action queue for this action bar manager
@property ActionQueueManager *actionQueueManager;

/// The view binded to this ActionBarManager
@property ActionBarView *actionBarView;

/// Delegate to be called 
@property id<ActionRunner> actionRunner;

/// Timer class used to count down on an action's runtime
@property ActionRunTimer *actionRunTimer;

/// Whether this action bar is paused and cannot recharge/disrcharge or perform actions
@property BOOL paused;

/// Updates this ActionBarManager
- (void)update:(NSTimeInterval)timestep;

/// Replenishes a portion of charge on this ActionBarManager
/// The method returns the actual charge replenished from the charge bar
- (CGFloat)replenishCharge:(CGFloat)charge;

/// Drains a set of the charge from ActionBarManager
/// The method returns the actual charge drained from the charge bar
- (CGFloat)drainCharge:(CGFloat)charge;

/// Performs a given action on this ActionBarManager
- (void)performAction:(BattleAction*)action;

/// Returns whether a given action can be performed on this ActionBarManager
- (BOOL)canPerformAction:(BattleAction*)action;

/// Removes all actions that are currently targeting a specific action target
- (void)clearActionsForTarget:(id)actionTarget;

@end
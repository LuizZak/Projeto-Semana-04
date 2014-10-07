//
//  ActionBarManager.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionBarManager.h"
#import "ActionBarView.h"

@implementation ActionBarManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.actionQueueManager = [[ActionQueueManager alloc] init];
        self.actionQueueManager.actionBarManager = self;
        self.actionRunTimer = [[ActionRunTimer alloc] init];
        
        self.chargeRate = 20;
        self.totalCharge = 100;
        
        self.actionBarView = [[ActionBarView alloc] initWithBarManager:self];
        
        self.paused = NO;
    }
    return self;
}

- (CGFloat)chargePercentage
{
    return self.charge / self.totalCharge;
}

- (void)update:(NSTimeInterval)timestep
{
    if(!self.paused)
    {
        // Replenish charge
        [self replenishCharge:self.chargeRate * timestep];
        
        [self.actionRunTimer update:timestep];
    }
    
    [self.actionQueueManager update:timestep];
    [self.actionBarView updateBarView:timestep];
}

/// Replenishes a portion of charge on this ActionBarManager
- (CGFloat)replenishCharge:(CGFloat)charge
{
    if(charge < 0 || self.actionRunTimer.isPerformingAction)
    {
        return 0;
    }
    
    CGFloat c = self.charge;
    
    self.charge = MIN(self.totalCharge, self.charge + charge);
    
    return self.charge - c;
}

/// Replenishes a portion of charge on this ActionBarManager
- (CGFloat)drainCharge:(CGFloat)charge
{
    if(charge < 0 || self.actionRunTimer.isPerformingAction)
    {
        return 0;
    }
    
    CGFloat c = self.charge;
    
    self.charge = MAX(0, self.charge - charge);
    
    return c - self.charge;
}

- (void)performAction:(BattleAction*)action
{
    if(![self canPerformAction:action])
    {
        return;
    }
    
    [self.actionRunTimer setTimer:action.actionDuration];
    [self.actionRunner performAction:action];
    
    self.lastAction = action;
    self.charge -= action.actionCharge;
}

/// Returns a BOOL value that states whether the action bar is currently accepting changes to the bar charge
- (BOOL)canChangeCharge
{
    return !self.actionRunTimer.isPerformingAction;
}

- (BOOL)canPerformAction:(BattleAction*)action
{
    // False case: Action charge is higher than available charge
    if(action.actionCharge > self.charge)
    {
        return NO;
    }
    
    // False case: There's an action currently being performed
    return !self.actionRunTimer.isPerformingAction;
}

/// Removes all actions that are currently targeting a specific action target
- (void)clearActionsForTarget:(id)actionTarget
{
    // Remove all actions that target this entity
    for (int i = 0; i < self.actionQueueManager.queueLength; i++)
    {
        if([self.actionQueueManager.actionQueue[i] actionTarget] == actionTarget)
        {
            [self.actionQueueManager removeAction:self.actionQueueManager.actionQueue[i]];
            i--;
        }
    }
}

@end
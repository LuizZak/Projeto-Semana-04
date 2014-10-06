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
        self.actionRunTimer = [[ActionRunTimer alloc] init];
        
        self.actionBarView = [[ActionBarView alloc] init];
        self.actionBarView.actionBarManager = self;
        
        self.chargeRate = 10;
        self.totalCharge = 100;
    }
    return self;
}

- (CGFloat)chargePercentage
{
    return self.charge / self.totalCharge;
}

- (void)update:(NSTimeInterval)timestep
{
    // Replenish charge
    [self replenishCharge:self.chargeRate * timestep];
    
    [self.actionRunTimer update:timestep];
    
    [self.actionQueueManager update:timestep];
    
    [self.actionBarView updateBarView:timestep];
}

/// Replenishes a portion of charge on this ActionBarManager
- (CGFloat)replenishCharge:(CGFloat)charge
{
    if(charge < 0)
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
    if(charge < 0)
    {
        return 0;
    }
    
    CGFloat c = self.charge;
    
    self.charge = MAX(0, self.charge - charge);
    
    return c - self.charge;
}

- (void)performAction:(BattleAction*)action
{
    if([self canPerformAction:action])
    {
        return;
    }
    
    [self.actionRunTimer setTimer:action.actionDuration];
    
    self.charge -= action.actionCharge;
}

/// Returns a BOOL value that states whether the action bar is currently accepting changes to the bar charge
- (BOOL)canChangeCharge
{
    return !self.actionRunTimer.isPerformingAction;
}

- (BOOL)canPerformAction:(BattleAction*)action
{
    return !self.actionRunTimer.isPerformingAction && self.charge >= action.actionCharge;
}

@end
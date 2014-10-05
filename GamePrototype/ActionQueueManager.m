//
//  ActionQueueManager.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionQueueManager.h"
#import "ActionBarManager.h"
#import "ActionQueueView.h"

@implementation ActionQueueManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.actionQueueView = [[ActionQueueView alloc] init];
        self.actionQueueView.actionQueueManager = self;
    }
    return self;
}

/// Returns the length of the current action queue
- (NSInteger)queueLength
{
    return self.actionQueue.count;
}

/// Returns a value that represents the sum of the charges needed by all the actions on this ActionQueueManager
- (CGFloat)totalQueueCharge
{
    CGFloat charge = 0;
    
    for (BattleAction *action in self.actionQueue)
    {
        charge += action.actionCharge;
    }
    
    return charge;
}


/// Updates this ActionQueueManager
- (void)update:(NSTimeInterval)timestep
{
    BattleAction *action = [self peek];
    
    if([self.actionBarManager canPerformAction:action])
    {
        [self.actionBarManager performAction:action];
    }
}

/// Queues an action on this ActionQueueManager
- (void)queue:(BattleAction*)action
{
    [self.actionQueue addObject:action];
}

/// Dequeues and returns an action from this ActionQueueManager
- (BattleAction*)dequeue
{
    BattleAction *action = self.actionQueue[0];
    
    [self.actionQueue removeObjectAtIndex:0];
    
    return action;
}

/// Returns the next action on this ActionQueueManager without dequeing it
- (BattleAction*)peek
{
    return self.actionQueue[0];
}

/// Returns whether the given battle can be queued
- (BOOL)canQueue:(BattleAction*)action
{
    return 0;
}

/// Returns
- (void)removeAction:(BattleAction*)action
{
    [self.actionQueue removeObject:action];
}

@end
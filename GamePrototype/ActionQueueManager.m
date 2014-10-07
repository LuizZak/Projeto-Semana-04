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
        self.actionQueue = [NSMutableArray array];
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
    
    if(action != nil && [self.actionBarManager canPerformAction:action])
    {
        [self dequeue];
        [self.actionBarManager performAction:action];
    }
    
    [self.actionQueueView updateQueueView:timestep];
}

/// Queues an action on this ActionQueueManager
- (void)queue:(BattleAction*)action
{
    if(![self canQueue:action])
    {
        return;
    }
    
    [self.actionQueue addObject:action];
    [self.actionQueueView viewQueueAction:action];
}

/// Dequeues and returns an action from this ActionQueueManager
- (BattleAction*)dequeue
{
    BattleAction *action = self.actionQueue[0];
    
    [self.actionQueue removeObjectAtIndex:0];
    [self.actionQueueView viewDequeueAction:action];
    
    return action;
}

/// Returns the next action on this ActionQueueManager without dequeing it
- (BattleAction*)peek
{
    return self.actionQueue.count == 0 ? nil : self.actionQueue[0];
}

/// Returns whether the given battle can be queued
- (BOOL)canQueue:(BattleAction*)action
{
    // False case: Total queue charge + action charge is larger than the total charge
    if(self.totalQueueCharge + action.actionCharge > self.actionBarManager.totalCharge)
    {
        return NO;
    }
    
    return YES;
}

/// Returns
- (void)removeAction:(BattleAction*)action
{
    [self.actionQueue removeObject:action];
    [self.actionQueueView viewDequeueAction:action];
}

@end
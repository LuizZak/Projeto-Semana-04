//
//  ActionQueueView.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionQueueView.h"
#import "ActionIconView.h"
#import "ActionQueueManager.h"
#import "ActionBarManager.h"

@implementation ActionQueueView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.actionIcons = [NSMutableArray array];
        
        [self initializeView];
    }
    return self;
}

- (void)initializeView
{
    self.position = CGPointMake(30, 130);
}

- (void)updateQueueView:(NSTimeInterval)timestep
{
    [self updateIcons];
}

/// Updates the battle action icons on this ActionQueueView
- (void)updateIcons
{
    // Accumulated X coordinate
    CGFloat x = 0;
    
    if(self.actionQueueManager.actionBarManager.actionRunTimer.isPerformingAction)
    {
        CGFloat animMod = 1 - self.actionQueueManager.actionBarManager.actionRunTimer.percentageDone;
        x += (self.actionQueueManager.actionBarManager.lastAction.actionCharge * animMod) / self.actionQueueManager.actionBarManager.totalCharge * self.actionQueueManager.actionBarManager.actionBarView.barWidth;
    }
    
    for (int i = 0; i < self.actionIcons.count; i++)
    {
        ActionIconView *view = self.actionIcons[i];
        CGFloat iconX = view.action.actionCharge / self.actionQueueManager.actionBarManager.totalCharge * self.actionQueueManager.actionBarManager.actionBarView.barWidth;
        x += iconX;
        
        [view setScale:0.5];
        view.position = CGPointMake(x, view.position.y);
    }
}

- (void)viewQueueAction:(BattleAction*)action
{
    ActionIconView *view = [[ActionIconView alloc] initWithAction:action];
    
    [view setOnTapped:^{
        if([self.actionQueueManager.actionQueue containsObject:action])
        {
            [self.actionQueueManager removeAction:action];
        }
    }];
    
    view.displayLabels = NO;
    [self.actionIcons addObject:view];
    [self addChild:view];
    
    [self updateIcons];
}

/// Called to notify when an action on the queue has been dequeued
- (void)viewDequeueAction:(BattleAction*)action context:(ActionQueueIconRemove)context;
{
    // Find the icon view that matches the action
    ActionIconView *view = [self actionIconViewForAction:action];
    
    if(view == nil)
        return;
    
    [view runAction:[self actionForActionQueueIconRemove:context] completion:^{
        [view removeFromParent];
    }];
    
    [self.actionIcons removeObject:view];
}

/// Returns an ActionIconView on this ActionQueueView that matches the passed BattleAction, or nil, if none was found
- (ActionIconView*)actionIconViewForAction:(BattleAction*)action
{
    for (ActionIconView *view in self.actionIcons)
    {
        if([view.action isEqual:action])
        {
            return view;
        }
    }
    
    return nil;
}

/// Creates an action for a type of ActionQueueIconRemove
- (SKAction*)actionForActionQueueIconRemove:(ActionQueueIconRemove)context
{
    NSTimeInterval animInterval = 0.2;
    SKAction *action = [SKAction waitForDuration:0];
    
    if(context == ActionQueueIconRemove_ActionPerformed)
    {
        action = [SKAction group:@[[SKAction moveByX:0 y:10 duration:animInterval], [SKAction fadeOutWithDuration:animInterval], [SKAction scaleBy:1.2 duration:animInterval]]];
    }
    else if(context == ActionQueueIconRemove_ActionCanceled)
    {
        action = [SKAction sequence:@[[SKAction moveByX:0 y:-3 duration:animInterval / 10], [SKAction group:@[[SKAction fadeOutWithDuration:animInterval], [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0]]]]];
    }
    
    return action;
}

@end
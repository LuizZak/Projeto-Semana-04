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

- (void)viewDequeueAction:(BattleAction*)action
{
    // Find the icon view that matches the action
    ActionIconView *view = [self actionIconViewForAction:action];
    [view removeFromParent];
    [self.actionIcons removeObject:view];
    
    [self updateIcons];
}

- (void)viewQueueAction:(BattleAction*)action
{
    ActionIconView *view = [[ActionIconView alloc] initWithAction:action];
    view.displayLabels = NO;
    [self.actionIcons addObject:view];
    [self addChild:view];
    
    [self updateIcons];
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

@end
//
//  ActionBarView.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionBarView.h"
#import "ActionBarManager.h"

/// Misc definitions
@interface ActionBarView ()
{
    /// The charge bar's background node
    SKSpriteNode *chargeBarBackgroundNode;
    /// The charge bar's fill node
    SKSpriteNode *chargeBarFillNode;
    /// The timer bar fill node
    SKSpriteNode *timeBarFillNode;
}

@end

/// Implementation
@implementation ActionBarView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        currentSceneSize = CGSizeZero;
        [self initializeView];
    }
    return self;
}

- (id)initWithBarManager:(ActionBarManager *)barManager
{
    self = [self init];
    if (self)
    {
        self.actionBarManager = barManager;
    }
    return self;
}

- (CGFloat)barWidth
{
    return currentSceneSize.width - 60;
}

- (void)initializeView
{
    chargeBarBackgroundNode = [[SKSpriteNode alloc] initWithColor:[[UIColor orangeColor] colorWithAlphaComponent:0.3] size:currentSceneSize];
    chargeBarFillNode = [[SKSpriteNode alloc] initWithColor:[UIColor orangeColor] size:currentSceneSize];
    timeBarFillNode = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:currentSceneSize];
    
    [self addChild:chargeBarBackgroundNode];
    [self addChild:chargeBarFillNode];
    [self addChild:timeBarFillNode];
    
    timeBarFillNode.hidden = YES;
}

- (void)updateBarView:(NSTimeInterval)timestep
{
    if(self.scene && !CGSizeEqualToSize(currentSceneSize, self.scene.size))
    {
        [self updateBarSize];
    }
    
    // Update the charge bar's scale
    chargeBarFillNode.xScale = self.actionBarManager.chargePercentage;
    
    timeBarFillNode.hidden = !self.actionBarManager.actionRunTimer.isPerformingAction;
    if(self.actionBarManager.actionRunTimer.isPerformingAction)
    {
        timeBarFillNode.position = CGPointMake(chargeBarFillNode.position.y + (chargeBarFillNode.size.width / chargeBarFillNode.xScale) * chargeBarFillNode.xScale, timeBarFillNode.position.y);
        timeBarFillNode.xScale = 1 - self.actionBarManager.actionRunTimer.percentageDone;
        timeBarFillNode.xScale *= (self.actionBarManager.lastAction.actionCharge / self.actionBarManager.totalCharge);
    }
}

- (void)updateBarSize
{
    currentSceneSize = self.scene.size;
    
    chargeBarBackgroundNode.size = CGSizeMake(currentSceneSize.width - 60, 60);
    chargeBarBackgroundNode.position = CGPointMake(30, 30);
    chargeBarBackgroundNode.anchorPoint = CGPointZero;
    
    chargeBarFillNode.size = CGSizeMake(currentSceneSize.width - 60, 60);
    chargeBarFillNode.position = CGPointMake(30, 30);
    chargeBarFillNode.anchorPoint = CGPointZero;
    
    timeBarFillNode.size = CGSizeMake(currentSceneSize.width - 60, 60);
    timeBarFillNode.position = CGPointMake(30, 30);
    timeBarFillNode.anchorPoint = CGPointZero;
}

@end
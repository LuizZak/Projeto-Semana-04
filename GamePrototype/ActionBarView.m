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
    /// The charge bar's frame
    SKSpriteNode *chargeBarFrame;
    /// The mask of the charge bar
    SKSpriteNode *chargeBarMask;
    /// The timer bar fill node
    SKSpriteNode *timeBarFillNode;
    /// The crop node used to trim the charge bar around the bar frame
    SKCropNode *chargeBarCropNode;
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
        sections = [NSMutableArray array];
        self.chargeBarSectionSize = 25;
    }
    return self;
}

- (id)initWithBarManager:(ActionBarManager *)barManager
{
    self = [self init];
    if (self)
    {
        self.actionBarManager = barManager;
        [self initializeView];
    }
    return self;
}

- (CGFloat)barWidth
{
    return currentSceneSize.width - 60;
}

- (void)initializeView
{
    chargeBarFrame = [[SKSpriteNode alloc] initWithImageNamed:@"commandBarFrame"];
    chargeBarFillNode = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithRed:255 / 255.0 green:198 / 255.0 blue:26 / 255.0 alpha:1] size:chargeBarFrame.size];
    chargeBarBackgroundNode = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithRed:78 / 255.0 green:75 / 255.0 blue:82 / 255.0 alpha:1] size:chargeBarFrame.size];
    chargeBarMask = [SKSpriteNode spriteNodeWithImageNamed:@"commandBarFillMask"];
    
    timeBarFillNode = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:chargeBarFrame.size];
    timeBarFillNode.hidden = YES;
    
    chargeBarCropNode = [SKCropNode node];
    chargeBarCropNode.maskNode = chargeBarMask;
    
    [self addChild:chargeBarCropNode];
    [self addChild:chargeBarFrame];
    [chargeBarCropNode addChild:chargeBarBackgroundNode];
    [chargeBarCropNode addChild:chargeBarFillNode];
    [chargeBarCropNode addChild:timeBarFillNode];
    
    [self createChargeBarSections];
}

/// Creates the charge bar sections
- (void)createChargeBarSections
{
    for (SKNode *node in sections)
    {
        [node removeFromParent];
    }
    
    sections = [NSMutableArray array];
    
    for (CGFloat step = 0; step < self.actionBarManager.totalCharge; step += self.chargeBarSectionSize)
    {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"commandBarSection"];
        node.position = CGPointMake(chargeBarFrame.size.width * (step / self.actionBarManager.totalCharge), 4);
        node.anchorPoint = CGPointMake(0.5, 0);
        
        [sections addObject:node];
        [chargeBarCropNode addChild:node];
    }
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
        timeBarFillNode.position = CGPointMake((chargeBarFillNode.size.width / chargeBarFillNode.xScale) * chargeBarFillNode.xScale, timeBarFillNode.position.y);
        timeBarFillNode.xScale = 1 - self.actionBarManager.actionRunTimer.percentageDone;
        timeBarFillNode.xScale *= (self.actionBarManager.lastAction.actionCharge / self.actionBarManager.totalCharge);
    }
}

- (void)updateBarSize
{
    currentSceneSize = self.scene.size;
    
    chargeBarBackgroundNode.position = CGPointMake(0, 0);
    chargeBarBackgroundNode.anchorPoint = CGPointZero;
    
    chargeBarFrame.position = CGPointMake(30, 30);
    chargeBarFrame.anchorPoint = CGPointZero;
    
    chargeBarCropNode.position = CGPointMake(30, 30);
    chargeBarMask.anchorPoint = CGPointZero;
    
    chargeBarFillNode.anchorPoint = CGPointZero;
    
    timeBarFillNode.anchorPoint = CGPointZero;
}

@end
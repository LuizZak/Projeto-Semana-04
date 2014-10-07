//
//  ActionIconView.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionIconView.h"

@implementation ActionIconView

- (id)initWithAction:(BattleAction *)action
{
    self = [super init];
    if (self)
    {
        self.enabled = YES;
        self.action = action;
        self.displayLabels = YES;
        self.userInteractionEnabled = YES;
        [self createIcon];
        [self createLabels];
        [self updateDisplay];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    [self updateDisplay];
}

- (void)update:(NSTimeInterval)timestep
{
    
}

/// Creates the display of this ActionIconView
- (void)createIcon
{
    self.iconBackground = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(60, 60)];
    
    [self addChild:self.iconBackground];
}

/// Creates the labels for this ActionIconView
- (void)createLabels
{
    lblCharge = [SKLabelNode labelNodeWithFontNamed:@"Avenir-Black"];
    lblCharge.text = [NSString stringWithFormat:@"%.0lf", self.action.actionCharge];
    lblCharge.position = CGPointMake(0, self.iconBackground.size.height / 2 + 3);
    lblCharge.fontColor = [UIColor orangeColor];
    lblCharge.fontSize = 25;
    [self addChild:lblCharge];
}

/// Updates the display of this ActionIconView
- (void)updateDisplay
{
    if(self.displayCategoryOnly)
    {
        self.iconBackground.texture = self.action.actionCategoryIconTexture;
    }
    else
    {
        self.iconBackground.texture = self.action.actionIconTexture;
    }
    
    lblCharge.hidden = self.displayCategoryOnly || !self.displayLabels;
    
    if(!self.enabled)
    {
        self.alpha = 0.5;
    }
    else
    {
        self.alpha = 1;
    }
}

- (void)setOnTapped:(ActionIconViewTapped)onTappedBlock
{
    self->onTapped = onTappedBlock;
}

- (void)setDisplayLabels:(BOOL)displayLabels
{
    self->_displayLabels = displayLabels;
    
    [self updateDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(onTapped != nil)
    {
        self->onTapped();
    }
}

@end
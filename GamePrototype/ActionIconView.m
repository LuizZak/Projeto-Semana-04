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
        self.action = action;
        [self updateDisplay];
    }
    return self;
}

/// Updates the display of this ActionIconView
- (void)updateDisplay
{
    self.iconBackground = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
    
    [self addChild:self.iconBackground];
}

@end
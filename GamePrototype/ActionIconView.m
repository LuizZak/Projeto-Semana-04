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
        self.userInteractionEnabled = YES;
        [self createIcon];
    }
    return self;
}

- (void)update:(NSTimeInterval)timestep
{
    
}

/// Updates the display of this ActionIconView
- (void)createIcon
{
    self.iconBackground = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(60, 60)];
    
    [self addChild:self.iconBackground];
}

- (void)setOnTapped:(ActionIconViewTapped)onTappedBlock
{
    self->onTapped = onTappedBlock;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(onTapped != nil)
    {
        self->onTapped();
    }
}

@end
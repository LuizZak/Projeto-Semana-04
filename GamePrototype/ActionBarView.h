//
//  ActionBarView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BattleAction.h"

@class ActionBarManager;
/// Represents a node that displays the action bar
@interface ActionBarView : SKNode
{
    /// The current size of this ActionBarView
    CGSize currentSceneSize;
}

/// The width of the bar to display on screen
@property (readonly) CGFloat barWidth;

/// The action bar manager that owns this ActionBarView
@property ActionBarManager *actionBarManager;

/// Initializes this ActionBarView with a given ActionBarManagher
- (id)initWithBarManager:(ActionBarManager*)barManager;

/// Updates this ActionBarView
- (void)updateBarView:(NSTimeInterval)timestep;

@end
//
//  ActionBarView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ActionBarManager.h"

/// Represents a node that displays the action bar
@interface ActionBarView : SKNode

/// The action bar manager that owns this ActionBarView
@property ActionBarManager *actionBarManager;

/// Updates this ActionBarView
- (void)updateBarView:(NSTimeInterval)timestep;

@end
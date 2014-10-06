//
//  ActionIconView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BattleAction.h"

/// Object utilized to display an action icon on the screen
@interface ActionIconView : SKNode

/// The action to load on this icon
@property BattleAction *action;

/// Whethe this ActionIconView is used to display the category of the battle action only
@property BOOL categoryDisplay;

/// The backgound image of the icon to display
@property SKSpriteNode *iconBackground;

/// The graphics of the icon to display
@property SKSpriteNode *iconContent;

/// Initializes this ActionIconView with a given action
- (id)initWithAction:(BattleAction*)action;

@end
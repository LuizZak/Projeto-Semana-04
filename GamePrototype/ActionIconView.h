//
//  ActionIconView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BattleAction.h"

typedef void(^ActionIconViewTapped)(void);

/// Object utilized to display an action icon on the screen
@interface ActionIconView : SKNode
{
    /// Block called whenever the action view has been tapped
    ActionIconViewTapped onTapped;
    
    /// Label used to display the needed charge for this action
    SKLabelNode *lblCharge;
}

/// The action to load on this icon
@property BattleAction *action;

/// Specifies whether this ActionIconView is currently enabled
@property (nonatomic) BOOL enabled;

/// Whether this ActionIconView is used to display the category of the battle action only
@property BOOL displayCategoryOnly;

/// Whether to display the labels binded on this ActionIconView
@property (nonatomic) BOOL displayLabels;

/// The backgound image of the icon to display
@property SKSpriteNode *iconBackground;

/// The graphics of the icon to display
@property SKSpriteNode *iconContent;

/// Initializes this ActionIconView with a given action
- (id)initWithAction:(BattleAction*)action;

/// Block called whenever the action view has been tapped
- (void)setOnTapped:(ActionIconViewTapped)onTapped;

@end
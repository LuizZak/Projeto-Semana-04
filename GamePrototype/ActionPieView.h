//
//  ActionPieView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ActionCollection.h"
#import "ActionBarManager.h"
#import "ActionIconView.h"
#import "ActionPieContainerView.h"
#import "GPGameScene.h"

/// Pie view used to display a collection of actions on top of a point
@interface ActionPieView : SKNode <GPGameSceneNotifier>
{
    /// Whether this ActionPieView is currently in the process of closing itself
    BOOL closing;
}

/// The source of this ActionPieView
@property id actionSource;

/// The target of this ActionPieView
@property id actionTarget;

/// The target node to point of this ActionPieView
@property SKNode *target;

/// The container for the items of this ActionPieView
@property ActionPieContainerView *container;

/// The orientation to display this ActionPieMenu
@property ActionPieViewMenuOrientation orientation;

/// The action collection associated with this ActionPieView
@property ActionCollection *actionCollection;

/// Whether to allow this ActionPieView to organize the actions into categories that are displayed in sub-menus
@property BOOL displayCategoriesOnly;

/// A reference to the action bar manager to perform actions
@property ActionBarManager *actionBarManager;

/// Initializes this ActionPieView with a given ActionCollection
- (id)initWithActionCollection:(ActionCollection*)collection;

/// Updates this pie menu
- (void)update:(NSTimeInterval)timestep;

/// Opens this menu with a given orientation at a given point
- (void)open:(ActionPieViewMenuOrientation)orientation onNode:(SKNode*)node atPoint:(CGPoint)point;

/// Called by the ActionPieContainerView to notify when the user has tapped an item
- (void)actionTapped:(ActionIconView*)icon;

/// Closes this menu and all children menus opened on this ActionPieView
- (void)close;

@end
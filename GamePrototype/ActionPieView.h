//
//  ActionPieView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ActionCollection.h"
#import "GPGameScene.h"

/// Describes the orientation of an ActionPieView
typedef enum ActionPieViewMenuOrientationEnum {
    /// Automatically chooses the orientation to display the ActionPieMenu
    ActionPieViewMenuOrientationAuto,
    /// Specifies that a menu is pointing up
    ActionPieViewMenuOrientationTop,
    /// Specifies that a menu is pointing left
    ActionPieViewMenuOrientationLeft,
    /// Specifies that a menu is pointing bottom
    ActionPieViewMenuOrientationBottom,
    /// Specifies that a menu is pointing right
    ActionPieViewMenuOrientationRight
} ActionPieViewMenuOrientation;

/// Pie view used to display a collection of actions on top of a point
@interface ActionPieView : SKNode <GPGameSceneNotifier>
{
    /// Whether this ActionPieView is currently in the process of closing itself
    BOOL closing;
}

/// The target of this ActionPieView
@property SKNode *target;

/// The radius of the pie menu
@property CGFloat pieRadius;

/// The radius to layout the items of the pie menu on, in degrees
@property CGFloat arcRadius;

/// Whether to allow this ActionPieView to organize the actions into categories that are displayed in sub-menus
@property BOOL organizeCategories;

/// The action collection associated with this ActionPieView
@property ActionCollection *actionCollection;

/// A reference to the parent menu of this ActionPieMenu, when available
@property (weak) ActionPieView *parentMenu;

/// A reference to the child menu of this ActionPieMenu, when available
@property ActionPieView *childMenu;

/// The orientation to display this ActionPieMenu
@property ActionPieViewMenuOrientation orientation;

/// Initializes this ActionPieView with a given ActionCollection
- (id)initWithActionCollection:(ActionCollection*)collection;

/// Opens this menu with a given orientation at a given point
- (void)open:(ActionPieViewMenuOrientation)orientation onNode:(SKNode*)node atPoint:(CGPoint)point;

/// Closes this menu and all children menus opened on this ActionPieView
- (void)close;

/// Called whenever the first immediate child of this ActionPieView has closed itself
- (void)childClosed;

/// Opens up a submenu on this ActionPieMenu on a given item index
- (void)openSubMenu:(ActionCollection*)collection onIndex:(NSInteger)index;

@end
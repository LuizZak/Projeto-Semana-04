//
//  ActionPieContainerView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 06/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ActionCollection.h"
#import "ActionIconView.h"

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

@class ActionPieView;
@interface ActionPieContainerView : SKNode
{
    /// The icons for the individual actions
    NSMutableArray *actionIcons;
}

/// The action pie that owns this ActionPieContainerView
@property ActionPieView *actionPieOwner;

/// The radius of the pie menu
@property CGFloat pieRadius;

/// The radius to layout the items of the pie menu on, in degrees
@property CGFloat arcRadius;

/// The offset angle to apply to the arc
@property CGFloat modAngle;

/// The orientation to display this ActionPieMenu
@property ActionPieViewMenuOrientation orientation;

/// The action collection associated with this ActionPieView
@property ActionCollection *actionCollection;

/// Whether to allow this ActionPieContainerView to organize the actions into categories that are displayed in sub-menus
@property BOOL displayCategoriesOnly;

/// A reference to the parent menu of this ActionPieContainerView, when available
@property (weak) ActionPieContainerView *parentMenu;
/// A reference to the child menu of this ActionPieContainerView, when available
@property ActionPieContainerView *childMenu;
/// The index of the menu item that opened the child item
@property NSInteger childIndex;

/// Initializes this ActionPieContainerView with a given collection of actions
- (id)initWithActionCollection:(ActionCollection*)collection;

/// Initializes this ActionPieContainerView
- (void)initialize;

/// Opens this menu with a given orientation at a given point
- (void)open:(ActionPieViewMenuOrientation)orientation onNode:(SKNode*)node atPoint:(CGPoint)point;

/// Called when an action has been tapped
- (void)tappedAction:(ActionIconView*)action;

/// Closes this menu and all children menus opened on this ActionPieView
- (void)close;

/// Called whenever the first immediate child of this ActionPieView has closed itself
- (void)childClosed;

/// Opens up a submenu on this ActionPieMenu on a given item index
- (void)openSubMenu:(ActionCollection*)collection onIndex:(NSInteger)index;

/// Returns the angle for the given icon
- (CGFloat)angleForIcon:(ActionIconView*)icon;

@end
//
//  ActionPieContainerView.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 06/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionPieContainerView.h"
#import "ActionBarView.h"
#import "ActionPieView.h"

@implementation ActionPieContainerView

- (id)initWithActionCollection:(ActionCollection *)collection
{
    self = [super init];
    if (self)
    {
        self.arcRadius = 160;
        self.pieRadius = 120;
        self.actionCollection = collection;
    }
    return self;
}

- (void)close
{
    [self removeFromParent];
    
    if(self.parentMenu)
    {
        [self.parentMenu childClosed];
        self.parentMenu = nil;
    }
}

- (void)childClosed
{
    self.childMenu = nil;
}

- (void)tappedAction:(ActionIconView *)action
{
    // Category button - open the category
    if(action.displayCategoryOnly)
    {
        // Close any child menus
        [self.childMenu close];
        
        [self.actionPieOwner openSubMenu:[self.actionCollection actionsForType:action.action.actionType] onActionContainer:self];
        //[self openSubMenu:[self.actionCollection actionsForType:action.action.actionType] onIndex:[actionIcons indexOfObject:action]];
        
        return;
    }
    
    [self.actionPieOwner actionTapped:action];
}

- (void)initialize
{
    [self createIcons];
}

// Private members
- (void)createIcons
{
    // List of icons to display
    NSMutableArray *iconsArray = [self getActionIconViewList];
    actionIcons = iconsArray;
    
    for (int i = 0; i < iconsArray.count; i++)
    {
        CGFloat iconAngle = [self angleForIcon:iconsArray[i]];
        
        CGPoint point = CGPointMake(cos(iconAngle * (M_PI / 180)) * self.pieRadius, sin(iconAngle * (M_PI / 180)) * self.pieRadius);
        
        ActionIconView *node = iconsArray[i];
        node.position = point;
        node.zPosition = self.zPosition + 10;
        
        node.onTapped = ^{
            [self tapActionAtIndex:i];
        };
        
        [self addChild:node];
    }
}

- (void)tapActionAtIndex:(int)index
{
    [self.actionPieOwner actionTapped:actionIcons[index]];
}

- (CGFloat)angleForIcon:(ActionIconView*)icon
{
    NSInteger index = [actionIcons indexOfObject:icon];
    
    // Calculate the angles now
    CGFloat startAngle = 0;
    
    switch (self.orientation) {
        case ActionPieViewMenuOrientationBottom:
            startAngle = -90;
            break;
        case ActionPieViewMenuOrientationLeft:
            startAngle = 180;
            break;
        case ActionPieViewMenuOrientationRight:
            startAngle = 0;
            break;
        case ActionPieViewMenuOrientationTop:
            startAngle = 90;
        default:
            startAngle = 0;
            break;
    }
    
    startAngle += self.modAngle;
    startAngle -= self.arcRadius / 2;
    CGFloat stepAngle = self.arcRadius / actionIcons.count;
    
    return startAngle + stepAngle * index + stepAngle / 2;
}

/// Returns a list of ActionIconView items that represent the icons to display on this ActionPieView
- (NSMutableArray*)getActionIconViewList
{
    NSMutableArray *iconsArray = [NSMutableArray array];
    
    if(self.actionCollection.actionList.count == 0)
    {
        return iconsArray;
    }
    
    if(self.displayCategoriesOnly)
    {
        BOOL hasAttack = NO;
        BOOL hasSkill = NO;
        BOOL hasItems = NO;
        
        for (BattleAction *action in self.actionCollection.actionList)
        {
            switch(action.actionType)
            {
                case ActionTypeAttack:
                    hasAttack = YES;
                    break;
                case ActionTypeItem:
                    hasItems = YES;
                    break;
                case ActionTypeSkill:
                    hasSkill = YES;
                    break;
            }
        }
        
        // Now, create an icon view for each item
        if(hasSkill)
        {
            BattleAction *dummy = [[BattleAction alloc] init]; dummy.actionType = ActionTypeSkill;
            
            ActionIconView *icon = [[ActionIconView alloc] initWithAction:dummy];
            icon.displayCategoryOnly = YES;
            
            [iconsArray addObject:icon];
        }
        if(hasAttack)
        {
            BattleAction *dummy = [[BattleAction alloc] init]; dummy.actionType = ActionTypeAttack;
            
            ActionIconView *icon = [[ActionIconView alloc] initWithAction:dummy];
            icon.displayCategoryOnly = YES;
            
            [iconsArray addObject:icon];
        }
        if(hasItems)
        {
            BattleAction *dummy = [[BattleAction alloc] init]; dummy.actionType = ActionTypeItem;
            
            ActionIconView *icon = [[ActionIconView alloc] initWithAction:dummy];
            icon.displayCategoryOnly = YES;
            
            [iconsArray addObject:icon];
        }
    }
    else
    {
        for (BattleAction *action in self.actionCollection.actionList)
        {
            ActionIconView *icon = [[ActionIconView alloc] initWithAction:action];
            [iconsArray addObject:icon];
        }
    }
    
    return iconsArray;
}

@end
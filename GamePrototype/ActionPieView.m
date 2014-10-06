//
//  ActionPieView.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionPieView.h"
#import "ActionIconView.h"

@implementation ActionPieView

- (id)initWithActionCollection:(ActionCollection *)collection
{
    self = [super init];
    if (self)
    {
        closing = NO;
        
        self.arcRadius = 160;
        self.pieRadius = 120;
        self.organizeCategories = YES;
        self.actionCollection = collection;
    }
    return self;
}

- (void)open:(ActionPieViewMenuOrientation)orientation onNode:(SKNode*)node atPoint:(CGPoint)point
{
    SKScene *scene = node.scene;
    
    CGPoint realPoint = [scene convertPoint:point fromNode:node];
    
    // Auto orientation scheme
    if(orientation == ActionPieViewMenuOrientationAuto)
    {
        CGSize screenSize = scene.size;
        CGPoint screenCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        
        CGFloat angle = atan2(realPoint.y - screenCenter.y, -realPoint.x - screenCenter.x) * -(180 / M_PI);
        
        angle = floor(angle / 90) * 90;
        
        if(realPoint.x > screenSize.width / 2)
        {
            orientation = ActionPieViewMenuOrientationLeft;
        }
        else
        // Right side
        if(angle == 0)
        {
            orientation = ActionPieViewMenuOrientationLeft;
        }
        // Top
        else if(angle == 90)
        {
            orientation = ActionPieViewMenuOrientationBottom;
        }
        // Left side
        else if(angle == 180 || angle == -180)
        {
            orientation = ActionPieViewMenuOrientationRight;
        }
        // Bottom side
        else if(angle == -90)
        {
            orientation = ActionPieViewMenuOrientationTop;
        }
    }
    
    self.target = node;
    self.orientation = orientation;
    self.zPosition = 1000;
    
    // Add pie menu to node
    self.position = realPoint;
    [scene addChild:self];
    
    [self createIcons];
}

- (void)close
{
    closing = YES;
    
    // Close children menu first
    if(self.childMenu)
    {
        [self.childMenu close];
    }
    
    [(GPGameScene*)self.scene removeNotifier:self];
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

- (void)openSubMenu:(ActionCollection *)collection onIndex:(NSInteger)index
{
    
}

// Private members
- (void)createIcons
{
    // List of icons to display
    NSMutableArray *iconsArray = [self getActionIconViewList];
    
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
    
    startAngle -= self.arcRadius / 2;
    CGFloat stepAngle = self.arcRadius / iconsArray.count;
    
    for (int i = 0; i < iconsArray.count; i++)
    {
        CGFloat iconAngle = startAngle + stepAngle * i + stepAngle / 2;
        
        CGPoint point = CGPointMake(cos(iconAngle * (M_PI / 180)) * self.pieRadius, sin(iconAngle * (M_PI / 180)) * self.pieRadius);
        
        SKNode *node = iconsArray[i];
        node.position = point;
        
        [self addChild:node];
    }
}

/// Returns a list of ActionIconView items that represent the icons to display on this ActionPieView
- (NSMutableArray*)getActionIconViewList
{
    NSMutableArray *iconsArray = [NSMutableArray array];
    
    if(self.actionCollection.actionList.count == 0)
    {
        return iconsArray;
    }
    
    if(self.organizeCategories)
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
            icon.categoryDisplay = YES;
            
            [iconsArray addObject:icon];
        }
        if(hasAttack)
        {
            BattleAction *dummy = [[BattleAction alloc] init]; dummy.actionType = ActionTypeAttack;
            
            ActionIconView *icon = [[ActionIconView alloc] initWithAction:dummy];
            icon.categoryDisplay = YES;
            
            [iconsArray addObject:icon];
        }
        if(hasItems)
        {
            BattleAction *dummy = [[BattleAction alloc] init]; dummy.actionType = ActionTypeItem;
            
            ActionIconView *icon = [[ActionIconView alloc] initWithAction:dummy];
            icon.categoryDisplay = YES;
            
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

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:gameScene];
    
    SKNode *nodeOnPoint = [gameScene nodeAtPoint:point];
    
    if(![nodeOnPoint inParentHierarchy:self] && ![nodeOnPoint inParentHierarchy:self.target])
    {
        [self close];
    }
}

@end
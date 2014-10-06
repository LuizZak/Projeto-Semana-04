//
//  ActionPieView.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionPieView.h"

@implementation ActionPieView

- (id)initWithActionCollection:(ActionCollection *)collection
{
    self = [super init];
    if (self)
    {
        closing = NO;
        
        self.actionCollection = collection;
        self.displayCategoriesOnly = YES;
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
    
    self.orientation = orientation;
    self.container = [self createContainer:self.actionCollection];
    [self addChild:self.container];
    [self.container initialize];
    
    self.target = node;
    self.orientation = orientation;
    self.zPosition = 1000;
    
    // Add pie menu to node
    self.position = realPoint;
    [scene addChild:self];
}

- (void)close
{
    [self.container close];
    
    closing = YES;
    
    [(GPGameScene*)self.scene removeNotifier:self];
    [self removeFromParent];
}

- (ActionPieContainerView*)createContainer:(ActionCollection*)collection
{
    ActionPieContainerView *container = [[ActionPieContainerView alloc] initWithActionCollection:collection];
    container.actionPieOwner = self;
    container.orientation = self.orientation;
    container.displayCategoriesOnly = self.displayCategoriesOnly;
    
    return container;
}

- (void)actionTapped:(ActionIconView *)action
{
    if(action.displayCategoryOnly)
    {
        ActionPieContainerView *container = [self containerForActionIconView:action];
        
        [container.childMenu close];
        
        ActionPieContainerView *newContainer = [self createContainer:[container.actionCollection actionsForType:action.action.actionType]];
        newContainer.displayCategoriesOnly = NO;
        newContainer.orientation = ActionPieViewMenuOrientationRight;
        newContainer.modAngle = [container angleForIcon:action];
        container.childMenu = newContainer;
        newContainer.parentMenu = container;
        
        CGPoint point = [action convertPoint:CGPointZero toNode:self];
        
        newContainer.position = point;
        [self addChild:newContainer];
        [newContainer initialize];
        
        return;
    }
    
    [self.actionBarManager performAction:action.action];
    [self close];
}

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self.scene];
    
    SKNode *nodeOnPoint = [self.scene nodeAtPoint:point];
    
    if(![nodeOnPoint inParentHierarchy:self] && ![nodeOnPoint inParentHierarchy:self.target])
    {
        [self close];
    }
}

- (ActionPieContainerView*)containerForActionIconView:(ActionIconView*)icon
{
    ActionPieContainerView *container = self.container;
    
    do
    {
        // Check tapped actions
        for (ActionIconView *icon in container.children)
        {
            if([icon isEqual:icon])
            {
                return container;
            }
        }
        container = container.childMenu;
    } while (container != nil);
    
    return nil;
}

@end
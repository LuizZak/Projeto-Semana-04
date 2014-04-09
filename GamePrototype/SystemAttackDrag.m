//
//  AttackDrag.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemAttackDrag.h"
#import "ComponentDraggableAttack.h"

@implementation SystemAttackDrag

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleComponent([ComponentDraggableAttack class]));
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    for(GPEntity *entity in entitiesArray)
    {
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[entity getComponent:[ComponentDraggableAttack class]];
        comp.currentCooldown -= interval;
        
        if(comp.currentCooldown <= 0)
        {
            [(SKSpriteNode*)entity.node setColor:[UIColor redColor]];
        }
    }
}

- (BOOL)gameSceneDidAddEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    BOOL ret;
    if((ret = [super gameSceneDidAddEntity:gameScene entity:entity]))
    {
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[entity getComponent:[ComponentDraggableAttack class]];
        
        comp.startPoint = entity.node.position;
    }
    
    return ret;
}

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    for(GPEntity *entity in entitiesArray)
    {
        if([entity.node containsPoint:pt])
        {
            ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[entity getComponent:[ComponentDraggableAttack class]];
            
            if(comp.currentCooldown <= 0)
            {
                self.currentDrag = entity;
                return;
            }
        }
    }
}

- (void)gameSceneDidReceiveTouchesMoved:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    if(self.currentDrag != nil)
    {
        self.currentDrag.node.position = pt;
    }
}

- (void)gameSceneDidReceiveTouchesEnd:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.currentDrag != nil)
    {
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[self.currentDrag getComponent:[ComponentDraggableAttack class]];
        
        comp.currentCooldown = comp.skillCooldown;
        
        SKAction *act = [SKAction moveTo:comp.startPoint duration:0.1];
        
        [(SKSpriteNode*)self.currentDrag.node setColor:[UIColor yellowColor]];
        [self.currentDrag.node runAction:act];
    }
    
    self.currentDrag = nil;
}

@end
//
//  AttackDrag.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemAttackDrag.h"
#import "ComponentHealth.h"
#import "ComponentDraggableAttack.h"

@implementation SystemAttackDrag

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleComponent([ComponentDraggableAttack class]));
        self.enemySelector = GPEntitySelectorCreate(GPRuleAnd(GPRuleComponent([ComponentHealth class]), GPRuleType(ENEMY_TYPE)));
        self.enemiesArray = [NSMutableArray array];
        
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
    
    if([self.enemySelector applyRuleToEntity:entity])
    {
        [self.enemiesArray addObject:entity];
    }
    
    return ret;
}

- (BOOL)gameSceneDidRemoveEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    [self.enemiesArray removeObject:entity];
    
    return [super gameSceneDidRemoveEntity:gameScene entity:entity];
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
                self.dragOffset = CGPointMake(pt.x - self.currentDrag.node.position.x, pt.y - self.currentDrag.node.position.y);
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
        self.currentDrag.node.position = CGPointMake(pt.x - self.dragOffset.x, pt.y - self.dragOffset.y);
    }
}

- (void)gameSceneDidReceiveTouchesEnd:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.currentDrag != nil)
    {
        UITouch *tch = [touches anyObject];
        CGPoint pt = [tch locationInNode:gameScene];
        
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[self.currentDrag getComponent:[ComponentDraggableAttack class]];
        
        // Checa se o jogador largou a skill em cima de um inimigo
        for(GPEntity *entity in self.enemiesArray)
        {
            if([entity.node containsPoint:pt])
            {
                comp.currentCooldown = comp.skillCooldown;
                
                [(SKSpriteNode*)self.currentDrag.node setColor:[UIColor yellowColor]];
                [(SKSpriteNode*)entity.node setColor:[UIColor magentaColor]];
                
                [self damageEntity:entity damage:comp.damage];
                
                break;
            }
        }
<<<<<<< HEAD
        
        SKAction *act = [SKAction moveTo:comp.startPoint duration:0.1];
        
        [(SKSpriteNode*)self.currentDrag.node setColor:[UIColor yellowColor]];
        
=======
        SKAction *act = [SKAction moveTo:comp.startPoint duration:0.1];
        
        [(SKSpriteNode*)self.currentDrag.node setColor:[UIColor yellowColor]];
>>>>>>> FETCH_HEAD
        [self.currentDrag.node runAction:act];
    }
    
    self.currentDrag = nil;
}

- (void)damageEntity:(GPEntity*)entity damage:(float)damage
{
    ComponentHealth *hc = (ComponentHealth*)[entity getComponent:[ComponentHealth class]];
    
    hc.health -= damage;
    
    if(hc.health <= 0)
    {
        hc.health = 0;
    }
}

@end
//
//  MyScene.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "MyScene.h"
#import "SystemAttackDrag.h"
#import "SystemHealthIndicator.h"
#import "ComponentHealth.h"
#import "ComponentHealthIndicator.h"
#import "ComponentDraggableAttack.h"

@implementation MyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self addSystem:[[SystemAttackDrag alloc] initWithGameScene:self]];
        [self addSystem:[[SystemHealthIndicator alloc] initWithGameScene:self]];
        
        [self createEnemy:260 y:250];
        [self createEnemy:260 y:290];
        [self createEnemy:260 y:330];
        
        [self createAttack:40 y:213 cooldown:1 damage:3];
        [self createAttack:120 y:213 cooldown:5 damage:10];
        [self createAttack:200 y:213 cooldown:10 damage:30];
        
        [self sortEnemies];
        [self sortAttacks];
    }
    return self;
}

- (void)createAttack:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage
{
    GPEntity *en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(100, 100)]];
    en.node.position = CGPointMake(x, y);
    [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:cooldown damage:damage]];
    
    [self addEntity:en];
}

- (void)sortEnemies
{
    NSArray *attacks = [self getEntitiesWithSelectorRule:GPRuleAnd(GPRuleType(ENEMY_TYPE), GPRuleComponent([ComponentHealth class]))];
    
    int x = self.frame.size.width - 100;
    int y = 250;
    
    for(GPEntity *entity in attacks)
    {
        entity.node.position = CGPointMake(x, y);
        
        y += 200;
    }
}

- (void)sortAttacks
{
    NSArray *attacks = [self getEntitiesWithSelectorRule:GPRuleComponent([ComponentDraggableAttack class])];
    
    int x = 80;
    int y = 80;
    for(GPEntity *entity in attacks)
    {
        entity.node.position = CGPointMake(x, y);
        
        ComponentDraggableAttack *attack = GET_COMPONENT(entity, ComponentDraggableAttack);
        attack.startPoint = entity.node.position;
        
        x += 130;
    }
}

- (void)createEnemy:(float)x y:(float)y
{
    SKNode *enemyNode = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(150, 150)];
    GPEntity *enemy = [[GPEntity alloc] initWithNode:enemyNode];
    
    [enemy addComponent:[[ComponentHealth alloc] initWithHealth:100 maxhealth:100]];
    [enemy addComponent:[[ComponentHealthIndicator alloc] initWithBarWidth:150 barBackColor:[UIColor blackColor] barFrontColor:[UIColor redColor]]];
    enemy.type = ENEMY_TYPE;
    
    enemyNode.position = CGPointMake(x, y);
    
    [self addEntity:enemy];
}

- (void)fecharATela
{
    SKTransition *reveal = [SKTransition fadeWithDuration:1.0];
    //WorldMap *battleScene = [[WorldMap alloc] initWithSize:self.size];
    [self.scene.view presentScene:[[GameData gameData] world] transition: reveal];
}

@end
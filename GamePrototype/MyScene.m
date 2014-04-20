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
        
        GPEntity *en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)]];
        en.node.position = CGPointMake(20, 213);
        [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:1 damage:3]];
        
        [self addEntity:en];
        
        en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)]];
        en.node.position = CGPointMake(60, 213);
        [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:5 damage:10]];
        
        [self addEntity:en];
        
        en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)]];
        en.node.position = CGPointMake(100, 213);
        [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:10 damage:30]];
        
        [self addEntity:en];
    }
    return self;
}

- (void)createEnemy:(float)x y:(float)y
{
    SKNode *enemyNode = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(30, 30)];
    GPEntity *enemy = [[GPEntity alloc] initWithNode:enemyNode];
    
    [enemy addComponent:[[ComponentHealth alloc] initWithHealth:100 maxhealth:100]];
    [enemy addComponent:[[ComponentHealthIndicator alloc] initWithBarWidth:30 barBackColor:[UIColor blackColor] barFrontColor:[UIColor redColor]]];
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
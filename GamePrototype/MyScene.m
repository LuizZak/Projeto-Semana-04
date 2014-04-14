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
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        [self addSystem:[[SystemAttackDrag alloc] initWithGameScene:self]];
        [self addSystem:[[SystemHealthIndicator alloc] initWithGameScene:self]];
        
        [self createEnemy:260 y:250];
        [self createEnemy:260 y:330];
        [self createEnemy:260 y:410];
        
        [self createSkill:40 y:213 cooldown:1 damage:3];
        [self createSkill:110 y:213 cooldown:5 damage:10];
        [self createSkill:180 y:213 cooldown:10 damage:30];
        
        SKSpriteNode *spr = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(100, 100)];
        spr.anchorPoint = CGPointMake(0, 0);
        [self addChild:spr];
    }
    return self;
}

- (void)createEnemy:(float)x y:(float)y
{
    SKNode *enemyNode = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(60, 60)];
    GPEntity *enemy = [[GPEntity alloc] initWithNode:enemyNode];
    
    [enemy addComponent:[[ComponentHealth alloc] initWithHealth:100 maxhealth:100]];
    [enemy addComponent:[[ComponentHealthIndicator alloc] initWithBarWidth:60 barBackColor:[UIColor blackColor] barFrontColor:[UIColor redColor]]];
    enemy.type = ENEMY_TYPE;
    
    enemyNode.position = CGPointMake(x, y);
    
    [self addEntity:enemy];
}

- (void)createSkill:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage
{
    GPEntity *en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(60, 60)]];
    en.node.position = CGPointMake(x, y);
    [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:cooldown damage:damage]];
    
    [self addEntity:en];
}

@end
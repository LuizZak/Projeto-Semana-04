//
//  MyScene.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SceneBattle.h"
#import "SystemAttackDrag.h"
#import "SystemHealthIndicator.h"
#import "ComponentAIBattle.h"
#import "ComponentHealth.h"
#import "ComponentHealthIndicator.h"
#import "ComponentDraggableAttack.h"

@implementation SceneBattle

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self addSystem:[[SystemAttackDrag alloc] initWithGameScene:self]];
        [self addSystem:[[SystemHealthIndicator alloc] initWithGameScene:self]];
        
        [self createEnemy:260 y:250 health:30];
        [self createEnemy:260 y:290 health:75];
        [self createEnemy:260 y:330 health:100];
        
        [self createAttack:40 y:213 cooldown:1 damage:3];
        [self createAttack:120 y:213 cooldown:5 damage:10];
        [self createAttack:200 y:213 cooldown:10 damage:30];
        
        [self createPlayer];
        
        [self sortEnemies];
        [self sortAttacks];
    }
    return self;
}

// Cria o jogador na cena de batalha
- (void)createPlayer
{
    SKNode *playerNode = [SKSpriteNode spriteNodeWithImageNamed:@"dragon-perfil"];
    GPEntity *player = [[GPEntity alloc] initWithNode:playerNode];
    
    [player addComponent:[[ComponentHealth alloc] initWithHealth:35 maxhealth:35]];
    [player addComponent:[[ComponentHealthIndicator alloc] initWithBarWidth:300 barHeight:30 barBackColor:[UIColor blackColor] barFrontColor:[UIColor redColor]]];
    player.ID = PLAYER_ID;
    
    [playerNode setScale:0.5f];
    
    playerNode.xScale = -playerNode.xScale;
    
    playerNode.position = CGPointMake(200, self.frame.size.height / 2 + 50);
    
    [self addEntity:player];
}

- (void)createEnemy:(float)x y:(float)y health:(float)health;
{
    SKSpriteNode *enemyNode = [SKSpriteNode spriteNodeWithImageNamed:@"Knight"];
    GPEntity *enemy = [[GPEntity alloc] initWithNode:enemyNode];
    
    [enemyNode setScale:0.4f];
    
    enemyNode.xScale = -enemyNode.xScale;
    
    [enemy addComponent:[[ComponentHealth alloc] initWithHealth:health maxhealth:health]];
    [enemy addComponent:[[ComponentHealthIndicator alloc] initWithBarWidth:150 barHeight:30 barBackColor:[UIColor blackColor] barFrontColor:[UIColor redColor]]];
    [enemy addComponent:[[ComponentAIBattle alloc] init]];
    enemy.type = ENEMY_TYPE;
    
    enemyNode.position = CGPointMake(x, y);
    
    [self addEntity:enemy];
}

- (void)createAttack:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage
{
    GPEntity *en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(100, 100)]];
    en.node.position = CGPointMake(x, y);
    [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:cooldown damage:damage]];
    
    en.type = PLAYER_TYPE;
    
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

- (void)fecharATela
{
    SKTransition *reveal = [SKTransition fadeWithDuration:1.0];
    //WorldMap *battleScene = [[WorldMap alloc] initWithSize:self.size];
    [self.scene.view presentScene:[[GameData gameData] world] transition: reveal];
}

@end
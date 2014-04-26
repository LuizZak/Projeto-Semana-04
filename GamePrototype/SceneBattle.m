//
//  MyScene.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SceneBattle.h"
#import "SystemBattle.h"
#import "SystemHealthIndicator.h"
#import "ComponentBattleState.h"
#import "ComponentHealth.h"
#import "ComponentHealthIndicator.h"
#import "ComponentDraggableAttack.h"
#import "ComponentBounty.h"
#import "Som.h"

@implementation SceneBattle

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // Adicionando fundo
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"earthScene"];
        self.background.anchorPoint = CGPointZero;
        self.background.zPosition = -50;
        
        [self.background setScale:0.5f];
        
        [self addChild:self.background];
    }
    return self;
}

// Carrega a batalha agora
- (void)didMoveToView:(SKView *)view
{
    [self loadBattle];
}

// Carrega a batalha
- (void)loadBattle
{
    // Limpa a cena
    [self clearScene];
    
    // Reinicia a batalha
    [self addSystem:[[SystemBattle alloc] initWithGameScene:self]];
    [self addSystem:[[SystemHealthIndicator alloc] initWithGameScene:self]];
    
    // Cria os inimigos, usando a array de inimigos passada
    for (GPEntity *enemy in self.battleConfig.enemiesArray)
    {
        [self addEntity:enemy];
    }
    
    // Cria o jogador
    [self createPlayer];
    
    [self createSkillsBar];
    
    [self sortEnemies];
    [self sortAttacks];
}

// Cria a barra de skills e suas skills respectivas
- (void)createSkillsBar
{
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.frame.size.width, 150)];
    
    sprite.anchorPoint = CGPointZero;
    sprite.zPosition = 10;
    
    [self addChild:sprite];
    
    [self createAttack:40 y:213 cooldown:1 damage:3 skillType:SkillFireball];
    [self createAttack:120 y:213 cooldown:5 damage:10 skillType:SkillFireball];
    [self createAttack:200 y:213 cooldown:10 damage:30 skillType:SkillFireball];
}

// Cria o jogador na cena de batalha
- (void)createPlayer
{
    SKNode *playerNode = [SKSpriteNode spriteNodeWithImageNamed:@"dragon-perfil"];
    GPEntity *player = [[GPEntity alloc] initWithNode:playerNode];
    
    float playerHealth = [[[GameData gameData].data objectForKey:KEY_PLAYER_HEALTH] floatValue];
    
    [player addComponent:[[ComponentHealth alloc] initWithHealth:playerHealth maxhealth:playerHealth]];
    [player addComponent:[[ComponentHealthIndicator alloc] initWithBarWidth:500 barHeight:30 barBackColor:[UIColor blackColor] barFrontColor:[UIColor redColor]]];
    [player addComponent:[[ComponentBattleState alloc] initWithProjectilePoint:CGPointMake(190, 0)]];
    player.ID = PLAYER_ID;
    
    [playerNode setScale:0.5f];
    
    playerNode.xScale = -playerNode.xScale;
    
    playerNode.position = CGPointMake(200, self.frame.size.height / 2 + 50);
    
    [self addEntity:player];
}

- (void)createAttack:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage skillType:(SkillType)skillType
{
    GPEntity *en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(100, 100)]];
    en.node.position = CGPointMake(x, y);
    en.node.zPosition = 12;
    [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:cooldown damage:damage skillType:skillType startEnabled:YES]];
    
    en.type = PLAYER_TYPE;
    
    [self addEntity:en];
}

- (void)sortEnemies
{
    NSArray *attacks = [self getEntitiesWithSelectorRule:GPRuleAnd(GPRuleType(ENEMY_TYPE), GPRuleComponent([ComponentHealth class]))];
    
    float x = self.frame.size.width - 100;
    float y = 250;
    
    for(GPEntity *entity in attacks)
    {
        int randX = -25 + (arc4random() % 50);
        int randY = -25 + (arc4random() % 50);
        
        entity.node.position = CGPointMake(x + randX, y + randY);
        
        [entity.node setScale:0.7f - ((y + randY) / 2000)];
        
        // Gira o inimigo para a esquerda
        entity.node.xScale = -entity.node.xScale;
        
        y += 200;
    }
}

- (void)sortAttacks
{
    NSArray *attacks = [self getEntitiesWithSelectorRule:GPRuleAnd(GPRuleType(PLAYER_TYPE), GPRuleComponent([ComponentDraggableAttack class]))];
    
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

- (void)setSceneType:(int)sceneType
{
    if(sceneType == TILE_GRASS)
    {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"gramaScene"]];
    }
    else if(sceneType == TILE_EARTH)
    {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"earthScene"]];
    }
}

- (void)fecharATela
{
    SKTransition *reveal = [SKTransition fadeWithDuration:1.0];
    //WorldMap *battleScene = [[WorldMap alloc] initWithSize:self.size];
    [self.scene.view presentScene:[[GameData gameData] world] transition: reveal];
}

@end
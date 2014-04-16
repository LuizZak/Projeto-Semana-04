//
//  WorldMap.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "WorldMap.h"
#import "ComponentMapaGrid.h"
#import "ComponentMovement.h"
#import "SystemMap.h"
#import "SystemMovimentoAndar.h"
#import "SystemMapMovement.h"
#import "SystemCamera.h"

@implementation WorldMap

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        /*SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];*/
        
        [self addSystem:[[SystemMovimentoAndar alloc] initWithGameScene:self]];
        // Adiciona o sistema de mapa
        [self addSystem:[[SystemMap alloc] initWithGameScene:self]];
        // Adiciona o sistema de movimentação de entidades no mapa
        [self addSystem:[[SystemMapMovement alloc] initWithGameScene:self]];
        // Adiciona o sistema de câmera
        [self addSystem:[[SystemCamera alloc] initWithGameScene:self]];
        
        [self createPlayer:CGRectGetMidX(self.frame) y:CGRectGetMidY(self.frame)];
        
        [self createMap];
    }
    return self;
}

- (void)createEnemy:(float)x y:(float)y
{
    SKNode *enemyNode = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
    GPEntity *enemy = [[GPEntity alloc] initWithNode:enemyNode];
    
    enemy.type = ENEMY_TYPE;
    
    enemyNode.position = CGPointMake(x, y);
    
    [self addEntity:enemy];
}

- (void)createPlayer:(float)x y:(float)y
{
    SKNode *playerNode = [SKNode node];
    SKSpriteNode *playerGfx = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    playerGfx.size = CGSizeMake(64, 64);
    playerGfx.zRotation = -M_PI / 2;
    
    [playerNode addChild:playerGfx];
    
    GPEntity *player = [[GPEntity alloc] initWithNode:playerNode];
    
    player.ID = PLAYER_ID;
    
    // Adiciona os componentes relevantes
    ComponentMovement *comp = [[ComponentMovement alloc] init];
    comp.offsetX = 32;
    comp.offsetY = 32;
    [player addComponent:comp];
    
    // Ajusta a posição pedida para o tile
    x = roundf(x / 64) * 64 + comp.offsetX;
    y = roundf(y / 64) * 64 + comp.offsetY;
    
    playerNode.position = CGPointMake(x, y);
    
    [self addEntity:player];
}

- (void)createCamera:(float)x y:(float)y following:(GPEntity*)entityToFollow
{
    SKSpriteNode *playerNode = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    playerNode.size = CGSizeMake(64, 64);
    playerNode.anchorPoint = CGPointMake(0, 0);
    GPEntity *player = [[GPEntity alloc] initWithNode:playerNode];
    
    player.ID = PLAYER_ID;
    
    // Adiciona os componentes relevantes
    [player addComponent:[[ComponentMovement alloc] init]];
    
    playerNode.position = CGPointMake(x, y);
    
    [self addEntity:player];
}

- (void)createMap
{
    SKNode *mapNode = [SKNode node];
    GPEntity *mapEntity = [[GPEntity alloc] initWithNode:mapNode];
    
    mapEntity.ID = MAP_ID;
    
    NSMutableArray *grid = [NSMutableArray array];
    
    for(int y = 0; y < 30; y++)
    {
        NSMutableArray *row = [NSMutableArray array];
        [grid addObject:row];
        
        for(int x = 0; x < 30; x++)
        {
            [row addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    ComponentMapaGrid *comp = [[ComponentMapaGrid alloc] init];
    comp.mapGrid = grid;
    
    [mapEntity addComponent:comp];
    
    [self addEntity:mapEntity];
}

- (BOOL)randomBattle
{
    int random = arc4random() % 50;
    
    ComponentMapaGrid *mapGrid = (ComponentMapaGrid*)[[self getEntityByID:MAP_ID] getComponent:[ComponentMapaGrid class]];
    
    // Mecher com o grid aqui dentro
    
    
    if (random == 6)
    {
        [self goToBattle];
        return YES;
    }
    
    return NO;
}

- (void)goToBattle
{
    SKTransition *reveal = [SKTransition fadeWithDuration:1.0];
    MyScene *battleScene = [[MyScene alloc] initWithSize:self.size];
    [self.scene.view presentScene: battleScene transition: reveal];
}

@end
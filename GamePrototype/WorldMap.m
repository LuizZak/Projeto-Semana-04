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
#import "ComponentCamera.h"
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
        
        GPEntity *playerEntity = [self createPlayer:CGRectGetMidX(self.frame) y:CGRectGetMidY(self.frame)];
        
        [self createMap];
        
        [self createCamera:0 y:0 withBounds:CGRectMake(0, 0, 30 * 64, 30 * 64) following:playerEntity];
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

- (GPEntity*)createPlayer:(float)x y:(float)y
{
    // Carregando a animação
    NSArray *dragonFrames = [self loadSpriteSheetFromImageWithName:@"dragon" startingAt:1];
    
    SKNode *playerNode = [SKNode node];
    SKSpriteNode *playerGfx = [SKSpriteNode spriteNodeWithTexture:dragonFrames[5]];
    [playerGfx runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:dragonFrames timePerFrame:0.05 resize:NO restore:YES]]];
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
    
    return player;
}

- (void)createCamera:(float)x y:(float)y withBounds:(CGRect)bounds following:(GPEntity*)entityToFollow
{
    SKNode *cameraNode = [SKNode node];
    GPEntity *camera = [[GPEntity alloc] initWithNode:cameraNode];
    
    camera.ID = CAMERA_ID;
    
    // Adiciona os componentes relevantes
    ComponentCamera *cameraComp = [[ComponentCamera alloc] init];
    cameraComp.cameraBounds = bounds;
    cameraComp.following = entityToFollow;
    [camera addComponent:cameraComp];
    
    cameraNode.position = CGPointMake(x, y);
    
    [self addEntity:camera];
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

-(NSMutableArray*)loadSpriteSheetFromImageWithName:(NSString*)name startingAt:(int)firstNum
{
    NSMutableArray *animationFrames = [NSMutableArray array];
    SKTextureAtlas *animationAtlas = [SKTextureAtlas atlasNamed:name];
    
    for(int i = firstNum; i <= animationAtlas.textureNames.count; i++)
    {
        // Nomes das imagens com números de 4 dígitos, por exemplo "0001"
        NSString *partName = [NSString stringWithFormat:@"%@%04i", name, i];
        SKTexture *part = [animationAtlas textureNamed:partName];
        
        [animationFrames addObject:part];
    }
    
    return animationFrames;
}

@end
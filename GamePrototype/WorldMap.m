//
//  WorldMap.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "WorldMap.h"
#import "ComponentMapaGrid.h"
#import "ComponentMapMovement.h"
#import "ComponentCamera.h"
#import "ComponentDialog.h"
#import "SystemMap.h"
#import "SystemMovimentoAndar.h"
#import "SystemCamera.h"
#import "SystemDialog.h"
#import "DSMultilineLabelNode.h"

@implementation WorldMap

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // Adiciona o sistema de mover o personagem com o dedo
        [self addSystem:[[SystemMovimentoAndar alloc] initWithGameScene:self]];
        // Adiciona o sistema de mapa
        [self addSystem:[[SystemMap alloc] initWithGameScene:self]];
        // Adiciona o sistema de movimentação de entidades no mapa
        [self addSystem:[[SystemMapMovement alloc] initWithGameScene:self]];
        // Adiciona o sistema de câmera
        [self addSystem:[[SystemCamera alloc] initWithGameScene:self]];
        
        // Arruma o delegate do sistema de movimento de mapa
        ((SystemMapMovement*)[self getSystem:[SystemMapMovement class]]).delegate = self;
        
        [self createMap];
        
        int playerSpawnX = 15;
        int playerSpawnY = 15;
        
        GPEntity *playerEntity = [self createPlayer:playerSpawnX * 64 y:playerSpawnY * 64];
        
        [self createCamera:0 y:0 withBounds:CGRectMake(0, 0, 30 * 64, 30 * 64) following:playerEntity];
        
        
        // ! TESTE !
        playerEntity = [self createPlayer:(playerSpawnX + 4) * 64 y:playerSpawnY * 64];
        playerEntity.ID = 0;
        
        [self entityModified:playerEntity];
        
        
        // TESTE DE CAIXA DE DIÁLOGO
        [self addSystem:[[SystemDialog alloc] initWithGameScene:self]];
        
        ComponentDialog *cmp = [[ComponentDialog alloc] init];
        cmp.textColor = [UIColor whiteColor];
        cmp.charDelay = 0.05f;
        cmp.avatarTexture = [SKTexture textureWithImageNamed:@"dragonAvatar"];
        cmp.characterName = @"Dragon";
        cmp.textDialog = @"Rawr! Eu sou um dragão!";
        
        ComponentDialog *cmp2 = [[ComponentDialog alloc] init];
        cmp2.textColor = [UIColor whiteColor];
        cmp2.charDelay = 0.05f;
        cmp2.textDialog = @"Mexa o personagem com o toque!";
        
        ComponentDialog *cmp3 = [[ComponentDialog alloc] init];
        cmp3.textColor = [UIColor whiteColor];
        cmp3.charDelay = 0.05f;
        cmp3.textDialog = @"Viva Final Fantasy (que eu nunca joguei)! ~~ testando textos grandes para exibição e tals...";
        
        cmp.nextDialog = cmp2;
        cmp2.nextDialog = cmp3;
        
        GPEntity *entity = [[GPEntity alloc] initWithNode:[SKNode node]];
        [entity addComponent:cmp];
        
        [self addEntity:entity];
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
    
    // Cria a entidade
    GPEntity *player = [[GPEntity alloc] initWithNode:playerNode];
    player.ID = PLAYER_ID;
    
    // Adiciona os componentes relevantes
    ComponentMapMovement *comp = [[ComponentMapMovement alloc] init];
    comp.offsetX = 32;
    comp.offsetY = 32;
    comp.currentGridX = roundf(x / 64);
    comp.currentGridY = roundf(y / 64);
    comp.blocksOtherEntities = NO;
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
    
    int mapWidth = 30;
    int mapHeight = 30;
    
    for(int y = 0; y < mapWidth; y++)
    {
        NSMutableArray *row = [NSMutableArray array];
        [grid addObject:row];
        
        for(int x = 0; x < mapHeight; x++)
        {
            [row addObject:[NSNumber numberWithInt:0]];
        }
    }
    // Mapa manual das grids
    // 0 - Grama
    // 1 - Montanha
    // 2 - Terra
    // 3 - Caverna
    int gridMapa[30][30] =
    {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,2,1,1,1,2,2,0,0,0,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1},
        {1,1,2,3,2,2,2,2,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1},
        {1,1,1,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1},
        {1,1,1,1,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,1,1,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,1,1,2,2,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,1,2,2,1,1,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
        {1,1,1,1,1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    };
    
    for(int y = 0; y < 30; y++)
    {
        for(int x = 0; x < 30; x++)
        {
            grid[y][x] = [NSNumber numberWithInt:gridMapa[mapHeight - y - 1][x]];
        }
    }
    
    ComponentMapaGrid *comp = [[ComponentMapaGrid alloc] init];
    comp.mapGrid = grid;
    
    [mapEntity addComponent:comp];
    
    [self addEntity:mapEntity];
}

- (void)systemMapMovement:(SystemMapMovement *)system entity:(GPEntity *)entity didWalkTo:(CGPoint)point tileID:(int)tileID
{
    // Gera uma batalha caso o jogador esteja andando em cima de terra
    if(entity.ID != PLAYER_ID)
        return;
    
    int random = arc4random() % 6;
    
    if(tileID == TILE_EARTH && random == 0)
    {
        [self goToBattle];
    }
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
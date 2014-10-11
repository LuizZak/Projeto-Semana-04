//
//  WorldMap.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "WorldMap.h"
#import "BattleConfig.h"
#import "ComponentMapaGrid.h"
#import "ComponentMapMovement.h"
#import "ComponentCamera.h"
#import "ComponentDialog.h"
#import "ComponentAIBattle.h"
#import "ComponentBattleState.h"
#import "ComponentHealth.h"
#import "ComponentHealthIndicator.h"
#import "ComponentDraggableAttack.h"
#import "ComponentBounty.h"
#import "SystemMap.h"
#import "SystemMovimentoAndar.h"
#import "SystemMapHud.h"
#import "SystemCamera.h"
#import "SystemDialog.h"
#import "DSMultilineLabelNode.h"
#import "GameData.h"
#import "GameController.h"
#import "Som.h"

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
        // Adiciona o sistema de HUD
        [self addSystem:[[SystemMapHud alloc] initWithGameScene:self]];
        // Adiciona o sistema de diálogo
        [self addSystem:[[SystemDialog alloc] initWithGameScene:self]];
        
        // Arruma o delegate do sistema de movimento de mapa
        ((SystemMapMovement*)[self getSystem:[SystemMapMovement class]]).delegate = self;
        
        [self createMap];
        
        int playerSpawnX = [[[GameData gameData].data objectForKey:KEY_PLAYER_SPAWN_X] intValue];
        int playerSpawnY = [[[GameData gameData].data objectForKey:KEY_PLAYER_SPAWN_Y] intValue];
        
        GPEntity *playerEntity = [self createPlayer:playerSpawnX * 64 y:playerSpawnY * 64];
        
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
    // 4 - Castelo-Terra
    // 5 - Castelo-Grama
    // 6 - Agua
    int gridMapa[30][30] =
    {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,2,1,1,1,2,2,2,2,2,2,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1},
        {1,1,2,3,2,2,2,2,2,0,0,0,2,2,2,2,1,1,1,1,2,2,2,2,2,1,1,1,1,1},
        {1,1,1,2,2,2,2,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1},
        {1,1,1,1,2,2,2,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,1,2,2,1,1,1},
        {1,1,1,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,1,1,2,2,1,1,1},
        {1,1,1,2,2,1,1,2,0,0,0,0,6,6,0,0,0,0,0,0,2,2,1,1,1,2,2,1,1,1},
        {1,1,2,2,1,2,2,2,0,0,0,6,6,6,6,0,0,0,0,0,2,1,1,1,2,2,2,2,1,1},
        {1,1,2,2,2,2,0,0,0,0,0,0,0,6,6,0,0,0,0,2,2,1,1,1,2,2,2,2,1,1},
        {1,1,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,1,1,1,2,2,2,2,2,1,1},
        {1,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,2,2,1,3,1,2,2,2,2,1,1,1},
        {1,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,0,0,2,1,1,1},
        {1,2,2,6,6,6,5,6,6,6,6,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,2,2,1,1},
        {1,2,2,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,2,2,1},
        {1,1,2,2,0,0,6,6,0,0,6,6,6,6,6,5,6,6,6,0,0,0,0,0,0,0,0,0,2,1},
        {1,1,1,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1},
        {1,1,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,2,2,1},
        {1,2,2,3,1,2,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,2,2,1,1},
        {1,2,2,1,1,2,0,0,0,0,0,0,0,0,0,2,2,1,1,1,2,0,0,0,0,0,2,2,1,1},
        {1,1,2,2,1,2,0,0,0,0,0,0,0,0,0,2,2,1,3,2,2,0,0,0,0,0,0,2,2,1},
        {1,1,2,2,2,6,6,6,6,0,0,0,0,0,0,2,1,2,2,2,6,6,0,0,0,0,0,2,2,1},
        {1,1,2,2,2,6,6,6,6,6,0,0,0,0,0,2,2,2,2,6,6,6,0,0,0,0,0,2,2,1},
        {1,1,1,2,2,2,6,6,6,2,2,2,2,0,0,0,0,6,6,6,6,0,0,0,0,0,0,2,2,1},
        {1,1,1,2,2,2,2,2,2,2,1,1,2,2,0,0,0,6,6,6,0,0,0,0,0,2,2,2,1,1},
        {1,1,1,2,2,2,2,2,2,2,1,1,1,2,0,0,0,0,0,0,0,0,0,2,2,2,2,2,1,1},
        {1,1,1,2,2,2,4,2,2,2,1,1,1,2,2,0,0,0,0,0,0,2,2,2,2,2,2,2,1,1},
        {1,1,1,1,1,2,2,2,2,1,1,1,1,1,2,2,2,0,0,2,2,2,1,2,2,2,4,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,1,1,1,1,2,2,1,1,1,1},
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
    
    int random;
    BOOL battle = NO;
    
    if(tileID == TILE_EARTH)
    {
        random = arc4random() % 30;
        
        if(random == 0)
        {
            battle = YES;
        }
    }
    else if(tileID == TILE_GRASS)
    {
        random = arc4random() % 200;
        
        if(random == 0)
        {
            battle = YES;
        }
    }
    else if(tileID == TILE_CASTLE_EARTH || tileID == TILE_CASTLE_GRASS)
    {
        battle = YES;
    }
    // Checkpoint. Revitaliza o life do jogador
    else if(tileID == TILE_CAVE)
    {
        int curHealth = [[[GameData gameData].data objectForKey:KEY_PLAYER_HEALTH] intValue];
        int maxHealth = [[[GameData gameData].data objectForKey:KEY_PLAYER_MAX_HEALTH] intValue];
        
        if(curHealth != maxHealth)
        {
            [[GameController gameController] setPlayerHealth:maxHealth];
            
            ComponentDialog *dialog = [[ComponentDialog alloc] init];
            
            dialog.textDialog = @"Life restored!";
            
            GPEntity *entity = [[GPEntity alloc] initWithNode:[SKNode node]];
            [entity addComponent:dialog];
            
            [self addEntity:entity];
        }
    }
    
    if(battle)
    {
        BattleConfig *config = [[BattleConfig alloc] init];
        
        // Pega o nível do player
        int playerLevel = [[[GameData gameData].data objectForKey:KEY_PLAYER_LEVEL] intValue];
        float healthMult = 1;
        int expMult = 1;
        
        // Torna a batalha mais dificil caso o jogador esteja em cima de um castelo
        if(tileID == TILE_CASTLE_EARTH || tileID == TILE_CASTLE_GRASS)
        {
            playerLevel += 5;
            
            healthMult *= 2;
            expMult *= 3;
        }
        
        // Adiciona alguns inimigos
        if(playerLevel == 1)
        {
            [config.enemiesArray addObject:[self createEnemyWithHealth:30 * healthMult exp:70 * expMult level:1]];
        }
        else
        {
            [config.enemiesArray addObject:[self createEnemyWithHealth:50 * healthMult exp:50 * expMult level:1]];
        }
        
        if(playerLevel > 1)
        {
            [config.enemiesArray addObject:[self createEnemyWithHealth:75 * healthMult exp:75 * expMult level:1]];
        }
        if(playerLevel > 3)
        {
            [config.enemiesArray addObject:[self createEnemyWithHealth:100 * healthMult exp:100 * expMult level:1]];
        }
        
        [self goToBattle:tileID battleConfig:config];
    }
}

- (void)goToBattle:(int)sceneType battleConfig:(BattleConfig*)config
{
    SceneBattle *battleScene = [[SceneBattle alloc] initWithSize:self.size];
    
    battleScene.battleConfig = config;
    
    [battleScene setSceneType:sceneType];
    
    SKTransition *reveal = [SKTransition fadeWithDuration:1.0];
    
    [self.view presentScene:battleScene transition:reveal];
}

// Método chamado quando o mapa veio de um final de batalha
- (void)comeFromBattle
{
    
}

- (NSMutableArray*)loadSpriteSheetFromImageWithName:(NSString*)name startingAt:(int)firstNum
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

// Cria um novo inimigo para uma batalha
- (GPEntity*)createEnemyWithHealth:(float)health exp:(int)exp level:(int)level
{
    SKSpriteNode *enemyNode = [SKSpriteNode spriteNodeWithImageNamed:@"Knight"];
    GPEntity *enemy = [[GPEntity alloc] initWithNode:enemyNode];
    
    [enemy addComponent:[[ComponentHealth alloc] initWithHealth:health maxhealth:health]];
    [enemy addComponent:[[ComponentHealthIndicator alloc] initWithBarWidth:200 barHeight:60 barBackColor:[UIColor blackColor] barFrontColor:[UIColor redColor]]];
    [enemy addComponent:[[ComponentAIBattle alloc] init]];
    [enemy addComponent:[[ComponentBattleState alloc] init]];
    
    [enemy addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:MAX(0, 5 - level) damage:5 skillType:SkillMelee startEnabled:NO]];
    [enemy addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:MAX(0, 10 - level) damage:10 skillType:SkillMelee startEnabled:NO]];
    [enemy addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:MAX(0, 20 - level) damage:20 skillType:SkillMelee startEnabled:NO]];
    
    if(level > 5)
    {
        [enemy addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:MAX(0, 40 - level) damage:40 skillType:SkillMelee startEnabled:NO]];
    }
    if(level > 15)
    {
        [enemy addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:MAX(0, 80 - level) damage:80 skillType:SkillMelee startEnabled:NO]];
    }
    
    // Adiciona um bounty para este inimigo
    [enemy addComponent:[[ComponentBounty alloc] initWithExp:exp gold:10]];
    
    // Cria o corpo de física
    SKNode *physicsNode = [SKNode node];
    
    physicsNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, enemyNode.frame.size.width, enemyNode.frame.size.height)];
    physicsNode.physicsBody.collisionBitMask   = FIREBALL_BITMASK;
    physicsNode.physicsBody.contactTestBitMask = FIREBALL_BITMASK;
    physicsNode.physicsBody.categoryBitMask    = ENEMY_BITMASK;
    physicsNode.physicsBody.dynamic = NO;
    
    physicsNode.position = CGPointMake(-enemyNode.frame.size.width / 2, -enemyNode.frame.size.height / 2);
    
    [enemyNode addChild:physicsNode];
    
    enemyNode.zPosition = -5;
    enemy.type = ENEMY_TYPE;
    
    return enemy;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.bgMusicPlayer = [[Som som] tocarSomMundo];
    
    if(self.battleResult != nil)
    {
        self.battleResult = nil;
    }
}
- (void)willMoveFromView:(SKView *)view
{
    [super willMoveFromView:view];
    
    [self.bgMusicPlayer stop];
}

@end
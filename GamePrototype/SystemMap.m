//
//  SystemMap.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 15/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMap.h"
#import "CommonImports.h"
#import "ComponentMapaGrid.h"

#define GET_CELL(x, y) ([comp.mapGrid[y][x] intValue])

@implementation SystemMap

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleAnd(GPRuleID(MAP_ID), GPRuleComponent([ComponentMapaGrid class])));
    }
    
    return self;
}

- (BOOL)testEntityToAdd:(GPEntity *)entity
{
    BOOL ret = [super testEntityToAdd:entity];
    
    // Recarrega o mapa
    if(ret)
    {
        self.mapEntity = entity;
        
        [self loadMap];
    }
    
    return ret;
}

- (void)loadMap
{
    if(self.mapEntity == nil)
        return;
    
    // Pega o c
    ComponentMapaGrid *comp = (ComponentMapaGrid*)[self.mapEntity getComponent:[ComponentMapaGrid class]];
    
    // Pega o node da entidade
    SKNode *mapContainer = [self.mapEntity node];
    
    mapContainer.zPosition = -100;
    
    // Limpa o node do mapa
    [mapContainer removeAllChildren];
    
    int mapWidth = (int)[comp.mapGrid[0] count];
    int mapHeight = (int)comp.mapGrid.count;
    
    // Cria os nós de tiles e atribui a eles os gráficos respectivos
    // 0 - Grama
    // 1 - Montanha
    // 2 - Terra
    // 3 - Caverna
    for(int y = 0; y < comp.mapGrid.count; y++)
    {
        for(int x = 0; x < [comp.mapGrid[y] count]; x++)
        {
            int tileID = [comp.mapGrid[y][x] intValue];
            
            // Cria o sprite node
            SKSpriteNode *tileNode;
            
            if(tileID == TILE_GRASS)
            {
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-grass"];
            }
            else if(tileID == TILE_MONTAIN)
            {
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-mountain"];
            }
            else if(tileID == TILE_EARTH)
            {
                float tileRotation = 0;
                NSString *tileName = @"tile-earth";
                
                //
                // TESTA TILES ADJACENTES
                //
                int adjency = 0;
                int cornerAdj = 0;
                
                // Em cima
                if(y < mapHeight - 1 && GET_CELL(x, y + 1) == TILE_GRASS)
                {
                    adjency = adjency | DIR_TOP;
                }
                // Em baixo
                if(y > 0 && GET_CELL(x, y - 1) == TILE_GRASS)
                {
                    adjency = adjency | DIR_BOTTOM;
                }
                // Na direita
                if(x < mapWidth - 1 && GET_CELL(x + 1, y) == TILE_GRASS)
                {
                    adjency = adjency | DIR_RIGHT;
                }
                // Na esquerda
                if(x > 0 && GET_CELL(x - 1, y) == TILE_GRASS)
                {
                    adjency = adjency | DIR_LEFT;
                }
                
                // Testa ajacência por cima dos cantos
                // Esquerdo
                if(x > 0)
                {
                    // Inferior
                    if(y > 0 && GET_CELL(x - 1, y - 1) == TILE_GRASS)
                    {
                        cornerAdj = cornerAdj | DIR_LEFT | DIR_BOTTOM;
                    }
                    // Superior
                    if(y < mapHeight - 1 && GET_CELL(x - 1, y + 1) == TILE_GRASS)
                    {
                        cornerAdj = cornerAdj | DIR_LEFT | DIR_TOP;
                    }
                }
                // Direito
                if(x < mapWidth - 1)
                {
                    // Inferior
                    if(y > 0 && GET_CELL(x + 1, y - 1) == TILE_GRASS)
                    {
                        cornerAdj = cornerAdj | DIR_RIGHT | DIR_BOTTOM;
                    }
                    // Superior
                    if(y < mapHeight - 1 && GET_CELL(x + 1, y + 1) == TILE_GRASS)
                    {
                        cornerAdj = cornerAdj | DIR_RIGHT | DIR_TOP;
                    }
                }
                
                //
                // ATUALIZA OS GRÁFICOS
                //
                
                // Testa adjacências
                // [_|]
                if(adjency == (DIR_BOTTOM | DIR_RIGHT))
                {
                    tileName = @"tile-earthTransitionL";
                    tileRotation = 0;
                }
                // [|_]
                else if(adjency == (DIR_BOTTOM | DIR_LEFT))
                {
                    tileName = @"tile-earthTransitionL";
                    tileRotation = -M_PI / 2;
                }
                // [|``]
                else if(adjency == (DIR_TOP | DIR_LEFT))
                {
                    tileName = @"tile-earthTransitionL";
                    tileRotation = M_PI;
                }
                // [``|]
                else if(adjency == (DIR_TOP | DIR_RIGHT))
                {
                    tileName = @"tile-earthTransitionL";
                    tileRotation = M_PI / 2;
                }
                // [__]
                else if(adjency == DIR_BOTTOM)
                {
                    tileName = @"tile-earthTransitionBot";
                }
                // [``]
                else if(adjency == DIR_TOP)
                {
                    tileName = @"tile-earthTransitionBot";
                    tileRotation = -M_PI;
                }
                // [ |]
                else if(adjency == DIR_RIGHT)
                {
                    tileName = @"tile-earthTransitionBot";
                    tileRotation = M_PI / 2;
                }
                // [| ]
                else if(adjency == DIR_LEFT)
                {
                    tileName = @"tile-earthTransitionBot";
                    tileRotation = -M_PI / 2;
                }
                // Adjacências
                // Esquerdo
                else if((cornerAdj & DIR_LEFT) != 0)
                {
                    // Superior
                    if((cornerAdj & DIR_TOP) != 0)
                    {
                        tileName = @"tile-earthTransitionCorner";
                        tileRotation = -M_PI;
                    }
                    // Inferior
                    else if((cornerAdj & DIR_BOTTOM) != 0)
                    {
                        tileName = @"tile-earthTransitionCorner";
                        tileRotation = -M_PI / 2;
                    }
                }
                // Direito
                else if((cornerAdj & DIR_RIGHT) != 0)
                {
                    // Superior
                    if((cornerAdj & DIR_TOP) != 0)
                    {
                        tileName = @"tile-earthTransitionCorner";
                        tileRotation = M_PI / 2;
                    }
                    // Inferior
                    else if((cornerAdj & DIR_BOTTOM) != 0)
                    {
                        tileName = @"tile-earthTransitionCorner";
                        tileRotation = 0;
                    }
                }
                
                
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:tileName];
                tileNode.zRotation = tileRotation;
            }
            else if(tileID == TILE_CAVE)
            {
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-cave"];
            }
            else if(tileID == TILE_CASTLE_EARTH)
            {
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-castle-earth"];
            }
            else if(tileID == TILE_CASTLE_GRASS)
            {
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-castle-grass"];
            }
            else if(tileID == TILE_WATER)
            {
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-water0001"];
            }
            
            //tileNode.anchorPoint = CGPointZero;
            
            tileNode.size = CGSizeMake(64, 64);
            tileNode.position = CGPointMake(x * 64 + 32, y * 64 + 32);
            
            [mapContainer addChild:tileNode];
        }
    }
}

@end
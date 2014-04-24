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

#define GET_CELL(x, y) ([comp.mapGrid[y][x] intValue])

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
    
    int mapWidth = [comp.mapGrid[0] count];
    int mapHeight = comp.mapGrid.count;
    
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
                NSString *tileName = @"tile-earth";
                
                // Testa tiles adjacentes
                int adjency = 0;
                
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
                
                // Testa adjacências
                // _|
                /*if(adjency == (DIR_BOTTOM & DIR_RIGHT))
                {
                    tileName =
                }*/
                
                
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:tileName];
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
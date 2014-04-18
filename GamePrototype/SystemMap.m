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
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-earth"];
            }
            else if(tileID == TILE_CAVE)
            {
                tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"tile-cave"];
            }
            
            tileNode.anchorPoint = CGPointZero;
            
            tileNode.size = CGSizeMake(64, 64);
            tileNode.position = CGPointMake(x * 64, y * 64);
            
            [mapContainer addChild:tileNode];
        }
    }
}

@end
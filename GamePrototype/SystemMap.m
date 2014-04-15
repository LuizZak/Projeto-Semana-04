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

- (void)loadMap
{
    if(entitiesArray.count == 0)
        return;
    
    // Pega o c
    ComponentMapaGrid *comp = (ComponentMapaGrid*)[entitiesArray[0] getComponent:[ComponentMapaGrid class]];
    
    // Pega o node da entidade
    SKNode *mapContainer = [entitiesArray[0] node];
    // Limpa o node do mapa
    [mapContainer removeAllChildren];
    
    // Cria os nós de tiles e atribui a eles os gráficos respectivos
    for(int y = 0; y < comp.mapGrid.count; y++)
    {
        for(int x = 0; x < [comp.mapGrid[x] count]; x++)
        {
            // Cria o sprite node
            SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(64, 64)];
            
            tileNode.position = CGPointMake(x * 64, y * 64);
        }
    }
}

@end
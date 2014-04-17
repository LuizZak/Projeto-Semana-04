//
//  SystemMapMovement.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMapMovement.h"
#import "ComponentMovement.h"
#import "ComponentMapaGrid.h"

@implementation SystemMapMovement

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleComponent([ComponentMovement class]));
        
        self.mapSelector = GPEntitySelectorCreate(GPRuleAnd(GPRuleID(MAP_ID), GPRuleComponent([ComponentMapaGrid class])));
    }
    
    return self;
}

- (BOOL)gameSceneDidAddEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    BOOL ret = [super gameSceneDidAddEntity:gameScene entity:entity];
    
    if([self.mapSelector applyRuleToEntity:entity])
    {
        self.mapEntity = entity;
    }
    
    return ret;
}

- (void)update:(NSTimeInterval)interval
{
    // Movimenta as entidades pela tela
    for (GPEntity *entity in entitiesArray)
    {
        ComponentMovement *mov = (ComponentMovement*)[entity getComponent:[ComponentMovement class]];
        CGPoint point = entity.node.position;
        point.x -= mov.offsetX;
        point.y -= mov.offsetY;
        
        // Checa se a entidade está parada em cima de um grid cell
        if((mov.forceX != 0 || mov.forceY != 0) && fmodf(point.x, 64) == 0 && fmodf(point.y, 64) == 0)
        {
            //NSLog(@"%lf %lf", point.x, point.y);
            
            // Move o personagem para o próximo tile válido
            int ntx = ((int)(point.x / 64) + mov.forceX) * 64 + mov.offsetX;
            int nty = ((int)(point.y / 64) + mov.forceY) * 64 + mov.offsetY;
            
            int gridCellNX = (ntx - mov.offsetX) / 64;
            int gridCellNY = (nty - mov.offsetY) / 64;
            
            // Gira o nó da entidade
            entity.node.zRotation = atan2f(mov.forceY, mov.forceX);
            
            // Checa se o bloco pode ser andado por cima
            if([self walkable:gridCellNX y:gridCellNY])
            {
                // Cria um SKAction para mover o nó da entidade
                SKAction *moveAction = [SKAction moveTo:CGPointMake(ntx, nty) duration:0.25f];
                [entity.node runAction:moveAction];
            }
        }
        
        mov.forceX = 0;
        mov.forceY = 0;
        
        // Aplica a fricção
        /*mov.velX *= mov.frictionX;
        mov.velY *= mov.frictionY;
        
        // Acumula a força na velocidade
        mov.velX += mov.forceX;
        mov.velY += mov.forceY;
        // Zera a força
        mov.forceX = 0;
        mov.forceY = 0;
        
        entity.node.position = CGPointMake(entity.node.position.x + mov.velX, entity.node.position.y + mov.velY);*/
    }
}

- (BOOL)walkable:(int)x y:(int)y
{
    ComponentMapaGrid *mapGrid = (ComponentMapaGrid*)[self.mapEntity getComponent:[ComponentMapaGrid class]];
    
    // Checagem de bounds do mapa
    if(x < 0 || y < 0 || y >= mapGrid.mapGrid.count || x >= [mapGrid.mapGrid[y] count])
        return NO;
    
    // Checagem de terreno
    if(mapGrid != nil)
        return [mapGrid.mapGrid[y][x] intValue] == 0;
    else
        return NO;
}

@end
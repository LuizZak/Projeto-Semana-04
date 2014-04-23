//
//  SystemMapMovement.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMapMovement.h"
#import "ComponentMapMovement.h"
#import "ComponentMapaGrid.h"

@implementation SystemMapMovement

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleComponent([ComponentMapMovement class]));
        
        self.mapSelector = GPEntitySelectorCreate(GPRuleAnd(GPRuleID(MAP_ID), GPRuleComponent([ComponentMapaGrid class])));
    }
    
    return self;
}

- (BOOL)testEntityToAdd:(GPEntity *)entity
{
    BOOL ret = [super testEntityToAdd:entity];
    
    if([self.mapSelector applyRuleToEntity:entity])
    {
        self.mapEntity = entity;
    }
    
    return ret;
}

- (void)update:(NSTimeInterval)interval
{
    ComponentMapaGrid *mapGrid = (ComponentMapaGrid*)[self.mapEntity getComponent:[ComponentMapaGrid class]];
    
    // Movimenta as entidades pela tela
    for (GPEntity *entity in entitiesArray)
    {
        ComponentMapMovement *mov = (ComponentMapMovement*)[entity getComponent:[ComponentMapMovement class]];
        CGPoint point = entity.node.position;
        point.x -= mov.offsetX;
        point.y -= mov.offsetY;
        
        // Checa se a entidade está parada em cima de um grid cell
        if(!mov.moving && (mov.forceX != 0 || mov.forceY != 0) && fmodf(point.x, 64) == 0 && fmodf(point.y, 64) == 0)
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
                // Notifica o delegate
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(systemMapMovement:entity:willWalkTo:tileID:)])
                {
                    [self.delegate systemMapMovement:self entity:entity willWalkTo:CGPointMake(gridCellNX, gridCellNY) tileID:[mapGrid.mapGrid[gridCellNX][gridCellNY] intValue]];
                }
                
                // Cria um SKAction para mover o nó da entidade
                SKAction *moveAction = [SKAction moveTo:CGPointMake(ntx, nty) duration:0.25f];
                
                // Adiciona um block para executar o delegate após o movimento do nó
                if(self.delegate != nil && [self.delegate respondsToSelector:@selector(systemMapMovement:entity:didWalkTo:tileID:)])
                {
                    int tileID = [mapGrid.mapGrid[gridCellNY][gridCellNX] intValue];
                    moveAction = [SKAction sequence:@[moveAction, [SKAction runBlock:^(void) {
                        [self.delegate systemMapMovement:self entity:entity didWalkTo:CGPointMake(gridCellNX, gridCellNY) tileID:tileID];
                        
                        mov.moving = NO;
                    }]]];
                }
                
                // Atualiza a posição no grid da entidade
                mov.currentGridX = gridCellNX;
                mov.currentGridY = gridCellNY;
                
                [entity.node runAction:moveAction];
                
                mov.moving = YES;
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
    
    int tileID = [mapGrid.mapGrid[y][x] intValue];
    
    // Checagem de entidades
    for(GPEntity *entity in entitiesArray)
    {
        ComponentMapMovement *comp = (ComponentMapMovement*)[entity getComponent:[ComponentMapMovement class]];
        
        if(comp.blocksOtherEntities && comp.currentGridX == x && comp.currentGridY == y)
        {
            return NO;
        }
    }
    
    // Checagem de terreno
    if(mapGrid != nil)
        return tileID == TILE_GRASS || tileID == TILE_EARTH || tileID == TILE_WATER || tileID == TILE_CAVE || tileID == TILE_CASTLE_EARTH || tileID == TILE_CASTLE_GRASS;
    else
        return NO;
}

@end
//
//  SystemMApMovement.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMapMovement.h"
#import "ComponentMovement.h"

@implementation SystemMapMovement

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleComponent([ComponentMovement class]));
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    // Movimenta as entidades pela tela
    for (GPEntity *entity in entitiesArray)
    {
        ComponentMovement *mov = (ComponentMovement*)[entity getComponent:[ComponentMovement class]];
        CGPoint point = entity.node.position;
        
        // Checa se a entidade está parada em cima de um grid cell
        if((mov.forceX != 0 || mov.forceY) && fmodf(point.x, 64) == 0 && fmodf(point.y, 64) == 0)
        {
            NSLog(@"%lf %lf", point.x, point.y);
            
            // Move o personagem para o próximo tile válido
            int ntx = ((int)(point.x / 64) + mov.forceX) * 64;
            int nty = ((int)(point.y / 64) + mov.forceY) * 64;
            
            // Cria um SKAction para mover o tile
            SKAction *moveAction = [SKAction moveTo:CGPointMake(ntx, nty) duration:0.2f];
            
            [entity.node runAction:moveAction];
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

@end
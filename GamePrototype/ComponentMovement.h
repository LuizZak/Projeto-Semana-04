//
//  ComponentMovement.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

@interface ComponentMovement : GPComponent

// A direção que a entidade está virada
@property int facingDirection;

// Offset horizontal para aplicar no nó
@property float offsetX;
// Offset vertical para aplicar no nó
@property float offsetY;

// A fricção horizontal da entidade
@property float frictionX;
// A fricção vertical da entidade
@property float frictionY;

// A força horizontal atual da entidade
@property float forceX;
// A força vertical atual da entidade
@property float forceY;

// A velocidade horizontal da entidade
@property float velX;
// A velocidade vertical da entidade
@property float velY;

@end
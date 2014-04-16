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

// A velocidade horizontal da entidade
@property float velX;
// A velocidade vertical da entidade
@property float velY;

@end
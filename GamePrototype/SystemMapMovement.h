//
//  SystemMapMovement.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
#import "CommonImports.h"

// Protocolo do sistema de movimento de mapa
@class SystemMapMovement;
@protocol SystemMapMovementDelegate <NSObject>

@optional

// Indica que uma entidade vai passar por cima do tile especificado
- (void)systemMapMovement:(SystemMapMovement*)system entity:(GPEntity*)entity willWalkTo:(CGPoint)point;

@end

// Sistema de movimento que movimenta as entidades baseado em um mapa de tiles
@interface SystemMapMovement : GPSystem

// Delegate do mapa
@property id<SystemMapMovementDelegate> delegate;

@property GPEntitySelector *mapSelector;

@property GPEntity *mapEntity;

@end
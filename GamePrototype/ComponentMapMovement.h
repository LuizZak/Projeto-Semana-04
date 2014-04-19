//
//  ComponentMapMovement.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 19/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentMovement.h"

// Componente de movimentação em mapa
@interface ComponentMapMovement : ComponentMovement

// A posição X no grid do mapa
@property int currentGridX;
// A posição Y no grid do mapa
@property int currentGridY;

// Se a entidade deve bloquear outras entidades que se movimentam via mapa
@property BOOL blocksOtherEntities;

@end
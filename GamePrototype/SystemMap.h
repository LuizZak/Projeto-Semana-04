//
//  SystemMap.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 15/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"

// Sistema de mapa
@interface SystemMap : GPSystem

// Entidade que guarda o mapa
@property GPEntity *mapEntity;

// Atualiza o grid
- (void)updateGrid;

@end
//
//  SystemHealthIndicator.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 09/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"

// Encapsula uma barra de life e sua entidade correspondente
@interface LifeBar : NSObject

// A representação da barra de vida na tela
@property GPEntity *healthBar;
// A entidade que a barra de vida está representando
@property GPEntity *entity;

@end

// Sistema Health Indicator, serve para mostrar uma barra de vida em cima de entidades com vida
@interface SystemHealthIndicator : GPSystem

// Array de objetos LifeBar
@property NSMutableArray *lifeBarsArray;

@end
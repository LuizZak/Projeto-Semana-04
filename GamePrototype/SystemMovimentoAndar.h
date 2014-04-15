//
//  SystemMovimentoAndar.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
#import "CommonImports.h"

@interface SystemMovimentoAndar : GPSystem

// List of enemies
@property GPEntitySelector *enemySelector;
@property NSMutableArray *enemiesArray;

// The place touched
@property CGPoint selectedPlace;

@end

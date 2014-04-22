//
//  AttackDrag.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
#import "CommonImports.h"

@interface SystemAttackDrag : GPSystem

// List of enemies
@property GPEntitySelector *enemySelector;
@property NSMutableArray *enemiesArray;

// Player selector
@property GPEntitySelector *playerSelector;
@property GPEntity *playerEntity;

// Current skill being dragged
@property CGPoint dragOffset;
@property GPEntity *currentDrag;

@property BOOL inBattle;

@end
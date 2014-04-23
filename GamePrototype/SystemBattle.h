//
//  AttackDrag.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
#import "CommonImports.h"

@interface SystemBattle : GPSystem

// List of enemies
@property GPEntitySelector *enemySelector;
@property NSMutableArray *enemiesArray;

// Player selector
@property GPEntitySelector *playerSelector;
@property GPEntity *playerEntity;

// AI Selector
@property GPEntitySelector *AISelector;

// Attacks selector
@property GPEntitySelector *attacksSelector;

// Current skill being dragged
@property CGPoint dragOffset;
@property GPEntity *currentDrag;

// Nó sendo utilizado para demarcar a skill selecionada atualmente
@property SKSpriteNode *selectionNode;

// Se a batalha está acontecendo
@property BOOL inBattle;

// Se o jogador pode apertar a tela para voltar ao mapa
@property BOOL tapToExit;

// Se o jogador ganhou a batalha
@property BOOL didWonBattle;

@end
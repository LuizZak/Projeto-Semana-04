//
//  BattleResult.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 28/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>

// Guarda resultados de uma batalha
@interface BattleResult : NSObject

// A posição X do mapa onde a batalha foi travada
@property int gridX;

// A posição Y do mapa onde a batalha foi travada
@property int gridY;

// O XP que o jogador ganhou da batalha
@property int bountyXP;
// O gold que o jogador ganhou da batalha
@property int bountyGold;

// Se o jogador ganhou a batalha
@property BOOL didWon;

@end
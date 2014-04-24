//
//  GameController.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentDraggableAttack.h"

// Protocolo para recebimento de notificações de eventos do jogo (subir de nível, ganhar skills novas, etc.)
@protocol GameControllerObserver <NSObject>

// Notifica que o jogador ganhou uma quantidade de XP
- (void)gameControllerDidWinXP:(int)xp;

// Notifica que o jogador subiu de nível
- (void)gameControllerDidWinLevel:(int)oldLevel newLevel:(int)newLevel;

// Notifica que o jogador recebeu as skills especificadas na array
- (void)gameControllerDidUnlockSkills:(NSMutableArray*)skills;

@end

// Singleton que controla o progresso do jogo
@interface GameController : NSObject
{
    // Array de observers de eventos
    NSMutableArray *observers;
}

// Pega uma instância do controller
+ (GameController*)gameController;

// Adiciona um objeto como observer de eventos do jogo
- (void)addObserver:(id<GameControllerObserver>)observer;

// Remove um objeto como observer de eventos do jogo
- (void)removeObserver:(id<GameControllerObserver>)observer;

// Dá uma qunatidade de XP para o player
- (void)givePlayerXP:(int)xp;

@end
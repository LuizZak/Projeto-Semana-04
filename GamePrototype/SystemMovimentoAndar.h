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
@property GPEntitySelector *mapSelector;
@property GPEntity *mapEntity;

// The place touched
@property CGPoint selectedPlace;
// O ponto em que o usuário está com o dedo agora
@property CGPoint currentPoint;

// Raio do deadzone do controle
@property float deadZone;

// Se o usuário está segurando o touch
@property BOOL holdingTouch;

// Cria a imagem do Dpad
@property SKSpriteNode* dPad;

@end

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

// The place touched
@property CGPoint selectedPlace;

// O ponto em que o usuário está com o dedo agora
@property CGPoint currentPoint;

// Raio do deadzone do controle
@property float deadZone;

// Se o usuário está segurando o touch
@property BOOL holdingTouch;

// Cria a imagem do Dpad
@property SKSpriteNode *dPad;

// Textura do DPad normal
@property SKTexture *textureDPad;

// Textura do DPad pressionado
@property SKTexture *textureDPadPressed;

//  Sprite node pra vver onde ele clicou
@property SKSpriteNode* recognizer;

@end
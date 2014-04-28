//
//  SceneRanking.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 25/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GamePrototype.h"

@interface SceneRanking : GPGameScene

// Barra do ranking
@property SKSpriteNode* cell;

// Score do jogador
@property SKLabelNode* pontuacao;

// Botão de voltar
@property SKSpriteNode* btnVoltar;

// Imagem de fundo
@property SKSpriteNode* background;

@end

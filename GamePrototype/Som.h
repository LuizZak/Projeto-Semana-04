//
//  Som.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 23/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
@import AVFoundation;

@interface Som : NSObject

+ (Som *) som;

// AudioPlayer
@property (nonatomic) AVAudioPlayer * som;

// Som do ataque inimigo de corpo a corpo
- (void)tocarSomEspada;

// Som da explosão da bola de fogo
- (void)tocarSomExplosao;

// Som da bola de fogo
- (void)tocarSomFireBall;

// Som de quando o Dragão morre
- (void)tocarSomMorteDragao;

// Sons de quando os inimigos morrem
- (void)tocarSomMorteHomem;

// Som de derrota
- (void)tocarSomGameOver;

// Som de vitoria
- (void)tocarSomVitoria;

// Som de fundo so mundo
- (void)tocarSomMundo;

// Som de fundo so mundo
- (void)tocarSomBatalha;

@end

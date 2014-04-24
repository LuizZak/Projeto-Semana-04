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
- (AVAudioPlayer *)tocarSomEspada;

// Som da explosão da bola de fogo
- (AVAudioPlayer *)tocarSomExplosao;

// Som da bola de fogo
- (AVAudioPlayer *)tocarSomFireBall;

// Som de quando o Dragão morre
- (AVAudioPlayer *)tocarSomMorteDragao;

// Sons de quando os inimigos morrem
- (AVAudioPlayer *)tocarSomMorteHomem;

// Som de derrota
- (AVAudioPlayer *)tocarSomGameOver;

// Som de vitoria
- (AVAudioPlayer *)tocarSomVitoria;

// Som de fundo so mundo
- (AVAudioPlayer *)tocarSomMundo;

// Som de fundo so mundo
- (AVAudioPlayer *)tocarSomBatalha;

@end

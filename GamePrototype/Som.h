//
//  Som.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 23/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
@import AVFoundation;

@interface Som : GPSystem

+ (Som *) som;

// AudioPlayer
@property (nonatomic) AVAudioPlayer * som;

- (void)tocarSomEspada;

- (void)tocarSomExplosao;

- (void)tocarSomFireBall;

- (void)tocarSomMorteDragao;

- (void)tocarSomMorteHomem;

@end

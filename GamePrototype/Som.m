//
//  Som.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 23/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "Som.h"

@implementation Som

// Cria o singleton
+ (Som *) som
{
    static Som *som = nil;
    if (!som)
    {
        som = [[super allocWithZone:nil] init];
    }
    return som;
}

// Nao deixa que ele crie outra variavel gamedata
+ (id)allocWithZone: (struct _NSZone *)zone
{
    return [self som];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Dá um preload dos sons
        [SKAction playSoundFileNamed:@"Espada.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"Explosao.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"fireBall.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"DragaoMorrendo.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"HomemMorrendo1.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"HomemMorrendo2.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"HomemMorrendo3.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"gameOver.wav" waitForCompletion:NO];
        [SKAction playSoundFileNamed:@"Vitoria.wav" waitForCompletion:NO];
    }
    return self;
}

// Som do ataque inimigo de corpo a corpo
- (AVAudioPlayer *)tocarSomEspada
{
    //return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"Espada" withExtension:@"wav"]:NO];
    
    [self.nodeForSound runAction:[SKAction playSoundFileNamed:@"Espada.wav" waitForCompletion:NO]];
    
    return nil;
}

// Som da explosão da bola de fogo
- (AVAudioPlayer *)tocarSomExplosao
{
    //return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"Explosao" withExtension:@"wav"]:NO];
    
    [self.nodeForSound runAction:[SKAction playSoundFileNamed:@"Explosao.wav" waitForCompletion:NO]];
    
    return nil;
}

// Som da bola de fogo
- (AVAudioPlayer *)tocarSomFireBall
{
    //return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"fireBall" withExtension:@"wav"]:NO];
    
    [self.nodeForSound runAction:[SKAction playSoundFileNamed:@"fireBall.wav" waitForCompletion:NO]];
    
    return nil;
}

// Som de quando o Dragão morre
- (AVAudioPlayer *)tocarSomMorteDragao
{
    //return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"DragaoMorrendo" withExtension:@"wav"]:NO];
    
    [self.nodeForSound runAction:[SKAction playSoundFileNamed:@"DragaoMorrendo.wav" waitForCompletion:NO]];
    
    return nil;
}

// Sons de quando os inimigos morrem
- (AVAudioPlayer *)tocarSomMorteHomem
{
    int random = arc4random() % 3;
    
    if(random == 0)
    {
        //return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"HomemMorrendo1" withExtension:@"wav"]:NO];
        [self.nodeForSound runAction:[SKAction playSoundFileNamed:@"HomemMorrendo1.wav" waitForCompletion:NO]];
    }
    else if(random == 1)
    {
        //return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"HomemMorrendo2" withExtension:@"wav"]:NO];
        [self.nodeForSound runAction:[SKAction playSoundFileNamed:@"HomemMorrendo2.wav" waitForCompletion:NO]];
    }
    else if(random == 2)
    {
        //return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"HomemMorrendo3" withExtension:@"wav"]:NO];
        [self.nodeForSound runAction:[SKAction playSoundFileNamed:@"HomemMorrendo3.wav" waitForCompletion:NO]];
    }
    
    return 0;
}

// Som de derrota
- (AVAudioPlayer *)tocarSomGameOver
{
    return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"gameOver" withExtension:@"wav"]:NO];
}

// Som de vitoria
- (AVAudioPlayer *)tocarSomVitoria
{
    return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"Vitoria" withExtension:@"wav"]:NO];
}

// Som de fundo so mundo
- (AVAudioPlayer *)tocarSomMundo
{
    return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"MundoMusica" withExtension:@"wav"]:YES];
}

// Som de fundo so mundo
- (AVAudioPlayer *)tocarSomBatalha
{
    return [self tocarSom:[[NSBundle mainBundle] URLForResource:@"BatalhaMusica" withExtension:@"wav"]:YES];
}

// Metodo que toca os sons
- (AVAudioPlayer *)tocarSom:(NSURL*)URL :(BOOL)loop
{
    NSError *error;
    self.som = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
    if (loop)
        self.som.numberOfLoops = -1;
    else
        self.som.numberOfLoops = 1;
    [self.som prepareToPlay];
    [self.som play];
    
    return self.som;
}

@end

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
    }
    return self;
}

- (void)tocarSomEspada
{
    [self tocarSom:[[NSBundle mainBundle] URLForResource:@"Espada" withExtension:@"wav"]:NO];
}

- (void)tocarSomExplosao
{
    [self tocarSom:[[NSBundle mainBundle] URLForResource:@"Explosao" withExtension:@"wav"]:NO];
}

- (void)tocarSomFireBall
{
    [self tocarSom:[[NSBundle mainBundle] URLForResource:@"fireBall" withExtension:@"wav"]:NO];
}

- (void)tocarSomMorteDragao
{
    [self tocarSom:[[NSBundle mainBundle] URLForResource:@"DragaoMorrendo" withExtension:@"wav"]:NO];
}

- (void)tocarSomMorteHomem
{
    int random = arc4random() % 3;
    
    if(random == 0)
    {
        [self tocarSom:[[NSBundle mainBundle] URLForResource:@"HomemMorrendo1" withExtension:@"wav"]:NO];
    }else if(random == 1)
    {
        [self tocarSom:[[NSBundle mainBundle] URLForResource:@"HomemMorrendo2" withExtension:@"wav"]:NO];
    }else if(random == 2)
    {
        [self tocarSom:[[NSBundle mainBundle] URLForResource:@"HomemMorrendo3" withExtension:@"wav"]:NO];
    }
}

- (void)tocarSom:(NSURL*)URL :(BOOL)loop
{
    NSError *error;
    self.som = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
    if (loop)
        self.som.numberOfLoops = -1;
    else
        self.som.numberOfLoops = 1;
    [self.som prepareToPlay];
    [self.som play];
}

@end

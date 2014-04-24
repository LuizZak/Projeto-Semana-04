//
//  Score.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "Score.h"

@implementation Score

- (id)initWithNome: (NSString *)nome pontos: (int)pontos
{
    self = [super init];
    if (self) {
        [self setPontos:pontos];
        [self setNome:nome];
    }
    return self;
}

@end

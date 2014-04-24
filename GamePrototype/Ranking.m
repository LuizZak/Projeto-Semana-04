//
//  Ranking.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "Ranking.h"
#import "Score.h"

@implementation Ranking

+(Ranking *) lista
{
    static Ranking *lista = nil;
    if (!lista)
    {
        lista = [[super allocWithZone:nil] init];
    }
    return lista;
}

+(id) allocWithZone: (struct _NSZone *)zone
{
    return [self lista];
}

- (id)init
{
    self = [super init];
    if (self) {
        tudo = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSMutableArray *)todosItens
{
    return tudo;
}

-(Score *) criarPontuacao :(NSString *)nome :(int)ponto
{
    Score *s = [[Score alloc] initWithNome:nome pontos:ponto];
    
    [tudo addObject: s];
    
    [self ordenar];
    
    return s;
}

-(void)ordenar
{
    for (int i = 0; i < [[[Ranking lista] todosItens] count]; i++)
    {
        for (int j = i+1; j < [[[Ranking lista] todosItens] count]; j++)
        {
            if ([[[[Ranking lista] todosItens] objectAtIndex:i] pontos] < [[[[Ranking lista] todosItens] objectAtIndex:j] pontos])
            {
                [[[Ranking lista] todosItens] insertObject:[[[Ranking lista] todosItens] objectAtIndex:j] atIndex:i];
                [[[Ranking lista] todosItens]removeObjectAtIndex:j+1];
            }
        }
    }
}

-(void)removePontuacao: (Ranking *)s
{
    [tudo removeObjectIdenticalTo:s];
}

-(void) moveItemAtIndex: (int)from toIndex:(int)to
{
    if (from == to)
    {
        return;
    }
    Ranking *s = [tudo objectAtIndex:from];
    
    [tudo removeObjectAtIndex:from];
    
    [tudo insertObject: s atIndex: to];
}

@end

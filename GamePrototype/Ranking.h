//
//  Ranking.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Score;
@interface Ranking : NSObject
{
    NSMutableArray *tudo;
}

@property NSString* currentPlayerName;
@property int currentPlayerScore;

+(Ranking *) lista;

-(NSMutableArray *) todosItens;
-(Score *) criarPontuacao :(NSString *)nome :(int)ponto;

-(void)removePontuacao: (Score *)s;
-(void) moveItemAtIndex: (int)from toIndex:(int)to;

@end

//
//  Score.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject

@property int pontos;
@property NSString* nome;

- (id)initWithNome: (NSString *)nome pontos: (int)pontos;

@end

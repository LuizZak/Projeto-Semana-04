//
//  System.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPGameScene.h"

@class GPGameScene;
// Representa um sistema, que possui a lógica para aplicar os comportamentos a entidades no sistema
@interface GPSystem : NSObject <GPGameSceneNotifier>
{
    // Seletor de entidade de conveniência usada para filtrar as entidades que este sistema possui
    GPEntitySelector *selector;
    // Array interna de entidades que este sistema controla
    NSMutableArray *entitiesArray;
}

// A cena que contém este sistema
@property GPGameScene *gameScene;

// Inicia esta instância de sistema com a cena fornecida
- (id)initWithGameScene:(GPGameScene*)gameScene;

// Chamado pela cena, para atualizar o sistema
- (void)update:(NSTimeInterval)interval;

@end
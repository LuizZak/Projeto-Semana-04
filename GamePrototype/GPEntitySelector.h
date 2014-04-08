//
//  GPEntitySelector.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GPEntity.h"

// Define uma regrapara o seletor de entidades
@interface GPSelectorRule : NSObject

// Aplica a regra atual para a entidade fornecida e retorna se a entidade
// passou na regra ou não
- (BOOL)applyRule:(GPEntity*)entity;

@end

// Define um seletor usado para selecionar entidades numa GameScene
@interface GPEntitySelector : SKNode
{
    GPSelectorRule *baseRule;
}

// Inicia uma nova instância da classe GPEntitySelector com a regra de seleção fornecida
- (id)initWithRule:(GPSelectorRule*)rule;

// Aplica a regra to selecionador atual na lista de entidades fornecida, e retorna
// uma nova array contendo as entidades que passaram na regra de seleção
- (NSArray*)applyRuleToArray:(NSArray*)entitiesArray;

// Aplica a regra do selecionador atual na entidade fornecida, e retorna se a
// entidade passou na regra ou não
- (BOOL)applyRuleToEntity:(GPEntity*)entity;

@end

// Funções estruturadas relacionadas são definidas a partir daqui
GPEntitySelector* GPEntitySelectorCreate(GPSelectorRule* rule);
//
//  GPSelectorRules.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPEntitySelector.h"

// Define algumas subclasses da classe GPSelectorRule
@interface GPSRNone : NSObject

// Aplica a regra atual para a entidade fornecida e retorna se a entidade
// passou na regra ou não
- (BOOL)applyRule:(GPEntity*)entity;

@end

@interface GPSRComponentSelector : GPSelectorRule

// Classe do componente para selecionar
@property Class componentClass;

@end

@interface GPSRIDSelector : GPSelectorRule

// ID da entidade para selecionar
@property entityid_t ID;

@end

@interface GPSRTypeSelector : GPSelectorRule

// Tipo da entidade para selecionar
@property entitytype_t type;

@end

@interface GPSRAndSelector : GPSelectorRule

// Define a primeira regra do selecionador AND
@property GPSelectorRule *firstRule;
// Define a segunda regra do selecionador AND
@property GPSelectorRule *secondRule;

@end

@interface GPSROrSelector : GPSelectorRule

// Define a primeira regra do selecionador OR
@property GPSelectorRule *firstRule;
// Define a segunda regra do selecionador OR
@property GPSelectorRule *secondRule;

@end

@interface GPSRNotSelector : GPSelectorRule

// Define a primeira regra do selecionador NOT
@property GPSelectorRule *rule;

@end

// Funções estruturadas relacionadas são definidas a partir daqui
GPSelectorRule* GPRuleAll();
GPSelectorRule* GPRuleNone();
GPSelectorRule* GPRuleComponent(Class componentClass);
GPSelectorRule* GPRuleID(entityid_t ID);
GPSelectorRule* GPRuleType(entitytype_t type);
GPSelectorRule* GPRuleOr(GPSelectorRule *rule1, GPSelectorRule *rule2);
GPSelectorRule* GPRuleAnd(GPSelectorRule *rule1, GPSelectorRule *rule2);
GPSelectorRule* GPRuleNot(GPSelectorRule *rule);
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
@interface GPSRComponentSelector : GPSelectorRule

// Classe do componente para selecionar
@property Class componentClass;

@end

@interface GPSRIDSelector : GPSelectorRule

// ID da entidade para selecionar
@property int ID;

@end

@interface GPSRTypeSelector : GPSelectorRule

// Tipo da entidade para selecionar
@property int type;

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
GPSelectorRule* GPRuleComponent(Class componentClass);
GPSelectorRule* GPRuleID(int ID);
GPSelectorRule* GPRuleType(int type);
GPSelectorRule* GPRuleOr(GPSelectorRule *rule1, GPSelectorRule *rule2);
GPSelectorRule* GPRuleAnd(GPSelectorRule *rule1, GPSelectorRule *rule2);
GPSelectorRule* GPRuleNot(GPSelectorRule *rule);
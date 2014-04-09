//
//  GPSelectorRules.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSelectorRules.h"

@implementation GPSRComponentSelector

- (BOOL)applyRule:(GPEntity *)entity
{
    // Checa se a entidade contém o componente passado
    return [entity hasComponent:self.componentClass];
}

@end

@implementation GPSRIDSelector

- (BOOL)applyRule:(GPEntity *)entity
{
    // Checa se o ID da entidade bate com o ID passado
    return entity.ID == self.ID;
}

@end

@implementation GPSRTypeSelector

- (BOOL)applyRule:(GPEntity *)entity
{
    // Checa se o tipo da entidade bate com o tipo passado
    return (entity.type & self.type) != 0;
}

@end

@implementation GPSRAndSelector

- (BOOL)applyRule:(GPEntity *)entity
{
    return [self.firstRule applyRule:entity] && [self.secondRule applyRule:entity];
}

@end

@implementation GPSROrSelector

- (BOOL)applyRule:(GPEntity *)entity
{
    return [self.firstRule applyRule:entity] || [self.secondRule applyRule:entity];
}

@end

@implementation GPSRNotSelector

- (BOOL)applyRule:(GPEntity *)entity
{
    return ![self.rule applyRule:entity];
}

@end

// Funções estruturadas relacionadas são definidas a partir daqui
GPSelectorRule* GPRuleAll()
{
    return [[GPSelectorRule alloc] init];
}
GPSelectorRule* GPRuleComponent(Class componentClass)
{
    GPSRComponentSelector *sel = [[GPSRComponentSelector alloc] init];
    sel.componentClass = componentClass;
    return sel;
}
GPSelectorRule* GPRuleID(entityid_t ID)
{
    GPSRIDSelector *sel = [[GPSRIDSelector alloc] init];
    sel.ID = ID;
    return sel;
}
GPSelectorRule* GPRuleType(entitytype_t type)
{
    GPSRTypeSelector *sel = [[GPSRTypeSelector alloc] init];
    sel.type = type;
    return sel;
}
GPSelectorRule* GPRuleAnd(GPSelectorRule *rule1, GPSelectorRule *rule2)
{
    GPSRAndSelector *sel = [[GPSRAndSelector alloc] init];
    sel.firstRule = rule1;
    sel.secondRule = rule2;
    return sel;
}
GPSelectorRule* GPRuleOr(GPSelectorRule *rule1, GPSelectorRule *rule2)
{
    GPSROrSelector *sel = [[GPSROrSelector alloc] init];
    sel.firstRule = rule1;
    sel.secondRule = rule2;
    return sel;
}
GPSelectorRule* GPRuleNot(GPSelectorRule *rule)
{
    GPSRNotSelector *sel = [[GPSRNotSelector alloc] init];
    sel.rule = rule;
    return sel;
}
//
//  GPEntitySelector.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPEntitySelector.h"

@implementation GPSelectorRule

// Por padrão, esta regra sempre retorna YES
- (BOOL)applyRule:(GPEntity *)entity
{
    return YES;
}

@end

@implementation GPEntitySelector

- (id)initWithRule:(GPSelectorRule*)rule
{
    self = [super init];
    if (self)
    {
        baseRule = rule;
    }
    return self;
}

- (NSArray*)applyRuleToArray:(NSArray *)entitiesArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for(GPEntity *entity in entitiesArray)
    {
        if([self applyRuleToEntity:entity])
            [array addObject:entity];
    }
    
    return array;
}

- (BOOL)applyRuleToEntity:(GPEntity *)entity
{
    return [baseRule applyRule:entity];
}

@end

// Funções estruturadas relacionadas são definidas a partir daqui
GPEntitySelector* GPEntitySelectorCreate(GPSelectorRule* rule)
{
    return [[GPEntitySelector alloc] initWithRule:rule];
}
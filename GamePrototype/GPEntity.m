//
//  Entity.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPEntity.h"

@implementation GPEntity

- (id)initWithNode:(SKNode*)node
{
    self = [super init];
    if (self)
    {
        components = [NSMutableArray array];
        targetNode = node;
    }
    return self;
}

- (SKNode*)node
{
    return targetNode;
}

- (void)addComponent:(GPComponent*)component
{
    [components addObject:component];
}
- (void)removeComponent:(GPComponent*)component
{
    [components removeObject:component];
}

- (id)getComponent:(Class)componentClass
{
    for(GPComponent *component in components)
    {
        if([component isKindOfClass:componentClass])
            return component;
    }
    
    return nil;
}

- (NSArray*)getComponents:(Class)componentClass
{
    NSMutableArray *array = [NSMutableArray array];
    
    for(GPComponent *component in components)
    {
        if([component isKindOfClass:componentClass])
            [array addObject:component];
    }
    
    return array;
}

- (BOOL)hasComponent:(Class)componentClass
{
    return [self getComponent:componentClass] != nil;
}

- (void)removeComponentsWithClass:(Class)componentClass
{
    GPComponent *comp = [self getComponent:componentClass];
    
    while (comp != nil)
    {
        [self removeComponent:comp];
        comp = [self getComponent:componentClass];
    }
}

@end
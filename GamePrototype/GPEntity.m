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

- (GPComponent*)getComponent:(Class)componentClass
{
    for(GPComponent *component in components)
    {
        if([component isKindOfClass:componentClass])
            return component;
    }
    
    return nil;
}

- (BOOL)hasComponent:(Class)componentClass
{
    return [self getComponent:componentClass] != nil;
}

@end
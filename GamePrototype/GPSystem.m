//
//  System.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"

@implementation GPSystem

- (id)initWithGameScene:(GPGameScene*)gameScene
{
    self = [super init];
    if (self)
    {
        // Inicia a regra com o seletor padrão (todos)
        selector = GPEntitySelectorCreate(GPRuleAll());
        entitiesArray = [NSMutableArray array];
        self.gameScene = gameScene;
    }
    return self;
}

- (BOOL)gameSceneDidAddEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    if([self testEntityToAdd:entity])
    {
        [entitiesArray addObject:entity];
        return YES;
    }
    
    return NO;
}

- (BOOL)gameSceneDidRemoveEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    if([self testEntityToRemove:entity])
    {
        [entitiesArray removeObject:entity];
    }
    
    return YES;
}

- (void)willAddToScnee:(GPGameScene*)gameScene
{
    
}
- (void)didAddToScene
{
    
}
- (void)willRemoveFromScene
{
    
}
- (void)didRemoveFromScene
{
    // Remove as referências as entidades ligadas
    [entitiesArray removeAllObjects];
}

- (void)update:(NSTimeInterval)interval
{
    
}
- (void)didEvaluateActions
{
    
}
- (void)didSimulatePhysics
{
    
}

- (void)reloadEntities:(NSArray *)array
{
    [entitiesArray removeAllObjects];
    
    for(GPEntity *entity in array)
    {
        if([self testEntityToAdd:entity])
        {
            [entitiesArray addObject:entity];
        }
    }
}

- (void)entityModified:(GPEntity *)entity
{
    if([entitiesArray containsObject:entity])
    {
        // Testa se a entidade não cabe mais ao selector
        if(![selector applyRuleToEntity:entity] && [self testEntityToRemove:entity])
        {
            [entitiesArray removeObject:entity];
        }
    }
    // Adiciona a entidade se ela passar no selector
    else if([self testEntityToAdd:entity])
    {
        [entitiesArray addObject:entity];
    }
}

- (BOOL)testEntityToAdd:(GPEntity*)entity
{
    return [selector applyRuleToEntity:entity];
}
- (BOOL)testEntityToRemove:(GPEntity*)entity
{
    return [entitiesArray containsObject:entity];
}

@end
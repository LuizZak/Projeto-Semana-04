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
    if([selector applyRuleToEntity:entity])
    {
        [entitiesArray addObject:entity];
        return YES;
    }
    
    return NO;
}

- (BOOL)gameSceneDidRemoveEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    [entitiesArray removeObject:entity];
    
    return YES;
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
        if([selector applyRuleToEntity:entity])
        {
            [entitiesArray addObject:entity];
        }
    }
}

@end
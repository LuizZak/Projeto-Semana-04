//
//  ActionCollection.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionCollection.h"

@implementation ActionCollection

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.actionList = [NSMutableArray array];
    }
    return self;
}

/// Adds an action to this ActionCollection
- (void)addAction:(BattleAction*)action
{
    [self.actionList addObject:action];
}

/// Removes an action from this ActionCollection
- (void)removeAction:(BattleAction*)action
{
    [self.actionList removeObject:action];
}

/// Clears this list of actions
- (void)clearList
{
    self.actionList = [NSMutableArray array];
}

/// Returns a list of actions that match the given battle action type
- (ActionCollection*)actionsForType:(BattleActionType)actionType
{
    ActionCollection *col = [[ActionCollection alloc] init];
    NSMutableArray *ret = [NSMutableArray array];
    
    for (BattleAction *action in self.actionList)
    {
        if(action.actionType == actionType)
        {
            [ret addObject:action];
        }
    }
    
    col.actionList = ret;
    return col;
}

/// Returns a list of actions that can be targeted on a given target type
- (ActionCollection*)actionsForTargetType:(BattleActionTarget)actionTarget;
{
    ActionCollection *col = [[ActionCollection alloc] init];
    NSMutableArray *ret = [NSMutableArray array];
    
    for (BattleAction *action in self.actionList)
    {
        if((action.actionTargetType & actionTarget) != 0)
        {
            [ret addObject:action];
        }
    }
    
    col.actionList = ret;
    return col;
}

@end
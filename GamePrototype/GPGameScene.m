//
//  GameScene.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPGameScene.h"
#import "GPSystem.h"

@implementation GPGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        entities = [NSMutableArray array];
        systems = [NSMutableArray array];
        notifiers = [NSMutableArray array];
    }
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    for(GPSystem *system in systems)
    {
        [system update:timeSinceLast];
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1)
    { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

// Adiciona uma entidade à cena
- (void)addEntity:(GPEntity*)entity
{
    [entities addObject:entity];
    
    [self addChild:entity.node];
    
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        [notifier gameSceneDidAddEntity:self entity:entity];
    }
}
// Remove uma entidade da cena
- (void)removeEntity:(GPEntity*)entity
{
    [entities removeObject:entity];
    
    [entity.node removeFromParent];
    
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        [notifier gameSceneDidRemoveEntity:self entity:entity];
    }
}
// Retorna uma entidade na cena que corresponde ao ID passado
- (GPEntity*)getEntityByID:(int)ID
{
    for(GPEntity *entity in entities)
    {
        if(entity.ID == ID)
            return entity;
    }
    
    return nil;
}
// Retorna uma lista de entidades que correspondem ao tipo passado
- (NSArray*)getEntitiesByType:(int)type
{
    NSMutableArray *array = [NSMutableArray array];
    
    for(GPEntity *entity in entities)
    {
        if(entity.type == type)
            [array addObject:entity];
    }
    
    return array;
}

// Retorna uma lista de entidades que foram filtradas com o selecionador de entidades fornecido
- (NSArray*)getEntitiesWithSelector:(GPEntitySelector*)selector
{
    return [selector applyRuleToArray:entities];
}


// Retorna uma lista de entidades que foram filtradas com a regra de selecionador fornecida
- (NSArray*)getEntitiesWithSelectorRule:(GPSelectorRule*)rule
{
    return [self getEntitiesWithSelector:GPEntitySelectorCreate(rule)];
}

// Adiciona um sistema à cena
- (void)addSystem:(GPSystem*)system
{
    [systems addObject:system];
    
    // Adiciona este sistema como notifier
    [notifiers addObject:system];
}
// Remove um sistema da cena
- (void)removeSystem:(GPSystem*)system
{
    [systems removeObject:system];
    
    // Adiciona este sistema como notifier
    [notifiers removeObject:system];
}

// Eventos de interface
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneDidReceiveTouchesBegan:touches:withEvent:)])
        {
            [notifier gameSceneDidReceiveTouchesBegan:self touches:touches withEvent:event];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneDidReceiveTouchesEnd:touches:withEvent:)])
        {
            [notifier gameSceneDidReceiveTouchesEnd:self touches:touches withEvent:event];
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneDidReceiveTouchesMoved:touches:withEvent:)])
        {
            [notifier gameSceneDidReceiveTouchesMoved:self touches:touches withEvent:event];
        }
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneDidReceiveTouchesCanceled:touches:withEvent:)])
        {
            [notifier gameSceneDidReceiveTouchesCanceled:self touches:touches withEvent:event];
        }
    }
}

@end
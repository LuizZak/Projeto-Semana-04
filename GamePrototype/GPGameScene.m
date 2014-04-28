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
        worldNode = [SKNode node];
        
        [self addChild:worldNode];
    }
    return self;
}

- (SKNode*)worldNode
{
    return worldNode;
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

- (void)didEvaluateActions
{
    [super didEvaluateActions];
    
    for(GPSystem *system in systems)
    {
        [system didEvaluateActions];
    }
}

- (void)didSimulatePhysics
{
    [super didSimulatePhysics];
    
    for(GPSystem *system in systems)
    {
        [system didSimulatePhysics];
    }
}

// Limpa a cena, removendo todas as entidades e sistemas
- (void)clearScene
{
    // Remove todos os sistemas
    while(systems.count > 0)
    {
        [self removeSystem:systems[0]];
    }
    
    // Remove todas as entides
    while(entities.count > 0)
    {
        [self removeEntity:entities[0]];
    }
}

// Adiciona uma entidade à cena
- (void)addEntity:(GPEntity*)entity
{
    [self addEntity:entity toNode:worldNode];
}
// Adiciona uma entidade à cena, sendo uma filha do nó passado
- (void)addEntity:(GPEntity*)entity toNode:(SKNode*)node
{
    [entities addObject:entity];
    
    [node addChild:entity.node];
    
    entity.gameScene = self;
    
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
    
    if(entity.gameScene == self)
        entity.gameScene = nil;
    
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
        if((entity.type & type) != 0)
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

// Notifica que a entidade passada foi modificada (componentes, id ou tipo foram modificados)
- (void)entityModified:(GPEntity *)entity
{
    for (GPSystem *system in systems)
    {
        [system entityModified:entity];
    }
}

// Adiciona um sistema à cena
- (void)addSystem:(GPSystem*)system
{
    [system willAddToScnee:self];
    
    [systems addObject:system];
    
    // Força o sistema a carregas as entidades relevantes
    [system reloadEntities:entities];
    
    // Adiciona este sistema como notifier
    [notifiers addObject:system];
    
    [system didAddToScene];
}
// Remove um sistema da cena
- (void)removeSystem:(GPSystem*)system
{
    [system willRemoveFromScene];
    
    [systems removeObject:system];
    
    // Remove este sistema como notifier
    [notifiers removeObject:system];
    
    [system didRemoveFromScene];
}
// Retorna um sistema específico adicionado à cena
- (GPSystem*)getSystem:(Class)systemClass
{
    for (GPSystem *system in systems) {
        if([system isKindOfClass:systemClass])
            return system;
    }
    
    return nil;
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
- (void)didMoveToView:(SKView *)view
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneDidAddToView:)])
        {
            [notifier gameSceneDidAddToView:self];
        }
    }
}
- (void)willMoveFromView:(SKView *)view
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneWillBeMovedFromView:)])
        {
            [notifier gameSceneWillBeMovedFromView:self];
        }
    }
}
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneDidBeginContact:)])
        {
            [notifier gameSceneDidBeginContact:contact];
        }
    }
}
- (void)didEndContact:(SKPhysicsContact *)contact
{
    // Notifica os notifiers
    for(id<GPGameSceneNotifier> notifier in notifiers)
    {
        if([notifier respondsToSelector:@selector(gameSceneDidEndContact:)])
        {
            [notifier gameSceneDidEndContact:contact];
        }
    }
}

@end
//
//  GameScene.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GPEntity.h"
#import "GPEntitySelector.h"
#import "GPSelectorRules.h"
#import "GPEventDispatcher.h"

@class GPGameScene;
@class GPSystem;
// Protocolo implementado em sistemas, serve para notificar quando
// entidades são adicionadas/removidas/modificadas em uma GameScene
@protocol GPGameSceneNotifier <NSObject>

@optional

// Notifica quando uma entidade for adicionada na cena. O valor de retorno dependeto contexto da classe que o implementa.
- (BOOL)gameSceneDidAddEntity:(GPGameScene*)gameScene entity:(GPEntity*)entity;
// Notifica quando uma entidade for removida da cena. O valor de retorno depende to contexto da classe que o implementa.
- (BOOL)gameSceneDidRemoveEntity:(GPGameScene*)gameScene entity:(GPEntity*)entity;

// Notifica quando a cena recebeu um evento de início de toque
- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene*)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event;
// Notifica quando a cena recebeu um evento de fim de toque
- (void)gameSceneDidReceiveTouchesEnd:(GPGameScene*)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event;
// Notifica quando a cena recebeu um evento de movimento de toque
- (void)gameSceneDidReceiveTouchesMoved:(GPGameScene*)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event;
// Notifica quando a cena recebeu um evento de cancelamento de toque
- (void)gameSceneDidReceiveTouchesCanceled:(GPGameScene*)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event;

// Notifica quando a cena vai ser removida da view
- (void)gameSceneWillBeMovedFromView:(GPGameScene*)gameScene;
// Notifica quando a cena foi adicionada a uma view
- (void)gameSceneDidAddToView:(GPGameScene*)gameScene;

// Notifica quando a cena teve um contato de colisão adicionado
- (void)gameSceneDidBeginContact:(SKPhysicsContact*)contact;
// Notifica quando a cena teve um contato de colisão removido
- (void)gameSceneDidEndContact:(SKPhysicsContact*)contact;


@end

// Representa uma cena do jogo que contém entidades e sistemas
@interface GPGameScene : SKScene <SKPhysicsContactDelegate>
{
    // Lista de entidades da cena
    NSMutableArray *entities;
    // Lista de sistemas da cena
    NSMutableArray *systems;
    // Lista de notifiers
    NSMutableArray *notifiers;
    // Nó raiz da cena
    SKNode *worldNode;
}

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (readonly) SKNode *worldNode;

/// The main event dispatcher for this scene
@property GPEventDispatcher *eventDispatcher;

// Limpa a cena, removendo todas as entidades e sistemas
- (void)clearScene;

// Adiciona uma entidade à cena
- (void)addEntity:(GPEntity*)entity;
// Adiciona uma entidade à cena, como filha do nó passado
- (void)addEntity:(GPEntity*)entity toNode:(SKNode*)node;
// Remove uma entidade da cena
- (void)removeEntity:(GPEntity*)entity;
// Retorna uma entidade na cena que corresponde ao ID passado
- (GPEntity*)getEntityByID:(int)ID;
// Retorna uma lista de entidades que correspondem ao tipo passado
- (NSArray*)getEntitiesByType:(int)type;
// Retorna uma lista de entidades que foram filtradas com o selecionador de entidades fornecido
- (NSArray*)getEntitiesWithSelector:(GPEntitySelector*)selector;
// Retorna uma lista de entidades que foram filtradas com a regra de selecionador fornecida
- (NSArray*)getEntitiesWithSelectorRule:(GPSelectorRule*)rule;
// Notifica que a entidade passada foi modificada (componentes, id ou tipo foram modificados)
- (void)entityModified:(GPEntity*)entity;

/// Adds a given object to the list of game scene notifiers for this game scene
- (void)addNotifier:(id<GPGameSceneNotifier>)notifier;
/// Removes a given object from the list of game scene notifiers for this game scene
- (void)removeNotifier:(id<GPGameSceneNotifier>)notifier;

// Adiciona um sistema à cena
- (void)addSystem:(GPSystem*)system;
// Remove um sistema da cena
- (void)removeSystem:(GPSystem*)system;
// Retorna um sistema específico adicionado à cena
- (id)getSystem:(Class)systemClass;

@end
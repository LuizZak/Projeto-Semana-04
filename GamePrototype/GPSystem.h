//
//  System.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPGameScene.h"

@class GPGameScene;
// Representa um sistema, que possui a lógica para aplicar os comportamentos a entidades no sistema
@interface GPSystem : NSObject <GPGameSceneNotifier>
{
    // Seletor de entidade de conveniência usada para filtrar as entidades que este sistema possui
    GPEntitySelector *selector;
    // Array interna de entidades que este sistema controla
    NSMutableArray *entitiesArray;
}

// A cena que contém este sistema
@property GPGameScene *gameScene;

// Inicia esta instância de sistema com a cena fornecida
- (id)initWithGameScene:(GPGameScene*)gameScene;

// Notifica que o sistema será adicionado a uma cena
- (void)willAddToScnee:(GPGameScene*)gameScene;
// Notifica que o sistema foi adicionado a uma cena
- (void)didAddToScene;
// Notifica que o sistema será removido de uma cena
- (void)willRemoveFromScene;
// Notifica que o sistema foi removido de uma cena
- (void)didRemoveFromScene;

// Chamado pela cena, para atualizar o sistema
- (void)update:(NSTimeInterval)interval;

// Chamado pela cena, quando as ações tiverem sido processadas
- (void)didEvaluateActions;
// Chamado pela cena, quando a simulação de física for atualizada
- (void)didSimulatePhysics;

// Força o sistema a recarregar as entidades guardadas nele
- (void)reloadEntities:(NSArray*)array;

// Chamado quando o sistema tem de testar uma entidade para adicionar na sua lista interna de entidades relevantes
- (BOOL)testEntityToAdd:(GPEntity*)entity;
// Chamado quando o sistema tem de testar uma entidade para remover da sua lista interna de entidades relevantes
- (BOOL)testEntityToRemove:(GPEntity*)entity;

@end
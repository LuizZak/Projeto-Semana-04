
//
//  Entity.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GPComponent.h"

#define GET_COMPONENT(entity, type) ((type*)[entity getComponent:[type class]]);
#define GET_COMPONENTS(entity, type) ([entity getComponents:[type class]]);

typedef unsigned long long entityid_t;
typedef unsigned long long entitytype_t;

@class GPGameScene;
// Representa uma entidade do jogo
@interface GPEntity : NSObject
{
    // Lista interna de componentes desta entidade
    SKNode *targetNode;
    NSMutableArray *components;
}

// O ID desta entidade (tem de ser único na cena)
@property entityid_t ID;

// O tipo desta entidade (pode ser igual a de outras entidades)
@property entitytype_t type;

// O nó que esta entidade acomoda
@property (readonly) SKNode *node;

// A cena em que esta entidade está localizada
@property GPGameScene *gameScene;

// Inicia esta entidade com o SKNode passado
- (id)initWithNode:(SKNode*)node;

// Adiciona um componente a esta entidade
- (void)addComponent:(GPComponent*)component;
// Remove um componente desta entidade
- (void)removeComponent:(GPComponent*)component;

// Retorna a instância de componente presente nesta entidade que corresponde ao tipo de classe passada.
// Se nenhum componente do tipo fornecido for encontrado, nil é retornado
- (GPComponent*)getComponent:(Class)componentClass;

// Retorna uma array de componentes presentes nesta entidade que correspondem ao tipo de classe passada.
// Se nenum componente do tipo fornecido for encontrado, uma array vazia é retornada
- (NSArray*)getComponents:(Class)componentClass;

// Retorna se esta entidade contém o componente referido pela classe passada
- (BOOL)hasComponent:(Class)componentClass;

// Remove todos os componentes nesta entidade que tem a classe especificada
- (void)removeComponentsWithClass:(Class)componentClass;

@end
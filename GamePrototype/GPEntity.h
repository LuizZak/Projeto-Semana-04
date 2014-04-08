//
//  Entity.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GPComponent.h"

// Representa uma entidade do jogo
@interface GPEntity : NSObject
{
    // Lista interna de componentes desta entidade
    SKNode *targetNode;
    NSMutableArray *components;
}

// O ID desta entidade (tem de ser único na cena)
@property int ID;

// O tipo desta entidade (pode ser igual a de outras entidades)
@property int type;

// O nó que esta entidade acomoda
@property (readonly) SKNode *node;

// Inicia esta entidade com o SKNode passado
- (id)initWithNode:(SKNode*)node;

// Adiciona um componente a esta entidade
- (void)addComponent:(GPComponent*)component;
// Remove um componente desta entidade
- (void)removeComponent:(GPComponent*)component;

// Retorna a instância de componente presente nesta entidade que corresponde ao tipo de classe passada.
// Se nenhum componente do tipo fornecido for encontrado, nil é retornado
- (GPComponent*)getComponent:(Class)componentClass;

// Retorna se esta entidade contém o componente referido pela classe passada
- (BOOL)hasComponent:(Class)componentClass;

@end
//
//  ComponentDialog.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 17/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

typedef void (^VoidBlock)();

@interface ComponentDialog : GPComponent

// O texto para exibir
@property NSString *textDialog;
// A cor do texto para exibir
@property UIColor *textColor;
// O delay entre cada caractére
@property float charDelay;

// Referência para o próximo diálogo a exibir após este
@property ComponentDialog *nextDialog;

// Bloco para executar quando o diálogo for exibido
@property (nonatomic, copy) VoidBlock beforeDialogBlock;

// Bloco para executar após o diálogo ser fechado
@property (nonatomic, copy) VoidBlock afterDialogBlock;

@end
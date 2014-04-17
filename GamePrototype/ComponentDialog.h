//
//  ComponentDialog.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 17/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

@interface ComponentDialog : GPComponent

// O texto para exibir
@property NSString *textDialog;
// A cor do texto para exibir
@property UIColor *textColor;

// Referência para o próximo diálogo a exibir após este
@property ComponentDialog *nextDialog;

@end
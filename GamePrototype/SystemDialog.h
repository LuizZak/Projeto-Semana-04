//
//  SystemDialog.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 17/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
#import "ComponentDialog.h"
#import "DSMultilineLabelNode.h"

// Sistema que cuida dos diálogos do jogo
@interface SystemDialog : GPSystem
{
    int dialogWidth;
    int dialogHeight;
    // Caractérie atual sendo exibido na tela
    int currentTextChar;
    // Delay atual entre a exibição do caractérie atual e o próximo
    float currentCharDelay;
    // Delay entre a exibição do caractérie atual e o próximo
    float charDelay;
    // Margem interna da caixa de diálogo
    int internalMargin;
}

// Entidade que descreve o diálogo sendo exibido atualmente
@property GPEntity *currentDialogEntity;

// Componente do diálogo atual
@property ComponentDialog *currentComponent;

// Nó da diálogo atual
@property SKNode *dialogNode;

// Nó do avatar do personagem
@property SKSpriteNode *avatarNode;

// Nó usado para indicar que o usuário pode tocar na tela para continuar
@property SKLabelNode *tapToContinueNode;

// Action usado para animar o tapToContinue
@property SKAction *continueLabelAction;

// Texto do diálogo atual
@property NSString *currentText;

// Dita se o sistema está exibindo um diálogo atualmente
@property BOOL showingDialog;

// Retorna se o texto está sendo exibido completamente na tela atualmente
@property (readonly) BOOL isTextFullyShown;

// Pega o label node sendo usado para exibir o diálogo
@property (readonly) DSMultilineLabelNode *labelNode;

//  Sprite node pra vver onde ele clicou
@property SKSpriteNode* recognizer;

// The place touched
@property CGPoint selectedPlace;

@end
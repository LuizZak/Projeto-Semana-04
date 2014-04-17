//
//  SystemDialog.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 17/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemDialog.h"
#import "ComponentDialog.h"

@implementation SystemDialog

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleComponent([ComponentDialog class]));
        
        [self initDialog];
        
        charDelay = 0.08f;
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    if(self.showingDialog)
    {
        // Delay de exibição de caractérie
        if(currentTextChar < [self.currentText length])
        {
            currentCharDelay -= interval;
            
            if(currentCharDelay <= 0)
            {
                [self changeDialogTextSize:currentTextChar + 1];
                
                currentCharDelay = charDelay - currentCharDelay;
            }
        }
    }
}

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.showingDialog)
    {
        if(!self.isTextFullyShown)
        {
            [self changeDialogTextSize:self.currentText.length];
        }
        else
        {
            ComponentDialog *comp = self.currentComponent;
            
            // Chama o bloco pós diálogo
            if(comp.afterDialogBlock != nil)
            {
                comp.afterDialogBlock();
            }
            
            if(comp.nextDialog != nil)
            {
                [self showDialogForComponent:comp.nextDialog];
            }
            else
            {
                [self hideDialog];
            }
        }
    }
}

- (BOOL)gameSceneDidAddEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    BOOL ret = [super gameSceneDidAddEntity:gameScene entity:entity];
    
    if(ret)
    {
        // Cira um diálogo
        [self showDialog:entity];
    }
    
    return ret;
}

- (BOOL)gameSceneDidRemoveEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    BOOL ret = [super gameSceneDidRemoveEntity:gameScene entity:entity];
    
    if(ret)
    {
        // Esconde o diálogo
        self.currentDialogEntity = nil;
        
        [self hideDialog];
    }
    
    return ret;
}

- (void)changeDialogTextSize:(int)newTextLength
{
    currentTextChar = newTextLength;
    
    self.labelNode.text = [self.currentText substringToIndex:currentTextChar];
    
    if(currentTextChar == self.currentText.length)
    {
        self.tapToContinueNode.hidden = NO;
        self.tapToContinueNode.alpha = 1;
        
        [self.tapToContinueNode removeAllActions];
        [self.tapToContinueNode runAction:self.continueLabelAction];
    }
}

// Inicia a caixa de diálogo para exibição
- (void)initDialog
{
    dialogWidth = self.gameScene.frame.size.width - 50;
    dialogHeight = 200;
    
    int internalMargin = 15;
    
    self.dialogNode = [SKNode node];
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(dialogWidth, dialogHeight)];
    SKLabelNode *textNode = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    // Ajusta o textNode
    textNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    textNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    textNode.position = CGPointMake(-dialogWidth / 2 + internalMargin, dialogHeight / 2 - internalMargin - 20);
    
    bgNode.alpha = 0.75f;
    bgNode.name = @"bgNode";
    textNode.name = @"textNode";
    
    self.dialogNode.position = CGPointMake(CGRectGetMidX(self.gameScene.frame), 125);
    
    [self.dialogNode addChild:bgNode];
    [self.dialogNode addChild:textNode];
    
    self.dialogNode.hidden = YES;
    
    // Inicia o texto de [Tap to Continue]
    self.tapToContinueNode = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    self.tapToContinueNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.tapToContinueNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    
    self.tapToContinueNode.color = [UIColor whiteColor];
    self.tapToContinueNode.text = @"[Tap to Continue]";
    self.tapToContinueNode.position = CGPointMake(dialogWidth / 2 - internalMargin, -dialogHeight / 2 + internalMargin);
    
    [self.dialogNode addChild:self.tapToContinueNode];
    self.tapToContinueNode.hidden = YES;
    
    self.continueLabelAction = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.5f], [SKAction fadeAlphaTo:0 duration:0], [SKAction waitForDuration:0.5f], [SKAction fadeAlphaTo:1 duration:0]]]];
    
    [self.gameScene addChild:self.dialogNode];
}

// Getter do isTextFullyShown
- (BOOL)isTextFullyShown
{
    return currentTextChar == self.currentText.length;
}

// Getter do labelNode
- (SKLabelNode*)labelNode
{
    return (SKLabelNode*)[self.dialogNode childNodeWithName:@"textNode"];
}

// Ajusta o texto passado no label node fornecido para caber numa largura especificada
- (void)fitTextOn:(SKLabelNode*)targetLabelNode text:(NSString*)text width:(int)width
{
    targetLabelNode.text = text;
    
    self.currentText = targetLabelNode.text;
}

- (void)showDialog:(GPEntity*)dialogEntity
{
    // Pega o componente de diálogo
    ComponentDialog *compDialog = (ComponentDialog*)[dialogEntity getComponent:[ComponentDialog class]];
    
    self.currentDialogEntity = dialogEntity;
    
    [self showDialogForComponent:compDialog];
}

- (void)showDialogForComponent:(ComponentDialog*)compDialog
{
    if(self.currentComponent.beforeDialogBlock != nil)
    {
        self.currentComponent.beforeDialogBlock();
    }
    
    charDelay = compDialog.charDelay;
    currentTextChar = 0;
    currentCharDelay = charDelay;
    
    self.currentComponent = compDialog;
    
    // Atualiza o label node
    [self fitTextOn:self.labelNode text:compDialog.textDialog width:dialogWidth];
    self.labelNode.color = compDialog.textColor;
    
    // Exibe a janela
    self.dialogNode.hidden = NO;
    self.showingDialog = YES;
    
    // Esconde o tap to continue
    self.tapToContinueNode.hidden = YES;
    
    // Se o delay dos caractéres for igual a -1, exibe o texto inteiro agora
    if(charDelay != -1)
        [self changeDialogTextSize:0];
    else
        [self changeDialogTextSize:self.currentText.length];
}

- (void)hideDialog
{
    // Se a entidade do diálogo atual não for nula, esconde o diálogo removendo ela
    if(self.currentDialogEntity != nil)
    {
        [self.gameScene removeEntity:self.currentDialogEntity];
        return;
    }
    
    self.dialogNode.hidden = YES;
    self.showingDialog = NO;
}

@end
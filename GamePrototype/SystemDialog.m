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
            [self changeDialogTextSize:(int)self.currentText.length];
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

- (BOOL)testEntityToAdd:(GPEntity *)entity
{
    BOOL ret = [super testEntityToAdd:entity];
    
    if(ret)
    {
        // Cira um diálogo
        [self showDialog:entity];
    }
    
    return ret;
}

- (BOOL)testEntityToRemove:(GPEntity *)entity
{
    BOOL ret = [super testEntityToRemove:entity];
    
    if(ret)
    {
        // Esconde o diálogo
        self.currentDialogEntity = nil;
        
        [self hideDialog];
    }
    
    return ret;
}

- (void)willRemoveFromScene
{
    [super willRemoveFromScene];
    
    // Destroi a caixa de diálogo
    [self destroyDialog];
}

- (void)changeDialogTextSize:(int)newTextLength
{
    currentTextChar = newTextLength;
    
    self.labelNode.text = [self.currentText substringToIndex:currentTextChar];
    
    self.labelNode.position = CGPointMake(-dialogWidth / 2 + internalMargin + self.labelNode.frame.size.width / 2, dialogHeight / 2 - self.labelNode.frame.size.height / 2 - internalMargin / 2);
    
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
    
    internalMargin = 15;
    
    self.dialogNode = [SKNode node];
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(dialogWidth, dialogHeight)];
    DSMultilineLabelNode *textNode = [DSMultilineLabelNode labelNodeWithFontNamed:@"GillSans"];
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

// Destroi a caixa de diálogo
- (void)destroyDialog
{
    // Fecha o diálogo primeiro
    [self hideDialog];
    
    [self.dialogNode removeFromParent];
}

// Getter do isTextFullyShown
- (BOOL)isTextFullyShown
{
    return currentTextChar == self.currentText.length;
}

// Getter do labelNode
- (DSMultilineLabelNode*)labelNode
{
    return (DSMultilineLabelNode*)[self.dialogNode childNodeWithName:@"textNode"];
}

// Ajusta o texto passado no label node fornecido para caber numa largura especificada
- (void)fitTextOn:(DSMultilineLabelNode*)targetLabelNode text:(NSString*)text width:(int)targetWidth
{
    self.labelNode.paragraphWidth = targetWidth;
    self.labelNode.text = text;
    
    self.labelNode.position = CGPointMake(-dialogWidth / 2 + internalMargin + self.labelNode.frame.size.width / 2, dialogHeight / 2 - self.labelNode.frame.size.height / 2 - internalMargin / 2);
    
    // Separa o texto em palavras menores
    /*NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@". ,!?\n\r"];
    
    // Texto final
    NSString *finalText = @"";
    
    int currentChar = 0;
    NSString *currentWord = @"";
    NSString *currentLine = @"";
    
    // Zera o texto
    targetLabelNode.text = @"";
    
    // Insere os caractéres um a um e quebra a linha
    while(true)
    {
        // Checa se o caractére atual é um de quebra de linha ou o fim da string foi alcançado
        if([charSet characterIsMember:[text characterAtIndex:currentChar]] || currentChar == text.length - 1)
        {
            // Termina a palavra atual se existir alguma
            if(![currentWord isEqualToString:@""])
            {
                // Mede a string
                targetLabelNode.text = [NSString stringWithFormat:@"%@%@", currentLine, currentWord];
                int textWidth = targetLabelNode.frame.size.width;
                
                if(textWidth > targetWidth)
                {
                    // Adiciona a linha ao texto final
                    finalText = [NSString stringWithFormat:@"%@%@\n", finalText, currentLine];
                    
                    // Adiciona a palavra atual e o separador para a próxima linha a ser adicionada, e reseta a palavra atual
                    currentLine = [NSString stringWithFormat:@"%@%c", currentWord, [text characterAtIndex:currentChar]];
                    currentWord = @"";
                }
                else
                {
                    // Adiciona a quebra de palavra na string também
                    currentLine = [NSString stringWithFormat:@"%@%@%c", currentLine, currentWord, [text characterAtIndex:currentChar]];
                    
                    currentWord = @"";
                }
                
                if(currentChar == text.length - 1)
                {
                    finalText = [NSString stringWithFormat:@"%@%@", finalText, currentLine];
                    currentLine = @"";
                }
            }
            // Se a palavra atual estiver vazia, adiciona a quebra de palavra
            else
            {
                // Tenta quebrar a linha se necessário
                targetLabelNode.text = [NSString stringWithFormat:@"%@%c", currentLine, [text characterAtIndex:currentChar]];
                int width = targetLabelNode.frame.size.width;
                
                if(width > targetWidth)
                {
                    finalText = [NSString stringWithFormat:@"%@\n", currentLine];
                    currentLine = @"";
                }
                
                // Adiciona a quebra de linha na linha também
                currentLine = [NSString stringWithFormat:@"%@%c", currentLine, [text characterAtIndex:currentChar]];
            }
        }
        else
        {
            // Acumula letras na palavra atual
            currentWord = [NSString stringWithFormat:@"%@%c", currentWord, [text characterAtIndex:currentChar]];
        }
        
        // Itera mais um caractére
        currentChar++;
        
        // Termina de iterar no último caractére
        if(currentChar >= text.length)
        {
            if(![currentLine isEqualToString:@""])
            {
                finalText = [NSString stringWithFormat:@"%@%@", finalText, currentLine];
            }
            
            break;
        }
    }
    
    targetLabelNode.text = finalText;*/
    
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
        [self changeDialogTextSize:(int)self.currentText.length];
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
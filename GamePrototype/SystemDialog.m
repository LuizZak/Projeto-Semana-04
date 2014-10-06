//
//  SystemDialog.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 17/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemDialog.h"
#import "ComponentDialog.h"

const int depthDialog = 2000;

@implementation SystemDialog

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        self.recognizer = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:gameScene.size];
        self.recognizer.anchorPoint = CGPointZero;
        self.recognizer.zPosition = 10000;
        
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
    UITouch *tch = [touches anyObject];
    self.selectedPlace = [tch locationInNode:gameScene];
    
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
    
    // Calcula um offset dependendo de se há um avatar sendo exibido no momento
    int offsetX = 0;
    
    if(!self.avatarNode.hidden)
        offsetX = self.avatarNode.frame.size.width + 5;
    
    self.labelNode.position = CGPointMake(-dialogWidth / 2 + internalMargin + self.labelNode.frame.size.width / 2 + offsetX, dialogHeight / 2 - self.labelNode.frame.size.height / 2 - internalMargin / 2);
    
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
    
    internalMargin = 10;
    
    self.dialogNode = [SKNode node];
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(dialogWidth, dialogHeight)];
    
    // TextNode
    DSMultilineLabelNode *textNode = [DSMultilineLabelNode labelNodeWithFontNamed:@"GillSans"];
    textNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    textNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
    textNode.position = CGPointMake(-dialogWidth / 2 + internalMargin, dialogHeight / 2 - internalMargin - 20);
    
    bgNode.alpha = 0.75f;
    bgNode.name = @"bgNode";
    textNode.name = @"textNode";
    
    // Avatar
    self.avatarNode = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(180, 180)];
    self.avatarNode.position = CGPointMake(-dialogWidth / 2 + self.avatarNode.frame.size.width / 2 + internalMargin, -dialogHeight / 2 + self.avatarNode.frame.size.height / 2 + internalMargin);
    
    
    // DialogNode
    self.dialogNode.position = CGPointMake(CGRectGetMidX(self.gameScene.frame), 125);
    
    [self.dialogNode addChild:self.avatarNode];
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
    
    self.dialogNode.zPosition = depthDialog;
    self.avatarNode.zPosition = depthDialog + 1;
    textNode.zPosition = depthDialog + 2;
    self.tapToContinueNode.zPosition = depthDialog + 3;
    
    //[self.gameScene addChild:self.dialogNode];
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
    if (self.recognizer.parent == nil)
    {
        [self.gameScene addChild:self.recognizer];
    }
    
    if(self.currentComponent.beforeDialogBlock != nil)
    {
        self.currentComponent.beforeDialogBlock();
    }
    
    charDelay = compDialog.charDelay;
    currentTextChar = 0;
    currentCharDelay = charDelay;
    
    self.currentComponent = compDialog;
    
    if(compDialog.avatarTexture != nil)
    {
        [self.avatarNode setTexture:compDialog.avatarTexture];
        self.avatarNode.hidden = NO;
    }
    else
    {
        self.avatarNode.hidden = YES;
    }
    
    // Calcula um offset de largura dependendo de se há um avatar sendo exibido no momento
    int offsetWidth = 0;
    if(!self.avatarNode.hidden)
        offsetWidth = self.avatarNode.frame.size.width + 5;
    
    // Atualiza o label node
    if(compDialog.characterName != nil)
    {
        [self fitTextOn:self.labelNode text:[NSString stringWithFormat:@"%@: %@", compDialog.characterName, compDialog.textDialog] width:dialogWidth - internalMargin - offsetWidth];
    }
    else
    {
        [self fitTextOn:self.labelNode text:compDialog.textDialog width:dialogWidth - internalMargin - offsetWidth];
    }
    self.labelNode.color = compDialog.textColor;
    
    // Exibe a janela
    self.dialogNode.hidden = NO;
    self.showingDialog = YES;
    
    // Esconde o tap to continue
    self.tapToContinueNode.hidden = YES;
    
    // Se o delay dos caractéres for igual a -1, exibe o texto inteiro agora
    if(charDelay != -1)
    {
        // Se houver um nome de personagem atrelado ao diálogo, já inicia com o nome
        if(compDialog.characterName != nil)
        {
            [self changeDialogTextSize:compDialog.characterName.length + 2];
        }
        else
        {
            [self changeDialogTextSize:0];
        }
    }
    else
    {
        [self changeDialogTextSize:(int)self.currentText.length];
    }
    
    [self.gameScene addChild:self.dialogNode];
}

- (void)hideDialog
{
    // Se a entidade do diálogo atual não for nula, esconde o diálogo removendo ela
    if(self.currentDialogEntity != nil)
    {
        [self.dialogNode removeFromParent];
        [self.gameScene removeEntity:self.currentDialogEntity];
        return;
    }
    
    self.dialogNode.hidden = YES;
    self.showingDialog = NO;
    
    [self.recognizer removeFromParent];
}

@end
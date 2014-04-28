//
//  SceneRanking.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 25/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SceneRanking.h"
#import "Ranking.h"
#import "Score.h"
#import "SceneMenu.h"

@implementation SceneRanking

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.background = [[SKSpriteNode alloc] initWithImageNamed:@"RankBG.png"];
        self.background.anchorPoint = CGPointMake(0, 0);
        self.background.size = size;
        
        UIImage* imgCell = [UIImage imageNamed:@"BtnVoltar.png"];
        self.btnVoltar = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(imgCell.size.width/2.5, imgCell.size.height/2.5)];
        self.btnVoltar.texture = [SKTexture textureWithImage:imgCell];
        self.btnVoltar.position = CGPointMake(900, 50);
        self.btnVoltar.zPosition = 10;
        
        [self addChild:self.background];
        [self addChild:self.btnVoltar];
        
        [self criarORanking];
    }
    return self;
}

- (void)criarORanking
{
    for (int i = 0; i < 10; i ++)
    {
        UIImage* imgCell = [UIImage imageNamed:@"RankCellBG.png"];
        self.cell = [[SKSpriteNode alloc] initWithColor:[UIColor whiteColor] size:CGSizeMake(600, 50)];
        self.cell.texture = [SKTexture textureWithImage:imgCell];
        self.cell.position = CGPointMake(500, 600 - (i*55));
        self.cell.zPosition = 10;
        
        [self.scene addChild:self.cell];
        
        if ([[Ranking lista] todosItens].count > i)
        {
            Score *score = [[[Ranking lista] todosItens] objectAtIndex:i];
            self.pontuacao = [[SKLabelNode alloc] initWithFontNamed:@"GillSans"];
            self.pontuacao.fontColor = [UIColor blackColor];
            self.pontuacao.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            self.pontuacao.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
            [self.pontuacao setText:[NSString stringWithFormat:@"%@: %d pontos",[score nome], [score pontos]]];
            self.pontuacao.zPosition = 15;
            
            [self.cell addChild:self.pontuacao];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    
    [self verificaAondeTocou:touchLocation];
}

- (void)verificaAondeTocou:(CGPoint)touchLocation
{
    if([self nodeAtPoint:touchLocation] == self.btnVoltar)
    {
        SceneMenu* newScene = [[SceneMenu alloc] initWithSize:self.size];
        [self.view presentScene:newScene];
    }
}

@end

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

@implementation SceneRanking

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.background = [[SKSpriteNode alloc] initWithImageNamed:@"RankBG.png"];
        self.background.anchorPoint = CGPointMake(0, 0);
        self.background.size = size;
        
        [self addChild:self.background];
        
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
        self.cell.alpha = 0.5;
        
        [self.scene addChild:self.cell];
        
        if (i < [[Ranking lista] todosItens].count)
        {
            Score *score = [[[Ranking lista] todosItens] objectAtIndex:i];
            self.pontuacao = [[SKLabelNode alloc] initWithFontNamed:@"GillSans"];
            self.pontuacao.fontColor = [UIColor blackColor];
            self.pontuacao.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            [self.pontuacao setText:[NSString stringWithFormat:@"%@: %d pontos",[score nome], [score pontos]]];
            
            [self.cell addChild:self.pontuacao];
        }
    }
}

@end

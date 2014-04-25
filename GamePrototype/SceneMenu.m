//
//  SceneMenu.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 25/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SceneMenu.h"
#import "WorldMap.h"
#import "SceneRanking.h"
#import "Ranking.h"


@implementation SceneMenu

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [UIColor greenColor];
        
        self.btnJogar = [[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(100, 100)];
        self.btnJogar.position = CGPointMake(510, 500);
        
        self.btnRanking = [[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(100, 100)];
        self.btnRanking.position = CGPointMake(510, 390);
        
        [self addChild:self.btnJogar];
        [self addChild:self.btnRanking];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    
    [self verificaAondeTocou:touchLocation];
}

- (void)verificaAondeTocou:(CGPoint)touchLocation
{
    if([self nodeAtPoint:touchLocation] == self.btnJogar)
    {
        UIAlertView *pegarONome = [[UIAlertView alloc] initWithTitle:@"Novo Jogo"
         message:@"Digite Seu Nome"
         delegate:self
         cancelButtonTitle:@"Submit"
         otherButtonTitles:nil];
         
         [pegarONome setAlertViewStyle:UIAlertViewStylePlainTextInput];
         
         [pegarONome show];
    }else if ([self nodeAtPoint:touchLocation] == self.btnRanking)
    {
        [self chamarAOutraScene:1];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UITextField *username = [alertView textFieldAtIndex:0];
        
        [[Ranking lista] setCurrentPlayerName:username.text];
        [[Ranking lista] setCurrentPlayerScore:0];
        
        [self chamarAOutraScene:0];
    }
}

- (void)chamarAOutraScene:(int)scene
{
    if (scene == 0)
    {
        WorldMap* newScene = [[WorldMap alloc] initWithSize:self.size];
        [self.view presentScene:newScene];
        [[GameData gameData] saveWorld:newScene];
    }else if (scene == 1)
    {
        SceneRanking* newScene = [[SceneRanking alloc] initWithSize:self.size];
        [self.view presentScene:newScene];
    }
    
}
@end

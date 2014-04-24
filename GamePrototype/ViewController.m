//
//  ViewController.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ViewController.h"
#import "SceneBattle.h"
#import "WorldMap.h"
#import "Ranking.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    
    UIAlertView *pegarONome = [[UIAlertView alloc] initWithTitle:@"Novo Jogo"
                                                         message:@"Digite Seu Nome"
                                                        delegate:self
                                               cancelButtonTitle:@"Submit"
                                               otherButtonTitles:nil];
    
    [pegarONome setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [pegarONome show];
    
    // Create and configure the scene.
    WorldMap * scene = [WorldMap sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [[GameData gameData] saveWorld:scene];
    
    [skView presentScene:scene];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[self navigationController] popToRootViewControllerAnimated:true];
        UITextField *username = [alertView textFieldAtIndex:0];
        
        [[Ranking lista] setCurrentPLayerName:username.text];
        [[Ranking lista] setCurrentPlayerScore:0];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
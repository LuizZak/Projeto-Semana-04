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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.btnTocar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnJogar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self criarBotao:self.btnTocar titulo:@"Touch Anywhere..." seletor:@selector(start) bordas:NO];
}

- (void)criarBotao:(UIButton*)button titulo:(NSString*)titulo seletor:(SEL)selector bordas:(BOOL)bordas
{
    [button addTarget:self
                      action:selector
            forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:titulo forState:UIControlStateNormal];
    button.frame = CGRectMake(430, 350.0, 160.0, 40.0);
    if (bordas)
    {
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor redColor].CGColor;
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
    }
    [self.view addSubview:button];
}

- (void)start
{
    [self.btnTocar setHidden:YES];
    
    self.imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:self.imgBackground];
    
    [self criarBotao:self.btnJogar titulo:@"JOGAR" seletor:@selector(comecarAJogar) bordas:YES];
}

- (void)comecarAJogar
{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    WorldMap * scene = [WorldMap sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [[GameData gameData] saveWorld:scene];
    
    // Present the scene.
    [skView presentScene:[[WorldMap alloc] initWithSize:skView.bounds.size]];
    
    [self.imgBackground setHidden:YES];
    [self.btnJogar removeFromSuperview];
    [self.btnTocar removeFromSuperview];
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
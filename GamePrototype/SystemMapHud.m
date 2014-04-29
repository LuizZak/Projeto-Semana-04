//
//  SystemMapHud.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 28/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMapHud.h"
#import "GameData.h"
#import "GFXBuilder.h"

const int depthHud = 1000;

@implementation SystemMapHud

// Reconstrói o HUD na gamescene
- (void)rebuildHUD
{
    [self removeHUD];
    [self createHUD];
}
// Cria o HUD na gamescene
- (void)createHUD
{
    // Cria o container da HUD
    self.hudContainer = [SKNode node];
    
    // Cria o background
    SKSpriteNode *bgnode = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.gameScene.frame.size.width, 100)];
    bgnode.anchorPoint = CGPointZero;
    
    bgnode.zPosition = depthHud;
    
    [self.hudContainer addChild:bgnode];
    
    // Cria o fundo da barra de life
    self.bgLifeBar = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(500, 40)];
    self.bgLifeBar.zPosition = depthHud + 1;
    self.bgLifeBar.anchorPoint = CGPointZero;
    self.bgLifeBar.position = CGPointMake(10, 50);
    
    [self.hudContainer addChild:self.bgLifeBar];
    
    // Cria a barra de life
    int margin = 10;
    self.lifeBar = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(self.bgLifeBar.frame.size.width - margin, self.bgLifeBar.frame.size.height - margin)];
    self.lifeBar.zPosition = depthHud + 2;
    self.lifeBar.anchorPoint = CGPointZero;
    
    self.lifeBar.position = CGPointMake(self.bgLifeBar.position.x + margin / 2, self.bgLifeBar.position.y + margin / 2);
    
    [self.hudContainer addChild:self.lifeBar];
    
    // Cria o label de life
    self.lifeLbl = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    self.lifeLbl.zPosition = depthHud + 3;
    self.lifeLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.lifeLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.lifeLbl.position = CGPointMake(self.bgLifeBar.position.x + self.bgLifeBar.frame.size.width / 2, self.bgLifeBar.position.y + self.bgLifeBar.frame.size.height / 2);
    
    [self.hudContainer addChild:self.lifeLbl];
    
    // Cria o texto do level
    self.levelLbl = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    self.levelLbl.zPosition = depthHud + 4;
    self.levelLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.levelLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    self.levelLbl.position = CGPointMake(10, 10);
    
    [self.hudContainer addChild:self.levelLbl];
    
    // Cria o texto do XP
    self.xpLbl = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    self.xpLbl.zPosition = depthHud + 5;
    self.xpLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.xpLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    self.xpLbl.position = CGPointMake(10, 10);
    
    [self.hudContainer addChild:self.xpLbl];
    
    // Cria o label das skills
    self.skillsLbl = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    self.skillsLbl.zPosition = depthHud + 6;
    self.skillsLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.skillsLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    self.skillsLbl.position = CGPointMake(self.bgLifeBar.position.x + self.bgLifeBar.frame.size.width + 10, 60);
    self.skillsLbl.text = @"Skills:";
    
    [self.hudContainer addChild:self.skillsLbl];
    
    // Cria as skills
    self.skillsContainer = [SKNode node];
    self.skillsContainer.position = CGPointMake(self.skillsLbl.position.x + self.skillsLbl.frame.size.width + 50, 50);
    [self.skillsContainer setScale:0.75f];
    
    [self updateSkillsBar];
    [self.hudContainer addChild:self.skillsContainer];
    
    
    [self.gameScene addChild:self.hudContainer];
    
    [self updateHUD];
}
// Remove o HUD da gamescene
- (void)removeHUD
{
    [self.hudContainer removeFromParent];
}
// Atualiza o hud
- (void)updateHUD
{
    // Busca os dados para preencher o HUD
    int curLife = [[[GameData gameData].data objectForKey:KEY_PLAYER_HEALTH] intValue];
    float maxLife = [[[GameData gameData].data objectForKey:KEY_PLAYER_MAX_HEALTH] intValue];
    int curLevel = [[[GameData gameData].data objectForKey:KEY_PLAYER_LEVEL] intValue];
    int xp = [[[GameData gameData].data objectForKey:KEY_PLAYER_EXP] intValue];
    
    // Atualiza o lifebar
    self.lifeBar.xScale = curLife / maxLife;
    self.lifeLbl.text = [NSString stringWithFormat:@"%i", curLife];
    
    // Atualiza o teto de XP e level
    self.levelLbl.text = [NSString stringWithFormat:@"Current level: %i", curLevel];
    self.xpLbl.position = CGPointMake(self.bgLifeBar.position.x + self.bgLifeBar.frame.size.width, 10);
    self.xpLbl.text = [NSString stringWithFormat:@"XP: %i", xp];
}
// Insere as skills na hud
- (void)updateSkillsBar
{
    [self.skillsContainer removeAllChildren];
    
    // Cria as skills uma a uma
    NSArray *skills = [[GameController gameController] getPlayerSkills];
    
    int i = 0;
    for (ComponentDraggableAttack *attack in skills)
    {
        GPEntity *entity = [GFXBuilder createAttack:130 * i y:0 cooldown:attack.skillCooldown damage:attack.damage skillType:attack.skillType depth:depthHud + 1];
        
        [self.skillsContainer addChild:entity.node];
        
        i++;
    }
}

- (void)gameSceneDidAddToView:(GPGameScene *)gameScene
{
    [self rebuildHUD];
    [[GameController gameController] addObserver:self];
}
- (void)gameSceneWillBeMovedFromView:(GPGameScene *)gameScene
{
    [[GameController gameController] removeObserver:self];
}
- (void)willRemoveFromScene
{
    [self removeHUD];
}

- (void)gameControllerDidReset
{
    [self rebuildHUD];
}

- (void)gameControllerDidUnlockSkills:(NSMutableArray *)skills
{
    [self updateSkillsBar];
}

- (void)gameControllerDidUpdatePlayerHP:(int)playerHP
{
    [self updateHUD];
}

@end
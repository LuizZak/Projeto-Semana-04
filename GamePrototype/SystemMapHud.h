//
//  SystemMapHud.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 28/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPSystem.h"
#import "GameController.h"

@interface SystemMapHud : GPSystem <GameControllerObserver>

// Container da hud
@property SKNode *hudContainer;

// Nó da barra de life
@property SKSpriteNode *lifeBar;
@property SKSpriteNode *bgLifeBar;
@property SKLabelNode *lifeLbl;

// Nó do texto de XP
@property SKLabelNode *xpLbl;
// Nó do texto de level
@property SKLabelNode *levelLbl;

// Label de skills
@property SKLabelNode *skillsLbl;

// Container das skills
@property SKNode *skillsContainer;

@end
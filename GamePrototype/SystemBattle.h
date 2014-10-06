//
//  AttackDrag.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GPSystem.h"
#import "CommonImports.h"
#import "Som.h"
#import "GameController.h"
#import "ActionBarManager.h"

@interface SystemBattle : GPSystem <GameControllerObserver>

/// List of enemies
@property GPEntitySelector *enemySelector;
@property NSMutableArray *enemiesArray;

/// Player selector
@property GPEntitySelector *playerSelector;
@property GPEntity *playerEntity;

/// AI Selector
@property GPEntitySelector *AISelector;

/// Attacks selector
@property GPEntitySelector *attacksSelector;

/// The action bar binded to the player actions
@property ActionBarManager *playerActionBar;

/// Current skill being dragged
@property CGPoint dragOffset;
@property GPEntity *currentDrag;

/// Nó sendo utilizado para demarcar a skill selecionada atualmente
@property SKSpriteNode *selectionNode;

/// Music player da música de fundo atual
@property AVAudioPlayer *bgMusicPlayer;

/// Arrsy de frames do cooldown das skills
@property NSArray *cooldownFrames;

/// Acumulador do XP de batalha
@property int battleXP;

/// Se a batalha está acontecendo
@property BOOL inBattle;

/// Se o jogador pode apertar a tela para voltar ao mapa
@property BOOL tapToExit;

/// Se o jogador ganhou a batalha
@property BOOL didWonBattle;

@end
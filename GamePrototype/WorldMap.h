//
//  WorldMap.h
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "GPGameScene.h"
#import "MyScene.h"
#import "CommonImports.h"

@interface WorldMap : GPGameScene

// Metodo que calcula quando ira aparecer inimigos
- (BOOL)randomBattle;

// Metodo que chama a cena de batalha
- (void)goToBattle;

@end
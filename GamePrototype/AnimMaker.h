//
//  AnimMaker.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 25/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ComponentDraggableAttack.h"

@interface AnimMaker : NSObject

// Cria um nó de animação de level up
+ (SKNode*)createLevelUpAnim:(int)newLevel;

// Cria um nó de animação de ganho de skill
+ (SKNode*)createSkillAnim:(ComponentDraggableAttack*)newAttack;

@end
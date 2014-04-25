//
//  AnimMaker.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 25/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "AnimMaker.h"

@implementation AnimMaker

// Cria um nó de animação de level up
+ (SKNode*)createLevelUpAnim:(int)newLevel
{
    SKNode *node = [SKNode node];
    SKAction *anim = [SKAction sequence:@[[SKAction scaleTo:1 duration:0.15f]]];
    
    [node setScale:0.8f];
    
    // Cria um label dentro
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    labelNode.text = @"Level Up!";
    labelNode.fontColor = [UIColor yellowColor];
    [node addChild:labelNode];
    
    [node runAction:anim];
    return node;
}

// Cria um nó de animação de ganho de skill
+ (SKNode*)createSkillAnim:(ComponentDraggableAttack*)newAttack
{
    SKNode *node = [SKNode node];
    SKAction *anim = [SKAction sequence:@[[SKAction scaleTo:1 duration:0.15f]]];
    
    [node setScale:0.8f];
    
    // Cria um label dentro
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    labelNode.text = [NSString stringWithFormat:@"New skill '%@' unlocked!", newAttack.skillName];
    [node addChild:labelNode];
    
    [node runAction:anim];
    return node;
}

@end
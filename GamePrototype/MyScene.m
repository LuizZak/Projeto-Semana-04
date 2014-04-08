//
//  MyScene.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "MyScene.h"
#import "SystemAttackDrag.h"
#import "ComponentDraggableAttack.h"

@implementation MyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        [self addSystem:[[SystemAttackDrag alloc] initWithGameScene:self]];
        
        GPEntity *en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)]];
        en.node.position = CGPointMake(20, 213);
        [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:1]];
        
        [self addEntity:en];
        
        en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)]];
        en.node.position = CGPointMake(60, 213);
        [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:5]];
        
        [self addEntity:en];
        
        en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(30, 30)]];
        en.node.position = CGPointMake(100, 213);
        [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:10]];
        
        [self addEntity:en];
        
        NSArray *array;
        
        array = [self getEntitiesWithSelectorRule:GPRuleAnd(GPRuleNot(GPRuleType(2)), GPRuleID(1))];
        array = [self getEntitiesWithSelectorRule:GPRuleComponent([GPComponent class])];
    }
    return self;
}

@end
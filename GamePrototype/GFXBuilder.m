//
//  GFXBuilder.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 28/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GFXBuilder.h"
#import "CommonImports.h"

@implementation GFXBuilder

+ (GPEntity*)createAttack:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage skillType:(SkillType)skillType
{
    return [self createAttack:x y:y cooldown:cooldown damage:damage skillType:skillType depth:12];
}

+ (GPEntity*)createAttack:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage skillType:(SkillType)skillType depth:(int)depth
{
    SKSpriteNode *attachGraph;
    SKLabelNode *damageLbl = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    SKSpriteNode *cooldownAnim = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)];
    cooldownAnim.alpha = 0;
    cooldownAnim.name = @"COOLDOWN";
    
    damageLbl.text = [NSString stringWithFormat:@"%.0lf", damage];
    damageLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    damageLbl.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    damageLbl.position = CGPointMake(45, -45);
    
    if(skillType == SkillFireball)
    {
        attachGraph = [SKSpriteNode spriteNodeWithImageNamed:@"bola-de-fogo"];
        attachGraph.zRotation = M_PI / 4;
        [attachGraph setScale:MIN(0.35f, 0.1f + damage / 150)];
    }
    else if(skillType == SkillMelee)
    {
        attachGraph = [SKSpriteNode spriteNodeWithImageNamed:@"bola-de-fogo"];
    }
    
    GPEntity *en = [[GPEntity alloc] initWithNode:[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(100, 100)]];
    en.node.position = CGPointMake(x, y);
    en.node.zPosition = depth + 5;
    [en addComponent:[[ComponentDraggableAttack alloc] initWithSkillCooldown:cooldown damage:damage skillType:skillType startEnabled:YES]];
    
    attachGraph.zPosition = depth;
    damageLbl.zPosition = depth + 1;
    cooldownAnim.zPosition = depth + 2;
    
    [en.node addChild:attachGraph];
    [en.node addChild:damageLbl];
    [en.node addChild:cooldownAnim];
    
    en.type = PLAYER_TYPE;
    
    return en;
}

@end
//
//  SystemHealthIndicator.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 09/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemHealthIndicator.h"
#import "ComponentHealth.h"
#import "ComponentHealthIndicator.h"

// LifeBar
@implementation LifeBar

@end

// SystemHealthIndicator
@implementation SystemHealthIndicator

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleAnd(GPRuleComponent([ComponentHealth class]), GPRuleComponent([ComponentHealthIndicator class])));
        self.lifeBarsArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    for(LifeBar *lb in self.lifeBarsArray)
    {
        ComponentHealth *hc = (ComponentHealth*)[lb.entity getComponent:[ComponentHealth class]];
        
        lb.healthBar.node.xScale = hc.health / hc.maxHealth;
    }
}

- (BOOL)gameSceneDidAddEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    BOOL ret = [super gameSceneDidAddEntity:gameScene entity:entity];
    
    if(ret != false)
    {
        // Cria uma life bar para esta entidade
        [self createLifeBar:entity];
    }
    
    return ret;
}

- (LifeBar*)createLifeBar:(GPEntity*)entity
{
    LifeBar *bar = [[LifeBar alloc] init];
    
    ComponentHealthIndicator *healthComp = GET_COMPONENT(entity, ComponentHealthIndicator);
    
    float barWidth = healthComp.barWidth;
    float barHeight = healthComp.barHeight;
    
    SKSpriteNode *backNode = [SKSpriteNode spriteNodeWithColor:healthComp.barBackColor size:CGSizeMake(barWidth, barHeight)];
    SKSpriteNode *barNode = [SKSpriteNode spriteNodeWithColor:healthComp.barFrontColor size:CGSizeMake(barWidth - 10, barHeight - 10)];
    
    bar.healthBar = [[GPEntity alloc] initWithNode:barNode];
    
    [self.gameScene addEntity:bar.healthBar];
    
    barNode.anchorPoint = CGPointMake(1, 0.5f);
    barNode.position = CGPointMake(barWidth / 2 - 5, entity.node.frame.size.height + barHeight / 1.5f);
    
    backNode.position = CGPointMake(0, entity.node.frame.size.height + barHeight / 1.5f);
    
    [barNode removeFromParent];
    [entity.node addChild:backNode];
    [entity.node addChild:barNode];
    
    bar.entity = entity;
    
    [self.lifeBarsArray addObject:bar];
    
    return bar;
}

@end
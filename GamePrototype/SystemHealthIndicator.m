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

// RuleLifeBarEnabled
@implementation RuleLifeBarEnabled

- (BOOL)applyRule:(GPEntity *)entity
{
    BOOL ret = false;
    
    ComponentHealthIndicator *hci = (ComponentHealthIndicator*)[entity getComponent:[ComponentHealthIndicator class]];
    ComponentHealth *hc = (ComponentHealth*)[entity getComponent:[ComponentHealth class]];
    
    if(hci != nil && hc != nil)
    {
        ret = YES;
    }
    
    return ret;
}

@end

// SystemHealthIndicator
@implementation SystemHealthIndicator

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate([[RuleLifeBarEnabled alloc] init]);
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
    
    float barWidth = ((ComponentHealthIndicator*)[entity getComponent:[ComponentHealthIndicator class]]).barWidth;
    
    SKSpriteNode *barNode = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(barWidth, 5)];
    
    bar.healthBar = [[GPEntity alloc] initWithNode:barNode];
    
    [self.gameScene addEntity:bar.healthBar];
    
    barNode.position = CGPointMake(0, [entity.node calculateAccumulatedFrame].size.height / 2 + 5);
    [barNode removeFromParent];
    [entity.node addChild:barNode];
    
    bar.entity = entity;
    
    [self.lifeBarsArray addObject:bar];
    
    return bar;
}

@end
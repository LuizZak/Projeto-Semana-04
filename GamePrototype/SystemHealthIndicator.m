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
        lb.healthLabelNode.text = [NSString stringWithFormat:@"%.0lf", hc.health];
        
        CGPoint labelScale = [self calculateAcumulatedScale:lb.healthLabelNode];
        
        if(labelScale.x <= 0)
        {
            lb.healthLabelNode.xScale = -lb.healthLabelNode.xScale;
        }
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

- (BOOL)testEntityToRemove:(GPEntity *)entity
{
    BOOL ret = [super testEntityToRemove:entity];
    
    if(ret)
    {
        // Remove o lifebar
        [self removeLifeBar:entity];
    }
    
    return ret;
}

- (void)removeLifeBar:(GPEntity*)entity
{
    // Acha a lifebar específica
    for (LifeBar *bar in self.lifeBarsArray)
    {
        if(bar.entity == entity)
        {
            [self.gameScene removeEntity:bar.healthBar];
            [bar.healthBar.node removeFromParent];
            [bar.backBar removeFromParent];
        }
    }
}

- (LifeBar*)createLifeBar:(GPEntity*)entity
{
    LifeBar *bar = [[LifeBar alloc] init];
    
    ComponentHealthIndicator *healthComp = GET_COMPONENT(entity, ComponentHealthIndicator);
    
    float barWidth = healthComp.barWidth;
    float barHeight = healthComp.barHeight;
    int barY = entity.node.frame.size.height / 2 / entity.node.yScale;
    
    SKSpriteNode *backNode = [SKSpriteNode spriteNodeWithColor:healthComp.barBackColor size:CGSizeMake(barWidth, barHeight)];
    SKSpriteNode *barNode  = [SKSpriteNode spriteNodeWithColor:healthComp.barFrontColor size:CGSizeMake(barWidth - 10, barHeight - 10)];
    SKLabelNode *lblNode   = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    
    // Inicia o label node
    lblNode.text = @"0";
    lblNode.fontSize = barHeight;
    lblNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    
    bar.healthBar = [[GPEntity alloc] initWithNode:barNode];
    
    // Inicia a barra da frente
    barNode.anchorPoint = CGPointMake(1, 0.5f);
    barNode.position = CGPointMake(barWidth / 2 - 5, barY + barHeight / 1.5f);
    
    // Inicia a barra de trás
    backNode.position = CGPointMake(0, barY + barHeight / 1.5f);
    
    [self.gameScene addEntity:bar.healthBar];
    
    [barNode removeFromParent];
    [entity.node addChild:backNode];
    [entity.node addChild:barNode];
    [backNode addChild:lblNode];
    
    bar.backBar = backNode;
    bar.healthLabelNode = lblNode;
    bar.entity = entity;
    
    [self.lifeBarsArray addObject:bar];
    
    return bar;
}

// Retorna a escala acumulada de um nó
- (CGPoint)calculateAcumulatedScale:(SKNode*)node
{
    CGPoint point = CGPointMake(1, 1);
    
    // Volta através da árvore de ancestrais do nó e acumula a escala com multiplicação
    while(node != nil)
    {
        point.x *= node.xScale;
        point.y *= node.yScale;
        
        node = node.parent;
    }
    
    return point;
}

@end
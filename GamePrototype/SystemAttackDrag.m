//
//  AttackDrag.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemAttackDrag.h"
#import "ComponentHealth.h"
#import "ComponentDraggableAttack.h"

@implementation SystemAttackDrag

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleAnd(GPRuleComponent([ComponentDraggableAttack class]), GPRuleType(PLAYER_TYPE)));
        self.enemySelector = GPEntitySelectorCreate(GPRuleAnd(GPRuleComponent([ComponentHealth class]), GPRuleType(ENEMY_TYPE)));
        self.enemiesArray = [NSMutableArray array];
        
        self.playerSelector = GPEntitySelectorCreate(GPRuleID(PLAYER_ID));
        
        self.inBattle = YES;
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    for(GPEntity *entity in entitiesArray)
    {
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[entity getComponent:[ComponentDraggableAttack class]];
        comp.currentCooldown -= interval;
        
        if(comp.currentCooldown <= 0)
        {
            [(SKSpriteNode*)entity.node setColor:[UIColor redColor]];
        }
    }
    
    [self runAI];
}

- (BOOL)gameSceneDidAddEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    BOOL ret;
    if((ret = [super gameSceneDidAddEntity:gameScene entity:entity]))
    {
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[entity getComponent:[ComponentDraggableAttack class]];
        
        comp.startPoint = entity.node.position;
    }
    
    if([self.enemySelector applyRuleToEntity:entity])
    {
        [self.enemiesArray addObject:entity];
    }
    
    return ret;
}

- (BOOL)gameSceneDidRemoveEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    [self.enemiesArray removeObject:entity];
    
    return [super gameSceneDidRemoveEntity:gameScene entity:entity];
}

- (BOOL)testEntityToAdd:(GPEntity *)entity
{
    BOOL ret = [super testEntityToAdd:entity];
    
    if([self.playerSelector applyRuleToEntity:entity])
    {
        self.playerEntity = entity;
    }
    
    return ret;
}

- (BOOL)testEntityToRemove:(GPEntity *)entity
{
    BOOL ret = [super testEntityToRemove:entity];
    
    if(self.playerEntity == entity)
    {
        self.playerEntity = nil;
    }
    
    return ret;
}

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    if(!self.inBattle)
    {
        return;
    }
    
    for(GPEntity *entity in entitiesArray)
    {
        if([entity.node containsPoint:pt])
        {
            ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[entity getComponent:[ComponentDraggableAttack class]];
            
            if(comp.currentCooldown <= 0)
            {
                self.currentDrag = entity;
                self.dragOffset = CGPointMake(pt.x - self.currentDrag.node.position.x, pt.y - self.currentDrag.node.position.y);
                return;
            }
        }
    }
}

- (void)gameSceneDidReceiveTouchesMoved:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    if(self.currentDrag != nil)
    {
        self.currentDrag.node.position = CGPointMake(pt.x - self.dragOffset.x, pt.y - self.dragOffset.y);
    }
}

- (void)gameSceneDidReceiveTouchesEnd:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.currentDrag != nil)
    {
        UITouch *tch = [touches anyObject];
        CGPoint pt = [tch locationInNode:gameScene];
        
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[self.currentDrag getComponent:[ComponentDraggableAttack class]];
        
        // Checa se o jogador largou a skill em cima de um inimigo
        for(GPEntity *entity in self.enemiesArray)
        {
            if([entity.node containsPoint:pt])
            {
                ComponentHealth *health = (ComponentHealth*)[entity getComponent:[ComponentHealth class]];
                
                if(health.health > 0)
                {
                    comp.currentCooldown = comp.skillCooldown;
                    
                    [self attackEntity:entity damage:comp.damage];
                    
                    break;
                }
            }
        }
        
        SKAction *act = [SKAction moveTo:comp.startPoint duration:0.1];
        
        [(SKSpriteNode*)self.currentDrag.node setColor:[UIColor yellowColor]];
        [self.currentDrag.node runAction:act];
    }
    
    self.currentDrag = nil;
}

// Roda a AI de ataque dos inimigos
- (void)runAI
{
    
}

- (void)createFireBall:(GPEntity*)source target:(GPEntity*)target radius:(float)radius
{
    SKAction *attack = [SKAction sequence:@[[SKAction moveTo:target.node.position duration:0.2f], [SKAction removeFromParent]]];
    
    SKSpriteNode *fireballNode = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(radius, radius)];
    
    fireballNode.position = source.node.position;
    
    [fireballNode runAction:attack];
    
    [self.gameScene addChild:fireballNode];
}

- (void)killEntity:(GPEntity*)entity
{
    SKAction *dieAnimation = [SKAction sequence:@[[SKAction group:@[[SKAction fadeAlphaTo:0 duration:1], [SKAction moveTo:CGPointMake(entity.node.position.x, entity.node.position.y - 30) duration:1]]],
    [SKAction runBlock:^(void) {
        [self.gameScene removeEntity:entity];
    }]]];
    
    [entity.node runAction:dieAnimation];
    
    if(entity == self.playerEntity)
    {
        self.inBattle = NO;
    }
}

- (void)attackEntity:(GPEntity*)entity damage:(float)damage
{
    // Anima o ataque do jogador
    [self createFireBall:self.playerEntity target:entity radius:10 + damage / 2];
    
    ComponentHealth *hc = (ComponentHealth*)[entity getComponent:[ComponentHealth class]];
    
    hc.health -= damage;
    
    if(hc.health <= 0)
    {
        [self killEntity:entity];
        
        hc.health = 0;
    }
    else
    {
        // Cria uma animação de dano
        UIColor *originalColor = [UIColor whiteColor];
        
        if([entity.node isKindOfClass:[SKSpriteNode class]])
        {
            originalColor = ((SKSpriteNode*)entity.node).color;
        }
        
        SKAction *damageAction = [SKAction sequence:@[[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0], [SKAction colorizeWithColor:originalColor colorBlendFactor:1 duration:0.25f]]];
        
        [entity.node runAction:damageAction];
    }
}

@end
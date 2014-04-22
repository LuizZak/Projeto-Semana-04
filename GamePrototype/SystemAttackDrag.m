//
//  AttackDrag.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemAttackDrag.h"
#import "ComponentAIBattle.h"
#import "ComponentBattleState.h"
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
        
        self.playerSelector = GPEntitySelectorCreate(GPRuleAnd(GPRuleComponent([ComponentBattleState class]), GPRuleID(PLAYER_ID)));
        
        self.AISelector = GPEntitySelectorCreate(GPRuleAnd(GPRuleAnd(GPRuleAnd(GPRuleComponent([ComponentDraggableAttack class]), GPRuleComponent([ComponentBattleState class])), GPRuleComponent([ComponentAIBattle class])), GPRuleType(ENEMY_TYPE)));
        
        self.attacksSelector = GPEntitySelectorCreate(GPRuleComponent([ComponentDraggableAttack class]));
        
        self.inBattle = YES;
        
        self.selectionNode = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(64, 64)];
        self.selectionNode.zPosition = -5;
        [self.gameScene addChild:self.selectionNode];
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    if(!self.inBattle)
    {
        self.currentDrag = nil;
    }
    
    if(self.currentDrag != nil)
    {
        self.selectionNode.position = self.currentDrag.node.position;
        self.selectionNode.size = CGSizeMake(self.currentDrag.node.frame.size.width + 5, self.currentDrag.node.frame.size.height + 5);
        self.selectionNode.hidden = NO;
    }
    else
    {
        self.selectionNode.hidden = YES;
    }
    
    NSArray *attacks = [self.gameScene getEntitiesWithSelector:self.attacksSelector];
    
    for(GPEntity *attackEntity in attacks)
    {
        NSArray *attacksArray = GET_COMPONENTS(attackEntity, ComponentDraggableAttack);
        
        for(ComponentDraggableAttack *attackEntity in attacksArray)
        {
            attackEntity.currentCooldown -= interval;
        }
    }
    
    for(GPEntity *entity in entitiesArray)
    {
        ComponentDraggableAttack *comp = GET_COMPONENT(entity, ComponentDraggableAttack);
        
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
        ComponentDraggableAttack *comp = GET_COMPONENT(entity, ComponentDraggableAttack);
        
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
    
    // Checa se o jogador pode atacar
    ComponentBattleState *bs = GET_COMPONENT(self.playerEntity, ComponentBattleState);
    if(!bs.canAttack)
    {
        return;
    }
    
    if(self.currentDrag != nil)
    {
        ComponentDraggableAttack *comp = (ComponentDraggableAttack*)[self.currentDrag getComponent:[ComponentDraggableAttack class]];
        
        // Checa se o jogador largou a skill em cima de um inimigo
        for(GPEntity *entity in self.enemiesArray)
        {
            if([entity.node containsPoint:pt])
            {
                ComponentHealth *health = (ComponentHealth*)[entity getComponent:[ComponentHealth class]];
                
                if(health.health > 0)
                {
                    [self attackEntity:comp source:self.playerEntity target:entity];
                    
                    break;
                }
            }
        }
        
        SKAction *act = [SKAction moveTo:comp.startPoint duration:0.1];
        
        [(SKSpriteNode*)self.currentDrag.node setColor:[UIColor yellowColor]];
        [self.currentDrag.node runAction:act];
    }
    
    self.currentDrag = nil;
    
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

/*- (void)gameSceneDidReceiveTouchesMoved:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    if(self.currentDrag != nil)
    {
        self.currentDrag.node.position = CGPointMake(pt.x - self.dragOffset.x, pt.y - self.dragOffset.y);
    }
}*/

/*
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
                    [self attackEntity:comp source:self.playerEntity target:entity];
                    
                    break;
                }
            }
        }
        
        SKAction *act = [SKAction moveTo:comp.startPoint duration:0.1];
        
        [(SKSpriteNode*)self.currentDrag.node setColor:[UIColor yellowColor]];
        [self.currentDrag.node runAction:act];
    }
    
    self.currentDrag = nil;
}*/

// Roda a AI de ataque dos inimigos
- (void)runAI
{
    if(!self.inBattle)
        return;
    
    // Seleciona os inimigos que podem atacar
    NSArray *enemies = [self.gameScene getEntitiesWithSelector:self.AISelector];
    
    for (GPEntity *enemy in enemies)
    {
        // Checa se o inimigo está vivo
        ComponentHealth *health = GET_COMPONENT(enemy, ComponentHealth);
        
        if(health.health <= 0)
            continue;
        
        // Checa primeiro se o inimigo pode atacar
        ComponentBattleState *battleState = GET_COMPONENT(enemy, ComponentBattleState);
        
        if(!battleState.canAttack)
            continue;
        
        // Pega as skills do inimigo
        NSArray *skills = GET_COMPONENTS(enemy, ComponentDraggableAttack);
        
        // Acha a primeira skill sem cooldown e usa ela contra o inimigo
        for(ComponentDraggableAttack *attack in skills)
        {
            if(attack.currentCooldown <= 0)
            {
                // Roda um dado para o ataque não ser constante
                if(arc4random() % 10 == 0)
                {
                    [self attackEntity:attack source:enemy target:self.playerEntity];
                    
                    break;
                }
            }
        }
    }
}

- (void)attackEntity:(ComponentDraggableAttack*)attack source:(GPEntity*)source target:(GPEntity*)target
{
    attack.currentCooldown = attack.skillCooldown;
    
    float damage = attack.damage;
    
    // Anima o ataque
    if(attack.skillType == SkillFireball)
    {
        [self createFireBall:source target:target radius:10 + damage / 2];
    }
    else if(attack.skillType == SkillMelee)
    {
        [self meleeAttack:source target:target];
    }
    
    ComponentHealth *hc = (ComponentHealth*)[target getComponent:[ComponentHealth class]];
    
    hc.health -= damage;
    
    if(hc.health <= 0)
    {
        [self killEntity:target];
        
        hc.health = 0;
    }
    else
    {
        // Cria uma animação de dano
        UIColor *originalColor = [UIColor whiteColor];
        
        if([target.node isKindOfClass:[SKSpriteNode class]])
        {
            originalColor = ((SKSpriteNode*)target.node).color;
        }
        
        SKAction *damageAction = [SKAction sequence:@[[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0], [SKAction colorizeWithColor:originalColor colorBlendFactor:0 duration:0.25f]]];
        
        [target.node runAction:damageAction];
    }
}

- (void)killEntity:(GPEntity*)entity
{
    SKAction *dieAnimation = [SKAction sequence:@[[SKAction group:@[[SKAction fadeAlphaTo:0 duration:1], [SKAction moveTo:CGPointMake(entity.node.position.x, entity.node.position.y - 30) duration:1]]],
                                                  [SKAction runBlock:^(void) {
        [self.gameScene removeEntity:entity];
    }]]];
    
    dieAnimation = [SKAction group:@[[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0], dieAnimation]];
    
    [entity.node runAction:dieAnimation];
    
    if(entity == self.playerEntity)
    {
        self.inBattle = NO;
    }
}

- (void)meleeAttack:(GPEntity*)source target:(GPEntity*)target
{
    ComponentBattleState *bs = GET_COMPONENT(source, ComponentBattleState);
    
    bs.canAttack = NO;
    
    SKAction *attack = [SKAction sequence:@[[SKAction moveTo:target.node.position duration:0.2f], [SKAction moveTo:source.node.position duration:0.2f],
    [SKAction runBlock:^{
        bs.canAttack = YES;
    }]]];
    
    [source.node runAction:attack];
}

- (void)createFireBall:(GPEntity*)source target:(GPEntity*)target radius:(float)radius
{
    SKAction *attack = [SKAction sequence:@[[SKAction moveTo:target.node.position duration:0.2f], [SKAction removeFromParent]]];
    
    SKSpriteNode *fireballNode = [SKSpriteNode spriteNodeWithImageNamed:@"bola-de-fogo"];//[SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(radius, radius)];
    
    [fireballNode setScale:0.3f];
    
    fireballNode.position = source.node.position;
    
    [fireballNode runAction:attack];
    
    [self.gameScene addChild:fireballNode];
}

@end
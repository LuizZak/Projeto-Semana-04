//
//  AttackDrag.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 08/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemBattle.h"
#import "AnimMaker.h"
#import "ComponentBounty.h"
#import "ComponentAIBattle.h"
#import "ComponentBattleState.h"
#import "ComponentHealth.h"
#import "ComponentHealthIndicator.h"
#import "ComponentDraggableAttack.h"
#import "WorldMap.h"
#import "Ranking.h"
#import "SceneMenu.h"

#define PLAYER_WON 0
#define ENEMY_WON 1

@implementation SystemBattle

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
        self.tapToExit = NO;
        
        self.selectionNode = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(64, 64)];
        self.selectionNode.zPosition = -5;
        [self.gameScene addChild:self.selectionNode];
        
        [Som som].nodeForSound = gameScene;
        
        [[GameController gameController] addObserver:self];
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

/*
- (BOOL)gameSceneDidRemoveEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    return [super gameSceneDidRemoveEntity:gameScene entity:entity];
}*/

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
        
        // Faz o jogador perder a batalha
        [self loseBattle];
    }
    
    [self.enemiesArray removeObject:entity];
    
    // Faz o jogador ganhar a batalha
    if(self.enemiesArray.count == 0 && self.inBattle)
    {
        [self winBattle];
    }
    
    return ret;
}

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    if(self.tapToExit)
    {
        if (self.didWonBattle)
        {
            SKTransition *reveal = [SKTransition fadeWithDuration:1.0];
            WorldMap *worldMap = [GameData gameData].world;
            [self.gameScene.view presentScene:worldMap transition:reveal];
            return;
        }else
        {
            SKTransition *reveal = [SKTransition fadeWithDuration:1.0];
            SceneMenu* menu = [[SceneMenu alloc] initWithSize:self.gameScene.size];
            [self.gameScene.view presentScene:menu transition:reveal];
            return;
        }
    }
    
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

// Faz o jogador perder a batalha
- (void)loseBattle
{
    self.inBattle = NO;
    
    self.didWonBattle = NO;
    
    // Toca música de lose
    [self.bgMusicPlayer stop];
    self.bgMusicPlayer = [[Som som] tocarSomGameOver];
    
    [self finishBattle];
    
}

// Faz o jogador ganhar a batalha
- (void)winBattle
{
    self.inBattle = NO;
    
    self.didWonBattle = YES;
    
    // Toca música de lose
    [self.bgMusicPlayer stop];
    self.bgMusicPlayer = [[Som som] tocarSomVitoria];
    
    [self finishBattle];
}

- (void)finishBattle
{
    // Acumuda a mensagem de win
    if(!self.didWonBattle)
    {
        [self createBattleMessage:@"You lost!" won:YES animKeyName:nil];
    }
    else
    {
        // Soma o XP da batalha
        [[GameController gameController] givePlayerXP:self.battleXP];
        
        [self createBattleMessage:@"You win!" won:YES animKeyName:nil];
    }
    
    self.tapToExit = YES;
}

// Cria uma mensagem de fim de batalha
- (SKNode*)createBattleMessage:(NSString*)labelText won:(BOOL)won animKeyName:(NSString*)key
{
    // Cria o texto de vitória e o apresenta na tela
    SKNode *holderNode = [SKNode node];
    SKLabelNode *textNode = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    
    textNode.text = labelText;
    textNode.fontSize = 100;
    
    textNode.fontColor = won ? [UIColor colorWithRed:0.8f green:1 blue:0.8f alpha:1] : [UIColor colorWithRed:1 green:0.8f blue:0.8f alpha:1];
    
    [holderNode addChild:textNode];
    
    holderNode.alpha = 0;
    holderNode.position = CGPointMake(self.gameScene.frame.size.width / 2, self.gameScene.frame.size.height / 1.5f);
    
    SKAction *animAction = [SKAction group:@[[SKAction fadeAlphaTo:1 duration:2], [SKAction scaleTo:1.2f duration:2]]];
    
    animAction = [SKAction sequence:@[animAction,
    [SKAction runBlock:^{
        self.tapToExit = YES;
    }]]];
    
    if(key == nil)
    {
        [holderNode runAction:animAction];
    }
    else
    {
        [holderNode runAction:animAction withKey:key];
    }
    
    holderNode.zPosition = 100;
    
    [self.gameScene addChild:holderNode];
    
    return holderNode;
}

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
        [self createFireBall:source target:target radius:damage / 100 forDamage:damage];
    }
    else if(attack.skillType == SkillMelee)
    {
        [self meleeAttack:source target:target forDamage:damage];
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
    
    // Remove o componente de HealthBar
    [entity removeComponentsWithClass:[ComponentHealthIndicator class]];
    [self.gameScene entityModified:entity];
    
    [entity.node runAction:dieAnimation];
    
    if(entity == self.playerEntity)
    {
        [[Som som] tocarSomMorteDragao];
        
        self.inBattle = NO;
        
        [[Ranking lista] criarPontuacao:[[Ranking lista] currentPlayerName] :[[Ranking lista] currentPlayerScore]];
    }
    else
    {
        [[Som som] tocarSomMorteHomem];
        
        [[Ranking lista] setCurrentPlayerScore:[[Ranking lista] currentPlayerScore] + 10];
        
        ComponentBounty *bounty = GET_COMPONENT(entity, ComponentBounty);
        self.battleXP += bounty.bountyXP;
    }
}

- (void)meleeAttack:(GPEntity*)source target:(GPEntity*)target forDamage:(float)damage
{
    ComponentBattleState *bs = GET_COMPONENT(source, ComponentBattleState);
    
    bs.canAttack = NO;
    
    SKAction *attack = [SKAction sequence:@[[SKAction moveTo:target.node.position duration:0.2f],
    [SKAction runBlock:^{
        CGPoint point = target.node.position;
        
        // Randomiza um pouco o ponto através da área do personagem
        point.x -= target.node.frame.size.width / 4;
        point.y -= target.node.frame.size.height / 4;
        
        point.x += arc4random() % (int)(target.node.frame.size.width / 2);
        point.y += arc4random() % (int)(target.node.frame.size.height / 2);
        
        [self createDamagePopup:damage point:point];
        
        [[Som som] tocarSomEspada];
    }],
    [SKAction moveTo:source.node.position duration:0.2f],
    [SKAction runBlock:^{
        bs.canAttack = YES;
    }]]];
    
    [source.node runAction:attack];
}

- (void)createFireBall:(GPEntity*)source target:(GPEntity*)target radius:(float)radius forDamage:(float)damage
{
    SKAction *attack = [SKAction sequence:@[[SKAction moveTo:target.node.position duration:0.2f],
    [SKAction runBlock:^{
        SKSpriteNode *explosionNode = [SKSpriteNode spriteNodeWithImageNamed:@"explosao"];
        
        explosionNode.position = target.node.position;
        
        float scaleMod = (0.75f + radius) * target.node.yScale;
        
        [explosionNode setScale:scaleMod];
        
        SKAction *anim = [SKAction group:@[[SKAction fadeAlphaTo:0 duration:0.15f], [SKAction scaleTo:2 * scaleMod duration:0.15f]]];
        
        [explosionNode runAction:anim];
        
        [self.gameScene addChild:explosionNode];
        
        // Create a damage popup
        [self createDamagePopup:damage point:target.node.position];
        
        [[Som som] tocarSomExplosao];
        
    }], [SKAction removeFromParent]]];
    
    // Toca o som de ataque
    [[Som som] tocarSomFireBall];
    
    ComponentBattleState *battleState = GET_COMPONENT(source, ComponentBattleState);
    
    SKSpriteNode *fireballNode = [SKSpriteNode spriteNodeWithImageNamed:@"bola-de-fogo"];
    
    fireballNode.zPosition = 5;
    fireballNode.position = CGPointMake(source.node.position.x + battleState.projectilePoint.x, source.node.position.y + battleState.projectilePoint.y);
    
    [fireballNode setScale:0.3f + radius];
    [fireballNode runAction:attack];
    
    // Calcula a rotação do fireball
    float dx = target.node.position.x - source.node.position.x;
    float dy = (target.node.position.y - source.node.position.y);
    
    fireballNode.zRotation = atan2f(dy, dx);
    
    [self.gameScene addChild:fireballNode];
}

- (void)createDamagePopup:(float)damage point:(CGPoint)point
{
    SKAction *animAction = [SKAction group:@[[SKAction fadeAlphaTo:0 duration:1], [SKAction moveTo:CGPointMake(point.x, point.y + 100) duration:1]]];
    animAction = [SKAction sequence:@[animAction, [SKAction removeFromParent]]];
    SKLabelNode *textNode = [SKLabelNode labelNodeWithFontNamed:@"GillSans"];
    
    textNode.zPosition = 10;
    textNode.text = [NSString stringWithFormat:@"%.0lf", damage];
    textNode.position = point;
    [textNode runAction:animAction];
    
    [self.gameScene addChild:textNode];
}

- (void)gameControllerDidWinLevel:(int)oldLevel newLevel:(int)newLevel
{
    SKNode *node = [AnimMaker createLevelUpAnim:newLevel];
    
    node.position = CGPointMake(self.gameScene.frame.size.width / 2, self.gameScene.frame.size.height / 2);
    
    [self.gameScene addChild:node];
}

- (void)gameControllerDidUnlockSkills:(NSMutableArray *)skills
{
    int y = self.gameScene.frame.size.height / 2.25f;
    
    for(int i = 0; i < skills.count; i++)
    {
        SKNode *node = [AnimMaker createSkillAnim:skills[0]];
        
        node.position = CGPointMake(self.gameScene.frame.size.width / 2, y);
        
        [self.gameScene addChild:node];
        
        y -= 30;
    }
}

- (void)gameSceneDidAddToView:(GPGameScene *)gameScene
{
    self.bgMusicPlayer = [[Som som] tocarSomBatalha];
}
- (void)gameSceneWillBeMovedFromView:(GPGameScene *)gameScene
{
    [self.bgMusicPlayer stop];
    
    [[GameController gameController] removeObserver:self];
}

@end
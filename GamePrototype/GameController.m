//
//  GameController.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GameController.h"
#import "GameData.h"

@implementation GameController

+ (GameController *) gameController
{
    static GameController *gameController = nil;
    if (!gameController)
    {
        gameController = [[super allocWithZone:nil] init];
    }
    return gameController;
}

+ (id)allocWithZone: (struct _NSZone *)zone
{
    return [self gameController];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        observers = [NSMutableArray array];
        
        [GameData gameData];
        
        [self resetGameData];
    }
    return self;
}

- (void)addObserver:(id<GameControllerObserver>)observer
{
    [observers addObject:observer];
}

- (void)removeObserver:(id<GameControllerObserver>)observer
{
    [observers removeObject:observer];
}

- (void)resetGameData
{
    [[GameData gameData].data setObject:[NSNumber numberWithFloat:200] forKey:KEY_PLAYER_HEALTH];
    [[GameData gameData].data setObject:[NSNumber numberWithInt:3] forKey:KEY_PLAYER_SPAWN_X];
    [[GameData gameData].data setObject:[NSNumber numberWithInt:25] forKey:KEY_PLAYER_SPAWN_Y];
    [[GameData gameData].data setObject:[NSNumber numberWithInt:1] forKey:KEY_PLAYER_LEVEL];
    [[GameData gameData].data setObject:[NSNumber numberWithInt:0] forKey:KEY_PLAYER_EXP];
    
    [self updatePlayerHealth];
}

// Dá uma quantidade de XP para o player
- (void)givePlayerXP:(int)xp
{
    // Soma o XP do player
    int currentXP = [[[GameData gameData].data objectForKey:KEY_PLAYER_EXP] intValue];
    
    currentXP += xp;
    
    // Seta o XP
    [[GameData gameData].data setObject:[NSNumber numberWithInt:currentXP] forKey:KEY_PLAYER_EXP];
    
    // Notifica os observers
    for (id<GameControllerObserver> observer in observers)
    {
        if([observer respondsToSelector:@selector(gameControllerDidWinXP:)])
        {
            [observer gameControllerDidWinXP:currentXP];
        }
    }
    
    [self checkForLevelUp];
}

// Checa se o jogador upou de nível
- (void)checkForLevelUp
{
    int currentXP = [[[GameData gameData].data objectForKey:KEY_PLAYER_EXP] intValue];
    int currentLevel = [[[GameData gameData].data objectForKey:KEY_PLAYER_LEVEL] intValue];
    
    int levelCount = 5;
    int xpLevels[] = { 0, 100, 200, 400, 800, 1200 };
    int nextLevel;
    
    // Checa se o nível mudou de índice
    for(nextLevel = 0; nextLevel < levelCount; nextLevel++)
    {
        if(xpLevels[nextLevel] > currentXP)
        {
            break;
        }
    }
    
    if(currentLevel < nextLevel)
    {
        // Para checagem de skills novas
        NSArray *curSkills = [self getPlayerSkills];
        
        // Atualiza o nível
        [[GameData gameData].data setObject:[NSNumber numberWithInt:nextLevel] forKey:KEY_PLAYER_LEVEL];
        
        // Atualiza o sangue do jogador
        [self updatePlayerHealth];
        
        // Destrava skills
        NSArray *newSkills = [self getPlayerSkills];
        
        // Itera as skills
        NSMutableArray *unlockedSkills = [NSMutableArray array];
        for(int i = curSkills.count; i < newSkills.count; i++)
        {
            [unlockedSkills addObject:newSkills[i]];
        }
        
        // Notifica os observers das skills destravadas
        for (id<GameControllerObserver> observer in observers)
        {
            if([observer respondsToSelector:@selector(gameControllerDidUnlockSkills:)])
            {
                [observer gameControllerDidUnlockSkills:unlockedSkills];
            }
        }
        
        // Notifica os observers do nível novo
        for (id<GameControllerObserver> observer in observers)
        {
            if([observer respondsToSelector:@selector(gameControllerDidWinLevel:newLevel:)])
            {
                [observer gameControllerDidWinLevel:currentLevel newLevel:nextLevel];
            }
        }
    }
}

// Atualiza o sangue do jogador baseado no seu nível atual
- (void)updatePlayerHealth
{
    int currentHealth = [[[GameData gameData].data objectForKey:KEY_PLAYER_HEALTH] intValue];
    int currentLevel = [[[GameData gameData].data objectForKey:KEY_PLAYER_LEVEL] intValue];
    
    int newHP = 25 + 50 * currentLevel;
    
    if(currentHealth != newHP)
    {
        [[GameData gameData].data setObject:[NSNumber numberWithInt:newHP] forKey:KEY_PLAYER_HEALTH];
        
        // Notifica os observers
        for (id<GameControllerObserver> observer in observers)
        {
            if([observer respondsToSelector:@selector(gameControllerDidChangeMaxPlayerHP:)])
            {
                [observer gameControllerDidChangeMaxPlayerHP:newHP];
            }
        }
    }
}

- (NSMutableArray*)getPlayerSkills
{
    int currentLevel = [[[GameData gameData].data objectForKey:KEY_PLAYER_LEVEL] intValue];
    
    NSMutableArray *skillsArray = [NSMutableArray array];
    
    // Skill padrão
    [skillsArray addObject:[[ComponentDraggableAttack alloc] initWithSkillCooldown:1 damage:3 skillType:SkillFireball skillName:@"Fireball 1" startEnabled:YES]];
    
    if(currentLevel > 1)
    {
        [skillsArray addObject:[[ComponentDraggableAttack alloc] initWithSkillCooldown:5 damage:10 skillType:SkillFireball skillName:@"Fireball 2" startEnabled:YES]];
    }
    if(currentLevel > 3)
    {
        [skillsArray addObject:[[ComponentDraggableAttack alloc] initWithSkillCooldown:10 damage:30 skillType:SkillFireball skillName:@"Fireball 3" startEnabled:YES]];
    }
    if(currentLevel > 5)
    {
        [skillsArray addObject:[[ComponentDraggableAttack alloc] initWithSkillCooldown:13 damage:40 skillType:SkillFireball skillName:@"Fireball 4" startEnabled:YES]];
    }
    
    return skillsArray;
}

@end
//
//  SystemMovimentoAndar.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMovimentoAndar.h"
#import "ComponentHealth.h"
#import "ComponentMapaGrid.h"
#import "ComponentMovement.h"
#import "WorldMap.h"
#import "CommonImports.h"

@implementation SystemMovimentoAndar

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleAnd(GPRuleComponent([ComponentMovement class]), GPRuleID(PLAYER_ID)));
        
        self.deadZone = 30;
        
        self.dPad = [SKSpriteNode spriteNodeWithImageNamed:@"dpad.png"];
        self.dPad.hidden = YES;
        self.dPad.size = CGSizeMake(200.0, 200.0);
        self.dPad.zPosition = 10;
    }
    
    return self;
}

- (BOOL)gameSceneDidAddEntity:(GPGameScene *)gameScene entity:(GPEntity *)entity
{
    // Joga o Dpad para cima de todas as entidades
    [self.dPad removeFromParent];
    [gameScene addChild:self.dPad];
    
    return [super gameSceneDidAddEntity:gameScene entity:entity];
}

- (void)update:(NSTimeInterval)interval
{
    if(self.holdingTouch)
    {
        float dx = self.currentPoint.x - self.selectedPlace.x;
        float dy = self.currentPoint.y - self.selectedPlace.y;
        
        // Só move o personagem se o usuário mexer o dedo uam certa distância
        if(sqrt(dx * dx + dy * dy) > self.deadZone)
        {
            // 2 = left, 0 = right
            int dirx = DIR_LEFT;
            // 3 = bottom, 1 = top
            int diry = DIR_BOTTOM;
            
            if(dx > 0)
                dirx = DIR_RIGHT;
            if(dy > 0)
                diry = DIR_TOP;
            
            int dir = diry;
            
            if(fabsf(dx) > fabsf(dy))
                dir = dirx;
            
            for(GPEntity *entity in entitiesArray)
            {
                ComponentMovement *mov = (ComponentMovement*)[entity getComponent:[ComponentMovement class]];
                
                if (dir == DIR_TOP)
                {
                    mov.forceY += 1;
                }
                else if (dir == DIR_RIGHT)
                {
                    mov.forceX += 1;
                }
                else if (dir == DIR_BOTTOM)
                {
                    mov.forceY += -1;
                }
                else if (dir == DIR_LEFT)
                {
                    mov.forceX += -1;
                }
            }
            
            // Chama metodo que criara a batalha
            /*if([(WorldMap*)self.gameScene randomBattle])
            {
                self.holdingTouch = NO;
                self.dPad.hidden = YES;
            }*/
        }
    }
}

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    self.selectedPlace = [tch locationInNode:gameScene];
    self.currentPoint = self.selectedPlace;
    
    self.dPad.hidden = NO;
    self.dPad.position = CGPointMake(self.selectedPlace.x, self.selectedPlace.y);
    
    self.holdingTouch = YES;
}

- (void)gameSceneDidReceiveTouchesMoved:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    self.currentPoint = pt;
}

- (void)gameSceneDidReceiveTouchesEnd:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.dPad.hidden = YES;
    self.holdingTouch = NO;
}

@end

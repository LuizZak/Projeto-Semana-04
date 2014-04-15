//
//  SystemMovimentoAndar.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMovimentoAndar.h"
#import "ComponentHealth.h"

#define DIR_TOP 1
#define DIR_RIGHT 0
#define DIR_LEFT 2
#define DIR_BOTTOM 3


@implementation SystemMovimentoAndar

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleType(ENEMY_TYPE));
        //self.enemiesArray = [NSMutableArray array]; 
        
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    if(self.holdingTouch)
    {
        float dx = self.currentPoint.x - self.selectedPlace.x;
        float dy = self.currentPoint.y - self.selectedPlace.y;
        
        // Só move o personagem se o usuário mexer o dedo uam certa distância
        if(sqrt(dx * dx + dy * dy) > 20)
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
                if (dir == DIR_TOP)
                {
                    [entity.node setPosition:CGPointMake([entity.node position].x, [entity.node position].y + 5.0)];
                }
                else if (dir == DIR_RIGHT)
                {
                    [entity.node setPosition:CGPointMake([entity.node position].x + 5.0, [entity.node position].y)];
                }
                else if (dir == DIR_BOTTOM)
                {
                    [entity.node setPosition:CGPointMake([entity.node position].x, [entity.node position].y - 5.0)];
                }
                else if (dir == DIR_LEFT)
                {
                    [entity.node setPosition:CGPointMake([entity.node position].x - 5.0, [entity.node position].y)];
                }
            }
        }
    }
}

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    self.selectedPlace = [tch locationInNode:gameScene];
    self.currentPoint = self.selectedPlace;
    
    self.dPad = [SKSpriteNode spriteNodeWithImageNamed:@"dpad.png"];
    self.dPad.position = CGPointMake(self.selectedPlace.x, self.selectedPlace.y);
    [gameScene addChild:self.dPad];
    
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
    [self.dPad removeFromParent];
    
    self.holdingTouch = NO;
}

@end

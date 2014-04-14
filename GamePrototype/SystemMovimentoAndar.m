//
//  SystemMovimentoAndar.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 14/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemMovimentoAndar.h"
#import "ComponentHealth.h"

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

- (void)gameSceneDidReceiveTouchesBegan:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    self.selectedPlace = [tch locationInNode:gameScene];
}

- (void)gameSceneDidReceiveTouchesMoved:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [touches anyObject];
    CGPoint pt = [tch locationInNode:gameScene];
    
    float diferenceY = pt.y - self.selectedPlace.y;
    float diferenceX = pt.x - self.selectedPlace.x;
    
    for(GPEntity *entity in entitiesArray)
    {
        if (pt.y > (self.selectedPlace.y + 50) && diferenceY > 0)
        {
            [entity.node setPosition:CGPointMake([entity.node position].x, [entity.node position].y + 5.0)];
        }else if (pt.x > (self.selectedPlace.x + 50) && diferenceX > 0)
        {
            [entity.node setPosition:CGPointMake([entity.node position].x + 5.0, [entity.node position].y)];
        }else if (pt.y < (self.selectedPlace.y + 50) && diferenceY < 0)
        {
            [entity.node setPosition:CGPointMake([entity.node position].x, [entity.node position].y - 5.0)];
        }else if (pt.x < (self.selectedPlace.x + 50) && diferenceX < 0)
        {
            [entity.node setPosition:CGPointMake([entity.node position].x - 5.0, [entity.node position].y)];
        }
    }
}

- (void)gameSceneDidReceiveTouchesEnd:(GPGameScene *)gameScene touches:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end

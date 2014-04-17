//
//  SystemBattle.m
//  GamePrototype
//
//  Created by ARTHUR HENRIQUE VIEIRA DE OLIVEIRA on 17/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemBattle.h"

@implementation SystemBattle

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        self.rodadaJogador = YES;
    }
    
    return self;
}

-(void)update:(NSTimeInterval)interval
{
    if (self.rodadaJogador)
    {
    }else
    {
        for (GPEntity *entity in entitiesArray)
        {
        }
    }
}

@end

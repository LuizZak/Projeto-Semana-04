//
//  SystemCamera.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "SystemCamera.h"
#import "CommonImports.h"
#import "ComponentCamera.h"

@implementation SystemCamera

- (id)initWithGameScene:(GPGameScene *)gameScene
{
    self = [super initWithGameScene:gameScene];
    
    if(self)
    {
        selector = GPEntitySelectorCreate(GPRuleAnd(GPRuleID(CAMERA_ID), GPRuleComponent([ComponentCamera class])));
    }
    
    return self;
}

- (void)update:(NSTimeInterval)interval
{
    // Atualiza a posição da câmera
    GPEntity *cameraEntity = entitiesArray[0];
    
    if(cameraEntity == nil)
        return;
    
    ComponentCamera *cameraComp = (ComponentCamera*)[cameraEntity getComponent:[ComponentCamera class]];
    
    if(cameraComp.following != nil)
    {
        cameraEntity.node.position = cameraComp.following.node.position;
    }
    
    cameraEntity.node.position = CGPointMake(cameraEntity.node.position.x / 2, cameraEntity.node.position.y / 2);
    
    self.gameScene.worldNode.position = cameraEntity.node.position;
}

@end
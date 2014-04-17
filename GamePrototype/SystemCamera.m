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

- (void)didEvaluateActions
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
    
    CGRect screenBounds = self.gameScene.frame;
    
    cameraEntity.node.position = CGPointMake(-cameraEntity.node.position.x + screenBounds.size.width / 2, -cameraEntity.node.position.y + screenBounds.size.height / 2);
    
    CGPoint cameraPoint = cameraEntity.node.position;
    
    // Reforça os bounds da câmera
    // Horizontal
    if(-cameraPoint.x < cameraComp.cameraBounds.origin.x)
    {
        cameraPoint.x = -cameraComp.cameraBounds.origin.x;
    }
    if(-cameraPoint.x + screenBounds.size.width > cameraComp.cameraBounds.origin.x + cameraComp.cameraBounds.size.width)
    {
        cameraPoint.x = -(cameraComp.cameraBounds.origin.x + cameraComp.cameraBounds.size.width - screenBounds.size.width);
    }
    // Vertical
    if(-cameraPoint.y < cameraComp.cameraBounds.origin.y)
    {
        cameraPoint.y = -(cameraComp.cameraBounds.origin.y);
    }
    if(-cameraPoint.y + screenBounds.size.height > cameraComp.cameraBounds.origin.y + cameraComp.cameraBounds.size.height)
    {
        cameraPoint.y = -(cameraComp.cameraBounds.origin.y + cameraComp.cameraBounds.size.height - screenBounds.size.height);
    }
    
    self.gameScene.worldNode.position = cameraPoint;
}

@end
//
//  ComponentHealth.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 09/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentHealth.h"

@implementation ComponentHealth

- (id)initWithHealth:(float)health maxhealth:(float)maxHealth
{
    self = [super init];
    
    if(self)
    {
        self.health = health;
        self.maxHealth = maxHealth;
    }
    
    return self;
}

@end
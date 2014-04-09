//
//  ComponentHealth.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 09/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

@interface ComponentHealth : GPComponent

@property float health;
@property float maxHealth;

- (id)initWithHealth:(float)health maxhealth:(float)maxHealth;

@end
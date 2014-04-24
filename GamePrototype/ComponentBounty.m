//
//  ComponentBounty.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentBounty.h"

@implementation ComponentBounty

- (id)initWithExp:(int)xp gold:(int)gold
{
    self = [super init];
    
    if(self)
    {
        self.bountyXP = xp;
        self.bountyGold = gold;
    }
    
    return self;
}

@end
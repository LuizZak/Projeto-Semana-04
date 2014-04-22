//
//  ComponentHealthIndicator.m
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 09/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ComponentHealthIndicator.h"

@implementation ComponentHealthIndicator

- (id)initWithBarWidth:(float)barWidth barHeight:(float)barHeight barBackColor:(UIColor*)barBackColor barFrontColor:(UIColor*)barFrontColor
{
    self = [super init];
    
    if(self)
    {
        self.barWidth = barWidth;
        self.barHeight = barHeight;
        self.barBackColor = barBackColor;
        self.barFrontColor = barFrontColor;
    }
    
    return self;
}

@end
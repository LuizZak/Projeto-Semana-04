//
//  ComponentHealthIndicator.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 09/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

@interface ComponentHealthIndicator : GPComponent

@property float barWidth;
@property float barHeight;
@property UIColor *barBackColor;
@property UIColor *barFrontColor;

- (id)initWithBarWidth:(float)barWidth barHeight:(float)barHeight barBackColor:(UIColor*)barBackColor barFrontColor:(UIColor*)barFrontColor;

@end
//
//  ActionRunTimer.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "ActionRunTimer.h"

@implementation ActionRunTimer

- (BOOL)isPerformingAction
{
    return self.remainingDuration > 0;
}

- (CGFloat)percentageDone
{
    if(!self.isPerformingAction)
    {
        return 0;
    }
    
    return 1 - (self.remainingDuration / self.startDuration);
}

- (void)update:(NSTimeInterval)timestep
{
    if(self.isPerformingAction)
    {
        self.remainingDuration -= timestep;
    }
}

- (void)setTimer:(NSTimeInterval)totalDuration;
{
    self.remainingDuration = totalDuration;
    self.startDuration = totalDuration;
}

@end
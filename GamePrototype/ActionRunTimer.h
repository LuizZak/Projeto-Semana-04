//
//  ActionRunTimer.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Class utilized to time actions
@interface ActionRunTimer : NSObject

/// The starting duration of this timer
@property CGFloat startDuration;
/// The current duration of this timer
@property CGFloat remainingDuration;

/// Returns a value ranging from [0 - 1] that represents the percentage of the timer
@property (readonly) CGFloat percentageDone;

/// Gets a value that states whether this ActionRunTimer is currently performing an action
@property (readonly) BOOL isPerformingAction;

/// Updates this ActionRunTimer
- (void)update:(NSTimeInterval)timestep;

/// Sets the timer to the given time interval
- (void)setTimer:(NSTimeInterval)totalDuration;

@end
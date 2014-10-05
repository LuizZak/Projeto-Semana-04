//
//  ActionQueueView.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ActionQueueManager.h"

/// Represents a view that displays the contents of an ActionQueueManager
@interface ActionQueueView : SKNode

/// The action queue manager that owns this ActionQueueView
@property ActionQueueManager* actionQueueManager;

/// Updates the contents of this ActionQueueView
- (void)updateQueueView:(NSTimeInterval)timestep;

@end
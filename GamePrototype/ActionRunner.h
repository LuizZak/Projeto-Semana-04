//
//  ActionRunner.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 05/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleAction.h"

/// Protocol to be implemented by classes that run actions
@protocol ActionRunner <NSObject>

/// Called to notify of performing a battle action
- (void)performAction:(BattleAction*)action;

@end
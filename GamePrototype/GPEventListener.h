//
//  GPEventListener.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 03/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPEvent.h"

@protocol GPEventListener <NSObject>

@optional

- (void)receiveEvent:(GPEvent*)event;

@end
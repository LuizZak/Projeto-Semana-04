//
//  GPEventHandler.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 03/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPEvent.h"
#import "GPEventListener.h"

/// Represents a class used to handle dispatching of eventss
@interface GPEventDispatcher : NSObject
{
    NSMutableDictionary *eventDictionary;
}

/// Dispatches an event so all listeners that are registered to it can receive it
- (void)dispatchEvent:(GPEvent*)event;

/// Registers an event listener for receiving a type of event
- (void)registerListener:(id<GPEventListener>)listener forEventType:(Class)eventClass;

/// Unregisters an event listener from receiving a type of event
- (void)unregisterListener:(id<GPEventListener>)listener fromEventType:(Class)eventClass;

/// Unregisters an event listener from all events it's currently listening to
- (void)unregisterListenerFromAllEvents:(id<GPEventListener>)listener;

/// Clears the list of event listeners from all listeners currently listed to this GPEventDispatcher
- (void)clearAllListeners;

@end
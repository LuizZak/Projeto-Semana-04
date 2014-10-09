//
//  GPEventHandler.m
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 03/10/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPEventDispatcher.h"

@implementation GPEventDispatcher

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        eventDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

/// Dispatches an event so all listeners bind to it can receive it
- (void)dispatchEvent:(GPEvent*)event
{
    NSString *hashEventType = [self hashForClass:[event class]];
    NSArray *listenerArray = [eventDictionary objectForKey:hashEventType];
    
    if(listenerArray != nil)
    {
        for (id<GPEventListener> listener in listenerArray)
        {
            if([listener respondsToSelector:@selector(receiveEvent:)])
            {
                [listener receiveEvent:event];
            }
        }
    }
}

/// Registers an event listener for receiving a type of event
- (void)registerListener:(id<GPEventListener>)listener forEventType:(Class)eventClass
{
    NSString *hashKey = [self hashForClass:eventClass];
    
    NSMutableArray *listenersArray = [eventDictionary objectForKey:hashKey];
    
    if(listenersArray != nil)
    {
        if(![listenersArray containsObject:listener])
        {
            [listenersArray addObject:listener];
        }
    }
    else
    {
        listenersArray = [NSMutableArray array];
        [listenersArray addObject:listener];
        [eventDictionary setObject:listenersArray forKey:hashKey];
    }
}

/// Unregisters an event listener from receiving a type of event
- (void)unregisterListener:(id<GPEventListener>)listener fromEventType:(Class)eventClass
{
    NSString *hashKey = [self hashForClass:eventClass];
    [self internalRemoveEventListener:listener hashEventType:hashKey];
}

/// Unregisters an event listener from all events it's currently listening to
- (void)unregisterListenerFromAllEvents:(id<GPEventListener>)listener
{
    int i = 0;
    
    while(i < eventDictionary.count)
    {
        int c = eventDictionary.count;
        
        [self internalRemoveEventListener:listener hashEventType:[eventDictionary allKeys][c]];
        
        if(c == eventDictionary.count)
        {
            i++;
        }
    }
}

- (void)clearAllListeners
{
    eventDictionary = [NSMutableDictionary dictionary];
}

// Internal method that removes an event listener bonded to a given event type hash
- (void)internalRemoveEventListener:(id<GPEventListener>)listener hashEventType:(NSString*)hashEventType
{
    NSMutableArray *listeners = [eventDictionary objectForKey:hashEventType];
    
    if(listeners != nil)
    {
        [listeners removeObject:listener];
        
        if(listeners.count == 0)
        {
            [eventDictionary setValue:nil forKey:hashEventType];
        }
    }
}

/// Returns an NSString object that represents a given class object
- (NSString*)hashForClass:(Class)class
{
    return NSStringFromClass(class);
}

@end
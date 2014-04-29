//
//  GFXBuilder.h
//  GamePrototype
//
//  Created by Luiz Fernando Silva on 28/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePrototype.h"
#import "ComponentDraggableAttack.h"

@interface GFXBuilder : NSObject

+ (GPEntity*)createAttack:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage skillType:(SkillType)skillType;

+ (GPEntity*)createAttack:(float)x y:(float)y cooldown:(float)cooldown damage:(float)damage skillType:(SkillType)skillType depth:(int)depth;

@end
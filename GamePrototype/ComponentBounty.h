//
//  ComponentBounty.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 24/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"

@interface ComponentBounty : GPComponent

// Especifica o tanto de experiência que o jogador ganha ao derrotar esta entidade
@property int bountyXP;
// Especifica o tanto de gold que o jogador ganha ao derrotar esta entidade
@property int bountyGold;

- (id)initWithExp:(int)xp gold:(int)gold;

@end
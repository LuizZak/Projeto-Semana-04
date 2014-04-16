//
//  ComponentCamera.h
//  GamePrototype
//
//  Created by LUIZ FERNANDO SILVA on 16/04/14.
//  Copyright (c) 2014 LUIZ FERNANDO SILVA. All rights reserved.
//

#import "GPComponent.h"
#import "GPEntity.h"

@interface ComponentCamera : GPComponent

// Os bounds da câmera
@property CGRect cameraBounds;
// A entidade que a câmera está seguindo
@property GPEntity *following;

@end
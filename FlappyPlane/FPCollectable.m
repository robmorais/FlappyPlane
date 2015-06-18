//
//  FPCollectable.m
//  FlappyPlane
//
//  Created by Roberto Silva on 17/06/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPCollectable.h"

@implementation FPCollectable

- (void)collect
{
    [self runAction:[SKAction removeFromParent]];
    
    if (self.delegate) {
        [self.delegate wasCollected:self];
    }
}

@end

//
//  FPCollectable.m
//  FlappyPlane
//
//  Created by Roberto Silva on 17/06/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPCollectable.h"
#import "SoundManager.h"

@implementation FPCollectable

- (void)collect
{
    [self runAction:[SKAction removeFromParent]];
    [self.collectionSound play];
    
    if (self.delegate) {
        [self.delegate wasCollected:self];
    }
}

- (void)setCollectionSound:(Sound *)collectionSound
{
    _collectionSound = collectionSound;
    _collectionSound.volume = 0.4;
}

@end

//
//  FPCollectable.h
//  FlappyPlane
//
//  Created by Roberto Silva on 17/06/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class FPCollectable;

@protocol FPCollectableDelegate <NSObject>

- (void)wasCollected:(FPCollectable *)collectable;

@end

@interface FPCollectable : SKSpriteNode

@property (nonatomic, weak) id<FPCollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;

- (void)collect;

@end

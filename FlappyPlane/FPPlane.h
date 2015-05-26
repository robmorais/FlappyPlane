//
//  FPPlane.h
//  FlappyPlane
//
//  Created by Roberto Silva on 30/04/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FPPlane : SKSpriteNode

@property (nonatomic) BOOL engineRunning;
@property (nonatomic) BOOL accelerating;
@property (nonatomic) BOOL crashed;

- (void)setRandomColour;
- (void)update;
- (void)collide:(SKPhysicsBody *)body;
- (void)reset;
@end

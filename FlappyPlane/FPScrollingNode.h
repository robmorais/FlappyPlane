//
//  FPScrollingNode.h
//  FlappyPlane
//
//  Created by Roberto Silva on 19/05/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FPScrollingNode : SKNode

@property (nonatomic) CGFloat horizontalScrollSpeed; // Distance Scroll Per Second
@property (nonatomic) BOOL scrolling;

- (void)updateSinceTimeElapsed:(NSTimeInterval)timeElapsed;

@end

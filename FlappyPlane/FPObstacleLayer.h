//
//  FPObstacleLayer.h
//  FlappyPlane
//
//  Created by Roberto Silva on 28/05/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPScrollingNode.h"
#import "FPCollectable.h"

@interface FPObstacleLayer : FPScrollingNode

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;
@property (nonatomic, weak) id<FPCollectableDelegate> collectableDelegate;

- (void)reset;

@end

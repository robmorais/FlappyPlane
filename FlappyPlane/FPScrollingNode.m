//
//  FPScrollingNode.m
//  FlappyPlane
//
//  Created by Roberto Silva on 19/05/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPScrollingNode.h"

@implementation FPScrollingNode

- (void)updateSinceTimeElapsed:(NSTimeInterval)timeElapsed
{
    if (self.scrolling) {
        self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
}

@end

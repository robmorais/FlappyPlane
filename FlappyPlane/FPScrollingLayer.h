//
//  FPScrollingLayer.h
//  FlappyPlane
//
//  Created by Roberto Silva on 19/05/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPScrollingNode.h"

@interface FPScrollingLayer : FPScrollingNode

- (instancetype)initWithTiles:(NSArray *)tileSpriteNodes;
- (void)layoutTiles;
@end

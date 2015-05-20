//
//  FPScrollingLayer.m
//  FlappyPlane
//
//  Created by Roberto Silva on 19/05/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPScrollingLayer.h"

NSString *const BG_TILE_NAME = @"BGTile";

@interface FPScrollingLayer()

@property (nonatomic) SKSpriteNode *rightmostTile;

@end

@implementation FPScrollingLayer

- (instancetype)initWithTiles:(NSArray *)tileSpriteNodes
{
    if (self = [super init]) {
        for (SKSpriteNode *tile in tileSpriteNodes) {
            tile.anchorPoint = CGPointZero;
            tile.name = BG_TILE_NAME;
            
            [self addChild:tile];
        }
        
        [self layoutTiles];
    }
    
    return self;
}

- (void)layoutTiles
{
    self.rightmostTile = nil;
    
    [self enumerateChildNodesWithName:BG_TILE_NAME usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(self.rightmostTile.position.x +
                                    self.rightmostTile.size.width, node.position.y);
        
        self.rightmostTile = (SKSpriteNode *)node;
    }];
}

- (void)updateSinceTimeElapsed:(NSTimeInterval)timeElapsed
{
    [super updateSinceTimeElapsed:timeElapsed];
    
    if (self.scrolling && self.horizontalScrollSpeed < 0 && self.scene) {
        [self enumerateChildNodesWithName:BG_TILE_NAME usingBlock:^(SKNode *node, BOOL *stop) {
            CGPoint nodePositionInScene = [self convertPoint:node.position toNode:self.scene];
            
            if (nodePositionInScene.x + node.frame.size.width < -self.scene.size.width * self.scene.anchorPoint.x) {
                node.position = CGPointMake(self.rightmostTile.position.x +
                                            self.rightmostTile.size.width, node.position.y);
                
                self.rightmostTile = (SKSpriteNode *)node;
            }
        }];
    }
}

@end

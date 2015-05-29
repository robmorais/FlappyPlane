//
//  FPObstacleLayer.m
//  FlappyPlane
//
//  Created by Roberto Silva on 28/05/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPObstacleLayer.h"
#import "FPConstants.h"

@interface FPObstacleLayer()

@property (nonatomic) CGFloat marker;

@end

static const CGFloat kFPMarkerBuffer = 200.0;

static NSString *const kFPMountainUpTextureName = @"MountainGrass";
static NSString *const kFPMountainDownTextureName = @"MountainGrassDown";

@implementation FPObstacleLayer

- (void)updateSinceTimeElapsed:(NSTimeInterval)timeElapsed
{
    [super updateSinceTimeElapsed:timeElapsed];
    
    if (self.scrolling) {
        // Find marker's location in scene coords.
        CGPoint markerInScene = [self convertPoint:CGPointMake(self.marker, 0) toNode:self.scene];
        
        // When marker comes into the screen, add new obstacles.
        if (markerInScene.x - (self.scene.size.width * self.scene.anchorPoint.x) < self.scene.size.width + kFPMarkerBuffer) {
            [self addObstacleSet];
        }
    }
}

- (void)addObstacleSet
{
    
}

- (SKSpriteNode*)createObstacleForKey:(NSString *)key
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    SKSpriteNode *sprite = nil;
    
    if (key == kFPMountainUpTextureName ) {
        sprite = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:kFPMountainUpTextureName]];
        
        CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 55 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);
        
        sprite.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        sprite.physicsBody.categoryBitMask = kFPCategoryGround;
        
        [self addChild:sprite];
    }
    else if (key == kFPMountainDownTextureName) {
        sprite = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:kFPMountainDownTextureName]];
        
        CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 55 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 199 - offsetY);
        
        CGPathCloseSubpath(path);
        
        sprite.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        sprite.physicsBody.categoryBitMask = kFPCategoryGround;
        
        [self addChild:sprite];
    }
    
    if (sprite) {
        sprite.name = key;
    }
    
    return sprite;
}

@end

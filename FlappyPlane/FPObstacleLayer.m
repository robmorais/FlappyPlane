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
static const CGFloat kFPVerticalGap = 90.0;
static const CGFloat kFPSpaceBetweenObstacleSets = 180.0;
static const int kFPCollectableVerticalRange = 200;
static const CGFloat kFPCollectableClearance = 50.0;

// Using texture names as the key
static NSString *const kFPKeyMountainUp = @"MountainGrass";
static NSString *const kFPKeyMountainDown = @"MountainGrassDown";
static NSString *const kFPKeyCollectableStar = @"starGold";

@implementation FPObstacleLayer

- (void)reset
{
    // Loop through nodes and reposition for reuse
    for (SKSpriteNode *sprite in self.children) {
        sprite.position = CGPointMake(-1000, 0);
    }
    
    // Reposition marker
    if (self.scene) {
        self.marker = self.scene.size.width + kFPMarkerBuffer;
    }
}

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
    SKSpriteNode *moutainUp = [self unusedObjectForKey:kFPKeyMountainUp];
    SKSpriteNode *moutainDown = [self unusedObjectForKey:kFPKeyMountainDown];
    
    // Calculate variation
    CGFloat maxVariation = (moutainDown.size.height + moutainUp.size.height + kFPVerticalGap) - (self.ceiling - self.floor);
    CGFloat yVariation = (CGFloat)arc4random_uniform(maxVariation);
    
    // Position moutain nodes.
    moutainUp.position = CGPointMake(self.marker, self.floor + (moutainUp.size.height * 0.5) - yVariation);
    moutainDown.position = CGPointMake(self.marker, moutainUp.position.y + moutainDown.size.height + kFPVerticalGap);
    
    // Get collectable star node.
    SKSpriteNode *star = [self unusedObjectForKey:kFPKeyCollectableStar];
    
    // Position star.
    CGFloat midPoint = moutainUp.position.y + (moutainUp.size.height * 0.5) + (kFPVerticalGap * 0.5);
    CGFloat yPosition = midPoint + arc4random_uniform(kFPCollectableVerticalRange) - (kFPCollectableVerticalRange * 0.5);
    
    yPosition = fminf(yPosition, self.ceiling - kFPCollectableClearance);
    yPosition = fmaxf(yPosition, self.floor + kFPCollectableClearance);
    
    star.position = CGPointMake(self.marker + (kFPSpaceBetweenObstacleSets * 0.5), yPosition);
    
    // Reposition marker.
    self.marker += kFPSpaceBetweenObstacleSets;
}

- (SKSpriteNode *)unusedObjectForKey:(NSString *)key
{
    if (self.scene) {
        // Get left edge of screen in local coordinates.
        CGFloat leftEdge = [self.scene convertPoint:CGPointMake(-self.scene.size.width * self.scene.anchorPoint.x, 0) toNode:self].x;
        
        // Try to find object for key to the left of the screen
        for (SKSpriteNode *sprite in self.children) {
            if (sprite.name == key && sprite.frame.origin.x + sprite.size.width < leftEdge) {
                return sprite;
            }
        }
    }
    
    // Couldn't find an unused object, so create a new one
    return [self createObjectForKey:key];
}

- (SKSpriteNode *)createObjectForKey:(NSString *)key
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    SKSpriteNode *sprite = nil;
    
    if (key == kFPKeyMountainUp ) {
        sprite = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:kFPKeyMountainUp]];
        
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
    else if (key == kFPKeyMountainDown) {
        sprite = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:kFPKeyMountainDown]];
        
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
    else if (key == kFPKeyCollectableStar) {
        sprite = [FPCollectable spriteNodeWithTexture:[atlas textureNamed:kFPKeyCollectableStar]];
        
        ((FPCollectable *)sprite).pointValue = 1;
        ((FPCollectable *)sprite).delegate = self.collectableDelegate;
        
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:0.3];
        sprite.physicsBody.categoryBitMask = kFPCategoryCollectable;
        sprite.physicsBody.dynamic = NO;
        
        [self addChild:sprite];
    }
    
    if (sprite) {
        sprite.name = key;
    }
    
    return sprite;
}

@end

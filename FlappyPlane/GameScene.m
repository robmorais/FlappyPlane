//
//  GameScene.m
//  FlappyPlane
//
//  Created by Roberto Silva on 29/04/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "GameScene.h"
#import "FPPlane.h"
#import "FPScrollingLayer.h"
#import "FPObstacleLayer.h"
#import "FPConstants.h"

@interface GameScene()

@property (nonatomic) SKNode *world;
@property (nonatomic) FPPlane *player;
@property (nonatomic) FPScrollingLayer *background;
@property (nonatomic) FPScrollingLayer *foreground;
@property (nonatomic) FPObstacleLayer *obstacles;

@end

static const CGFloat kMinFPS = 10.0/60.0;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    //self.size = view.bounds.size; // BUG FIX option 2
    
    // Set background color to Sky Blue
    self.backgroundColor = [SKColor colorWithRed:213./255. green:237./255. blue:247./255. alpha:1.0];
    
    //Get Atlas File
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    
    // Setup physics
    self.physicsWorld.gravity = CGVectorMake(0.0, -4.5);
    self.physicsWorld.contactDelegate = self;
    
    self.world = [SKNode node];
    [self addChild:self.world];
    
    // Setup Background Layer
    NSMutableArray *backgroundTiles = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i<3; i++) {
        [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
    }
    
    _background = [[FPScrollingLayer alloc] initWithTiles:backgroundTiles];
    //_background.position = CGPointZero;
    _background.horizontalScrollSpeed = -60.0;
    _background.scrolling = YES;
    [_world addChild:_background];
    
    // Setup Obstacles Layer
    _obstacles = [FPObstacleLayer new];
    _obstacles.horizontalScrollSpeed = -80.0;
    _obstacles.scrolling = YES;
    _obstacles.floor = 0.0;
    _obstacles.ceiling = self.size.height;
    [_world addChild:_obstacles];
    
    // Setup Foreground Layer
    _foreground = [[FPScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                            [self generateGroundTile],
                                                            [self generateGroundTile]]];
    //_foreground.position = CGPointZero;
    _foreground.horizontalScrollSpeed = -80.0;
    _foreground.scrolling = YES;
    [_world addChild:_foreground];
    
    // Add Player
    self.player = [FPPlane new];
    [self.world addChild:self.player];
    
    [self newGame];
}

-(void)newGame
{
    // Reset Layers
    self.foreground.position = CGPointZero;
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    self.obstacles.scrolling = NO;
    [self.obstacles reset];
    self.background.position = CGPointZero;
    [self.background layoutTiles];
    
    // Reset Player
    self.player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches.count > 0) {
        if (self.player.crashed) {
            [self newGame];
        } else {
            self.player.accelerating = YES;
            self.player.physicsBody.affectedByGravity = YES;
            self.obstacles.scrolling = YES;
        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 0) {
        self.player.accelerating = NO;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == kFPCategoryPlane) {
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == kFPCategoryPlane) {
        [self.player collide:contact.bodyA];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) timeElapsed = kMinFPS;
    lastCallTime = currentTime;
    
    [self.player update];
    if (!self.player.crashed) {
        [self.background updateSinceTimeElapsed:timeElapsed];
        [self.obstacles updateSinceTimeElapsed:timeElapsed];
        [self.foreground updateSinceTimeElapsed:timeElapsed];
    }
    
}

#pragma mark Helper Methods

- (SKSpriteNode *)generateGroundTile
{
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero; // The FPScrollingLayer will set it, so I am setting it here to get the right path
    // Path
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 372 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 286 - offsetX, 8 - offsetY);
    CGPathAddLineToPoint(path, NULL, 235 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 219 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 185 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 154 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 124 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 78 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 45 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 17 - offsetX, 18 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 17 - offsetY);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = kFPCategoryGround;
    
    /* Bugged, not showing on simulator
     SKShapeNode *shape = [SKShapeNode node];
     shape.path = path;
     shape.strokeColor = [SKColor redColor];
     shape.lineWidth = 1.0;
     [sprite addChild:shape];
     */
    
    return sprite;
}

@end

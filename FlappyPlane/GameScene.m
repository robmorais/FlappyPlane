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

@interface GameScene()

@property (nonatomic) SKNode *world;
@property (nonatomic) FPPlane *player;
@property (nonatomic) FPScrollingLayer *background;

@end

static const CGFloat kMinFPS = 10.0/60.0;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    //self.size = view.bounds.size; // BUG FIX option 2
    
    // Set background color to Sky Blue
    self.backgroundColor = [SKColor colorWithRed:213./255. green:237./255. blue:247./255. alpha:1.0];
    
    //Get Atlas File
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Setup physics
    self.physicsWorld.gravity = CGVectorMake(0.0, -4.5);
    
    self.world = [SKNode node];
    [self addChild:self.world];
    
    // Setup Background Layer
    NSMutableArray *backgroundTiles = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i<3; i++) {
        [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
    }
    
    _background = [[FPScrollingLayer alloc] initWithTiles:backgroundTiles];
    _background.position = CGPointZero;
    _background.horizontalScrollSpeed = -60.0;
    _background.scrolling = YES;
    [_world addChild:_background];
    
    // Setup Player
    self.player = [FPPlane new];
    self.player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.world addChild:self.player];
    
    self.player.engineRunning = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (touches.count > 0) {
        self.player.accelerating = YES;
        self.player.physicsBody.affectedByGravity = YES;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 0) {
        self.player.accelerating = NO;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) timeElapsed = kMinFPS;
    lastCallTime = currentTime;
    
    [self.player update];
    [self.background updateSinceTimeElapsed:timeElapsed];
}

@end

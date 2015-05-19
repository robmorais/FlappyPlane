//
//  GameScene.m
//  FlappyPlane
//
//  Created by Roberto Silva on 29/04/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "GameScene.h"
#import "FPPlane.h"

@interface GameScene()

@property (nonatomic) SKNode *world;
@property (nonatomic) FPPlane *player;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    // Setup physics
    self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
    
    self.world = [SKNode node];
    [self addChild:self.world];
    
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
    [self.player update];
}

@end

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
    /* Setup your scene here */
    
    self.world = [SKNode node];
    [self addChild:self.world];
    
    self.player = [FPPlane new];
    self.player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    [self.world addChild:self.player];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

//
//  GameScene.h
//  FlappyPlane
//

//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FPCollectable.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate, FPCollectableDelegate>

@end

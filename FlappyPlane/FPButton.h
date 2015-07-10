//
//  FPButton.h
//  FlappyPlane
//
//  Created by Roberto Silva on 03/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FPButton : SKSpriteNode

@property (nonatomic, readonly, weak) id pressedTarget;
@property (nonatomic, readonly) SEL pressedAction;

@property (nonatomic) CGFloat pressedScale;

- (void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction;

@end

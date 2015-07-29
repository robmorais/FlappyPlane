//
//  FPButton.m
//  FlappyPlane
//
//  Created by Roberto Silva on 03/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPButton.h"
#import <objc/message.h>
#import "SoundManager.h"

@interface FPButton()

@property (nonatomic) CGRect fullSizeFrame;
@property (nonatomic) BOOL pressed;
@end

@implementation FPButton

+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture
{
    FPButton *instance = [super spriteNodeWithTexture:texture];
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    FPButton *instance = [super spriteNodeWithImageNamed:name];
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
}

- (void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction
{
    _pressedTarget = pressedTarget;
    _pressedAction = pressedAction;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (self.pressed != CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            self.pressed = !self.pressed;
            
            if (self.pressed) {
                [self setScale:self.pressedScale];
                [self.pressedSound play];
            } else {
                [self setScale:1.0];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.pressed = NO;
    [self setScale:1.0];
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            // Pressed button
            
            objc_msgSend(self.pressedTarget,self.pressedAction);
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.pressed = NO;
    [self setScale:1.0];
}

@end

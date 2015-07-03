//
//  FPButton.m
//  FlappyPlane
//
//  Created by Roberto Silva on 03/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPButton.h"

@interface FPButton()

@property (nonatomic) CGRect fullSizeFrame;

@end

@implementation FPButton

+ (instancetype)spriteNodeWithTexture:(SKTexture *)texture
{
    FPButton *instance = [super spriteNodeWithTexture:texture];
    instance.name = @"lalala";
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    FPButton *instance = [super spriteNodeWithImageNamed:name];
    instance.name = @"lalala";
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            [self setScale:self.pressedScale];
        } else {
            [self setScale:1.0];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            // Pressed button
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
}

@end

//
//  FPBitmapFontLabel.h
//  FlappyPlane
//
//  Created by Roberto Silva on 19/06/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    BitmapFontAlignmentLeft,
    BitmapFontAlignmentCenter,
    BitmapFontAlignmentRight
} BitmapFontAlignment;

@interface FPBitmapFontLabel : SKNode

@property (nonatomic) NSString *fontName;
@property (nonatomic) NSString *text;
@property (nonatomic) NSInteger letterSpacing;
@property (nonatomic) BitmapFontAlignment alignment;

- (instancetype)initWithText:(NSString *)text andFontName:(NSString *)fontName;

@end

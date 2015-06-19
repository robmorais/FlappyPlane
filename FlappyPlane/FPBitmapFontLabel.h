//
//  FPBitmapFontLabel.h
//  FlappyPlane
//
//  Created by Roberto Silva on 19/06/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FPBitmapFontLabel : SKNode

@property (nonatomic) NSString *fontName;
@property (nonatomic) NSString *text;
@property (nonatomic) NSInteger letterSpacing;

- (instancetype)initWithText:(NSString *)text andFontName:(NSString *)fontName;

@end

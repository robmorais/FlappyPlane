//
//  FPWeatherLayer.h
//  FlappyPlane
//
//  Created by Roberto Silva on 27/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    WeatherClean,
    WeatherRain,
    WeatherSnow
} WeatherType;

@interface FPWeatherLayer : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) WeatherType conditions;

- (instancetype)initWithSize:(CGSize)size;

@end

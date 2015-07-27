//
//  FPWeatherLayer.m
//  FlappyPlane
//
//  Created by Roberto Silva on 27/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPWeatherLayer.h"

@interface FPWeatherLayer()

@property (nonatomic) SKEmitterNode *rainEmitter;
@property (nonatomic) SKEmitterNode *snowEmitter;

@end

@implementation FPWeatherLayer

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    
    if (self) {
        _size = size;
        
        // Load rain effect
        NSString *rainEffectPath = [[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
        _rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:rainEffectPath];
        _rainEmitter.position = CGPointMake(size.width * 0.5 + 32, size.height + 5);
        
        // Load snow effect
        NSString *snowEffectPath = [[NSBundle mainBundle] pathForResource:@"SnowEffect" ofType:@"sks"];
        _snowEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:snowEffectPath];
        _snowEmitter.position = CGPointMake(size.width * 0.5, size.height + 5);
    }
    
    return self;
}

- (void)setConditions:(WeatherType)conditions
{
    if (_conditions != conditions) {
        _conditions = conditions;
        // Remove existing weather conditions
        [self removeAllChildren];
        
        // Add weather conditions
        switch (conditions) {
            case WeatherRain:
                [self addChild:self.rainEmitter];
                [self.rainEmitter advanceSimulationTime:5];
                break;
                
            case WeatherSnow:
                [self addChild:self.snowEmitter];
                [self.snowEmitter advanceSimulationTime:5];
                break;
                
            default:
                break;
        }
    }
}
@end

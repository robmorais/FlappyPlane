//
//  FPPlane.m
//  FlappyPlane
//
//  Created by Roberto Silva on 30/04/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPPlane.h"

@interface FPPlane()

@property (nonatomic) NSMutableArray *planeAnimations;

@end

@implementation FPPlane

- (instancetype)init
{
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    
    if (self) {
        _planeAnimations = [NSMutableArray array];
        
        // Fill Animations Array
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animationsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in animationsDictionary) {
            [_planeAnimations addObject:[self animationFromArray:animationsDictionary[key] withDuration:0.4]];
        }
        
        [self setRandomColour];
    }
    
    return self;
}

- (SKAction *)animationFromArray:(NSArray *)textureNames withDuration:(CGFloat)duration
{
    // Create array for textures
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:textureNames.count];
    
    // Get plane atlas
    SKTextureAtlas *planeAtlas = [SKTextureAtlas atlasNamed:@"Planes"];
    
    // Loop through texture names
    for (NSString *textureName in textureNames) {
        [frames addObject:[planeAtlas textureNamed:textureName]];
    }
    
    CGFloat frameTime = duration/(CGFloat)frames.count;
    
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime]];
    
}

#pragma public messages

- (void)setRandomColour
{
    [self runAction:[self.planeAnimations objectAtIndex:arc4random_uniform((int)self.planeAnimations.count)]];
}

@end

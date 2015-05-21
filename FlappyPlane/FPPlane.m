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
@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthrate;

@end

static NSString *const kPlaneAnimationKey = @"FPPlaneAnimation";

@implementation FPPlane

- (instancetype)init
{
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    
    if (self) {
        _planeAnimations = [NSMutableArray array];
        
        // Setup Physic body
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width * 0.5];
        
        // Fill Animations Array
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animationsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in animationsDictionary) {
            [_planeAnimations addObject:[self animationFromArray:animationsDictionary[key] withDuration:0.4]];
        }
        
        // Setup Puff trail emmiter node
        NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"PlanePuffTrail" ofType:@"sks"];
        _puffTrailEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, 0.0);
        [self addChild:_puffTrailEmitter];
        
        // Store original birthrate and turn it off
        self.puffTrailBirthrate = _puffTrailEmitter.particleBirthRate;
        self.puffTrailEmitter.particleBirthRate = 0.0;
        
        [self setRandomColour];
    }
    
    return self;
}

- (SKAction *)animationFromArray:(NSArray *)textureNames withDuration:(CGFloat)duration
{
    // Create array for textures
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:textureNames.count];
    
    // Get plane atlas
    SKTextureAtlas *planeAtlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
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
    [self removeActionForKey:kPlaneAnimationKey];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform((int)self.planeAnimations.count)];
    [self runAction:animation withKey:kPlaneAnimationKey];
    
    if (!self.engineRunning) {
        [self actionForKey:kPlaneAnimationKey].speed = 0.0;
    }
}

- (void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning;
    
    if (engineRunning) {
        [self actionForKey:kPlaneAnimationKey].speed = 1.0;
        self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthrate;
        self.puffTrailEmitter.targetNode = self.parent;
    }
    else {
        [self actionForKey:kPlaneAnimationKey].speed = 0.0;
        self.puffTrailEmitter.particleBirthRate = 0.0;
    }
}

- (void)update
{
    if (self.accelerating) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
}

@end

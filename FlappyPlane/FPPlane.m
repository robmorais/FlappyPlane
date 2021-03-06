//
//  FPPlane.m
//  FlappyPlane
//
//  Created by Roberto Silva on 30/04/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPPlane.h"
#import "FPConstants.h"
#import "FPCollectable.h"
#import "SoundManager.h"

@interface FPPlane()

@property (nonatomic) NSMutableArray *planeAnimations;
@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthrate;
@property (nonatomic) Sound *engineSound;

@end

static NSString *const kFPPlaneAnimationKey = @"FPPlaneAnimation";
static const CGFloat kFPMaxAltitude = 300.0;

@implementation FPPlane

- (instancetype)init
{
    self = [super initWithImageNamed:@"planeBlue1@2x"];
    
    if (self) {
        _planeAnimations = [NSMutableArray array];
        
        // Setup Physic body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 43 - offsetX, 16 - offsetY);
        CGPathAddLineToPoint(path, NULL, 36 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, NULL, 11 - offsetX, 36 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 27 - offsetY);
        CGPathAddLineToPoint(path, NULL, 11 - offsetX, 5 - offsetY);
        CGPathAddLineToPoint(path, NULL, 29 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 38 - offsetX, 7 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.mass = 0.08;
        self.physicsBody.categoryBitMask = kFPCategoryPlane;
        self.physicsBody.contactTestBitMask = kFPCategoryGround | kFPCategoryCollectable;
        self.physicsBody.collisionBitMask = kFPCategoryGround;
        
        // Fill Animations Array
        NSString *animationPlistPath = [[NSBundle mainBundle] pathForResource:@"PlaneAnimations" ofType:@"plist"];
        NSDictionary *animationsDictionary = [NSDictionary dictionaryWithContentsOfFile:animationPlistPath];
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
        
        // Setup engine sound
        _engineSound = [Sound soundNamed:@"Engine.caf"];
        _engineSound.looping = YES;
        
        [self setRandomColour];
    }
    
    return self;
}

- (SKAction *)animationFromArray:(NSArray *)textureNames withDuration:(CGFloat)duration
{
    // Create array for textures
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:textureNames.count];
    
    // Get plane atlas
    SKTextureAtlas *planeAtlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    
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
    [self removeActionForKey:kFPPlaneAnimationKey];
    SKAction *animation = [self.planeAnimations objectAtIndex:arc4random_uniform((int)self.planeAnimations.count)];
    [self runAction:animation withKey:kFPPlaneAnimationKey];
    
    if (!self.engineRunning) {
        [self actionForKey:kFPPlaneAnimationKey].speed = 0.0;
    }
}

- (void)setAccelerating:(BOOL)accelerating
{
    _accelerating = accelerating && !self.crashed;
}

- (void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning && !self.crashed;
    
    if (engineRunning) {
        [self.engineSound play];
        [self.engineSound fadeIn:1.0];
        
        [self actionForKey:kFPPlaneAnimationKey].speed = 1.0;
        self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthrate;
        self.puffTrailEmitter.targetNode = self.parent;
    }
    else {
        [self.engineSound fadeOut:0.5];
        [self actionForKey:kFPPlaneAnimationKey].speed = 0.0;
        self.puffTrailEmitter.particleBirthRate = 0.0;
    }
}

- (void)setCrashed:(BOOL)crashed
{
    _crashed = crashed;
    if (crashed) {
        self.engineRunning = NO;
        self.accelerating = NO;
    }
}

- (void)reset
{
    self.crashed = NO;
    self.engineRunning = YES;
    self.zRotation = 0.0;
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    self.physicsBody.angularVelocity = 0.0;
    
    [self setRandomColour];
}

- (void)collide:(SKPhysicsBody *)body
{
    // Ignore collisions if already crashed
    if (!self.crashed) {
        if (body.categoryBitMask == kFPCategoryGround) {
            // Hit the ground
            self.crashed = YES;
            [[SoundManager sharedManager] playSound:@"Crunch.caf"];
        }
        if (body.categoryBitMask == kFPCategoryCollectable) {
            if ([body.node respondsToSelector:@selector(collect)]) {
                [body.node performSelector:@selector(collect)];
            }
        }
    }
}

- (void)update
{
    if (self.accelerating && self.position.y <= kFPMaxAltitude) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
    if (!self.crashed) {
        self.zRotation = fmaxf(fminf(self.physicsBody.velocity.dy, 400.0),-400.0) / 400.0;
        self.engineSound.volume = 0.25 + (fmaxf(fminf(self.physicsBody.velocity.dy, 300.0),0) / 300.0) * 0.75;
    }
}

@end

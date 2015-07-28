//
//  GameScene.m
//  FlappyPlane
//
//  Created by Roberto Silva on 29/04/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "GameScene.h"
#import "FPPlane.h"
#import "FPScrollingLayer.h"
#import "FPWeatherLayer.h"
#import "FPObstacleLayer.h"
#import "FPConstants.h"
#import "FPBitmapFontLabel.h"
#import "FPTilesetTextureProvider.h"

typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver
} GameState;

@interface GameScene()

@property (nonatomic) SKNode *world;
@property (nonatomic) FPPlane *player;
@property (nonatomic) FPScrollingLayer *background;
@property (nonatomic) FPScrollingLayer *foreground;
@property (nonatomic) FPWeatherLayer *weather;
@property (nonatomic) FPObstacleLayer *obstacles;
@property (nonatomic) FPBitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) FPGameOverMenu *gameOverMenu;
@property (nonatomic) GameState gameState;
@property (nonatomic) SKSpriteNode *tap;
@end

static const CGFloat kMinFPS = 10.0/60.0;
static NSString *const kFPKeyBestScore = @"FPBestScore";

@implementation GameScene

#pragma mark Life Cycle

-(void)didMoveToView:(SKView *)view {
    //self.size = view.bounds.size; // BUG FIX option 2
    
    // Set background color to Sky Blue
    self.backgroundColor = [SKColor colorWithRed:213./255. green:237./255. blue:247./255. alpha:1.0];
    
    //Get Atlas File
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    
    // Setup physics
    self.physicsWorld.gravity = CGVectorMake(0.0, -4.0);
    self.physicsWorld.contactDelegate = self;
    
    self.world = [SKNode node];
    [self addChild:self.world];
    
    // Setup Background Layer
    NSMutableArray *backgroundTiles = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i<3; i++) {
        [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
    }
    
    _background = [[FPScrollingLayer alloc] initWithTiles:backgroundTiles];
    _background.horizontalScrollSpeed = -60.0;
    _background.scrolling = YES;
    [_world addChild:_background];
    
    // Setup Obstacles Layer
    _obstacles = [FPObstacleLayer new];
    _obstacles.collectableDelegate = self;
    _obstacles.horizontalScrollSpeed = -80.0;
    _obstacles.scrolling = YES;
    _obstacles.floor = 0.0;
    _obstacles.ceiling = self.size.height;
    [_world addChild:_obstacles];
    
    // Setup Foreground Layer
    _foreground = [[FPScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                            [self generateGroundTile],
                                                            [self generateGroundTile]]];
    _foreground.horizontalScrollSpeed = -80.0;
    _foreground.scrolling = YES;
    [_world addChild:_foreground];
    
    // Add Player
    self.player = [FPPlane new];
    [self.world addChild:self.player];
    
    // Setup weather layer
    self.weather = [[FPWeatherLayer alloc] initWithSize:self.size];
    [self.world addChild:self.weather];
    
    // Load best score
    self.bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kFPKeyBestScore];
    
    // Setup Score Label
    _scoreLabel = [[FPBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
    _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 60);
    [self addChild:_scoreLabel];
    
    // Setup Game Over Menu
    _gameOverMenu = [[FPGameOverMenu alloc] initWithSize:self.size];
    _gameOverMenu.delegate = self;
    
    [self newGame];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (self.gameState == GameReady) {
        [self.tap runAction:[SKAction fadeOutWithDuration:0.2]];
        self.player.physicsBody.affectedByGravity = YES;
        self.obstacles.scrolling = YES;
        self.gameState = GameRunning;
    }
    
    if (self.gameState == GameRunning) {
        self.player.accelerating = YES;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.gameState == GameRunning) {
        self.player.accelerating = NO;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == kFPCategoryPlane) {
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == kFPCategoryPlane) {
        [self.player collide:contact.bodyA];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) timeElapsed = kMinFPS;
    lastCallTime = currentTime;
    
    [self.player update];
    
    if (self.player.crashed && self.gameState == GameRunning) {
        // Player just crashed in the last frame
        self.gameState = GameOver;
        // Fade out score display
        [self.scoreLabel runAction:[SKAction fadeOutWithDuration:0.4]];
        // Show game over menu
        [self crashAnimation];
        [self gameOver];
    }
    
    if (self.gameState != GameOver) {
        [self.background updateSinceTimeElapsed:timeElapsed];
        [self.obstacles updateSinceTimeElapsed:timeElapsed];
        [self.foreground updateSinceTimeElapsed:timeElapsed];
    }
    
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
}

#pragma mark private methods

- (void)gameOver
{
    // Setup game over menu
    self.gameOverMenu.score = self.score;
    self.gameOverMenu.medal = [self medalForCurrentScore];
    if (self.score > self.bestScore) {
        self.bestScore = self.score;
        [[NSUserDefaults standardUserDefaults] setInteger:self.bestScore forKey:kFPKeyBestScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.gameOverMenu.bestScore = self.bestScore;
    
    // Show game over menu
    [self addChild:self.gameOverMenu];
    [self.gameOverMenu show];
}

-(void)newGame
{
    // Randomize tileset
    [[FPTilesetTextureProvider sharedProvider] randomizeTileset];
    
    // Set weather conditions
    [self setupWeather];
    
    // Reset Layers
    self.foreground.position = CGPointZero;
    for (SKSpriteNode *node in self.foreground.children) {
        node.texture = [[FPTilesetTextureProvider sharedProvider] textureForKey:@"ground"];
    }
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    self.obstacles.scrolling = NO;
    [self.obstacles reset];
    self.background.position = CGPointZero;
    [self.background layoutTiles];
    
    // Reset Score
    self.score = 0;
    self.scoreLabel.alpha = 1.0;
    
    // Reset Player
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
    
    // Set game state
    self.gameState = GameReady;
    
    [self tapToStartAnimation];
}

-(void)tapToStartAnimation
{
    if (!self.tap) {
        //Get Atlas File
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
        
        // Set tap animation textures
        NSArray *tapAnimationTextures = @[[graphics textureNamed:@"tap"],
                                          [graphics textureNamed:@"tapTick"],
                                          [graphics textureNamed:@"tapTick"]];
        
        // Create tap animation action
        SKAction *tapAnimation = [SKAction animateWithTextures:tapAnimationTextures timePerFrame:0.5 resize:YES restore:NO];
        
        // Create animation
        self.tap = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"tap"]];
        self.tap.position = CGPointMake(self.size.width * 0.5,self.size.height * 0.5);
        [self.world addChild:self.tap];
        [self.tap runAction:[SKAction repeatActionForever:tapAnimation]];
    } else {
        self.tap.alpha = 1.0;
    }
}

#pragma mark FPGameOverMenuDelegate

- (void)pressedNewGameButton
{
    SKSpriteNode *blackRectangle = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:self.size];
    blackRectangle.anchorPoint = CGPointZero;
    blackRectangle.alpha = 0.0;
    blackRectangle.zPosition = 100.0;
    [self addChild:blackRectangle];
    
    SKAction *startNewGame = [SKAction runBlock:^{
        [self newGame];
        [self.gameOverMenu removeFromParent];
    }];
    
    SKAction *fadeTransition = [SKAction sequence:@[[SKAction fadeInWithDuration:0.4],startNewGame,[SKAction fadeOutWithDuration:0.5],[SKAction removeFromParent]]];
    
    [blackRectangle runAction:fadeTransition];
}

#pragma mark Collectable Delegate

- (void)wasCollected:(FPCollectable *)collectable
{
    self.score += collectable.pointValue;
}

#pragma mark Helper Methods

- (void)crashAnimation
{
    // Setup action to tint the plane red and remove it later
    SKAction *tintPlane = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.8 duration:0.0];
    SKAction *removeTint = [SKAction colorizeWithColorBlendFactor:0.0 duration:0.2];
    [self.player runAction:[SKAction sequence:@[tintPlane,removeTint]]];
    
    // Setup action to bump world
    SKAction *bump = [SKAction sequence:@[[SKAction moveBy:CGVectorMake(-5,-4) duration:0.1],
                                          [SKAction moveTo:CGPointZero duration:0.1]]];
    
    [self.world runAction:[SKAction sequence:@[bump,bump]]];
}

- (void)setupWeather
{
    NSString *tilesetName = [FPTilesetTextureProvider sharedProvider].currentTilesetName;
    self.weather.conditions = WeatherClean;
    if ([tilesetName isEqualToString:kFPTilesetDirt] || [tilesetName isEqualToString:kFPTilesetGrass]) {
        // 1 in 3 chance to rain
        if (arc4random_uniform(3) == 0) self.weather.conditions = WeatherRain;
    }
    if ([tilesetName isEqualToString:kFPTilesetIce] || [tilesetName isEqualToString:kFPTilesetSnow]) {
        // 1 in 2 chance to snow
        if (arc4random_uniform(2) == 0) self.weather.conditions = WeatherSnow;
    }
}

- (MedalType)medalForCurrentScore
{
    NSInteger bestScore = 6;
    if (self.bestScore > bestScore) {
        bestScore = self.bestScore;
    }
    
    if (self.score > bestScore) {
        return MedalGold;
    } else if (self.score >= (bestScore * 0.75)) {
        return MedalSilver;
    } else if (self.score >= (bestScore * 0.5)) {
        return MedalBronze;
    }
    return MedalNone;
}

- (SKSpriteNode *)generateGroundTile
{
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero; // The FPScrollingLayer will set it, so I am setting it here to get the right path
    // Path
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 372 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 329 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 286 - offsetX, 8 - offsetY);
    CGPathAddLineToPoint(path, NULL, 235 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 219 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 185 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 154 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 124 - offsetX, 33 - offsetY);
    CGPathAddLineToPoint(path, NULL, 78 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 45 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 17 - offsetX, 18 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 17 - offsetY);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = kFPCategoryGround;
    
    /* Bugged, not showing on simulator
     SKShapeNode *shape = [SKShapeNode node];
     shape.path = path;
     shape.strokeColor = [SKColor redColor];
     shape.lineWidth = 1.0;
     [sprite addChild:shape];
     */
    
    return sprite;
}

@end

//
//  TPGameOverMenu.m
//  FlappyPlane
//
//  Created by Roberto Silva on 10/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPGameOverMenu.h"
#import "FPConstants.h"
#import "FPBitmapFontLabel.h"
#import "FPButton.h"

@interface FPGameOverMenu()
@property (nonatomic) SKSpriteNode *medalDisplay;
@property (nonatomic) FPBitmapFontLabel *scoreText;
@property (nonatomic) FPBitmapFontLabel *bestScoreText;
@property (nonatomic) SKSpriteNode *gameOverTitle;
@property (nonatomic) SKNode *panelGroup;
@property (nonatomic) FPButton *playButton;
@end

@implementation FPGameOverMenu

- (instancetype)initWithSize:(CGSize)size {

    if (self = [super init]) {
        _size = size;
        
        // Get texture atlas
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
        
        // Setup game over title
        _gameOverTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textGameOver"]];
        _gameOverTitle.position = CGPointMake(size.width * 0.5, size.height - 70);
        [self addChild:_gameOverTitle];
        
        // Create a node to put all other nodes
        _panelGroup = [SKNode node];
        [self addChild:_panelGroup];
        
        // Setup panel background
        SKSpriteNode *panelBG = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"UIbg"]];
        panelBG.position = CGPointMake(size.width * 0.5, size.height - 150);
        panelBG.centerRect = CGRectMake(10/panelBG.size.width, 10/panelBG.size.height,
                                        (panelBG.size.width-20)/panelBG.size.width,
                                        (panelBG.size.height-20)/panelBG.size.height);
        
        panelBG.xScale = 175./panelBG.size.width;
        panelBG.yScale = 115./panelBG.size.height;
        
        [self.panelGroup addChild:panelBG];
        
        // Setup score title
        SKSpriteNode *scoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textScore"]];
        scoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        scoreTitle.position = CGPointMake(CGRectGetMaxX(panelBG.frame) - 20, CGRectGetMaxY(panelBG.frame) - 10);
        [self.panelGroup addChild:scoreTitle];
        
        // Setup score text label
        _scoreText = [[FPBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreText.alignment = BitmapFontAlignmentRight;
        _scoreText.position = CGPointMake(CGRectGetMaxX(scoreTitle.frame),CGRectGetMinY(scoreTitle.frame) - 15);
        [_scoreText setScale:0.5];
        [self.panelGroup addChild:_scoreText];
        
        // Setup best score title
        SKSpriteNode *bestScoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textBest"]];
        bestScoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        bestScoreTitle.position = CGPointMake(CGRectGetMaxX(panelBG.frame) - 20, CGRectGetMaxY(panelBG.frame) - 60);
        [self.panelGroup addChild:bestScoreTitle];
        
        // Setup best score text label
        _bestScoreText = [[FPBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _bestScoreText.alignment = BitmapFontAlignmentRight;
        _bestScoreText.position = CGPointMake(CGRectGetMaxX(bestScoreTitle.frame),CGRectGetMinY(bestScoreTitle.frame) - 15);
        [_bestScoreText setScale:0.5];
        [self.panelGroup addChild:_bestScoreText];
        
        // Setup medal title
        SKSpriteNode *medalTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textMedal"]];
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0);
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBG.frame) + 20, CGRectGetMaxY(panelBG.frame) - 10);
        [self.panelGroup addChild:medalTitle];
        
        // Setup medal display
        _medalDisplay = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"medalBlank"]];
        _medalDisplay.anchorPoint = CGPointMake(0.5, 1.0);
        _medalDisplay.position = CGPointMake(CGRectGetMidX(medalTitle.frame), CGRectGetMinY(medalTitle.frame) - 15);
        [self.panelGroup addChild:_medalDisplay];
        
        // Setup play button
        _playButton = [FPButton spriteNodeWithTexture:[atlas textureNamed:@"buttonPlay"]];
        _playButton.position = CGPointMake(CGRectGetMidX(panelBG.frame), CGRectGetMinY(panelBG.frame) - 25);
        [_playButton setPressedTarget:self withAction:@selector(pressedPlayButton)];
        [self addChild:_playButton];
        
        // Set initial values
        self.medal = MedalNone;
        self.score = 0;
        self.bestScore = 0;
        
    }
    
    return self;
}

- (void)pressedPlayButton
{
    [self.delegate pressedNewGameButton];
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreText.text = [NSString stringWithFormat:@"%ld",(long)score];
}

- (void)setBestScore:(NSInteger)bestScore
{
    _bestScore = bestScore;
    self.bestScoreText.text = [NSString stringWithFormat:@"%ld",(long)bestScore];
}

- (void)setMedal:(MedalType)medal
{
    // Get texture atlas
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    
    _medal = medal;
    
    switch (medal) {
        case MedalBronze:
            self.medalDisplay.texture = [atlas textureNamed:@"medalBronze"];
            break;
        case MedalSilver:
            self.medalDisplay.texture = [atlas textureNamed:@"medalSilver"];
            break;
        case MedalGold:
            self.medalDisplay.texture = [atlas textureNamed:@"medalGold"];
            break;
        default:
            self.medalDisplay.texture = [atlas textureNamed:@"medalBlank"];
            break;
    }
}

- (void)show
{
    // Animate game over title
    SKAction *dropGameOverTitle = [SKAction moveToY:self.gameOverTitle.position.y duration:0.5];
    dropGameOverTitle.timingMode = SKActionTimingEaseOut;
    self.gameOverTitle.position = CGPointMake(self.gameOverTitle.position.x, self.gameOverTitle.position.y+100);
    [self.gameOverTitle runAction:dropGameOverTitle];
    
    // Animate panel group
    SKAction *raisePanel = [SKAction group:@[[SKAction fadeInWithDuration:0.4],
                                             [SKAction moveByX:0.0 y:100.0 duration:0.4]]];
    raisePanel.timingMode = SKActionTimingEaseOut;
    self.panelGroup.alpha = 0.01;
    self.panelGroup.position = CGPointMake(self.panelGroup.position.x, self.panelGroup.position.y-100);
    [self.panelGroup runAction:[SKAction sequence:@[[SKAction waitForDuration:0.4],raisePanel]]];
    
    // Animate play button
    SKAction *fadeInPlayButton = [SKAction sequence:@[[SKAction waitForDuration:0.8],[SKAction fadeInWithDuration:0.4]]];
    self.playButton.alpha = 0.0;
    self.playButton.userInteractionEnabled = NO;
    [self.playButton runAction:fadeInPlayButton completion:^{
        self.playButton.userInteractionEnabled = YES;
    }];
    
}


@end

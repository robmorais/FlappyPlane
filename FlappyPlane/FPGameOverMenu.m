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

@interface FPGameOverMenu()
@property (nonatomic) SKSpriteNode *medalDisplay;
@property (nonatomic) FPBitmapFontLabel *scoreText;
@property (nonatomic) FPBitmapFontLabel *bestScoreText;
@end

@implementation FPGameOverMenu

- (instancetype)initWithSize:(CGSize)size {

    if (self = [super init]) {
        _size = size;
        
        // Get texture atlas
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
        
        // Create an overravel node to put all other nodes
        SKNode *panelGroup = [SKNode node];
        [self addChild:panelGroup];
        
        // Setup panel background
        SKSpriteNode *panelBG = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"UIbg"]];
        panelBG.position = CGPointMake(size.width * 0.5, size.height - 150);
        panelBG.centerRect = CGRectMake(10/panelBG.size.width, 10/panelBG.size.height,
                                        (panelBG.size.width-20)/panelBG.size.width,
                                        (panelBG.size.height-20)/panelBG.size.height);
        
        panelBG.xScale = 175./panelBG.size.width;
        panelBG.yScale = 115./panelBG.size.height;
        
        [panelGroup addChild:panelBG];
        
        // Setup score title
        SKSpriteNode *scoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textScore"]];
        scoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        scoreTitle.position = CGPointMake(CGRectGetMaxX(panelBG.frame) - 20, CGRectGetMaxY(panelBG.frame) - 10);
        [panelGroup addChild:scoreTitle];
        
        // Setup score text label
        _scoreText = [[FPBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreText.alignment = BitmapFontAlignmentRight;
        _scoreText.position = CGPointMake(CGRectGetMaxX(scoreTitle.frame),CGRectGetMinY(scoreTitle.frame) - 15);
        [_scoreText setScale:0.5];
        [panelGroup addChild:_scoreText];
        
        // Setup best score title
        SKSpriteNode *bestScoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textBest"]];
        bestScoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        bestScoreTitle.position = CGPointMake(CGRectGetMaxX(panelBG.frame) - 20, CGRectGetMaxY(panelBG.frame) - 60);
        [panelGroup addChild:bestScoreTitle];
        
        // Setup best score text label
        _bestScoreText = [[FPBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _bestScoreText.alignment = BitmapFontAlignmentRight;
        _bestScoreText.position = CGPointMake(CGRectGetMaxX(bestScoreTitle.frame),CGRectGetMinY(bestScoreTitle.frame) - 15);
        [_bestScoreText setScale:0.5];
        [panelGroup addChild:_bestScoreText];
        
        // Setup medal title
        SKSpriteNode *medalTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textMedal"]];
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0);
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBG.frame) + 20, CGRectGetMaxY(panelBG.frame) - 10);
        [panelGroup addChild:medalTitle];
        
        // Setup medal display
        _medalDisplay = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"medalBlank"]];
        _medalDisplay.anchorPoint = CGPointMake(0.5, 1.0);
        _medalDisplay.position = CGPointMake(CGRectGetMidX(medalTitle.frame), CGRectGetMinY(medalTitle.frame) - 15);
        [panelGroup addChild:_medalDisplay];
        
        // Set initial values
        self.medal = MedalNone;
        self.score = 78;
        self.bestScore = 340;
        
    }
    
    return self;
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


@end

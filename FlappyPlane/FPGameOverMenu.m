//
//  TPGameOverMenu.m
//  FlappyPlane
//
//  Created by Roberto Silva on 10/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPGameOverMenu.h"
#import "FPConstants.h"

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
        
        // Setup best score title
        SKSpriteNode *bestScoreTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textBest"]];
        bestScoreTitle.anchorPoint = CGPointMake(1.0, 1.0);
        bestScoreTitle.position = CGPointMake(CGRectGetMaxX(panelBG.frame) - 20, CGRectGetMaxY(panelBG.frame) - 60);
        [panelGroup addChild:bestScoreTitle];
        
        // Setup medal title
        SKSpriteNode *medalTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textMedal"]];
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0);
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBG.frame) + 20, CGRectGetMaxY(panelBG.frame) - 10);
        [panelGroup addChild:medalTitle];
        
    }
    
    return self;
}


@end

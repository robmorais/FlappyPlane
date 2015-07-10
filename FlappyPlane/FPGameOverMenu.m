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
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
        
        SKSpriteNode *panelBG = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"UIbg"]];
        panelBG.position = CGPointMake(size.width * 0.5, size.height - 150);
        panelBG.centerRect = CGRectMake(10/panelBG.size.width, 10/panelBG.size.height,
                                        (panelBG.size.width-20)/panelBG.size.width,
                                        (panelBG.size.height-20)/panelBG.size.height);
        
        panelBG.xScale = 175./panelBG.size.width;
        panelBG.yScale = 150./panelBG.size.height;
        
        [self addChild:panelBG];
        
    }
    
    return self;
}


@end

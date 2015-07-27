//
//  FPTilesetTextureProvider.h
//  FlappyPlane
//
//  Created by Roberto Silva on 26/06/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface FPTilesetTextureProvider : NSObject

@property (nonatomic) NSString *currentTilesetName;

+ (instancetype)sharedProvider;
- (void)randomizeTileset;
- (SKTexture *)textureForKey:(NSString *)key;
@end

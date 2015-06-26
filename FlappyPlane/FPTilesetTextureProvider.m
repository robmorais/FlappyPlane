//
//  FPTilesetTextureProvider.m
//  FlappyPlane
//
//  Created by Roberto Silva on 26/06/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPTilesetTextureProvider.h"
#import "FPConstants.h"

@interface FPTilesetTextureProvider()

@property (nonatomic) NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentTileset;

@end

@implementation FPTilesetTextureProvider

+ (instancetype)sharedProvider
{
    static FPTilesetTextureProvider *provider = nil;
    
    @synchronized(self){
        if (provider) {
            provider = [FPTilesetTextureProvider new];
        }
        
        return provider;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadTilesets];
        [self randomizeTileset];
    }
    
    return self;
}

- (void)randomizeTileset
{
    NSArray *tilesetKeys = [self.tilesets allKeys];
    NSString *key = [tilesetKeys objectAtIndex:arc4random_uniform((uint)tilesetKeys.count)];
    self.currentTileset = [self.tilesets objectForKey:key];
}

- (void)loadTilesets
{
    self.tilesets = [NSMutableDictionary new];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kFPGraphicsAtlas];
    
    // Get the path to the property list
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TilesetGraphics" ofType:@"plist"];
    
    // Load contents of file
    NSDictionary *tilesetList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    for (NSString *tilesetKey in tilesetList) {
        // Get dictionary of texture names
        NSDictionary *textureList = [tilesetList objectForKey:tilesetKey];
        // Create a dictionary to hold textures
        NSMutableDictionary *textures = [NSMutableDictionary new];
        
        for (NSString *textureKey in textureList) {
            SKTexture *texture = [atlas textureNamed:[textureList objectForKey:textureKey]];
            [textures setObject:texture forKey:textureKey];
        }
        
        
        // Add textures dictionary to tilesets
        [self.tilesets setObject:textures forKey:tilesetKey];
    }
}

@end

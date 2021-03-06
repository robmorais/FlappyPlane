//
//  FPConstants.m
//  FlappyPlane
//
//  Created by Roberto Silva on 25/05/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "FPConstants.h"

@implementation FPConstants

const uint32_t kFPCategoryPlane         = 0x1 << 0;
const uint32_t kFPCategoryGround        = 0x1 << 1;
const uint32_t kFPCategoryCollectable   = 0x1 << 2;;

NSString *const kFPGraphicsAtlas = @"Graphics";

NSString *const kFPTilesetGrass = @"Grass";
NSString *const kFPTilesetDirt = @"Dirt";
NSString *const kFPTilesetSnow = @"Snow";
NSString *const kFPTilesetIce = @"Ice";
@end

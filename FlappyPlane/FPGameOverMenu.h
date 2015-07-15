//
//  TPGameOverMenu.h
//  FlappyPlane
//
//  Created by Roberto Silva on 10/07/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold
} MedalType;

@protocol FPGameOverMenuDelegate <NSObject>

- (void)pressedNewGameButton;

@end

@interface FPGameOverMenu : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;
@property (nonatomic, weak) id<FPGameOverMenuDelegate> delegate;

- (instancetype)initWithSize:(CGSize)size;
- (void)show;
@end

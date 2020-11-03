//
//  YGCTrimVideoView.h
//  VideoTrimView
//
//  Created by Qilong Zang on 30/01/2018.
//  Copyright © 2018 Qilong Zang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void (^YGCExportFinished)(BOOL success, NSURL* outputURL);

@protocol YGCTrimVideoViewDelegate <NSObject>

- (void)videoBeginTimeChanged:(CMTime)begin;

- (void)videoEndTimeChanged:(CMTime)end;

- (void)dragActionEnded:(CMTimeRange)range;

@end

@interface YGCTrimVideoView : UIView

@property(nonatomic, weak) id<YGCTrimVideoViewDelegate> delegate;

@property(nonatomic, strong, readonly) AVComposition* currentAsset;

/*
 * change the left sidebar Image
 */
@property(nonatomic, strong) UIImage* leftSidebarImage;

/*
 * change the right sidebar Image
 */
@property(nonatomic, strong) UIImage* rightSidebarImage;

/*
 * change the center range Image
 */
@property(nonatomic, strong) UIImage* centerRangeImage;

/*
 * change the maximum duration of video
 */
@property(nonatomic, assign) NSTimeInterval maxSeconds;

/*
 * change the minimum duration of video
 */
@property(nonatomic, assign) NSTimeInterval minSeconds;

/*
 * change the left and right side maskView when slider range decrease
 */
@property(nonatomic, strong) UIColor* maskColor;

- (id)initWithFrame:(CGRect)frame assetURL:(NSURL*)url maxSeconds:(float)max minSeconds:(float)min inset:(CGFloat)inset;

- (void)updateCursor:(float)time;

- (AVMutableComposition*)trimVideo;

@end

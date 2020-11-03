//
//  YGCTrimVideoView.m
//  VideoTrimView
//
//  Created by Qilong Zang on 30/01/2018.
//  Copyright © 2018 Qilong Zang. All rights reserved.
//

#import "YGCTrimVideoView.h"

#import "UIView+YGCFrameUtil.h"
#import "YGCThumbCollectionViewCell.h"
#import "YGCTrimVideoControlView.h"

// static CGFloat const kDefaultMaxSeconds = 10;
// static CGFloat const kDefaultMinSeconds = 2;
// static NSInteger const kMaxThumbCount = 30;
static CGFloat const kDefaultSidebarWidth = 12;
static NSString* const kCellIdentifier = @"YGCThumbCollectionViewCell";

@interface YGCTrimVideoView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YGCTrimVideoControlViewDelegate> {
    CMTime _startTime;
    CMTime _endTime;
}

@property(nonatomic, strong) UICollectionView* thumbCollectionView;
@property(nonatomic, strong) YGCTrimVideoControlView* controlView;
@property(nonatomic, assign) CGFloat controlInset;
@property(nonatomic, strong) AVURLAsset* asset;
@property(nonatomic, strong) AVAssetImageGenerator* imageGenerator;
@property(nonatomic, strong) NSMutableArray<UIImage*>* thumbImageArray;
@property(nonatomic, strong) NSMutableArray<NSValue*>* timeArray;
@property(nonatomic, assign) CGFloat sidebarWidth;

@end

@implementation YGCTrimVideoView

- (id)initWithFrame:(CGRect)frame assetURL:(NSURL*)url maxSeconds:(float)max minSeconds:(float)min inset:(CGFloat)inset {
    if (self = [super initWithFrame:frame]) {
        _startTime = kCMTimeZero;
        _endTime = kCMTimeZero;
        _asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        _controlInset = inset;
        _leftSidebarImage = [UIImage imageNamed:@"video_cut_left"];
        _rightSidebarImage = [UIImage imageNamed:@"video_cut_right"];
        _centerRangeImage = [UIImage imageNamed:@"video_cut_middle"];
        _sidebarWidth = kDefaultSidebarWidth;
        self.thumbImageArray = [NSMutableArray array];
        self.timeArray = [NSMutableArray array];
        _maxSeconds = max;
        _minSeconds = MIN(min, CMTimeGetSeconds(_asset.duration));
        [self commonInit];
        [self generateVideoThumb];
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.thumbCollectionView];
    [self addSubview:self.controlView];

    [self.thumbCollectionView registerClass:[YGCThumbCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

- (NSTimeInterval)pixelSeconds {
    return [self actualMaxSecons] / (self.controlView.ygc_width - self.controlInset * 2.0);
}

- (NSTimeInterval)cellTime {
    return [self pixelSeconds] * [self cellWidth];
}

- (CGFloat)cellWidth {
    return self.controlView.ygc_width / 10;
}

- (CGFloat)actualMaxSecons {
    NSTimeInterval duration = CMTimeGetSeconds(self.asset.duration);
    if (duration < self.maxSeconds) {
        return duration;
    } else {
        return self.maxSeconds;
    }
}

#pragma mark - Getter

- (YGCTrimVideoControlView*)controlView {
    if (_controlView == nil) {
        _controlView = [[YGCTrimVideoControlView alloc] initWithFrame:self.bounds
                                                     leftControlImage:self.leftSidebarImage
                                                    rightControlImage:self.rightSidebarImage
                                                     centerRangeImage:self.centerRangeImage
                                                         sideBarInset:self.controlInset];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (UICollectionView*)thumbCollectionView {
    if (_thumbCollectionView == nil) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _thumbCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _thumbCollectionView.bounces = NO;
        _thumbCollectionView.delegate = self;
        _thumbCollectionView.dataSource = self;
    }
    return _thumbCollectionView;
}

- (AVAssetImageGenerator*)imageGenerator {
    if (_imageGenerator == nil) {
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
        _imageGenerator.maximumSize = CGSizeMake(80, 80);
        _imageGenerator.appliesPreferredTrackTransform = YES;
    }
    return _imageGenerator;
}

#pragma mark - Setter

- (void)setMaskColor:(UIColor*)maskColor {
    _maskColor = maskColor;
    self.controlView.maskColor = _maskColor;
}

- (void)setMinSeconds:(NSTimeInterval)minSeconds {
    _minSeconds = minSeconds;
    self.controlView.mininumTimeWidth = _minSeconds / [self pixelSeconds];
}

- (void)setSidebarWidth:(CGFloat)sidebarWidth {
    _sidebarWidth = sidebarWidth;
}

- (void)setLeftSidebarImage:(UIImage*)leftSidebarImage {
    _leftSidebarImage = leftSidebarImage;
    [self.controlView resetLeftSideBarImage:leftSidebarImage];
}

- (void)setRightSidebarImage:(UIImage*)rightSidebarImage {
    _rightSidebarImage = rightSidebarImage;
    [self.controlView resetRightSideBarImage:rightSidebarImage];
}

- (void)setCenterRangeImage:(UIImage*)centerRangeImage {
    _centerRangeImage = centerRangeImage;
    [self.controlView resetCenterRangeImage:centerRangeImage];
}

#pragma mark - CollectionView DataSource

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    YGCThumbCollectionViewCell* thumbCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    thumbCell.thumbImageView.image = self.thumbImageArray[indexPath.row];
    return thumbCell;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.thumbImageArray.count;
}

#pragma mark - CollectionViewFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView*)collectionView
                    layout:(UICollectionViewLayout*)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake(self.cellWidth, self.ygc_height - 6);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView
                                 layout:(UICollectionViewLayout*)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView
                                      layout:(UICollectionViewLayout*)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.controlInset, 0, self.controlInset);
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView*)sender {
    if ([_delegate respondsToSelector:@selector(videoBeginTimeChanged:)]) {
        [self refreshVideoTime:[self.controlView leftBarFrame] rightFrmae:[self.controlView rightBarFrame]];
        [_delegate videoBeginTimeChanged:_startTime];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self refreshVideoTime:[self.controlView leftBarFrame] rightFrmae:[self.controlView rightBarFrame]];
        if ([self.delegate respondsToSelector:@selector(dragActionEnded:)]) {
            [self.delegate dragActionEnded:CMTimeRangeMake(_startTime, CMTimeSubtract(_endTime, _startTime))];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    [self refreshVideoTime:[self.controlView leftBarFrame] rightFrmae:[self.controlView rightBarFrame]];
    if ([self.delegate respondsToSelector:@selector(dragActionEnded:)]) {
        [self.delegate dragActionEnded:CMTimeRangeMake(_startTime, CMTimeSubtract(_endTime, _startTime))];
    }
}

#pragma mark - Trim ControlView Delegate

- (void)leftSideBarChangedFrame:(CGRect)leftFrame rightBarCurrentFrame:(CGRect)rightFrame {
    [self refreshVideoTime:leftFrame rightFrmae:rightFrame];
    if ([self.delegate respondsToSelector:@selector(videoBeginTimeChanged:)]) {
        [self.delegate videoBeginTimeChanged:_startTime];
    }
}

- (void)rightSideBarChangedFrame:(CGRect)rightFrame leftBarCurrentFrame:(CGRect)leftFrame {
    [self refreshVideoTime:leftFrame rightFrmae:rightFrame];
    if ([self.delegate respondsToSelector:@selector(videoEndTimeChanged:)]) {
        [self.delegate videoEndTimeChanged:_endTime];
    }
}

- (void)panGestureEnded:(CGRect)leftFrame rightFrame:(CGRect)rightFrame {
    [self refreshVideoTime:leftFrame rightFrmae:rightFrame];
    if ([self.delegate respondsToSelector:@selector(dragActionEnded:)]) {
        [self.delegate dragActionEnded:CMTimeRangeMake(_startTime, CMTimeSubtract(_endTime, _startTime))];
    }
}

#pragma mark - Private Method

- (void)refreshVideoTime:(CGRect)leftFrame rightFrmae:(CGRect)rightFrame {
    CGRect convertLeftBarRect = [self.controlView convertRect:leftFrame toView:self];
    CGRect convertRightBarRect = [self.controlView convertRect:rightFrame toView:self];
    CGFloat leftPosition = self.thumbCollectionView.contentOffset.x + CGRectGetMaxX(convertLeftBarRect) - self.controlInset;
    CGFloat rightPosition = self.thumbCollectionView.contentOffset.x + convertRightBarRect.origin.x - self.controlInset;
    CGFloat startSec = leftPosition * [self pixelSeconds];
    CGFloat endSec = rightPosition * [self pixelSeconds];
    _startTime = CMTimeMakeWithSeconds(startSec, self.asset.duration.timescale);
    _endTime = CMTimeMakeWithSeconds(endSec, self.asset.duration.timescale);
}

- (void)generateVideoThumb {
    CMTimeScale timeScale = self.asset.duration.timescale;

    self.controlView.mininumTimeWidth = self.minSeconds / [self pixelSeconds];

    NSInteger thumbNumber = CMTimeGetSeconds(self.asset.duration) / [self cellTime];
    for (int i = 0; i < thumbNumber; i++) {
        CMTime time = CMTimeMakeWithSeconds([self cellTime] * i, timeScale);
        NSValue* value = [NSValue valueWithCMTime:time];
        [self.timeArray addObject:value];
    }

    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:self.timeArray
                                              completionHandler:^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime,
                                                                  AVAssetImageGeneratorResult result, NSError* _Nullable error) {
                                                  if (error == nil && result == AVAssetImageGeneratorSucceeded) {
                                                      [self.thumbImageArray addObject:[UIImage imageWithCGImage:image]];
                                                      dispatch_async(dispatch_get_main_queue(), ^{ [self.thumbCollectionView reloadData]; });
                                                  }
                                              }];
}

- (AVMutableComposition*)trimVideo {
    AVAssetTrack* assetVideoTrack = nil;
    AVAssetTrack* assetAudioTrack = nil;
    AVURLAsset* asset = self.asset;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }

    // avoid user doesn't drag control bar
    if (CMTimeCompare(_startTime, kCMTimeZero) == 0 && CMTimeCompare(_endTime, kCMTimeZero) == 0) {
        _endTime = CMTimeMakeWithSeconds([self actualMaxSecons], self.asset.duration.timescale);
    }

    int sampleRate = 0;
    NSArray* formatDesc = assetAudioTrack.formatDescriptions;
    for (int i = 0; i < [formatDesc count]; ++i) {
        CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)[formatDesc objectAtIndex:i];
        const AudioStreamBasicDescription* asbd = CMAudioFormatDescriptionGetStreamBasicDescription(item);
        if (asbd && asbd->mSampleRate) {
            sampleRate = asbd->mSampleRate;
            break;
        }
    }

    CMTimeRange cutRange = CMTimeRangeMake(_startTime, _endTime);
    NSError* error = nil;

    AVMutableComposition* mutableComposition = [AVMutableComposition composition];

    // Insert half time range of the video and audio tracks from AVAsset
    if (assetVideoTrack != nil) {
        AVMutableCompositionTrack* compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:cutRange ofTrack:assetVideoTrack atTime:kCMTimeZero error:&error];
        [compositionVideoTrack setPreferredTransform:assetVideoTrack.preferredTransform];
    }
    if (assetAudioTrack != nil) {
        AVMutableCompositionTrack* compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:cutRange ofTrack:assetAudioTrack atTime:kCMTimeZero error:&error];
    }

    CMTime acturalDuraton = CMTimeSubtract(_endTime, _startTime);
    [mutableComposition removeTimeRange:CMTimeRangeMake(acturalDuraton, mutableComposition.duration)];
    return mutableComposition;
}

- (void)updateCursor:(float)time {
    [_controlView updateCursorOffset:time / [self pixelSeconds]];
}

#pragma mark - Export

- (void)exportVideo:(YGCExportFinished)finishedBlock {
    AVMutableComposition* asset = [self trimVideo];
    NSString* tmpFile = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
    }
    AVAssetExportSession* session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    session.outputURL = [NSURL fileURLWithPath:tmpFile];
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^{
        if (session.status == AVAssetExportSessionStatusCompleted) {
            finishedBlock(YES, session.outputURL);
        } else {
            finishedBlock(NO, nil);
        }
    }];
}
@end

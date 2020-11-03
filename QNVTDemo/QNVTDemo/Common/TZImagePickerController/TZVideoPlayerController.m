//
//  TZVideoPlayerController.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZVideoPlayerController.h"

#import "QNVTOffsetButton.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "TZPhotoPreviewController.h"
#import "UIImage+Util.h"
#import "UIView+Layout.h"
#import "YGCTrimVideoView.h"

#import <MediaPlayer/MediaPlayer.h>

@interface TZVideoPlayerController () <UIGestureRecognizerDelegate, YGCTrimVideoViewDelegate> {
    AVPlayer* _player;
    AVPlayerLayer* _playerLayer;
    UIButton* _playButton;
    UIImage* _cover;

    UIView* _toolBar;
    QNVTOffsetButton* _doneButton;
    UIProgressView* _progress;

    UIStatusBarStyle _originStatusBarStyle;
}
@property(assign, nonatomic) BOOL needShowStatusBar;
// iCloud无法同步提示UI
@property(nonatomic, strong) UIView* iCloudErrorView;
@property(nonatomic, strong) YGCTrimVideoView* videoCutterView;
@property(nonatomic, strong) UIView* bottomBar;
@property(nonatomic, strong) UIView* playerContainer;
@property(nonatomic, strong) UILabel* timeLabel;
@property(nonatomic, strong) UILabel* recommendLabel;

@property(nonatomic, assign) CMTime startTime;
@property(nonatomic, assign) CMTime endTime;
@property(nonatomic, assign) double duration;
@property(nonatomic, strong) id playerTimeObserver;

@property(nonatomic, strong) id<UIGestureRecognizerDelegate> oriPopDelegate;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation TZVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needShowStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    self.view.backgroundColor = [UIColor blackColor];
    TZImagePickerController* tzImagePickerVc = (TZImagePickerController*)self.navigationController;
    if (tzImagePickerVc) {
        self.navigationItem.title = tzImagePickerVc.previewBtnTitleStr;
    }

    [self setupContainer];
    [self configMoviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pausePlayerAndShowNaviBar)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    self.oriPopDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;

    self.navigationController.interactivePopGestureRecognizer.delegate = _oriPopDelegate;
}

- (void)setupContainer {
    _playerContainer = [[UIView alloc] init];
    _playerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomBar = [[UIView alloc] init];
    _bottomBar.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_playerContainer];
    [self.view addSubview:_bottomBar];

    [[_playerContainer.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[_playerContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
    [[_playerContainer.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];

    [[_bottomBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[_bottomBar.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor] setActive:YES];
    [[_bottomBar.topAnchor constraintEqualToAnchor:_playerContainer.bottomAnchor] setActive:YES];
    [[_bottomBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[_bottomBar.heightAnchor constraintEqualToConstant:156] setActive:YES];
}

- (void)setupBottomBar:(AVURLAsset*)asset {
    TZImagePickerController* tzImagePickerVc = (TZImagePickerController*)self.navigationController;
    QNVTProperty* property = tzImagePickerVc.userInfo.properties.firstObject;
    float duration = (property.value.outPoint - property.value.inPoint) / tzImagePickerVc.userInfo.fps;
    self.endTime = CMTimeMakeWithSeconds(duration, 100000);

    float inset = 40;
    float assetDuration = CMTimeGetSeconds(asset.duration);
    if (assetDuration < 5) {
        inset = (SCREENWIDTH - (SCREENWIDTH - inset * 2) / 5.0 * assetDuration) / 2.0;
    }
    _videoCutterView = [[YGCTrimVideoView alloc] initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 70)
                                                      assetURL:asset.URL
                                                    maxSeconds:duration
                                                    minSeconds:duration
                                                         inset:inset];
    _videoCutterView.delegate = self;

    self.duration = MIN(duration, assetDuration);
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 200, 17)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = [NSString stringWithFormat:@"0.0/%.1f", self.duration];

    _recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 134, SCREENWIDTH, 17)];
    _recommendLabel.font = [UIFont systemFontOfSize:12];
    _recommendLabel.textColor = [UIColor whiteColor];
    _recommendLabel.text = [NSString stringWithFormat:@"推荐视频时长%.1f秒", duration];
    _recommendLabel.textAlignment = NSTextAlignmentCenter;

    [_bottomBar addSubview:_timeLabel];
    [_bottomBar addSubview:_videoCutterView];
    [_bottomBar addSubview:_recommendLabel];

    [self dragActionEnded:CMTimeRangeMake(kCMTimeZero, self.endTime)];
    [_player pause];
}

- (void)configMoviePlayer {
    [[TZImageManager manager] getPhotoWithAsset:_model.asset
                                     completion:^(UIImage* photo, NSDictionary* info, BOOL isDegraded) {
                                         BOOL iCloudSyncFailed = !photo && [TZCommonTools isICloudSyncError:info[PHImageErrorKey]];
                                         self.iCloudErrorView.hidden = !iCloudSyncFailed;
                                         if (!isDegraded && photo) {
                                             self->_cover = photo;
                                             self->_doneButton.enabled = YES;
                                         }
                                     }];

    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;

    PHImageManager* manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:_model.asset
                            options:options
                      resultHandler:^(AVAsset* _Nullable asset, AVAudioMix* _Nullable audioMix, NSDictionary* _Nullable info) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              AVURLAsset* urlAsset = (AVURLAsset*)asset;
                              AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:asset];
                              self->_player = [AVPlayer playerWithPlayerItem:playerItem];
                              self->_playerLayer = [AVPlayerLayer playerLayerWithPlayer:self->_player];
                              self->_playerLayer.frame = self->_playerContainer.frame;
                              self.startTime = kCMTimeZero;
                              self.endTime = playerItem.duration;
                              [self->_playerContainer.layer addSublayer:self->_playerLayer];
                              [self setupBottomBar:urlAsset];
                              [self addProgressObserver];
                              [self configPlayButton];
                              [self configBottomToolBar];
                              [self playButtonClick];
                              [[NSNotificationCenter defaultCenter] addObserver:self
                                                                       selector:@selector(playButtonClick)
                                                                           name:AVPlayerItemDidPlayToEndTimeNotification
                                                                         object:self->_player.currentItem];
                          });
                      }];
}

/// Show progress，do it next time / 给播放器添加进度更新,下次加上
- (void)addProgressObserver {
    W_SELF;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30)
                                          queue:dispatch_get_main_queue()
                                     usingBlock:^(CMTime time) {
                                         S_SELF;
                                         if (sself) {
                                             float seconds = CMTimeGetSeconds(CMTimeSubtract(time, sself.startTime));
                                             seconds = MAX(0, seconds);
                                             sself.timeLabel.text = [NSString stringWithFormat:@"%.1f/%.1f", seconds, sself.duration];
                                             [sself.videoCutterView updateCursor:seconds];
                                         }
                                     }];
}

- (void)configPlayButton {
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage tz_imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage tz_imageNamedFromMyBundle:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self->_playerContainer addSubview:_playButton];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];

    _doneButton = [QNVTOffsetButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
    if (!_cover) {
        _doneButton.enabled = NO;
    }

    TZImagePickerController* tzImagePickerVc = (TZImagePickerController*)self.navigationController;
    _doneButton = [QNVTOffsetButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(0, 0, 60, 30);
    _doneButton.offset = UIEdgeInsetsMake(0, 10, 0, -10);
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSAttributedString* title = [[NSAttributedString alloc] initWithString:@"完成" attributes:attributes];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setAttributedTitle:title forState:UIControlStateNormal];
    [_doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_doneButton setBackgroundImage:[UIImage imageWithColor:QNVTCOLOR(1f66ff) size:CGSizeMake(60, 30) radius:4] forState:UIControlStateNormal];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    self.navigationItem.rightBarButtonItem = item;

    [self.view addSubview:_toolBar];

    if (tzImagePickerVc.videoPreviewPageUIConfigBlock) {
        tzImagePickerVc.videoPreviewPageUIConfigBlock(_playButton, _toolBar, _doneButton);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    TZImagePickerController* tzImagePicker = (TZImagePickerController*)self.navigationController;
    if (tzImagePicker && [tzImagePicker isKindOfClass:[TZImagePickerController class]]) {
        return tzImagePicker.statusBarStyle;
    }
    return [super preferredStatusBarStyle];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _playerLayer.frame = self.view.bounds;
    CGFloat toolBarHeight = [TZCommonTools tz_isIPhoneX] ? 44 + (83 - 49) : 44;
    _toolBar.frame = CGRectMake(0, self.view.tz_height - toolBarHeight, self.view.tz_width, toolBarHeight);
    _toolBar.hidden = YES;
    _playButton.frame = self->_playerContainer.bounds;

    TZImagePickerController* tzImagePickerVc = (TZImagePickerController*)self.navigationController;
    if (tzImagePickerVc.videoPreviewPageDidLayoutSubviewsBlock) {
        tzImagePickerVc.videoPreviewPageDidLayoutSubviewsBlock(_playButton, _toolBar, _doneButton);
    }

    if (_playerLayer.superlayer) {
        self->_playerLayer.frame = self->_playerContainer.bounds;
    }
}

#pragma mark - Click Event

- (void)playButtonClick {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value)
            [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
        [_playButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self pausePlayerAndShowNaviBar];
    }
}

- (void)doneButtonClick {
    if (self.navigationController) {
        TZImagePickerController* imagePickerVc = (TZImagePickerController*)self.navigationController;
        if (imagePickerVc.autoDismiss) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
            [self callDelegateMethod];
        } else {
            [self callDelegateMethod];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{ [self callDelegateMethod]; }];
    }
}

- (void)callDelegateMethod {
    AVMutableComposition* asset = [_videoCutterView trimVideo];
    TZImagePickerController* imagePickerVc = (TZImagePickerController*)self.navigationController;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:composition:)]) {
        [imagePickerVc.pickerDelegate imagePickerController:imagePickerVc didFinishPickingVideo:_cover sourceAssets:_model.asset composition:asset];
    }
    if (imagePickerVc.didFinishPickingVideoHandle) {
        imagePickerVc.didFinishPickingVideoHandle(_cover, _model.asset, asset);
    }
}

#pragma mark - Notification Method

- (void)pausePlayerAndShowNaviBar {
    [_player pause];
    [_playButton setImage:[UIImage tz_imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];

    //    _toolBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    if (self.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
}

#pragma mark - lazy
- (UIView*)iCloudErrorView {
    if (!_iCloudErrorView) {
        _iCloudErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, [TZCommonTools tz_isIPhoneX] ? 88 + 10 : 64 + 10, self.view.tz_width, 28)];
        UIImageView* icloud = [[UIImageView alloc] init];
        icloud.image = [UIImage tz_imageNamedFromMyBundle:@"iCloudError"];
        icloud.frame = CGRectMake(20, 0, 28, 28);
        [_iCloudErrorView addSubview:icloud];
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(53, 0, self.view.tz_width - 63, 28);
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor whiteColor];
        label.text = [NSBundle tz_localizedStringForKey:@"iCloud sync failed"];
        [_iCloudErrorView addSubview:label];
        [self.view addSubview:_iCloudErrorView];
        _iCloudErrorView.hidden = YES;
    }
    return _iCloudErrorView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma clang diagnostic pop

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        if (CGRectContainsPoint(self.videoCutterView.frame, [gestureRecognizer locationInView:self.bottomBar])) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - cutter delegate

- (void)videoBeginTimeChanged:(CMTime)begin {
    if (CMTimeCompare(begin, kCMTimeZero) < 0) {
        return;
    }

    self.startTime = begin;

    if (_player.rate > 0) {
        [_player pause];
    }

    [_player seekToTime:begin toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)videoEndTimeChanged:(CMTime)end {
    if (CMTimeCompare(self->_player.currentItem.asset.duration, end) < 0) {
        return;
    }

    self.endTime = end;

    if (_player.rate > 0) {
        [_player pause];
    }

    [_player seekToTime:end toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)dragActionEnded:(CMTimeRange)range {
    if (_playerTimeObserver) {
        [_player removeTimeObserver:_playerTimeObserver];
    }

    self.startTime = range.start;
    self.endTime = CMTimeRangeGetEnd(range);

    __weak typeof(self) wself = self;
    _playerTimeObserver = [_player addBoundaryTimeObserverForTimes:@[ [NSValue valueWithCMTime:self.endTime] ]
                                                             queue:NULL
                                                        usingBlock:^{
                                                            typeof(self) sself = wself;
                                                            if (sself) {
                                                                [sself->_player seekToTime:sself.startTime
                                                                           toleranceBefore:kCMTimeZero
                                                                            toleranceAfter:kCMTimeZero];
                                                                [sself->_player play];
                                                            }
                                                        }];

    [_player play];
}

@end

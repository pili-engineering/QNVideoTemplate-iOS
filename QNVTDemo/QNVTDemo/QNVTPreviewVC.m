//
//  QNVTVideoPlayerViewController.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/19.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTPreviewVC.h"

#import "QNVTOffsetButton.h"
#import "QNVTSlider.h"
#import "UIView+Util.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface QNVTPreviewVC ()

@property(nonatomic, copy) NSString* url;
@property(nonatomic, strong) AVPlayer* player;
@property(nonatomic, strong) AVPlayerLayer* playerLayer;
@property(nonatomic, strong) UIView* playerContainer;

@property(nonatomic, strong) QNVTOffsetButton* saveButton;
@property(nonatomic, strong) QNVTSlider* slider;
@property(nonatomic, assign) BOOL seeking;
@property(nonatomic, assign) BOOL saved;
@property(nonatomic, strong) UIButton* playButton;

@end

@implementation QNVTPreviewVC

- (instancetype)initWithUrl:(NSString*)url {
    if (self = [super init]) {
        self.url = url;
        self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:url]];
        [self.player setPreventsDisplaySleepDuringVideoPlayback:true];
        self.playerLayer = [[AVPlayerLayer alloc] init];
        [self.playerLayer setPlayer:self.player];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _saveButton = [QNVTOffsetButton buttonWithType:UIButtonTypeSystem];
    _saveButton.frame = CGRectMake(0, 0, 60, 30);
    _saveButton.offset = UIEdgeInsetsMake(0, 10, 0, -10);
    [_saveButton setBackgroundImage:[UIImage imageWithColor:QNVTCOLOR(1166ff) size:CGSizeMake(60, 30) radius:4] forState:UIControlStateNormal];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    self.navigationItem.rightBarButtonItem = item;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];

    self.playerContainer = [[UIView alloc] init];
    self.slider = [[QNVTSlider alloc] init];
    self.slider.slider.maximumValue = CMTimeGetSeconds(_player.currentItem.asset.duration);
    self.slider.rightLabel.text = [NSString stringWithFormat:@"%.1fs", self.slider.slider.maximumValue];
    [self.slider.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:_playerContainer];
    [self.view addSubview:_slider];
    [_playerContainer.layer addSublayer:self.playerLayer];
    [self.view disableChildViewTranslatesAutoresizingMaskIntoConstraints];

    [[_playerContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:38] setActive:YES];
    [[_playerContainer.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[_playerContainer.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];

    [[_slider.topAnchor constraintEqualToAnchor:_playerContainer.bottomAnchor constant:50] setActive:YES];
    [[_slider.heightAnchor constraintEqualToConstant:38] setActive:YES];
    [[_slider.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:22] setActive:YES];
    [[_slider.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-22] setActive:YES];
    [[_slider.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-40] setActive:YES];

    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerContainer addSubview:_playButton];

    W_SELF;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30)
                                          queue:NULL
                                     usingBlock:^(CMTime time) {
                                         S_SELF;
                                         if (sself && !sself.seeking) {
                                             sself.slider.slider.value = CMTimeGetSeconds(time);
                                         }
                                     }];
}

- (void)sliderValueChanged:(UISlider*)slider {
    _seeking = YES;
    [_player seekToTime:CMTimeMake(slider.value * 100, 100) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)sliderTouchUp:(UISlider*)slider {
    _seeking = NO;
}

- (void)playBtnClick:(UIButton*)sender {
    if (self.player.rate == 0) {
        [self.player play];
        [_playButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self.player pause];
        [_playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
}

- (void)saveBtnClick:(UIButton*)sender {
    if (_saved) {
        UIAlertController* sucessAlert = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"已保存到相册"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        [sucessAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:sucessAlert animated:YES completion:nil];
        return;
    }

    sender.enabled = NO;

    [[PHPhotoLibrary sharedPhotoLibrary]
        performChanges:^{ [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:self.url]]; }
        completionHandler:^(BOOL success, NSError* _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.saveButton.enabled = YES;
                self.saved = !error;
                UIAlertController* sucessAlert =
                    [UIAlertController alertControllerWithTitle:@""
                                                        message:(error ? [NSString stringWithFormat:@"%@\n%@", @"保存失败", error.description]
                                                                       : @"保存成功")preferredStyle:UIAlertControllerStyleAlert];
                [sucessAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:sucessAlert animated:YES completion:nil];
            });
        }];
}

- (void)playerItemDidPlayToEnd:(NSNotification*)notification {
    [self replay];
}

- (void)replay {
    if (!self.player) {
        return;
    }
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
    [self.playButton setImage:nil forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.player play];
    [self.playButton setImage:nil forState:UIControlStateNormal];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.playerLayer.frame = self.playerContainer.bounds;
    self.playButton.frame = self.playerContainer.bounds;
}

@end

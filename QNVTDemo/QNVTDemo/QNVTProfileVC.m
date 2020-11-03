//
//  QNVTEditVC.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/2.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTProfileVC.h"

#import "QNVTEditVC.h"
#import "QNVTOffsetButton.h"
#import "QNVTSlider.h"
#import "UIImage+Util.h"

#import <AVFoundation/AVFoundation.h>

@interface QNVTProfileVC ()

@property(nonatomic, strong) QNVTModel* model;
@property(nonatomic, strong) NSMutableArray<QNVTPropertyModel*>* properties;
@property(nonatomic, strong) QNVTAsset* asset;

@property(nonatomic, strong) UILabel* nameLabel;
@property(nonatomic, strong) UILabel* describeLabel;
@property(nonatomic, strong) UIView* playerContainer;
@property(nonatomic, strong) AVPlayerLayer* playerLayer;
@property(nonatomic, strong) AVPlayer* player;
@property(nonatomic, strong) QNVTSlider* slider;
@property(nonatomic, strong) UIButton* playButton;
@property(nonatomic, strong) UIButton* editButton;

@property(nonatomic, assign) BOOL seeking;

@end

@implementation QNVTProfileVC

- (instancetype)initWithModel:(QNVTModel*)model {
    if (self = [super init]) {
        _model = model;
        _properties = [NSMutableArray array];
        _playerLayer = [AVPlayerLayer layer];

        _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:[NSString pathWithComponents:@[ model.path, @"demo.mp4" ]]]];
        [_playerLayer setPlayer:_player];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"模板详情";
    [self setupUI];
    [self loadProperties];

    [_player play];
}

- (void)setupUI {
    QNVTOffsetButton* editBtn = [[QNVTOffsetButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    editBtn.enabled = NO;
    editBtn.offset = UIEdgeInsetsMake(0, 10, 0, -10);
    NSAttributedString* title = [[NSAttributedString alloc]
        initWithString:@"编辑"
            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [editBtn setAttributedTitle:title forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setBackgroundImage:[UIImage imageWithColor:QNVTCOLOR(1F66FF) size:CGSizeMake(60, 30) radius:4] forState:UIControlStateNormal];
    UIBarButtonItem* editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = editItem;
    self.editButton = editBtn;

    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:24];
    _nameLabel.textColor = UIColor.whiteColor;
    _nameLabel.text = _model.name;
    _describeLabel = [UILabel new];
    _describeLabel.font = [UIFont systemFontOfSize:14];
    _describeLabel.textColor = [UIColor whiteColor];
    _playerContainer = [UIView new];
    _slider = [[QNVTSlider alloc] init];
    self.slider.slider.maximumValue = CMTimeGetSeconds(_player.currentItem.asset.duration);
    self.slider.rightLabel.text = [NSString stringWithFormat:@"%.1fs", self.slider.slider.maximumValue];
    [self.slider.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchCancel];

    [self.view addSubview:_nameLabel];
    [self.view addSubview:_describeLabel];
    [self.view addSubview:_playerContainer];
    [self.view addSubview:_slider];

    [[_nameLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:28] setActive:YES];
    [[_nameLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:50] setActive:YES];
    [[_nameLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-50] setActive:YES];

    [[_describeLabel.topAnchor constraintEqualToAnchor:_nameLabel.bottomAnchor constant:10] setActive:YES];
    [[_describeLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:50] setActive:YES];
    [[_describeLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-50] setActive:YES];

    [[_playerContainer.topAnchor constraintEqualToAnchor:self.describeLabel.bottomAnchor constant:28] setActive:YES];
    [[_playerContainer.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[_playerContainer.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];

    [[_slider.topAnchor constraintEqualToAnchor:_playerContainer.bottomAnchor constant:38] setActive:YES];
    [[_slider.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:22] setActive:YES];
    [[_slider.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-22] setActive:YES];
    [[_slider.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-38] setActive:YES];
    [[_slider.heightAnchor constraintEqualToConstant:38] setActive:YES];

    [_playerContainer.layer addSublayer:_playerLayer];
    [self.view disableChildViewTranslatesAutoresizingMaskIntoConstraints];

    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerContainer addSubview:_playButton];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];

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

- (void)playBtnClick:(UIButton*)sender {
    if (self.player.rate == 0) {
        [self.player play];
        [_playButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self.player pause];
        [_playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
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
    [_playButton setImage:nil forState:UIControlStateNormal];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
    [_playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
}

- (void)sliderValueChanged:(UISlider*)slider {
    _seeking = YES;
    [_player seekToTime:CMTimeMake(slider.value * 100, 100) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)sliderTouchUp:(UISlider*)slider {
    _seeking = NO;
    [self.player play];
    [self.playButton setImage:nil forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _playerLayer.frame = _playerContainer.bounds;
    _playButton.frame = _playerContainer.bounds;
}

- (void)editBtnClick:(UIButton*)sender {
    QNVTEditVC* editvc = [[QNVTEditVC alloc] initWithAsset:_asset properties:_properties];
    [self.navigationController pushViewController:editvc animated:YES];
}

- (void)loadProperties {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        self.asset = [[QNVTAsset alloc] initWithPath:self.model.path];

        int textCount = 0, pictureCount = 0;
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        for (QNVTProperty* property in [self.asset getReplaceableProperties]) {
            if ([property.name hasPrefix:@"rpl_"]) {
                QNVTPropertyModel* model = [dic objectForKey:property.value.identifier];
                if (!model) {
                    model = [[QNVTPropertyModel alloc] init];
                    model.fps = self.asset.fps;
                    [self.properties addObject:model];
                    [dic setObject:model forKey:property.value.identifier];

                    if (property.type == QNVTPropertyTypeText) {
                        textCount += 1;
                    } else {
                        pictureCount += 1;
                    }
                }
                [model appendProperty:property];
            }
        }

        [self.properties sortUsingComparator:^NSComparisonResult(QNVTPropertyModel* _Nonnull obj1, QNVTPropertyModel* _Nonnull obj2) {
            return obj1.properties.firstObject.value.inPoint >= obj2.properties.firstObject.value.inPoint;
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* text = [NSString stringWithFormat:@"%d张图片/视频，%d段文字", pictureCount, textCount];
            if (self.asset.bgmPath.length > 0) {
                text = [text stringByAppendingString:@"，1段音频"];
            }
            self.describeLabel.text = text;
            self.editButton.enabled = YES;
        });
    });
}

@end

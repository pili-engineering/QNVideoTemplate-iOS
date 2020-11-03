//
//  QNVTViewController.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/4.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTEditVC.h"

#import "QNVTMusicCell.h"
#import "QNVTMusicModel.h"
#import "QNVTOffsetButton.h"
#import "QNVTPreviewVC.h"
#import "QNVTProgressView.h"
#import "QNVTPropertyCell.h"
#import "QNVTSlider.h"
#import "QNVTTextEditView.h"
#import "QNVTVertButton.h"
#import "TZImagePickerController.h"
#import "UIView+Util.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <PLShortVideoKit/PLSAVAssetExportSession.h>
#import <PLShortVideoKit/PLSEditSettings.h>
#import <QNVideoTemplate/QNVTPlayer.h>

static const int IMAGE_WIDTH_LIMIT = 1280;

@interface QNVTEditVC () <UIGestureRecognizerDelegate,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate,
                          TZImagePickerControllerDelegate>

@property(nonatomic, strong) NSArray<QNVTPropertyModel*>* properties;
@property(nonatomic, strong) NSMutableArray<QNVTMusicModel*>* musics;
@property(nonatomic, strong) QNVTMusicModel* selectedMusic;
@property(nonatomic, strong) NSIndexPath* selectedIndexPath;
@property(nonatomic, assign) NSInteger tabIndex;

@property(nonatomic, copy) NSString* videoPath;

@property(nonatomic, strong) QNVTPlayer* player;
@property(nonatomic, strong) QNVTAsset* asset;
@property(nonatomic, strong) QNVTMovieWriter* movieWriter;

@property(nonatomic, strong) QNVTPreview* preview;
@property(nonatomic, strong) QNVTSlider* slider;
@property(nonatomic, strong) UICollectionView* collectionView;
@property(nonatomic, strong) UICollectionView* musicCollectionView;
@property(nonatomic, strong) UIView* bottomBoxView;
@property(nonatomic, strong) QNVTVertButton* materialTab;
@property(nonatomic, strong) QNVTVertButton* musicTab;
@property(nonatomic, strong) UIButton* playButton;

@property(nonatomic, assign) BOOL seeking;
@property(nonatomic, assign) BOOL shouldAutoResume;

@end

@implementation QNVTEditVC

- (instancetype)initWithAsset:(QNVTAsset*)asset properties:(NSArray<QNVTPropertyModel*>*)properties {
    if (self = [super init]) {
        self.seeking = NO;
        self.asset = asset;
        self.properties = properties;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模板编辑";
    self.view.backgroundColor = QNVTCOLOR(232323);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [self setupPlayer]; // 比较耗时，异步加载
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setupUI];
            [self loadMusics];
            [self.player play];
            [self.playButton setImage:nil forState:UIControlStateNormal];
        });
    });
}

- (void)dealloc {
}

- (void)loadMusics {
    self.musics = [NSMutableArray array];

    QNVTMusicModel* model = [QNVTMusicModel new];
    model.name = @"默认";
    model.path = _asset.bgmPath;
    model.selected = YES;
    model.icon = [UIImage imageNamed:@"icon_music_default"];
    [self.musics addObject:model];
    self.selectedMusic = model;

    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [NSString pathWithComponents:@[ [bundle resourcePath], @"music" ]];
    NSArray* sorted = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]
        sortedArrayUsingDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:nil ascending:YES] ]];
    for (NSString* filename in sorted) {
        NSString* jsonPath = [NSString pathWithComponents:@[ path, filename, @"config.json" ]];
        NSData* data = [NSData dataWithContentsOfFile:jsonPath];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        QNVTMusicModel* model = [QNVTMusicModel new];
        model.name = dic[@"name"];
        model.path = [NSString pathWithComponents:@[ path, filename, dic[@"path"] ]];
        model.selected = NO;
        model.icon = [UIImage imageWithContentsOfFile:[NSString pathWithComponents:@[ path, filename, dic[@"icon"] ]]];
        [self.musics addObject:model];
    };

    [self.musicCollectionView reloadData];
}

- (void)setupPlayer {
    _player = [[QNVTPlayer alloc] initWithAsset:_asset dimension:CGSizeMake(1280, 1280) fps:0];
    __weak typeof(self) wself = self;
    [_player setStateObserver:^(QNVTPlayerState state) {
        if (state == QNVTPlayerStateStop) {
            [wself.player seek:0];
            [wself.player play];
        }
    }];
    [_player setProgressObserver:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!wself.seeking && wself.slider) {
                [wself.slider.slider setValue:progress];
            }
            wself.slider.leftLabel.text = [NSString stringWithFormat:@"%.1fs", progress];
        });
    }];
    [_player setPlayMode:QNVTPlayModeRealTime];
}

- (void)sliderValueChanged:(UISlider*)slider {
    _seeking = YES;
    [_player seek:slider.value];
}

- (void)sliderTouchUp:(UISlider*)slider {
    [_player play];
    [self.playButton setImage:nil forState:UIControlStateNormal];
    _seeking = NO;
}

- (void)setupUI {
    self.preview = self.player.preview;
    self.preview.backgroundColor = QNVTCOLOR(232323);
    [self.preview setBackgroundColorRed:0 green:0 blue:0 alpha:0];

    self.slider = [[QNVTSlider alloc] init];
    self.slider.backgroundColor = QNVTCOLOR(232323);
    self.slider.slider.maximumValue = self.asset.duration;
    self.slider.rightLabel.text = [NSString stringWithFormat:@"%.1fs", self.asset.duration];
    [self.slider.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventAllEvents];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider.slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchCancel];
    self.bottomBoxView = [[UIView alloc] init];
    self.bottomBoxView.backgroundColor = QNVTCOLOR(232323);
    [self.bottomBoxView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.bottomBoxView];
    self.view.backgroundColor = QNVTCOLOR(232323);

    [self.view addSubview:self.preview];

    [self setupCollectionView];

    QNVTOffsetButton* exportBtn = [[QNVTOffsetButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    exportBtn.offset = UIEdgeInsetsMake(0, 10, 0, -10);
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSAttributedString* title = [[NSAttributedString alloc] initWithString:@"导出" attributes:attributes];
    [exportBtn setAttributedTitle:title forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(exportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [exportBtn setBackgroundImage:[UIImage imageWithColor:QNVTCOLOR(3F66FF) size:CGSizeMake(60, 30) radius:4] forState:UIControlStateNormal];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:exportBtn];
    self.navigationItem.rightBarButtonItem = item;

    [[self.preview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.preview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.preview.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12] setActive:YES];
    [[self.preview.bottomAnchor constraintEqualToAnchor:self.slider.topAnchor constant:-5] setActive:YES];

    [[self.slider.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[self.slider.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[self.slider.heightAnchor constraintEqualToConstant:48] setActive:YES];

    [[self.collectionView.topAnchor constraintEqualToAnchor:self.slider.bottomAnchor constant:0] setActive:YES];
    [[self.collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0] setActive:YES];
    [[self.collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0] setActive:YES];
    [[self.collectionView.heightAnchor constraintEqualToConstant:156] setActive:YES];

    [[self.collectionView.topAnchor constraintEqualToAnchor:self.musicCollectionView.topAnchor constant:0] setActive:YES];
    [[self.collectionView.leftAnchor constraintEqualToAnchor:self.musicCollectionView.leftAnchor constant:0] setActive:YES];
    [[self.collectionView.rightAnchor constraintEqualToAnchor:self.musicCollectionView.rightAnchor constant:0] setActive:YES];
    [[self.collectionView.bottomAnchor constraintEqualToAnchor:self.musicCollectionView.bottomAnchor] setActive:YES];

    [[self.bottomBoxView.topAnchor constraintEqualToAnchor:self.collectionView.bottomAnchor] setActive:YES];
    [[self.bottomBoxView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[self.bottomBoxView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[self.bottomBoxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[self.bottomBoxView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-56] setActive:YES];

    NSDictionary* selectedAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:8], NSForegroundColorAttributeName : QNVTCOLOR(1f66ff)};
    _materialTab = [[QNVTVertButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 2.0, 56)];
    _materialTab.selected = YES;
    [_materialTab setTitle:@"素材编辑" forState:UIControlStateNormal];
    NSAttributedString* selectedTitle = [[NSAttributedString alloc] initWithString:@"素材编辑" attributes:selectedAttr];
    [_materialTab setAttributedTitle:selectedTitle forState:UIControlStateSelected];
    [_materialTab setImage:[UIImage imageNamed:@"icon_material_edit_nor"] forState:UIControlStateNormal];
    [_materialTab setImage:[UIImage imageNamed:@"icon_material_edit_sel"] forState:UIControlStateSelected];
    [_materialTab addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchUpInside];

    _musicTab = [[QNVTVertButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2.0, 0, SCREENWIDTH / 2.0, 56)];
    [_musicTab setTitle:@"音乐编辑" forState:UIControlStateNormal];
    selectedTitle = [[NSAttributedString alloc] initWithString:@"音乐编辑" attributes:selectedAttr];
    [_musicTab setAttributedTitle:selectedTitle forState:UIControlStateSelected];
    [_musicTab setImage:[UIImage imageNamed:@"icon_music_edit_nor"] forState:UIControlStateNormal];
    [_musicTab setImage:[UIImage imageNamed:@"icon_music_edit_sel"] forState:UIControlStateSelected];
    [_musicTab addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchUpInside];

    [_bottomBoxView addSubview:_materialTab];
    [_bottomBoxView addSubview:_musicTab];

    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview addSubview:_playButton];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout* flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(76, 150);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100) collectionViewLayout:flowlayout];
    [_collectionView registerClass:[QNVTPropertyCell class] forCellWithReuseIdentifier:@"QNVTPropertyCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 0);
    [self.view addSubview:_collectionView];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];

    flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(90, 150);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 0;
    _musicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)
                                              collectionViewLayout:flowlayout];
    [_musicCollectionView registerClass:[QNVTMusicCell class] forCellWithReuseIdentifier:@"QNVTMusicCell"];
    _musicCollectionView.delegate = self;
    _musicCollectionView.dataSource = self;
    _musicCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 0);
    _musicCollectionView.hidden = YES;
    [self.view addSubview:_musicCollectionView];
    [_musicCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _playButton.frame = _preview.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_shouldAutoResume) {
        [_player resume];
        [_playButton setImage:nil forState:UIControlStateNormal];
    }
    _shouldAutoResume = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
}

- (void)tabClick:(QNVTVertButton*)sender {
    if (sender == _materialTab) {
        if (!_materialTab.selected) {
            _materialTab.selected = YES;
            _musicTab.selected = NO;
            _collectionView.hidden = NO;
            _musicCollectionView.hidden = YES;
        }
    } else if (sender == _musicTab) {
        if (!_musicTab.selected) {
            _materialTab.selected = NO;
            _musicTab.selected = YES;

            _collectionView.hidden = YES;
            _musicCollectionView.hidden = NO;
        }
    }
}

- (void)playBtnClick:(UIButton*)sender {
    if (self.player.state != QNVTPlayerStatePlaying) {
        [self.player play];
        [_playButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self.player pause];
        [_playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
}

- (void)pickPhoto {
    QNVTPropertyModel* selectedModel = _properties[_selectedIndexPath.row];
    if (!selectedModel || selectedModel.properties.firstObject.type == QNVTPropertyTypeText) {
        return;
    }

    NSInteger margin = 40;
    NSInteger width = SCREENWIDTH - margin;
    NSInteger height = 1.0 * width / selectedModel.width * selectedModel.height;

    TZImagePickerController* picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self];
    picker.allowTakePicture = NO;
    picker.allowTakeVideo = NO;
    picker.naviBgColor = UIColor.blackColor;
    picker.showSelectBtn = NO;
    picker.allowCrop = YES;
    picker.cropRect = CGRectMake(margin / 2, (SCREENHEIGHT - height) / 2.0, width, height);
    picker.scaleAspectFillCrop = YES;
    picker.allowPickingOriginalPhoto = NO;
    picker.userInfo = selectedModel;
    picker.photoPreviewMaxWidth = IMAGE_WIDTH_LIMIT;
    picker.photoWidth = IMAGE_WIDTH_LIMIT;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)exportWithSetting:(QNVTVideoSetting*)setting completion:(void (^)(void))completion {
    [self.movieWriter setVideoSetting:setting];

    QNVTProgressView* progressView = [[QNVTProgressView alloc] init];
    [progressView showInView:[UIApplication sharedApplication].keyWindow];

    [self.movieWriter startWithCallback:^(double progress, bool complete, bool success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.title = [NSString stringWithFormat:@"正在生成%d%%", (int)(progress * 100)];
            if (complete) {
                completion();
                [progressView hid];

                if (!success) {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:@"视频导出失败"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:^{ [self.player resume]; }];
                } else {
                    QNVTPreviewVC* vc = [[QNVTPreviewVC alloc] initWithUrl:self->_videoPath];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        });
    }];
}

- (void)exportBtnClick:(UIButton*)sender {
    if (!_movieWriter) {
        NSString* cache = NSTemporaryDirectory();
        cache = [NSString pathWithComponents:@[ cache, @"tmp_video.mov" ]];
        _videoPath = cache;
        _movieWriter = [[QNVTMovieWriter alloc] initWithAsset:self.asset videoSetting:nil];
    }

    UIView* maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    [self.view addSubview:maskview];
    [self.player pause];

    [self getVideoSetting:^(QNVTVideoSetting* setting) {
        if (!setting) {
            [maskview removeFromSuperview];
            [self.player resume];
            return;
        }

        if (setting.dimension.width > 2048 || setting.dimension.height > 2048) {
            if (setting.dimension.width > 4096 || setting.dimension.height > 4096) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"分辨率超出硬件限制！！！！"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];

                [self.player resume];
                return;
            }

            setting.enableHWAccel = YES;

            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"设置分辨率过大，将启用硬编！"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction* _Nonnull action) {
                                                        [self exportWithSetting:setting completion:^{ [maskview removeFromSuperview]; }];
                                                    }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self exportWithSetting:setting completion:^{ [maskview removeFromSuperview]; }];
        }
    }];
}

- (void)getVideoSetting:(void (^)(QNVTVideoSetting*))completion {
    __block UITextField *widthField, *heightField, *bitrateField;
    UIAlertController* configAlert =
        [UIAlertController alertControllerWithTitle:@""
                                            message:@"输入配置信息,使用默认配置请留空\n导出视频的尺寸将会按比例缩放至设置的长宽之内"
                                     preferredStyle:UIAlertControllerStyleAlert];
    [configAlert addTextFieldWithConfigurationHandler:^(UITextField* _Nonnull textField) {
        textField.placeholder = @"width limit, default value 720";
        widthField = textField;
    }];
    [configAlert addTextFieldWithConfigurationHandler:^(UITextField* _Nonnull textField) {
        textField.placeholder = @"height limit, default value 1280";
        heightField = textField;
    }];
    [configAlert addTextFieldWithConfigurationHandler:^(UITextField* _Nonnull textField) {
        textField.placeholder = @"bitrate, default value width*height";
        bitrateField = textField;
    }];

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction* _Nonnull action) { //
                                                       completion(nil);
                                                   }];
    [configAlert addAction:cancel];
    [configAlert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction* _Nonnull action) {
                                                      int width = [widthField.text intValue];
                                                      int height = [heightField.text intValue];
                                                      int bitrate = [bitrateField.text intValue];

                                                      QNVTVideoSetting* setting = [QNVTVideoSetting new];
                                                      setting.outputPath = self.videoPath;
                                                      if (width > 0 && height > 0) {
                                                          setting.dimension = CGSizeMake(width, height);
                                                      }
                                                      if (bitrate > 0) {
                                                          setting.bitrate = bitrate;
                                                      }

                                                      completion(setting);
                                                  }]];
    [self presentViewController:configAlert animated:YES completion:nil];
}

#pragma mark - picker delegate

- (void)imagePickerController:(TZImagePickerController*)picker
       didFinishPickingPhotos:(NSArray<UIImage*>*)photos
                 sourceAssets:(NSArray*)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    QNVTPropertyModel* selectedModel = _properties[_selectedIndexPath.row];
    if (!selectedModel || selectedModel.properties.firstObject.type == QNVTPropertyTypeText) {
        return;
    }

    NSString* path = NSTemporaryDirectory();
    path = [NSString pathWithComponents:@[ path, [NSString stringWithFormat:@"%010lld.png", (int64_t)CFAbsoluteTimeGetCurrent()] ]];
    UIImage* image = photos.firstObject;
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:NO];

    selectedModel.thumbnail = [UIImage downSampleWithPath:path maxLength:150];
    for (QNVTProperty* property in selectedModel.properties) {
        QNVTImageValue* value = [QNVTImageValue new];
        value.imagePath = path;

        property.type = QNVTPropertyTypeImage;
        property.value = value;
        [self.player setProperty:property];
    }
    [_collectionView reloadItemsAtIndexPaths:@[ _selectedIndexPath ]];
}

- (void)imagePickerController:(TZImagePickerController*)picker
        didFinishPickingVideo:(UIImage*)coverImage
                 sourceAssets:(PHAsset*)asset
                  composition:(AVMutableComposition*)compo {
    QNVTPropertyModel* selectedModel = _properties[_selectedIndexPath.row];
    if (!selectedModel || selectedModel.properties.firstObject.type == QNVTPropertyTypeText) {
        return;
    }

    _shouldAutoResume = NO;
    QNVTProgressView* progressView = [[QNVTProgressView alloc] init];
    [progressView showInView:[UIApplication sharedApplication].keyWindow];

    CGSize videosize = compo.naturalSize;
    static const CGSize limit = {IMAGE_WIDTH_LIMIT, IMAGE_WIDTH_LIMIT};
    if (videosize.width > limit.width || videosize.height > limit.height) {
        float wratio = limit.width / videosize.width;
        float hratio = limit.height / videosize.height;
        float ratio = wratio < hratio ? wratio : hratio;

        videosize = CGSizeMake(ceil(videosize.width * ratio), ceil(videosize.height * ratio));
        videosize.width = ((int)videosize.width) & (~1);
        videosize.height = ((int)videosize.height) & (~1);
    }

    NSDictionary* videoSettings = @{PLSMovieSettingsKey : @{PLSDurationKey : @(CMTimeGetSeconds(compo.duration))}};

    PLSAVAssetExportSession* exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:compo];
    exportSession.outputFileType = PLSFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = NO;
    exportSession.bitrate = videosize.width * videosize.height * 2.0;
    exportSession.gopSize = 10; //较小的gopsize有利于seek的流畅度
    exportSession.outputSettings = videoSettings;

    // 设置视频的导出分辨率，会将原视频缩放
    exportSession.outputVideoSize = videosize;

    __weak typeof(self) weakSelf = self;

    [exportSession setCompletionBlock:^(NSURL* url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf replaceVideo:url.path];
            [progressView hid];
            [weakSelf.player play];
            [weakSelf.playButton setImage:nil forState:UIControlStateNormal];
        });
    }];

    [exportSession setFailureBlock:^(NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"warning"
                                                                           message:@"导出视频失败！"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction* _Nonnull action) {
                                                        [weakSelf.player play];
                                                        [weakSelf.playButton setImage:nil forState:UIControlStateNormal];
                                                        weakSelf.shouldAutoResume = YES;
                                                    }]];
            [progressView hid];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        });
    }];

    [exportSession setProcessingBlock:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{ progressView.title = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)]; });
    }];

    [exportSession exportAsynchronously];
}

- (void)replaceVideo:(NSString*)url {
    QNVTPropertyModel* selectedModel = _properties[_selectedIndexPath.row];
    if (!selectedModel || selectedModel.properties.firstObject.type == QNVTPropertyTypeText) {
        return;
    }

    selectedModel.thumbnail = [UIImage getVideoPreViewImage:url maxLength:150];
    for (QNVTProperty* property in selectedModel.properties) {
        QNVTVideoValue* value = [QNVTVideoValue new];
        value.videoPath = url;

        property.type = QNVTPropertyTypeVideo;
        property.value = value;
        [self.player setProperty:property];
    }
    [_collectionView reloadItemsAtIndexPaths:@[ _selectedIndexPath ]];
}

#pragma mark - collectionview delegate

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _collectionView) {
        return _properties.count;
    }

    if (collectionView == _musicCollectionView) {
        return _musics.count;
    }

    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    if (collectionView == _collectionView) {
        QNVTPropertyCell* cell = (QNVTPropertyCell*)[_collectionView dequeueReusableCellWithReuseIdentifier:@"QNVTPropertyCell"
                                                                                               forIndexPath:indexPath];
        cell.model = _properties[indexPath.row];
        return cell;
    }

    if (collectionView == _musicCollectionView) {
        QNVTMusicCell* cell = (QNVTMusicCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"QNVTMusicCell" forIndexPath:indexPath];
        cell.model = _musics[indexPath.row];
        return cell;
    }

    return [UICollectionViewCell new];
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
    QNVTPropertyModel* model = _properties[indexPath.row];
    if (collectionView == _collectionView) {
        [_player pause];
        _selectedIndexPath = indexPath;
        if (model.properties.firstObject.type == QNVTPropertyTypeText) {
            QNVTTextEditView* editView = [[QNVTTextEditView alloc] init];
            editView.didEndEditBlock = ^(NSString* _Nonnull text) {
                QNVTTextValue* value = [QNVTTextValue new];
                value.text = text;
                for (QNVTProperty* property in model.properties) {
                    property.type = QNVTPropertyTypeText;
                    property.value = value;
                    [self.player setProperty:property];
                }
                [collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
                [self.player play];
            };
            [editView showInView:[UIApplication sharedApplication].keyWindow];
        } else {
            [self pickPhoto];
        }
        return;
    }

    if (collectionView == _musicCollectionView) {
        _selectedMusic.selected = NO;
        QNVTMusicModel* model = _musics[indexPath.row];
        model.selected = YES;
        _selectedMusic = model;
        [_musicCollectionView reloadData];

        [_player setBgm:model.path];
        return;
    }
}

@end

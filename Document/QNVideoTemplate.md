<a id="1"></a>
# 1 概述

QNVideoTemplate 是七牛推出的一款短视频视频模板SDK，可帮助开发者快速实现类似抖音的影集、剪映的剪同款功能。该SDK支持iOS和Android端，并且具有炫酷的视频模板供开发者参考使用。同时，该SDK允许定制个性化模板，以便给开发者及终端用户提供更多创作支持。

</br>

<a id="1.1"></a>
## 1.1 下载地址
- [iOS Demo 以及 SDK 下载地址](https://github.com/pili-engineering/QNVideoTemplate-iOS)

</br>

<a id="2"></a>
# 2 阅读对象

本文档为技术文档，需要阅读者

- 具有基本的 iOS 开发能力
- 准备接入七牛模板视频

</br>

<a id="3"></a>
# 3 总体设计


<a id="3.1"></a>
## 3.1 基本规则

为了方便理解和使用，对于 SDK 的接口设计，我们遵循了如下的原则：

- 每个接口类，均以 `QNVT` 开头
- 回调以 block 方式实现


<a id="3.2"></a>
## 3.2 核心接口

核心接口类说明如下：

|类名 |功能 |备注 |
|-|-|-|
|QNVTAsset |代表视频模板资源的类，保存模板的信息和属性 |此类中的属性为只读，不可直接修改 |
|QNVTPlayer |负责视频模板播放，实时渲染展示模板内容，并可替换模板中的图片、视频、文字、背景音乐等属性 |内部会使用 OpenGL 进行渲染，进入后台请暂停，否则有可能造成crash |
|QNVTMovieWriter |负责将模板导出为视频 |内部会使用 OpenGL 进行渲染，进入后台请暂停，否则有可能造成crash |

</br>

<a id="4"></a>
# 4 开发准备


<a id="4.1"></a>
## 4.1 设备及系统要求
- 设备要求： iPhone 6 及以上机型
- 系统要求： iOS 12 及以上系统  
  

<a id="4.2"></a>
## 4.2 开发环境配置

- Xcode 开发工具。App Store [下载地址](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)
- 安装 CocoaPods。[了解 CocoaPods 使用方法](https://cocoapods.org/)
  >[CocoaPods](https://cocoapods.org/) 是针对 objc 的依赖管理工具，它能够将使用类似 QNVideoTemplate 的第三方库的安装过程变得非常简单和自动化，你能够用下面的命令来安装它：
  >```bash
  >$ sudo gem install cocoapods
  >```


<a id="4.3"></a>
## 4.3 导入 SDK

视频的替换需要裁减、转码等前处理，这里推荐使用七牛推出的短视频SDK [PLShortVideoKit](https://github.com/pili-engineering/PLShortVideoKit)

### Podfile

为了使用 CoacoaPods 集成 QNVideoTemplate 到你的 Xcode 工程当中，你需要编写你的 `Podfile`

```ruby
target 'TargetName' do
pod 'QNVideoTemplate'
pod 'PLShortVideoKit'
end
```

<a id="4.4"></a>
## 4.4 添加权限说明
我们需要在 Info.plist 文件中添加相应权限的说明，否则程序将会出现崩溃。需要添加如下权限：

- 相册权限:&emsp;&emsp; Privacy - Photo Library Usage Description &emsp;&emsp; 是否允许 App 访问媒体资料库

</br>

<a id="5"></a>
# 5 快速开始

### 设置鉴权文件路径
鉴权必须在调用其他接口之前
``` objc
#import <QNVideoTemplate/QNVTCommon.h>

NSString* path = [[NSBundle mainBundle] pathForResource:@"qnvt" ofType:@"license"];
QNVTSetLicensePath([path UTF8String]);
```
### 创建 QNVTAsset 对象
模板解析比较耗时，这里推荐使用 GCD 异步创建
``` objc
dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
    self.asset = [[QNVTAsset alloc] initWithPath:self.model.path];
}
```
### 创建播放器 
比较耗时，推荐异步创建
``` objc
dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{

    self.player = [[QNVTPlayer alloc] initWithAsset:self.asset dimension:CGSizeMake(1280, 1280) fps:0];

    __weak typeof(self) wself = self;
    [self.player setStateObserver:^(QNVTPlayerState state) {
        // 循环播放
        if (state == QNVTPlayerStateStop) {
            [wself.player seek:0];
            [wself.player play];
        }
    }];

    [self.player setProgressObserver:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 显示进度条，防止拖动进度条造成冲突，增加 seeking 标识
            if (!wself.seeking && wself.slider) {
                [wself.slider.slider setValue:progress];
            }
            wself.slider.leftLabel.text = [NSString stringWithFormat:@"%.1fs", progress];
        });
    }];

    [self.player setPlayMode:QNVTPlayModeRealTime];

    // 主线程更新 UI
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.player.preview.backgroundColor = QNVTCOLOR(232323);
        [self.player.preview setBackgroundColorRed:0 green:0 blue:0 alpha:0];
        self.player.preview.frame = self.view.bouds;
        [self.view addSubview: self.player.preview];
    });
}
```
### 替换资源
``` objc
// 这里的 property 使用 player 或 asset 接口中返回的 property， 不要自行创建，有可能丢失 pid 等关键信息
// 文字属性只能替换 textValue, 视频图片属性可相互替换
QNVTImageValue* value = [QNVTImageValue new];
value.imagePath = path;
property.type = QNVTPropertyTypeImage;
property.value = value;

[self.player setProperty:property];
```
### 导出视频
```objc
QNVTMovieWriter* movieWriter = [[QNVTMovieWriter alloc] initWithAsset:self.asset videoSetting:nil];

QNVTVideoSetting* setting = [QNVTVideoSetting new];
[movieWriter setVideoSetting:setting];

[movieWriter startWithCallback:^(double progress, bool complete, bool success) {
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.title = [NSString stringWithFormat:@"正在生成%d%%", (int)(progress * 100)];
        if (complete) {
            [progressView hid];
            if (!success) {
                // ...
            } else {
                // ...
            }
        }
    });
}];
```

</br>

<a id="6"></a>
# 6 最佳实践

- 播放器以及导出的FPS若无特殊要求建议设为 0，使用模板中预置的FPS
- 导出视频软编同等码率下效果更好，硬编效率更高内存消耗更少，可根据需要设定，导出 2k 以上视频建议使用硬编
- 替换的图片分辨率应裁剪到尽量小，可以加快渲染速度
- 替换的视频应提前转码，分辨率尽量小，GOP size 尽量小（推荐 10 以内），可以加快渲染速度，GOP size 对于预览拖动的流畅度至关重要
- 替换的背景音乐应使用 AAC 编码的音频，非 AAC 编码（例如 MP3）有可能造成导出的视频无法在微信中分享

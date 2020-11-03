//
//  QNVTPlayer.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/16.
//  Copyright © 2020 李政勇. All rights reserved.
//

#import "QNVTAsset.h"
#import "QNVTContext.h"
#import "QNVTFrameBuffer.h"
#import "QNVTPreview.h"
#import "QNVTProperty.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, QNVTPlayerState)
{
    QNVTPlayerStateStop,
    QNVTPlayerStatePlaying,
    QNVTPlayerStatePause
};

typedef NS_ENUM(int, QNVTPlayMode)
{
    QNVTPlayModeRealTime,
    QNVTPlayModeFrameAdvance
};

/*!
 @class QNVTPlayer
 @abstract 模板播放器，实时渲染播放模板文件
 */
@interface QNVTPlayer : NSObject

typedef void (^StateObserver)(QNVTPlayerState);
typedef void (^ProgressObserver)(double);

/*!
 @property preview
 @brief 预览视图

 @since v1.0.0
 */
@property(nonatomic, strong, readonly) QNVTPreview* preview;

/*!
 @property state
 @brief 播放器的当前状态

 @since v1.0.0
 */
@property(nonatomic, assign, readonly) QNVTPlayerState state;

/*!
 @method init NS_UNAVAILABLE
 @abstract 禁用默认初始化函数

 @since v1.0.0
 */
- (instancetype)init NS_UNAVAILABLE;

/*!
 @method initWithAsset:dimension:fps:
 @abstract 初始化函数

 @param asset 播放的模板文件
 @param dimensionLimit 预览的分辨率大小限制
 @param fps 预览的fps，这里建议设为 0，使用模板中预置的分辨率

 @since v1.0.0
 */
- (instancetype)initWithAsset:(QNVTAsset*)asset dimension:(CGSize)dimensionLimit fps:(float)fps NS_DESIGNATED_INITIALIZER;

/*!
 @method play
 @abstract 开始播放

 @since v1.0.0
 */
- (void)play;

/*!
 @method pause
 @abstract 暂停播放

 @since v1.0.0
 */
- (void)pause;

/*!
 @method resume
 @abstract 恢复播放

 @since v1.0.0
 */
- (void)resume;

/*!
 @method stop
 @abstract 停止播放

 @since v1.0.0
 */
- (void)stop;

/*!
 @method seek:
 @abstract 跳转到指定时间

 @param time 要跳转的时刻，单位：秒

 @since v1.0.0
 */
- (void)seek:(double)time;

/*!
 @method currentAsset
 @abstract 当前播放的模板文件

 @since v1.0.0
 */
- (QNVTAsset*)currentAsset;

/*!
 @method replaceCurrentAsset:
 @abstract 替换播放器当前的模板文件

 @param asset 新的模板文件

 @since v1.0.0
 */
- (void)replaceCurrentAsset:(QNVTAsset*)asset;

/*!
 @method setBackgroudColor:
 @abstract 设置播放器背景颜色

 @param bgcolor 背景颜色

 @since v1.0.0
 */
- (void)setBackgroudColor:(QNVTColor)bgcolor;

/*!
 @method setStateObserver:
 @abstract 设置状态观察者，状态改变时会回调

 @param observer 状态观察者

 @since v1.0.0
 */
- (void)setStateObserver:(StateObserver)observer;

/*!
 @method setProgressObserver:
 @abstract 设置播放进度观察者

 @param observer 进度观察者

 @since v1.0.0
 */
- (void)setProgressObserver:(ProgressObserver)observer;

/*!
 @method setPlayMode:
 @abstract 设置播放的模式

 @param mode 播放模式

 @discussion 当播放模式为 realtime 时，播放器会按照真实的时间渲染播放模板，若模板比较耗性能，单帧渲染时间比较长，将会出现跳帧的情况；播放模式为 frame
 advance 时，播放器将会逐帧渲染模板文件，有可能出现音画不同步现象

 @since v1.0.0
 */
- (void)setPlayMode:(QNVTPlayMode)mode;

/*!
 @method setBgm:
 @abstract 设置模板的背景音乐

 @param path 背景音乐的绝对路径

 @discussion SDK内部仅会将音视频流合并，并不会对音频文件进行转码，背景音乐最好为aac编码，安卓版微信在 7.0 之后不再识别音频流为非 aac
 的视频文件，在安卓上使用非 aac 编码的音频文件将可能造成无法在微信中分享

 @since v1.0.0
 */
- (void)setBgm:(NSString*)path;

/*!
 @method getReplaceableProperties
 @abstract 获取当前模板文件中可替换的图片、视频、文字等属性

 @since v1.0.0
 */
- (NSArray<QNVTProperty*>*)getReplaceableProperties;

/*!
 @method setProperty:
 @abstract 修改属性

 @param pid 属性id

 @since v1.0.0
 */
- (void)setProperty:(QNVTProperty*)pid;

/*!
 @method resetProperty:
 @abstract 恢复默认属性

 @param pid 属性id

 @since v1.0.0
 */
- (void)resetProperty:(int)pid;

/*!
 @method resetAllProperty
 @abstract 恢复所有默认属性

 @since v1.0.0
 */
- (void)resetAllProperty;

@end

NS_ASSUME_NONNULL_END

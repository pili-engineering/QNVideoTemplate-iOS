//
//  QNVTMovieWriter.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/16.
//  Copyright © 2020 李政勇. All rights reserved.
//

#import "QNVTAsset.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class QNVTVideoSetting
 @abstract 导出视频的选项
 */
@interface QNVTVideoSetting : NSObject

/*!
 @property outputPath
 @brief 视频保存的绝对路径

 @since v1.0.0
 */
@property(nonatomic, copy) NSString* outputPath;

/*!
 @property dimension
 @brief 导出视频的尺寸，这里必须是偶数，传入奇数会在导出时强制转换为偶数

 @since v1.0.0
 */
@property(nonatomic, assign) CGSize dimension;

/*!
 @property dimensionExact
 @brief 导出视频的尺寸是否严格按照设置的 dimension，若为 YES，导出视频的尺寸为设定的 dimension，将会用 background color 填充剩余部分，若为
 NO，将会将画面按照实际比例限制到 dimension 内。

 @since v1.0.0
 */
@property(nonatomic, assign) BOOL dimensionExact;

/*!
 @property enableHWAccel
 @brief 是否开启视频编码硬件加速，实测软编同码率下效果要好于硬编，硬编的性能和内存消耗优于软编，可根据实际需要设置

 @since v1.0.0
 */
@property(nonatomic, assign) BOOL enableHWAccel;

/*!
 @property backgourdColor
 @brief 背景颜色，模板比例和设置的 dimension 比例不一致时用来填充空白区域

 @since v1.0.0
 */
@property(nonatomic, assign) QNVTColor backgourdColor;

/*!
 @property bitrate
 @brief 编码的比特率，单位：bit，设为 0 将会使用 width * height，更高的比特率将会有更好的画面质量

 @since v1.0.0
 */
@property(nonatomic, assign) int64_t bitrate;

@end

/*!
 @class QNVTMovieWriter
 @abstract 将模板导出为视频的类
 */
@interface QNVTMovieWriter : NSObject

/*!
 @property videoSetting
 @brief 视频参数

 @since v1.0.0
 */
@property(nonatomic, strong) QNVTVideoSetting* videoSetting;

typedef void (^Callback)(double progress, bool complete, bool success);

/*!
 @method initWithAsset:videoSetting:
 @abstract 初始化函数

 @param asset 将要导出的模板文件
 @param setting 视频参数

 @since v1.0.0
 */
- (instancetype)initWithAsset:(QNVTAsset*)asset videoSetting:(QNVTVideoSetting* _Nullable)setting;

/*!
 @method startWithCallback:
 @abstract 开始导出

 @param callback 进度回调

 @since v1.0.0
 */
- (void)startWithCallback:(Callback)callback;

/*!
 @method stop
 @abstract 停止导出

 @since v1.0.0
 */
- (void)stop;

/*!
 @method pause
 @abstract 暂停导出

 @since v1.0.0
 */
- (void)pause;

/*!
 @method resume
 @abstract 恢复导出

 @since v1.0.0
 */
- (void)resume;

@end

NS_ASSUME_NONNULL_END

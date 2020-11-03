//
//  QNVTAsset.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/16.
//  Copyright © 2020 李政勇. All rights reserved.
//

#import "QNVTProperty.h"

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    float red;
    float green;
    float blue;
    float alpha;
} QNVTColor;

/*!
 @class QNVTAsset
 @abstract 代表模板文件的类，包含了模板的一些属性
 */
@interface QNVTAsset : NSObject

/*!
 @property size
 @brief 模板的尺寸

 @since v1.0.0
 */
@property(nonatomic, readonly, assign) CGSize size;

/*!
 @property duration
 @brief 模板长度，单位：秒

 @since v1.0.0
 */
@property(nonatomic, readonly, assign) double duration;

/*!
 @property fps
 @brief 模板中预设的帧率

 @since v1.0.0
 */
@property(nonatomic, readonly, assign) double fps;

/*!
 @property bgmPath
 @brief 模板中的背景音乐

 @since v1.0.0
 */
@property(nonatomic, readonly, strong) NSString* bgmPath;

/*!
 @method initWithPath:
 @abstract 初始化一个Asset

 @param rootPath 模板文件包的路径

 @since v1.0.0
 */
- (instancetype)initWithPath:(NSString*)rootPath;

/*!
 @method getReplaceableProperties
 @abstract 模板中可替换的属性

 @since v1.0.0
 */
- (NSArray<QNVTProperty*>*)getReplaceableProperties;

@end

NS_ASSUME_NONNULL_END

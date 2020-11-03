//
//  QNVTPreview.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/16.
//  Copyright © 2020 李政勇. All rights reserved.
//

#import "QNVTContext.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

typedef NS_ENUM(NSUInteger, QNVTFillMode)
{
    kQNVTFillModeStretch,
    kQNVTFillModePreserveAspectRatio,
    kQNVTFillModePreserveAspectRatioAndFill
};

typedef NS_ENUM(NSUInteger, QNVTRotationMode)
{
    kQNVTRotationNormal,
    kQNVTRotationLeft,
    kQNVTRotationRight,
    kQNVTRotationFlipVertical,
    kQNVTRotationFlipHorizonal,
    kQNVTRotationRightFlipVertical,
    kQNVTRotationRightFlipHorizontal,
    kQNVTRotation180
};

#pragma mark -

/*!
 @class QNVTPreview
 @abstract 播放器预览视图
 */
@interface QNVTPreview : UIView

/*!
 @property context
 @brief .

 @since v1.0.0
 */
@property(nonatomic, strong, readonly) QNVTContext* context;

/*!
 @property fillMode
 @brief 填充模式

 @since v1.0.0
 */
@property(nonatomic, assign) QNVTFillMode fillMode;

/*!
 @property rotationMode
 @brief 旋转

 @since v1.0.0
 */
@property(nonatomic, assign) QNVTRotationMode rotationMode;

/*!
 @property sizeInPixels
 @brief 图像大小

 @since v1.0.0
 */
@property(nonatomic, assign, readonly) CGSize sizeInPixels;

/*!
 @method setBackgroundColorRed:green:blue:alpha:
 @abstract 设置背景颜色

 @param redComponent 红，0.0 ~ 1.0
 @param greenComponent 绿，0.0 ~ 1.0
 @param blueComponent 蓝，0.0 ~ 1.0
 @param alphaComponent 透明度，0.0 ~ 1.0

 @since v1.0.0
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

@end

NS_ASSUME_NONNULL_END

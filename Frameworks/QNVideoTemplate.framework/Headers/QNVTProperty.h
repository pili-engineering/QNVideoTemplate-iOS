//
//  QNVTProperty.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/16.
//  Copyright © 2020 李政勇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class QNVTPropertyValueBase
 @abstract 模板中的属性值基类
 */
@interface QNVTPropertyValue : NSObject

/*!
 @property inPoint
 @brief 当前属性在模板中的开始帧数，要转换成秒需要乘以模板中的fps

 @since v1.0.0
 */
@property(nonatomic, assign, readonly) float inPoint;

/*!
 @property outPoint
 @brief 当前属性在模板中的结束帧数，要转换成秒需要乘以模板中的fps

 @since v1.0.0
 */
@property(nonatomic, assign, readonly) float outPoint;

/*!
 @property identifier
 @brief 当前属性的标识符，文字属性为文字的内容，多媒体属性为多媒体文件的路径

 @since v1.0.0
 */
@property(nonatomic, copy, readonly) NSString* identifier;

@end

/*!
 @class QNVTMediaValueBase
 @abstract 多媒体属性值基类
 */
@interface QNVTMediaValueBase : QNVTPropertyValue

/*!
 @property width
 @brief 当前属性宽度

 @since v1.0.0
 */
@property(nonatomic, assign, readonly) int width;

/*!
 @property height
 @brief 当前属性高度

 @since v1.0.0
 */
@property(nonatomic, assign, readonly) int height;

@end

/*!
 @class QNVTTextValue
 @abstract 文字属性值
 */
@interface QNVTTextValue : QNVTPropertyValue

/*!
 @property text
 @brief 文字内容

 @since v1.0.0
 */
@property(nonatomic, copy) NSString* text;
@end

/*!
 @class QNVTImageValue
 @abstract 图片属性值
 */
@interface QNVTImageValue : QNVTMediaValueBase

/*!
 @property imagePath
 @brief 图片路径

 @since v1.0.0
 */
@property(nonatomic, copy) NSString* imagePath;
@end

/*!
 @class QNVTVideoValue
 @abstract 视频属性值
 */
@interface QNVTVideoValue : QNVTMediaValueBase

/*!
 @property videoPath
 @brief 视频路径

 @since v1.0.0
 */
@property(nonatomic, copy) NSString* videoPath;
@end

/*!
 @class QNVTProperty
 @abstract 模板中可替换的属性
 */
@interface QNVTProperty : NSObject

typedef NS_ENUM(int, QNVTPropertyType)
{ //
    QNVTPropertyTypeText,
    QNVTPropertyTypeImage,
    QNVTPropertyTypeVideo
};

/*!
 @property pid
 @brief 属性id

 @since v1.0.0
 */
@property(nonatomic, readonly, assign) int pid;

/*!
 @property type
 @brief 属性类别

 @since v1.0.0
 */
@property(nonatomic, assign) QNVTPropertyType type;

/*!
 @property name
 @brief 属性名字，官方模板中建议替换的属性名将会以 rpl_ 开头

 @since v1.0.0
 */
@property(nonatomic, copy) NSString* name;

/*!
 @property value
 @brief 属性值

 @since v1.0.0
 */
@property(nonatomic, strong) QNVTPropertyValue* value;

@end

NS_ASSUME_NONNULL_END

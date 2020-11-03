//
//  QNVTContext.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/16.
//  Copyright © 2020 李政勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class QNVTContext
 @abstract 模板环境
 */
@interface QNVTContext : NSObject

/*!
 @property eaglContext
 @brief OpenGL ES 3.0 环境

 @since v1.0.0
 */
@property(nonatomic, strong, readonly) EAGLContext* eaglContext;

/*!
 @method sharedContext:
 @abstract 获取单例 context

 @param ptr 接收 context 的指针

 @since v1.0.0
 */
+ (void)sharedContext:(QNVTContext* __strong _Nullable* _Nonnull)ptr;
@end

NS_ASSUME_NONNULL_END

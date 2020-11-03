//
//  QNVTFrameBuffer.h
//  QNVideoTemplate
//
//  Created by 李政勇 on 2020/4/16.
//  Copyright © 2020 李政勇. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class QNVTFrameBuffer
 @abstract OpenGL ES framebuffer 包装类
 */
@interface QNVTFrameBuffer : NSObject

/*!
 @property buffersize
 @brief buffer 的尺寸

 @since v1.0.0
 */
@property(nonatomic, readonly, assign) CGSize buffersize;

/*!
 @property textureid
 @brief buffer 中绘制的 texture id

 @since v1.0.0
 */
@property(nonatomic, readonly, assign) GLuint textureid;

/*!
 @property fbo
 @brief buffer id

 @since v1.0.0
 */
@property(nonatomic, readonly, assign) GLuint fbo;

@end

NS_ASSUME_NONNULL_END

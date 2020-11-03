//
//  UIImage+DownSample.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Util)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size radius:(CGFloat)radius;

+ (UIImage*)downSampleWithPath:(NSString*)filePath maxLength:(NSInteger)max;
+ (UIImage*)getVideoPreViewImage:(NSString*)path maxLength:(NSInteger)max;

@end

NS_ASSUME_NONNULL_END

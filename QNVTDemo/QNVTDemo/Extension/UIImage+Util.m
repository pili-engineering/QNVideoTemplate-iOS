//
//  UIImage+DownSample.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "UIImage+Util.h"

#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Util)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size radius:(CGFloat)radius {
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)downSampleWithPath:(NSString*)filePath maxLength:(NSInteger)max {
    NSURL* url = [NSURL fileURLWithPath:filePath];
    NSDictionary* imageResourceOption = @{(__bridge_transfer NSString*)kCGImageSourceShouldCache : @(NO)};
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, (__bridge CFDictionaryRef)imageResourceOption);
    NSDictionary* thumbnailOption = @{
        (__bridge_transfer NSString*)kCGImageSourceCreateThumbnailFromImageAlways : @(YES),
        (__bridge_transfer NSString*)kCGImageSourceShouldCacheImmediately : @(NO),
        (__bridge_transfer NSString*)kCGImageSourceCreateThumbnailWithTransform : @(YES),
        (__bridge_transfer NSString*)kCGImageSourceThumbnailMaxPixelSize : @(max)
    };

    CGImageRef cgimage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)thumbnailOption);
    UIImage* image = [UIImage imageWithCGImage:cgimage];

    CGImageRelease(cgimage);
    CFRelease(imageSource);
    return image;
}

+ (UIImage*)getVideoPreViewImage:(NSString*)path maxLength:(NSInteger)max {
    AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    AVAssetImageGenerator* assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    assetGen.maximumSize = CGSizeMake(max, max);
    CMTime time = CMTimeMakeWithSeconds(0.05, 30);
    NSError* error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage* videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    if (videoImage == nil) {
        videoImage = [UIImage imageNamed:@"default_video.png"];
    }
    return videoImage;
}

@end

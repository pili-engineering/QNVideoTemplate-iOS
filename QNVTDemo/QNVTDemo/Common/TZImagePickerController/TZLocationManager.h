//
//  TZLocationManager.h
//  TZImagePickerController
//
//  Created by 谭真 on 2017/06/03.
//  Copyright © 2017年 谭真. All rights reserved.
//  定位管理类

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface TZLocationManager : NSObject

+ (instancetype)manager NS_SWIFT_NAME(default());

/// 开始定位
- (void)startLocation;
- (void)startLocationWithSuccessBlock:(void (^)(NSArray<CLLocation*>*))successBlock failureBlock:(void (^)(NSError* error))failureBlock;
- (void)startLocationWithGeocoderBlock:(void (^)(NSArray* geocoderArray))geocoderBlock;
- (void)startLocationWithSuccessBlock:(void (^)(NSArray<CLLocation*>*))successBlock
                         failureBlock:(void (^)(NSError* error))failureBlock
                        geocoderBlock:(void (^)(NSArray* geocoderArray))geocoderBlock;

/// 结束定位
- (void)stopUpdatingLocation;

@end

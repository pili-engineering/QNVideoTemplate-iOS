//
//  QNVTModel.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/4.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVTModel : NSObject

@property(nonatomic, copy) NSString* path;
@property(nonatomic, copy) NSString* name;
@property(nonatomic, strong) UIImage* cover;
@property(nonatomic, assign) CGSize dimension;

@property(nonatomic, assign) CGSize layoutSize;

@end

NS_ASSUME_NONNULL_END

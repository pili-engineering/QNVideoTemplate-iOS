//
//  QNVTPropertyModel.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "UIImage+Util.h"

#import <Foundation/Foundation.h>
#import <QNVideoTemplate/QNVideoTemplate.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVTPropertyModel : NSObject

@property(nonatomic, strong) NSArray<QNVTProperty*>* properties;
@property(nonatomic, strong) UIImage* thumbnail;

@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;
@property(nonatomic, assign) float fps;

- (void)appendProperty:(QNVTProperty*)property;

@end

NS_ASSUME_NONNULL_END

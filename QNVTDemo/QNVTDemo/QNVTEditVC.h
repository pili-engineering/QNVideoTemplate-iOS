//
//  QNVTViewController.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/4.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTBaseVC.h"
#import "QNVTModel.h"
#import "QNVTPropertyModel.h"

#import <QNVideoTemplate/QNVTAsset.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVTEditVC : QNVTBaseVC

- (instancetype)initWithAsset:(QNVTAsset*)asset properties:(NSArray<QNVTPropertyModel*>*)properties;

@end

NS_ASSUME_NONNULL_END

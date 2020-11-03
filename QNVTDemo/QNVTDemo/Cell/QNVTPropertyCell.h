//
//  QNVTPropertyCell.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTPropertyModel.h"

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface QNVTPropertyCell : UICollectionViewCell

@property(nonatomic, strong) QNVTPropertyModel* model;

@property(nonatomic, strong) UIImageView* imageView;
@property(nonatomic, strong) UILabel* textLable;
@property(nonatomic, strong) UILabel* timeLable;
@property(nonatomic, strong) UIView* dotView;
@property(nonatomic, strong) CAShapeLayer* boderLayer;

@property(nonatomic, strong) UIView* containerView;

@end

NS_ASSUME_NONNULL_END

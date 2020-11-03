//
//  QNVTMusicCell.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/16.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTMusicModel.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVTMusicCell : UICollectionViewCell

@property(nonatomic, strong) QNVTMusicModel* model;

@property(nonatomic, strong) UIImageView* iconImg;
@property(nonatomic, strong) UILabel* titleLabel;

@property(nonatomic, strong) UIView* selectedMask;
@property(nonatomic, strong) UIImageView* selectedMarkImg;

@end

NS_ASSUME_NONNULL_END

//
//  QNVTListCellTableViewCell.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/4.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTModel.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVTListCell : UICollectionViewCell

@property(nonatomic, strong) QNVTModel* model;

@end

NS_ASSUME_NONNULL_END

//
//  QNVTListCellTableViewCell.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/4.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTListCell.h"

#import "UIImage+Util.h"

@interface QNVTListCell ()

@property(nonatomic, strong) UIImageView* coverImg;
@property(nonatomic, strong) UILabel* nameLabel;

@end

@implementation QNVTListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor darkGrayColor];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = SCREENSCALE;
    self.layer.borderColor = QNVTCOLOR(232323).CGColor;
    self.layer.borderWidth = 1;

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];

    _coverImg = [[UIImageView alloc] init];
    _coverImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_coverImg];
}

- (void)layoutSubviews {
    _nameLabel.frame = self.contentView.bounds;
    _coverImg.frame = self.contentView.bounds;
}

- (void)setModel:(QNVTModel*)model {
    _model = model;
    if (!model.cover) {
        NSString* coverPath = [NSString pathWithComponents:@[ model.path, @"cover.png" ]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:coverPath]) {
            model.cover = [UIImage imageWithContentsOfFile:coverPath];
        } else {
            model.cover = [[UIImage alloc] init];
        }
    }

    _nameLabel.text = model.name;
    _coverImg.image = model.cover;
}

@end

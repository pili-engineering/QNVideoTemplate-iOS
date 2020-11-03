//
//  QNVTMusicCell.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/16.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTMusicCell.h"

@implementation QNVTMusicCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    _iconImg = [UIImageView new];
    _iconImg.layer.cornerRadius = 26;
    _iconImg.layer.masksToBounds = YES;
    _iconImg.contentMode = UIViewContentModeScaleAspectFit;
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _selectedMask = [UIView new];
    _selectedMask.layer.cornerRadius = 26;
    _selectedMask.layer.masksToBounds = YES;
    _selectedMask.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.4];
    _selectedMarkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_music_sel"]];
    _selectedMarkImg.contentMode = UIViewContentModeCenter;

    [self.contentView addSubview:_iconImg];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_selectedMask];
    [_selectedMask addSubview:_selectedMarkImg];

    [[_iconImg.widthAnchor constraintEqualToConstant:52] setActive:YES];
    [[_iconImg.heightAnchor constraintEqualToConstant:52] setActive:YES];
    [[_iconImg.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:-20] setActive:YES];
    [[_iconImg.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor] setActive:YES];

    [[_titleLabel.topAnchor constraintEqualToAnchor:_iconImg.bottomAnchor constant:8] setActive:YES];
    [[_titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:2] setActive:YES];
    [[_titleLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-2] setActive:YES];

    [[_selectedMask.leftAnchor constraintEqualToAnchor:_iconImg.leftAnchor] setActive:YES];
    [[_selectedMask.rightAnchor constraintEqualToAnchor:_iconImg.rightAnchor] setActive:YES];
    [[_selectedMask.topAnchor constraintEqualToAnchor:_iconImg.topAnchor] setActive:YES];
    [[_selectedMask.bottomAnchor constraintEqualToAnchor:_iconImg.bottomAnchor] setActive:YES];

    [[_selectedMask.leftAnchor constraintEqualToAnchor:_selectedMarkImg.leftAnchor] setActive:YES];
    [[_selectedMask.rightAnchor constraintEqualToAnchor:_selectedMarkImg.rightAnchor] setActive:YES];
    [[_selectedMask.topAnchor constraintEqualToAnchor:_selectedMarkImg.topAnchor] setActive:YES];
    [[_selectedMask.bottomAnchor constraintEqualToAnchor:_selectedMarkImg.bottomAnchor] setActive:YES];

    [self.contentView disableChildViewTranslatesAutoresizingMaskIntoConstraints];
}

- (void)setModel:(QNVTMusicModel*)model {
    _model = model;

    _iconImg.image = model.icon;
    _titleLabel.text = model.name;
    _selectedMask.hidden = !model.selected;
}

@end

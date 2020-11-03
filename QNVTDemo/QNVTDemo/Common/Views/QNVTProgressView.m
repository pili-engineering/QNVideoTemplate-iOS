//
//  QNVTProgressView.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/16.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTProgressView.h"

@interface QNVTProgressView ()

@property(nonatomic, strong) UIView* contentView;
@property(nonatomic, strong) UIActivityIndicatorView* indicator;
@property(nonatomic, strong) UILabel* titileLabel;

@end

@implementation QNVTProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _contentView = [[UIView alloc] init];
    _contentView.layer.cornerRadius = 6;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _titileLabel = [[UILabel alloc] init];
    _titileLabel.font = [UIFont systemFontOfSize:16];
    _titileLabel.textColor = UIColor.whiteColor;
    _titileLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:_contentView];
    [_contentView addSubview:_indicator];
    [_contentView addSubview:_titileLabel];

    [[_contentView.heightAnchor constraintEqualToConstant:168] setActive:YES];
    [[_contentView.widthAnchor constraintEqualToConstant:168] setActive:YES];
    [[_contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
    [[_contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-30] setActive:YES];

    [[_indicator.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor] setActive:YES];
    [[_indicator.centerYAnchor constraintEqualToAnchor:_contentView.centerYAnchor constant:-10] setActive:YES];

    [[_titileLabel.centerXAnchor constraintEqualToAnchor:_contentView.centerXAnchor constant:0] setActive:YES];
    [[_titileLabel.topAnchor constraintEqualToAnchor:_indicator.bottomAnchor constant:25] setActive:YES];
    [self disableChildViewTranslatesAutoresizingMaskIntoConstraints];

    [_indicator startAnimating];
}

- (void)setTitle:(NSString*)title {
    _title = title;
    _titileLabel.text = title;
}

- (void)showInView:(UIView*)view {
    self.frame = view.bounds;

    [view addSubview:self];
}

- (void)hid {
    [self removeFromSuperview];
}

@end

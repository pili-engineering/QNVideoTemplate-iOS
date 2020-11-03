//
//  QNVTVertButton.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/16.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTVertButton.h"

@implementation QNVTVertButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:8];
        self.titleLabel.textColor = UIColor.whiteColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height + 5, -self.imageView.frame.size.width, 0.0, 0.0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0, 0.0, -self.titleLabel.bounds.size.width)];
}

@end

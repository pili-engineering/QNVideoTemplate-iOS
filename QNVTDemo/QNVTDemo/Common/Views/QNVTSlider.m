//
//  QNVTSlider.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/7.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTSlider.h"

@implementation QNVTSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.slider = [[UISlider alloc] init];
    self.slider.maximumTrackTintColor = QNVTCOLOR(2439aa);
    self.slider.minimumTrackTintColor = QNVTCOLOR(3f66ff);
    self.slider.backgroundColor = UIColor.clearColor;
    [self.slider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.font = [UIFont systemFontOfSize:10];
    self.leftLabel.textColor = QNVTCOLOR(eeeeee);
    [self.leftLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = [UIFont systemFontOfSize:10];
    self.rightLabel.textColor = QNVTCOLOR(eeeeee);
    [self.rightLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.leftLabel.text = @"0.0s";
    self.rightLabel.text = @"0.0s";

    [self addSubview:self.slider];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];

    [[self.slider.centerYAnchor constraintEqualToAnchor:self.leftLabel.centerYAnchor] setActive:YES];
    [[self.slider.centerYAnchor constraintEqualToAnchor:self.rightLabel.centerYAnchor] setActive:YES];
    [[self.slider.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[self.slider.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:50] setActive:YES];
    [[self.slider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-50] setActive:YES];
    [[self.leftLabel.rightAnchor constraintEqualToAnchor:self.slider.leftAnchor constant:-6] setActive:YES];
    [[self.rightLabel.leftAnchor constraintEqualToAnchor:self.slider.rightAnchor constant:6] setActive:YES];
}

@end

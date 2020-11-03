//
//  QNVTPropertyCell.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTPropertyCell.h"

@implementation QNVTPropertyCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.backgroundColor = [UIColor clearColor];

        self.textLable = [UILabel new];
        self.textLable.textAlignment = NSTextAlignmentCenter;
        self.textLable.numberOfLines = 0;
        self.textLable.textColor = [UIColor whiteColor];
        self.textLable.font = [UIFont systemFontOfSize:10];

        self.timeLable = [[UILabel alloc] init];
        self.timeLable.textAlignment = NSTextAlignmentCenter;
        self.timeLable.numberOfLines = 1;
        self.timeLable.textColor = QNVTCOLOR(a6a6a6);
        self.timeLable.font = [UIFont systemFontOfSize:10];

        self.containerView = [UIView new];
        self.containerView.layer.cornerRadius = 3;
        self.containerView.layer.masksToBounds = YES;
        self.containerView.backgroundColor = QNVTCOLOR(474747);

        [self.contentView addSubview:self.containerView];
        [self.contentView addSubview:self.timeLable];
        [self.containerView addSubview:self.textLable];
        [self.containerView addSubview:self.imageView];

        CGRect rect = CGRectMake(0, 0, 68, 99);
        CAShapeLayer* border = [CAShapeLayer layer];
        border.strokeColor = [UIColor whiteColor].CGColor;
        border.fillColor = [UIColor clearColor].CGColor;
        border.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3].CGPath;
        border.frame = rect;
        border.lineWidth = 1.f;
        border.lineDashPattern = @[ @2, @2 ];
        [self.containerView.layer addSublayer:border];

        [[self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor] setActive:YES];
        [[self.containerView.widthAnchor constraintEqualToConstant:68] setActive:YES];
        [[self.containerView.heightAnchor constraintEqualToConstant:99] setActive:YES];
        [[self.containerView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:10] setActive:YES];

        [[self.imageView.topAnchor constraintEqualToAnchor:self.textLable.topAnchor] setActive:YES];
        [[self.imageView.trailingAnchor constraintEqualToAnchor:self.textLable.trailingAnchor] setActive:YES];
        [[self.imageView.bottomAnchor constraintEqualToAnchor:self.textLable.bottomAnchor] setActive:YES];
        [[self.imageView.leadingAnchor constraintEqualToAnchor:self.textLable.leadingAnchor] setActive:YES];

        [[self.imageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor] setActive:YES];
        [[self.imageView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor] setActive:YES];
        [[self.imageView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor] setActive:YES];
        [[self.imageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor] setActive:YES];

        [[self.timeLable.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor] setActive:YES];
        [[self.timeLable.bottomAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:-8] setActive:YES];

        [self.contentView disableChildViewTranslatesAutoresizingMaskIntoConstraints];
    }
    return self;
}

- (void)setModel:(QNVTPropertyModel*)model {
    _model = model;
    QNVTProperty* pro = model.properties.firstObject;
    _timeLable.text = [NSString stringWithFormat:@"%.1fs", pro.value.inPoint / model.fps];
    switch (pro.type) {
        case QNVTPropertyTypeText: {
            self.textLable.hidden = NO;
            self.imageView.image = nil;
            self.textLable.text = [(QNVTTextValue*)pro.value text];
            break;
        }

        default: {
            self.textLable.hidden = YES;
            self.imageView.image = model.thumbnail;
            break;
        }
    }
}

@end

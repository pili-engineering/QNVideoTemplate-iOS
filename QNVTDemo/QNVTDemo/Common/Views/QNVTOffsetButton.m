//
//  QNVTOffsetButton.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/7.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTOffsetButton.h"

@implementation QNVTOffsetButton

- (UIEdgeInsets)alignmentRectInsets {
    return _offset;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + _offset.left, bounds.origin.y + _offset.top, bounds.size.width, bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

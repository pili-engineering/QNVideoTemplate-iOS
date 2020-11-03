//
//  UIView+Notch.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "UIView+Util.h"

static NSSet* class_map;

@implementation UIView (Util)

+ (void)load {
    class_map = [[NSSet alloc] initWithArray:@[ [UISlider class] ]];
}

- (BOOL)hasNotch {
    if (@available(iOS 11.0, *)) {
        if (UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0) {
            return YES;
        }
    }
    return NO;
}

- (void)disableChildViewTranslatesAutoresizingMaskIntoConstraints {
    for (UIView* subview in self.subviews) {
        if (![class_map containsObject:[subview class]]) {
            [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
            [subview disableChildViewTranslatesAutoresizingMaskIntoConstraints];
        }
    }
}

@end

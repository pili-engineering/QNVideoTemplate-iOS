//
//  UIView+Notch.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/3/12.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Util)

- (BOOL)hasNotch;

- (void)disableChildViewTranslatesAutoresizingMaskIntoConstraints;

@end

NS_ASSUME_NONNULL_END

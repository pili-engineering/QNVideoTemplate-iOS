//
//  QNVTProgressView.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/16.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVTProgressView : UIView

@property(nonatomic, strong) NSString* title;

- (void)showInView:(UIView*)view;
- (void)hid;

@end

NS_ASSUME_NONNULL_END

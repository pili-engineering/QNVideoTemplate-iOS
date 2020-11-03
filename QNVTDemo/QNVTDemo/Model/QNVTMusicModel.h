//
//  QNVTMusicModel.h
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/7.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNVTMusicModel : NSObject

@property(nonatomic, assign) BOOL selected;

@property(nonatomic, strong) UIImage* icon;
@property(nonatomic, copy) NSString* name;
@property(nonatomic, copy) NSString* path;

@end

NS_ASSUME_NONNULL_END

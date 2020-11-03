//
//  main.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/2/27.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "AppDelegate.h"

#import <UIKit/UIKit.h>

int main(int argc, char* argv[]) {
    NSString* appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

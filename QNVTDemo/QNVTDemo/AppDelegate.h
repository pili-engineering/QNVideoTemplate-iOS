#import <UIKit/UIKit.h>

@class QNVTListVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController* navController;

    QNVTListVC* listController;
}

@property(strong, nonatomic) UIWindow* window;

@end

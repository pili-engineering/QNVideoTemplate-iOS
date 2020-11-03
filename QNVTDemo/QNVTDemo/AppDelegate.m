#import "AppDelegate.h"

#import "QNVTListVC.h"

#import <QNVideoTemplate/QNVideoTemplate.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    navController = [[UINavigationController alloc] init];
    listController = [[QNVTListVC alloc] initWithNibName:nil bundle:nil];
    [navController pushViewController:listController animated:NO];

    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];

    NSString* path = [[NSBundle mainBundle] pathForResource:@"qnvt" ofType:@"license"];
    QNVTSetLicensePath([path UTF8String]);

    return YES;
}

@end

//
//  QNVTBaseVC.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/3.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTBaseVC.h"

@interface QNVTBaseVC ()

@end

@implementation QNVTBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupStyle];
}

- (void)setupStyle {
    self.view.backgroundColor = QNVTCOLOR(232323);
    UIBarButtonItem* item = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.barTintColor = UIColor.blackColor;
    [self.navigationController.navigationBar
        setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

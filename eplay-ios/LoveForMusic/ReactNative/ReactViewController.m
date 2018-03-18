//
//  ReactViewController.m
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/3/12.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "ReactViewController.h"

@interface ReactViewController ()

@end

@implementation ReactViewController
@synthesize component;
@synthesize params;
@synthesize rootView;
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"ihg will appear");
    [super viewWillAppear:animated];
    NSMutableDictionary *a = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [a setValue:@"pause" forKey:@"viewControllerState"];
//    [self.params setValue:@"pause" forKey:@"viewControllerState"];
//    [self.rootView setAppProperties:self.params];
//
    self.rootView.appProperties = a;

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"ihg will disappear");
//    [self.params setValue:@"resume" forKey:@"viewControllerState"];
//      [self.rootView setAppProperties:self.params];
//    self.rootView.appProperties = @{@"viewControllerState": @"resume"};
    NSMutableDictionary *a = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [a setValue:@"resume" forKey:@"viewControllerState"];
    //    [self.params setValue:@"pause" forKey:@"viewControllerState"];
    //    [self.rootView setAppProperties:self.params];
    //
    self.rootView.appProperties = a;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString * strUrl = @"http://127.0.0.1:8081/index.ios.bundle?platform=ios&dev=true";
    [self.params setValue:@"resume" forKey:@"viewControllerState"];
//     NSString * strUrl = @"http://30.33.48.95:8081/index.ios.bundle?platform=ios&dev=true";
//    NSURL * jsCodeLocation = [NSURL URLWithString:strUrl];
        NSURL * jsCodeLocation =[[NSBundle mainBundle] URLForResource:@"jsbundle/ios" withExtension:@"jsbundle"];
    self.rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                         moduleName: component
                                                  initialProperties:params
                                                      launchOptions:nil];
    self.view = self.rootView;
    //  也可addSubview，自定义大小位置
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

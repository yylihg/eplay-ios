//
//  BaseViewController.m
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/4/3.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize mConnector;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [AppDelegate storyBoradAutoLay:self.view];
}

//展示ToastView
-(void)toast:(NSString *)msg{
    [self.navigationController.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//连接网络成功后
-(void)connectFinishAction:(NSURLConnection *)connection resultJson:(NSString *)json{
    
}
@end

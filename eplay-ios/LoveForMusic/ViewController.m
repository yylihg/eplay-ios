//
//  ViewController.m
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/3/12.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "ViewController.h"
#import "RegistViewController.h"
#import "ResetPasswordViewController.h"
#import "MainViewController.h"
#import "VideoViewController.h"
#import "NTESLoginManager.h"
#import "NSString+NTES.h"
#import "UIView+Toast.h"

#import "NTESLiveStreamVC.h"
#import "NTESLiveDataCenter.h"
#import "NTESChatroomManger.h"
#import "NTESEncryption.h"
@interface ViewController ()
//- (IBAction)goRN:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameET;
@property (weak, nonatomic) IBOutlet UITextField *passwordET;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressBar;
- (IBAction)userDone:(id)sender;
- (IBAction)passwordDone:(id)sender;
- (IBAction)LoginBtn:(id)sender;//登陆按钮
- (IBAction)resetPasswordBtn:(id)sender;//忘记密码按钮
- (IBAction)registBtn:(id)sender;//注册按钮
- (IBAction)back:(id)sender;

@end

@implementation ViewController
@synthesize userInfo = _userInfo;
@synthesize delegate = _delegate;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameET.delegate = self;
    self.passwordET.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
    [AppDelegate storyBoradAutoLay:self.view];

    self.progressBar.hidden = YES;//设置登陆进度条不可见

        //设置正在登陆中为未在登陆
    isLogining = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)goRN:(id)sender {
//    ReactViewController *mReactViewController = [[ReactViewController alloc] init];
//    [self presentViewController:mReactViewController animated: true completion:^{
//        
//    }];
//}

- (IBAction)userDone:(id)sender {
     [sender resignFirstResponder];
}

- (IBAction)passwordDone:(id)sender {
     [sender resignFirstResponder];
}

- (IBAction)LoginBtn:(id)sender {
    //判断是否正在登陆，是的话不做响应
    if (isLogining) {
        [self showDialog:@"正在登陆"];
        return;
    }
    //判断用户名是否为空，为空提示用户
//    if ([self.usernameET.text isEqualToString:@""]) {
//        self.usernameET.placeholder = @"用户名不能为空";
//        [self showDialog:@"用户名不能为空"];
//        return;
//    }
//    //判断密码是否为空，为空提示用户
//    if ([self.passwordET.text isEqualToString:@""]) {
//        self.passwordET.placeholder = @"密码不能为空";
//        [self showDialog:@"密码不能为空"];
//        return;
//    }
    self.progressBar.hidden = NO;
    
    [self getAccessToken];

}

-(void)getAccessToken{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],@"/api/accessToken/find.do?appId=ep20170712235111&secret=34463963d038419e859e4f62f47c85de" ] parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
        
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"%@",responseObject);
            _userInfo= [[UserModel alloc] init];
             _userInfo.accessToken =[[responseObject objectForKey:@"data"] objectForKey:@"ACCESS_TOKEN"];
             [Utils setUserInfo:_userInfo];
             [self doLogin];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             [self showDialog:@"获取ACCESS_TOKEN失败"];
         }
     ];
}

-(void)doLogin{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:_userInfo.accessToken forHTTPHeaderField:@"access-token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:self.usernameET.text forKey:@"username"];
//    [parameters setObject:self.passwordET.text forKey:@"password"];
    [parameters setObject:@"15959445222"forKey:@"username"];
    [parameters setObject:@"wxh123" forKey:@"password"];
    [manager POST: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],@"/api/login/login.do" ]  parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
        
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             self.progressBar.hidden = NO;
             isLogining = false;
             NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
             if([code isEqualToString:@"0"]){
                 NSLog(@"ihgresponseObject %@", responseObject);
                 _userInfo.userToken = [[responseObject objectForKey:@"data"] objectForKey:@"USER_TOKEN"];
                 _userInfo.roleId = [[responseObject objectForKey:@"data"] objectForKey:@"ROLE_ID"];\
                 _userInfo.username = [parameters objectForKey:@"username"];
                 _userInfo.password = [parameters objectForKey:@"password"];
                 [Utils setUserInfo:_userInfo];
                 if (_delegate  != NULL) {
                     [_delegate loginSuccess:responseObject];
                 }
                 
                 
                 
                 NSString *loginAccount =  [[responseObject objectForKey:@"data"] objectForKey:@"IM_USERNAME"];
                 NSString *password   = [[responseObject objectForKey:@"data"] objectForKey:@"IM_PASSWORD"];
                 NSString *loginToken   = password;
                 
                 [[[NIMSDK sharedSDK] loginManager] login:loginAccount
                                                    token:loginToken
                                               completion:^(NSError *error) {
                                                   if (error == nil)
                                                   {
                                                       LoginData *sdkData = [[LoginData alloc] init];
                                                       sdkData.account   = loginAccount;
                                                       sdkData.token     = loginToken;
                                                       [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                                       
                                                       //保存用户名和密码
                                                       [NTESLoginManager sharedManager].currentNTESLoginData.accid = loginAccount;
                                                       [NTESLoginManager sharedManager].currentNTESLoginData.password = loginToken;
                                                       
                                                   }
                                               }];
//
                 
                 [self.navigationController popViewControllerAnimated:YES];
             }else{
//                 [self showDialog: [[responseObject objectForKey:@"errorMsg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
             }
//                NSLog(@"ihg%@",[[responseObject objectForKey:@"errorMsg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              self.progressBar.hidden = NO;
                 isLogining = false;
             [self showDialog:@"登陆失败，请重试！"];
         }
     ];
    
}


//-(void)goMainView{
//    MainViewController *mMainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
//    [self.navigationController pushViewController:mMainViewController animated:YES];
//}


- (IBAction)resetPasswordBtn:(id)sender {
    ResetPasswordViewController *mResetPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"resetPasswordView"];
    
    [self.navigationController pushViewController:mResetPasswordViewController animated:YES];
}

- (IBAction)registBtn:(id)sender {

    //进入聊天室
    NTESLiveStreamVC *push = [[NTESLiveStreamVC alloc] initWithChatroomId:@"19804023"];
    push.pushUrl = @"rtmp://p1948666e.live.126.net/live/eda925a2e7b24416b238960c3d2e437d?wsSecret=2546a304bbd377cd51045178410aec87&wsTime=1512883961";
    [self presentViewController:push animated:YES completion:nil];
//
//    RegistViewController *mRegistViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"registView"];
//     [self.navigationController pushViewController:mRegistViewController animated:YES];
}
//展示ToastView
-(void)showDialog:(NSString *)msg{
    [self.navigationController.view makeToast:msg duration:2.0 position:CSToastPositionCenter];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.textField = textField;
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

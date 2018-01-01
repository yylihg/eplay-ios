//
//  RegistViewController.m
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/4/3.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameEt;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeEt;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UserTypeSegment;
@property (weak, nonatomic) IBOutlet UITextField *passwordEt;
- (IBAction)userRegister:(id)sender;
- (IBAction)roleSelect:(id)sender;
- (IBAction)editDone:(id)sender;
- (IBAction)getVerificationCode:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;

@end

@implementation RegistViewController
@synthesize userInfo = _userInfo;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameEt.delegate = self;
    self.verifyCodeEt.delegate = self;
    self.passwordEt.delegate = self;
    role = GENERAL;
    second = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userRegister:(id)sender {
    
    NSLog(@"ihg: %d",(int)[self.UserTypeSegment selectedSegmentIndex]);
    //判断用户名是否为空，为空提示用户
    if ([self.userNameEt.text isEqualToString:@""]) {
        self.userNameEt.placeholder = @"用户名不能为空";
        [self toast:@"用户名不能为空"];
        return;
    }
    //判断验证码是否为空，为空提示用户
    if ([self.verifyCodeEt.text isEqualToString:@""]) {
        self.verifyCodeEt.placeholder = @"验证码不能为空";
        [self toast:@"验证码错误"];
        return;
    }
    //判断密码是否为空，为空提示用户
    if ([self.passwordEt.text isEqualToString:@""]) {
        [self toast:@"密码错误"];
        return;
    }
    [self regist];
//    [self back];
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
             _userInfo.userToken = @"";
             [Utils setUserInfo:_userInfo];
             [self getCode];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             [self toast:@"获取验证码失败"];
         }
     ];
}


-(void)regist{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:_userInfo.accessToken forHTTPHeaderField:@"access-token"];
     NSLog(@"ihg accessToken %@", _userInfo.accessToken);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.userNameEt.text forKey:@"mobile"];
    [parameters setObject:self.passwordEt.text forKey:@"password"];
    [parameters setObject:self.verifyCodeEt.text  forKey:@"mobileCode"];
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)[self.UserTypeSegment selectedSegmentIndex]]forKey:@"isTeacher"];
     NSLog(@"ihg parameters %@",parameters);
    [manager POST: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],@"/api/register/doRegister.do" ]  parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
             if([code isEqualToString:@"0"]){
                 [self back];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"ihg error %@", error);

         }
     ];
}



//选择角色
- (IBAction)roleSelect:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        role = GENERAL;
    }else if (sender.selectedSegmentIndex == 1){
        role = TEACHER;
    }
}

- (IBAction)editDone:(id)sender {
     [sender resignFirstResponder];
}

- (IBAction)getVerificationCode:(id)sender {
    NSLog(@"ihg: %@",self.userNameEt.text);
    if (second == 0) {
        second = 60;
        //全局队列    默认优先级
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //定时器模式  事件源
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
        //NSEC_PER_SEC是秒，＊1是每秒
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
        //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
        dispatch_source_set_event_handler(timer, ^{
            //回调主线程，在主线程中操作UI
            dispatch_async(dispatch_get_main_queue(), ^{
                if (second >= 0) {
                    [self.verificationBtn setTitle:[NSString stringWithFormat:@"(%d)重发验证码",second] forState:UIControlStateNormal];
                    second--;
                }
                else
                {
                    //这句话必须写否则会出问题
                    dispatch_source_cancel(timer);
                    [self.verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                }
            });
        });
        //启动源
        dispatch_resume(timer);
        [self getAccessToken];
    }else{
         [self toast:@"请稍等"];
    }
    
    
}

-(void)getCode{
    //判断用户名是否为空，为空提示用户
    if (self.userNameEt.text.length == 0|| [self.userNameEt.text isEqualToString:@""]) {
        self.userNameEt.placeholder = @"用户名不能为空";
        [self toast:@"用户名不能为空"];
        return;
    }
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@" , [Utils getStringFromPlist:@"connectIp"],@"/api/register/findMobileCode.do?mobile=", self.userNameEt.text] );
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[Utils getUserInfo].accessToken forHTTPHeaderField:@"access-token"];
    [manager GET: [NSString stringWithFormat:@"%@%@%@%@" , [Utils getStringFromPlist:@"connectIp"],@"/api/register/findMobileCode.do?mobile=", self.userNameEt.text, @"&type=1"] parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             NSLog(@"%@", responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
         }
     ];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.textField = textField;
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

@end

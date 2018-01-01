//
//  ReactModule.m
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/5/1.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "ReactModule.h"
#import "ResetPasswordViewController.h"

#import "UIView+React.h"
#import "RCTUIManager.h"
#import "RCTUtils.h"
#import "VideoViewController.h"
#import "ReactViewController.h"
#import "ViewController.h"
@implementation ReactModule
@synthesize bridge = _bridge;
RCTResponseSenderBlock _loginCallback;
RCT_EXPORT_METHOD(
                  podViewController:(nonnull NSNumber *)reactTag // Component 对象的 reactTag
                  resolver:(RCTPromiseResolveBlock)resolve // 这行
                  rejecter:(RCTPromiseRejectBlock)reject   // 和这行是可选的，如果需要在执行完毕后给 JavaScript 通知的话，就带上
)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //            [app.nav pushViewController:one animated:YES];
        [app.nav  popViewControllerAnimated:YES];
    });
}


RCT_EXPORT_METHOD(pushReactViewController:(nonnull NSNumber *)reactTag component:(nonnull NSString *)componentName params:(NSDictionary *)params){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ReactViewController *mReactViewController = [stroyboard instantiateViewControllerWithIdentifier:@"reactView"];
        mReactViewController.component = componentName;
        mReactViewController.params = params;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //            [app.nav pushViewController:one animated:YES];
        [app.nav pushViewController:mReactViewController animated:YES];
    });
}

//RCT_EXPORT_METHOD(pushReactViewController:(nonnull NSNumber *)reactTag component:(nonnull NSString *)componentName){
//    [self pushReactViewController:reactTag component:componentName params:nil];
//}

RCT_EXPORT_METHOD(
                  pushViewController:(nonnull NSNumber *)reactTag // Component 对象的 reactTag
                  resolver:(RCTPromiseResolveBlock)resolve // 这行
                  rejecter:(RCTPromiseRejectBlock)reject   // 和这行是可选的，如果需要在执行完毕后给 JavaScript 通知的话，就带上
)
{
    RCTUIManager *uiManager = self.bridge.uiManager;
    dispatch_async(uiManager.methodQueue, ^{
        [uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
            UIView *view = viewRegistry[reactTag];
            UIViewController *viewController = (UIViewController *)view.reactViewController;
            
            UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                ResetPasswordViewController *mMainViewController = [stroyboard instantiateViewControllerWithIdentifier:@"resetPasswordView"];
              [viewController.navigationController pushViewController:mMainViewController animated:YES];
//            [viewController.navigationController popToViewController:[viewController.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
            // It's now ok to do something with the viewController
            // which is in charge of the component.
        }];
    });
}

RCT_EXPORT_METHOD(
                  pushVideoViewController:(nonnull NSNumber *)reactTag // Component 对象的 reactTag
                  url:(NSString *)videoUrl
                  title:(NSString *)videoTitle
)
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        VideoViewController *mVideoViewController = [stroyboard instantiateViewControllerWithIdentifier:@"videoView"];
        mVideoViewController.videoTitle = videoTitle;
        mVideoViewController.videoUrl = videoUrl;

        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //            [app.nav pushViewController:one animated:YES];
        [app.nav pushViewController:mVideoViewController animated:YES];
    });
}


RCT_EXPORT_METHOD(
                  pushLoginController:(nonnull NSNumber *)reactTag // Component 对象的 reactTag
                callback:(RCTResponseSenderBlock)callback)
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ViewController *mViewController = [stroyboard instantiateViewControllerWithIdentifier:@"loginView"];
        mViewController.delegate = self;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:mViewController animated:YES];
    });
}

RCT_EXPORT_METHOD(loginOut){
    UserModel *userModel = [[UserModel alloc]init];
    userModel.accessToken = @"";
    userModel.userToken = @"";
    userModel.roleId = @"";
    userModel.username = @"";
    userModel.password = @"";
    [Utils setUserInfo:userModel];
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        //jump to login page
    }];
}

RCT_EXPORT_METHOD(getUser:(RCTResponseSenderBlock)callback){
    NSLog(@"ihg getUser");
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    
    [user setValue:[Utils getUserInfo].username forKey:@"username"];
    [user setValue:[Utils getUserInfo].password forKey:@"password"];
    [user setValue:[Utils getUserInfo].roleId forKey:@"roleId"];
    [user setValue:[Utils getUserInfo].accessToken forKey:@"accessToken"];
    [user setValue:[Utils getUserInfo].userToken forKey:@"userToken"];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    [result addObject:user];
    callback(result);
}


RCT_EXPORT_METHOD(setItem: (NSString*)key value:(NSString *)value ){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}

RCT_EXPORT_METHOD(getItem: (NSString*)key callBack:(RCTResponseSenderBlock)callback){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *valueObj = [[NSMutableDictionary alloc] init];
    [valueObj setValue:[defaults objectForKey: key] forKey:@"value"];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    [result addObject:valueObj];
    callback(result);
    ;
}


RCT_EXPORT_METHOD(doLogin:(NSString *)username password:(NSString *)password callback:(RCTResponseSenderBlock)callback){
    UserModel *_userInfo = [Utils getUserInfo];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:_userInfo.accessToken forHTTPHeaderField:@"access-token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    
    [manager POST: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],@"/api/login/login.do" ]  parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
             if([code isEqualToString:@"0"]){
                 _userInfo.userToken = [[responseObject objectForKey:@"data"] objectForKey:@"USER_TOKEN"];
                 _userInfo.roleId = [[responseObject objectForKey:@"data"] objectForKey:@"ROLE_ID"];
                 _userInfo.username = [parameters objectForKey:@"username"];
                 _userInfo.password = [parameters objectForKey:@"password"];
                 [Utils setUserInfo:_userInfo];
                 callback(@[responseObject]);
             }
                             NSLog(@"ihg%@",[[responseObject objectForKey:@"errorMsg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }
     ];
}


RCT_EXPORT_METHOD(getAccessToken:(RCTResponseSenderBlock)callback){
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],@"/api/accessToken/find.do?appId=ep20170712235111&secret=34463963d038419e859e4f62f47c85de" ] parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             UserModel *_userInfo= [Utils getUserInfo];
             _userInfo.accessToken =[[responseObject objectForKey:@"data"] objectForKey:@"ACCESS_TOKEN"];

             [Utils setUserInfo:_userInfo];
             callback(@[responseObject]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
            
         }
     ];
}

RCT_EXPORT_METHOD(fetch:(NSString *)method params:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback){
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[Utils getUserInfo].accessToken forHTTPHeaderField:@"access-token"];
    [manager.requestSerializer setValue:[Utils getUserInfo].userToken forHTTPHeaderField:@"user-token"];
    NSLog(@"ihg url: %@",[NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],[params objectForKey:@"api"]]);
    if ([method isEqualToString:@"get"]) {
        [manager GET: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],[params objectForKey:@"api"]] parameters:nil
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
//                 NSLog(@"ihg%@",[[responseObject objectForKey:@"errorMsg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                 callback(@[[NSNull null], responseObject]);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
//                  NSLog(@"ihg error: %@",error);
                 callback(@[error,]);
             }
         ];
    }else if ([method isEqualToString:@"post"]) {
        [manager POST: [NSString stringWithFormat:@"%@%@" , [Utils getStringFromPlist:@"connectIp"],[params objectForKey:@"api"] ]  parameters:[params objectForKey:@"params"]
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"ihg success: %@",responseObject);
//                     NSLog(@"ihg%@",[[responseObject objectForKey:@"errorMsg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                     callback(@[[NSNull null], responseObject]);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                   NSLog(@"ihg error: %@",error);
                 callback(@[error,]);
             }
         ];

    }
   
}

RCT_EXPORT_METHOD(sendNotification:(NSString *)action notificationName:(NSString *)name){
  
}

RCT_EXPORT_MODULE();
//  对外提供调用方法（testNormalEvent为方法名，后面为参数，按顺序和对应数据类型在js进行传递）
RCT_EXPORT_METHOD(back){
    NSLog(@"ihg hbms,ahfba ");
//        UIViewController * rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    MainViewController *mMainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
//    [rootVC.navigationController pushViewController:mMainViewController animated:YES];
    UIViewController * rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

   
    dispatch_async(dispatch_get_main_queue(), ^{
        [rootVC.navigationController popToViewController:[rootVC.navigationController.viewControllers objectAtIndex:0] animated:YES];
    });
    
}

-(void)loginSuccess:(id)responseObject{
    NSLog(@"ihg run login");
    if (_loginCallback != NULL) {
        _loginCallback(@[responseObject]);
    }
}

@end

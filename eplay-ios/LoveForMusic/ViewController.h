//
//  ViewController.h
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/3/12.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectUtils.h"
@class ViewController;
@protocol ViewControllerDelegate <NSObject>
-(void)loginSuccess:(id) responseObject;
@end
@interface ViewController : UIViewController <MBProgressHUDDelegate,UITextFieldDelegate>
{
    NSString *outString;
    Boolean isLogining;
    NSMutableData *jsonData;
    NSString *timeStamp;
}
@property (nonatomic, retain) MBProgressHUD *ToastView;//提示信息窗口
@property (nonatomic, retain) UserModel *userInfo;//用户信息
@property (nonatomic,retain) UITextField *textField;
@property (nonatomic, weak) id<ViewControllerDelegate> delegate;

@end


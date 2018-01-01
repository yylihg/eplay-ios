//
//  RegistViewController.h
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/4/3.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import <UIKit/UIKit.h>
#define GENERAL  0;
#define TEACHER  1;

@interface RegistViewController : BaseViewController<UITextFieldDelegate>
{
    int role;
    int second;
}
@property (nonatomic,retain) NSString *titleName;//
@property (nonatomic, retain) UserModel *userInfo;//用户信息
@property (nonatomic,retain) UITextField *textField;
@end

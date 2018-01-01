//
//  ResetPasswordViewController.h
//  LoveForMusic
//
//  Created by yyl ihg on 2017/10/21.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "BaseViewController.h"

@interface ResetPasswordViewController : BaseViewController<UITextFieldDelegate>
{
    int second;
}
@property (nonatomic,retain) NSString *titleName;//
@property (nonatomic, retain) UserModel *userInfo;//用户信息
@property (nonatomic,retain) UITextField *textField;


@end

//
//  ReactViewController.h
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/3/12.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <React/RCTRootView.h>
@interface ReactViewController : UIViewController

@property(nonatomic,retain) NSString *component;//react native 组件
@property(nonatomic,retain) NSDictionary *params;
@property(nonatomic,retain) RCTRootView * rootView;
@end

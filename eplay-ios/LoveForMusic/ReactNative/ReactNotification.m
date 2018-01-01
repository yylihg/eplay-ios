//
//  ReactNotification.m
//  LoveForMusic
//
//  Created by yanlin.yyl on 2017/9/9.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "ReactNotification.h"

@implementation ReactNotification

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"NativeEvent"];
}

//发送广播通知，主要用于登陆相关通知
RCT_EXPORT_METHOD(sendEvent:(NSString *)notification){
    NSLog(@"ihg recidsds success");
//     NSString *eventName = notification.userInfo[@"name"];
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
//            [self sendEventWithName:@"NativeEvent" body:@{@"name": notification}];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"test" object:@{@"name": notification}];
    });

}

@end

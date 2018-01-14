//
//  NTESLiveAnchorHandler.m
//  NIMLiveDemo
//
//  Created by chris on 16/8/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveAnchorHandler.h"
#import "NSString+NTES.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveViewDefine.h"
#import "NTESMicConnector.h"
#import "NTESLiveManager.h"

@interface NTESLiveAnchorHandler ()

@property (nonatomic,strong) NIMChatroom *chatroom;

@end

@implementation NTESLiveAnchorHandler

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
{
    self = [super init];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}



- (void)dealWithBypassCustomNotification:(NIMCustomSystemNotification *)notification
{
    NSString *content  = notification.content;
    NSString *from     = notification.sender;
    NSDictionary *dict = [content jsonObject];
    if (![self shouldDealWithNotification:notification]) {
        return;
    }
    NTESLiveCustomNotificationType type = [dict jsonInteger:@"command"];
    switch (type) {
        case NTESLiveCustomNotificationTypePushMic:{
            //这个是连麦者发来的请求
            DDLogInfo(@"anchor: on receive notification NTESLiveCustomNotificationTypePushMic");
            NSDictionary *info = [dict jsonDict:@"info"];
            NSString *nick   = [info jsonString:@"nick"];
            NSString *avatar = [info jsonString:@"avatar"];
            NIMNetCallMediaType callType = [dict jsonInteger:@"style"];
            
            NTESMicConnector *connector = [[NTESMicConnector alloc] init];
            connector.uid    = from;
            connector.state  = NTESLiveMicStateWaiting;
            connector.nick   = nick;
            connector.avatar = avatar;
            connector.type   = callType;
            
            [[NTESLiveManager sharedInstance] updateConnectors:connector];
            if ([self.delegate respondsToSelector:@selector(didUpdateConnectors)]) {
                [self.delegate didUpdateConnectors];
            }
            break;
        }
        case NTESLiveCustomNotificationTypePopMic:
            //这个是连麦者发来的请求，处于等待->取消状态
            DDLogInfo(@"anchor: on receive notification NTESLiveCustomNotificationTypePopMic");
            [[NTESLiveManager sharedInstance] removeConnectors:from];
            if ([self.delegate respondsToSelector:@selector(didUpdateConnectors)]) {
                [self.delegate didUpdateConnectors];
            }
            break;
        case NTESLiveCustomNotificationTypeRejectAgree:
            //这个只有主播会收到，是连麦者拒绝主播连麦，因连麦过期造成，非用户触发
            DDLogInfo(@"anchor: on receive notification NTESLiveCustomNotificationTypeRejectAgree");
            [NTESLiveManager sharedInstance].connectorOnMic = nil;
            [[NTESLiveManager sharedInstance] removeConnectors:notification.sender];
            if ([self.delegate respondsToSelector:@selector(didUpdateConnectors)]) {
                [self.delegate didUpdateConnectors];
            }
            break;
        default:
            break;
    }
}



- (BOOL)shouldDealWithNotification:(NIMCustomSystemNotification *)notification
{
    NSString *content  = notification.content;
    NSDictionary *dict = [content jsonObject];
    NSString *roomId = [dict jsonString:@"roomid"];
    BOOL validRoom = [roomId isEqualToString:self.chatroom.roomId];
    return validRoom;
}


@end

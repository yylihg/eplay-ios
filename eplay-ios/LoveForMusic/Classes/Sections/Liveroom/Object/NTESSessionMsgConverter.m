//
//  NTESSessionMsgHelper.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionMsgConverter.h"
#import "NSString+NTES.h"
#import "NTESPresentAttachment.h"
#import "NTESLikeAttachment.h"
#import "NTESPresent.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveViewDefine.h"
#import "NTESLiveManager.h"
#import "NTESMicConnector.h"
#import "NTESMicAttachment.h"

@implementation NTESSessionMsgConverter


+ (NIMMessage*)msgWithText:(NSString*)text
{
    NIMMessage *textMessage = [[NIMMessage alloc] init];
    textMessage.text        = text;
    return textMessage;
}

+ (NIMMessage *)msgWithTip:(NSString *)tip
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMTipObject *tipObject    = [[NIMTipObject alloc] init];
    message.messageObject      = tipObject;
    message.text               = tip;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    message.setting            = setting;
    return message;
}

+ (NIMMessage *)msgWithPresent:(NTESPresent *)present
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    NTESPresentAttachment *attachment = [[NTESPresentAttachment alloc] init];
    attachment.presentType     = present.type;
    attachment.count           = 1;
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}

+ (NIMMessage *)msgWithLike
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    NTESLikeAttachment *attachment = [[NTESLikeAttachment alloc] init];
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}

+ (NIMMessage *)msgWithConnectedMic:(NTESMicConnector *)connector
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    NTESMicConnectedAttachment *attachment = [[NTESMicConnectedAttachment alloc] init];
    attachment.type            = connector.type;
    attachment.nick            = connector.nick;
    attachment.avatar          = connector.avatar;
    attachment.connectorId     = connector.uid;
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}

+ (NIMMessage *)msgWithDisconnectedMic:(NTESMicConnector *)connector
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMCustomObject *object    = [[NIMCustomObject alloc] init];
    NTESDisConnectedAttachment *attachment = [[NTESDisConnectedAttachment alloc] init];
    attachment.connectorId     = connector.uid;
    object.attachment          = attachment;
    message.messageObject      = object;
    return message;
}


@end



@implementation NTESSessionCustomNotificationConverter

+ (NIMCustomSystemNotification *)notificationWithPushMic:(NSString *)roomId style:(NIMNetCallMediaType)style
{
    NIMChatroomMember *member = [[NTESLiveManager sharedInstance] myInfo:roomId];
    if (member) {
        NSString *content = [ @{
                                @"command"   : @(NTESLiveCustomNotificationTypePushMic),
                                @"roomid" : roomId,
                                @"style"  : @(style),
                                @"info"   : @{
                                                @"nick"   : member.roomNickname,
                                                @"avatar" : member.roomAvatar.length? member.roomAvatar : @"avatar_default"
                                            }
                                } jsonBody];
        NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
        notification.sendToOnlineUsersOnly = YES;
        return notification;
    }
    return nil;
}


+ (NIMCustomSystemNotification *)notificationWithPopMic:(NSString *)roomId
{
    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypePopMic),@"roomid" : roomId} jsonBody];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    return notification;
}

+ (NIMCustomSystemNotification *)notificationWithAgreeMic:(NSString *)roomId style:(NIMNetCallMediaType)style
{
    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypeAgreeConnectMic),@"roomid" : roomId, @"style":@(style)} jsonBody];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    return notification;
}

+ (NIMCustomSystemNotification *)notificationWithRejectAgree:(NSString *)roomId
{
    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypeRejectAgree),@"roomid" : roomId} jsonBody];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    return notification;
}


+ (NIMCustomSystemNotification *)notificationWithForceDisconnect:(NSString *)roomId
{
    NSString *content = [@{@"command":@(NTESLiveCustomNotificationTypeForceDisconnect),@"roomid" : roomId} jsonBody];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = NO;
    return notification;
}

@end

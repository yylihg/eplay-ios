//
//  NTESSessionMsgHelper.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionMsgConverter.h"
#import "NSString+NTES.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESSnapchatAttachment.h"
#import "NTESChartletAttachment.h"
#import "NTESWhiteboardAttachment.h"
#import "NTESRedPacketAttachment.h"
#import "NTESRedPacketTipAttachment.h"

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

+ (NIMMessage*)msgWithImage:(UIImage*)image
{
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
   return [NTESSessionMsgConverter generateImageMessage:imageObject];
}

+ (NIMMessage *)msgWithImagePath:(NSString*)path
{
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithFilepath:path];
    return [NTESSessionMsgConverter generateImageMessage:imageObject];
}

+ (NIMMessage *)generateImageMessage:(NIMImageObject *)imageObject
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    imageObject.displayName = [NSString stringWithFormat:@"图片发送于%@",dateString];
    NIMImageOption *option  = [[NIMImageOption alloc] init];
    option.compressQuality  = 0.8;
    imageObject.option = option;
    NIMMessage *message     = [[NIMMessage alloc] init];
    message.messageObject   = imageObject;
    message.apnsContent = @"发来了一张图片";
    return message;
}


+ (NIMMessage*)msgWithAudio:(NSString*)filePath
{
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = audioObject;
    message.apnsContent = @"发来了一段语音";
    return message;
}

+ (NIMMessage*)msgWithVideo:(NSString*)filePath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:filePath];
    videoObject.displayName = [NSString stringWithFormat:@"视频发送于%@",dateString];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = videoObject;
    message.apnsContent = @"发来了一段视频";
    return message;
}


+ (NIMMessage*)msgWithJenKenPon:(NTESJanKenPonAttachment *)attachment
{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了猜拳信息";
    return message;
}

+ (NIMMessage*)msgWithSnapchatAttachment:(NTESSnapchatAttachment *)attachment
{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了阅后即焚";
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.historyEnabled = NO;
    setting.roamingEnabled = NO;
    setting.syncEnabled    = NO;
    message.setting = setting;
    
    return message;
}


+ (NIMMessage*)msgWithFilePath:(NSString*)path{
    NIMFileObject *fileObject = [[NIMFileObject alloc] initWithSourcePath:path];
    NSString *displayName     = path.lastPathComponent;
    fileObject.displayName    = displayName;
    NIMMessage *message       = [[NIMMessage alloc] init];
    message.messageObject     = fileObject;
    message.apnsContent = @"发来了一个文件";
    return message;
}

+ (NIMMessage*)msgWithFileData:(NSData*)data extension:(NSString*)extension{
    NIMFileObject *fileObject = [[NIMFileObject alloc] initWithData:data extension:extension];
    NSString *displayName;
    if (extension.length) {
        displayName     = [NSString stringWithFormat:@"%@.%@",[NSUUID UUID].UUIDString.MD5String,extension];
    }else{
        displayName     = [NSString stringWithFormat:@"%@",[NSUUID UUID].UUIDString.MD5String];
    }
    fileObject.displayName    = displayName;
    NIMMessage *message       = [[NIMMessage alloc] init];
    message.messageObject     = fileObject;
    message.apnsContent = @"发来了一个文件";
    return message;
}


+ (NIMMessage*)msgWithChartletAttachment:(NTESChartletAttachment *)attachment{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"[贴图]";
    return message;
}

+ (NIMMessage*)msgWithWhiteboardAttachment:(NTESWhiteboardAttachment *)attachment
{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    message.setting            = setting;

    return message;
}


+ (NIMMessage *)msgWithTip:(NSString *)tip
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMTipObject *tipObject    = [[NIMTipObject alloc] init];
    message.messageObject      = tipObject;
    message.text               = tip;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    setting.shouldBeCounted    = NO;
    message.setting            = setting;
    return message;
}


+ (NIMMessage *)msgWithRedPacket:(NTESRedPacketAttachment *)attachment
{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    
    message.apnsContent = @"发来了一个红包";
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.historyEnabled     = NO;
    message.setting            = setting;

    return message;
}

+ (NIMMessage *)msgWithRedPacketTip:(NTESRedPacketTipAttachment *)attachment
{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;

    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    setting.shouldBeCounted    = NO;
    setting.historyEnabled     = NO;
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


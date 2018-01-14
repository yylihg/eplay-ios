//
//  NTESUserUtil.m
//  NIM
//
//  Created by chris on 15/9/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESUserUtil.h"
#import "NIMKitUtil.h"
#import "NTESDataManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+NTES.h"
#import "NTESCustomKeyDefine.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveManager.h"
#import "NTESBundleSetting.h"

@implementation NTESUserUtil

+ (NSString *)showName:(NSString *)userId
           withMessage:(NIMMessage *)message
{
    NTESDataUser * user = [[NTESDataManager sharedInstance] infoByUser:userId withMessage:message];
    return user.showName;
}

+ (NSString *)genderString:(NIMUserGender)gender{
    NSString *genderStr = @"";
    switch (gender) {
        case NIMUserGenderMale:
            genderStr = @"男";
            break;
        case NIMUserGenderFemale:
            genderStr = @"女";
            break;
        case NIMUserGenderUnknown:
            genderStr = @"未知";
        default:
            break;
    }
    return genderStr;
}

+ (void)requestMediaCapturerAccess:(NIMNetCallMediaType)type handler:(void (^)(NSError *))handler{
    [NTESUserUtil requestAuidoAccessWithHandler:^(NSError *error) {
        if (!error && type == NIMNetCallMediaTypeVideo)
        {
            [NTESUserUtil requestVideoAccessWithHandler:^(NSError *error) {
                handler(error);
            }];
        }
        else
        {
            handler(error);
        }
    }];
}

+ (void)requestVideoAccessWithHandler:(void (^)(NSError *))handler
{
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus) {
        handler(nil);
    }else{
        if (AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问摄像头，请设置", @"此应用需要访问摄像头，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(error);
        }
        else
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(nil);
                    });
                }else{
                    NSString *errMsg = NSLocalizedString(@"不允许访问摄像头", @"不允许访问摄像头");
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                    NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(error);
                    });
                }
            }];
        }
        
    }
}

+ (void)requestAuidoAccessWithHandler:(void (^)(NSError *))handler
{
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        handler(nil);
    }else{
        if (AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus) {
            NSString *errMsg = NSLocalizedString(@"此应用需要访问麦克风，请设置", @"此应用需要访问麦克风，请设置");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
            NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
            handler(error);
        }else{
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(nil);
                    });
                }else{
                    NSString *errMsg = NSLocalizedString(@"不允许访问麦克风", @"不允许访问麦克风");
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                    NSError *error = [NSError errorWithDomain:@"访问权限" code:0 userInfo:userInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(error);
                    });
                }
            }];
        }
    }
}


+ (NSString *)meetingName:(NIMChatroom *)chatroom
{
    NSString *ext = chatroom.ext;
    id object = [ext jsonObject];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSString *meetingName = [[ext jsonObject] jsonString:NTESCMMeetingName];
        return meetingName;
    }
    return nil;
}

+ (NIMNetCallOption *)fillNetCallOption:(NIMNetCallMeeting *)meeting{
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.preferHDAudio = [[NTESBundleSetting sharedConfig] preferHDAudio];
    option.scene = [[NTESBundleSetting sharedConfig] scene];
    option.autoRotateRemoteVideo = NO;
    option.enableBypassStreaming = YES;
    option.bypassStreamingMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
    option.bypassStreamingMixCustomLayoutConfig = [[NTESBundleSetting sharedConfig] bypassVideoMixCustomLayoutConfig];
    option.bypassStreamingServerRecording = [[NTESBundleSetting sharedConfig] bypassStreamingServerRecord];
    option.webrtcCompatible = [[NTESBundleSetting sharedConfig] webrtcCompatible];
    meeting.option = option;
    return option;
}

+ (NIMNetCallVideoCaptureParam *)videoCaptureParam
{
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
    param.preferredVideoQuality = [NTESUserUtil defaultVideoQuality];
    param.videoFrameRate = NIMNetCallVideoFrameRate25FPS;
    param.format = [[NTESBundleSetting sharedConfig] videoCaptureFormat];
    param.provideLocalVideoProcess = YES;
    
    return param;
}

+ (NIMNetCallVideoQuality)defaultVideoQuality
{
    return [NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityNormal? NIMNetCallVideoQualityDefault : NIMNetCallVideoQuality540pLevel;
}

@end

//
//  ReactIMModule.m
//  LoveForMusic
//
//  Created by yyl ihg on 2017/12/31.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "ReactIMModule.h"

#import "NTESSessionViewController.h"
#import "NTESAnchorPreviewController.h"
//#import "NTESLiveStreamVC.h"
//#import "NTESChatroomDataCenter.h"

//#import "NTESLiveDataCenter.h"
//#import "NTESChatroomManger.h"
//#import "NTESEncryption.h"
#import "NTESLiveManager.h"
#import "NTESAudienceLiveViewController.h"

@implementation ReactIMModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(
                  pushSessionController:(NSString *)uid
                  )
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NIMSession *session = [NIMSession session:uid type:NIMSessionTypeP2P];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:vc animated:YES];
        
    });
}

RCT_EXPORT_METHOD(
                  pushTeamSessionController:(NSString *)teamid
                  )
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NIMSession *session = [NIMSession session:teamid type:NIMSessionTypeTeam];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:vc animated:YES];
        
    });
}

RCT_EXPORT_METHOD(pushLiveController:(NSString *)roomId pushUrl:(NSString *)pushUrl)
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
        [NTESLiveManager sharedInstance].liveQuality = NTESLiveQualityHigh;
        
        NTESAnchorPreviewController *vc = [[NTESAnchorPreviewController alloc]init];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NIMChatroom *chatroom = [[NIMChatroom alloc]init];
        chatroom.roomId = roomId;
        chatroom.broadcastUrl = pushUrl;
        vc.chatroom = chatroom;
        [app.nav pushViewController:vc animated:YES];
    });
}


RCT_EXPORT_METHOD(pushLivePlayController:(NSString *)roomId playUrl:(NSString *)playUrl)
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [NTESLiveManager sharedInstance].orientation = orientation;
        [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
        [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;
        [NTESLiveManager sharedInstance].liveQuality = NTESLiveQualityHigh;
        NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:roomId streamUrl:playUrl];
          AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [app.nav pushViewController:vc animated:YES];
    });
}




@end

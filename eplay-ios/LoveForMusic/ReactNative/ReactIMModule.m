//
//  ReactIMModule.m
//  LoveForMusic
//
//  Created by yyl ihg on 2017/12/31.
//  Copyright © 2017年 wbk. All rights reserved.
//

#import "ReactIMModule.h"

#import "NTESSessionViewController.h"
#import "NTESLiveStreamVC.h"
#import "NTESChatroomDataCenter.h"

#import "NTESLiveDataCenter.h"
#import "NTESChatroomManger.h"
#import "NTESEncryption.h"
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
     
        
        NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
        request.roomId = roomId;
        [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {

            if (!error)
            {
                NSLog(@"[NTES_IM_Demo] >>> 进入聊天室成功!");

                //缓存数据
                [NTESChatroomDataCenter sharedInstance].currentRoomId = request.roomId;
                [[NTESChatroomDataCenter sharedInstance] cacheAnchorInfo:me roomId:request.roomId];
                [[NTESChatroomDataCenter sharedInstance] cacheMyInfo:me roomId:request.roomId];
                [[NTESChatroomDataCenter sharedInstance] cacheChatroom:chatroom];
                
                
                NTESLiveStreamVC *push = [[NTESLiveStreamVC alloc] initWithChatroomId:roomId];
                push.pushUrl = pushUrl;
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [app.nav pushViewController:push animated:YES];
            }
            else
            {
                NSLog(@"[NTES_IM_Demo] >>> 进入聊天室失败，%zi", error.code);
            }

//            if (complete) {
//                complete(error, roomId);
//            }
        }];
        
        
//        NTESLiveStreamVC *push = [[NTESLiveStreamVC alloc] initWithChatroomId:roomId];
//        push.pushUrl = pushUrl;
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [app.nav pushViewController:push animated:YES];
    });
}




@end

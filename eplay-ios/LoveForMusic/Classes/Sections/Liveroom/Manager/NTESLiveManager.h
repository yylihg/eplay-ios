//
//  NTESChatroomManager.h
//  NIM
//
//  Created by chris on 16/1/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESService.h"
#import "NTESLiveViewDefine.h"

@class NTESPresent;
@class NTESPresentItem;
@class NTESMicConnector;

@interface NTESLiveManager : NTESService

//直播中的角色
@property (nonatomic, assign) NTESLiveRole role;

//目前直播间的类型
@property (nonatomic, assign) NTESLiveType type;

//目前直播间直播画面质量，仅视频直播有效
@property (nonatomic, assign) NTESLiveQuality liveQuality;

//请求直播方向
@property (nonatomic, assign) NIMVideoOrientation requestOrientation;

//目前直播方向
@property (nonatomic, assign) NIMVideoOrientation orientation;

//连麦用户
@property (nonatomic, strong) NTESMicConnector *connectorOnMic;

//目前互动直播的类型，为连麦者本身的属性
@property (nonatomic, assign) NIMNetCallMediaType bypassType;

//聊天室信息
- (NIMChatroom *)roomInfo:(NSString *)roomId;

//我在聊天室内的信息
- (NIMChatroomMember *)myInfo:(NSString *)roomId;

//聊天室的主播信息
- (void)anchorInfo:(NSString *)roomId handler:(void(^)(NSError *,NIMChatroomMember *))handler;

//缓存我的聊天室个人信息
- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId;

//缓存聊天室信息
- (void)cacheChatroom:(NIMChatroom *)chatroom;

//礼物信息
- (NSDictionary *)presents;

//我收到的礼物
- (NSArray<NTESPresentItem *> *)myPresentBox;


//-----------------以下接口只对主播有效------------------//
//更新连麦者
- (void)updateConnectors:(NTESMicConnector *)connector;

//移除连麦者
- (void)removeConnectors:(NSString *)uid;

//移除所有连麦者
- (void)removeAllConnectors;

//获取连麦者
- (NTESMicConnector *)findConnector:(NSString *)uid;

//获取某一状态下的连麦者
- (NSArray<NTESMicConnector *> *)connectors:(NTESLiveMicState)state;

@end

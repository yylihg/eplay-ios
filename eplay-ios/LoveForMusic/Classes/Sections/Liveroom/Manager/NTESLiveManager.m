//
//  NTESChatroomManager.m
//  NIM
//
//  Created by chris on 16/1/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveManager.h"
#import "NSDictionary+NTESJson.h"
#import "NTESChatroomMaker.h"
#import "NTESPresent.h"
#import "NTESFileLocationHelper.h"
#import "NTESPresentAttachment.h"
#import "NTESPresentItem.h"
#import "NTESMicConnector.h"

@interface NTESLiveManager()<NIMChatManagerDelegate>

@property (nonatomic,strong) NSMutableDictionary *chatrooms;

@property (nonatomic,strong) NSMutableDictionary *myInfo;

@property (nonatomic,strong) NSMutableDictionary *anchorInfo;

@property (nonatomic,strong) NSMutableArray<NTESPresentItem *> *presentBox; //收到的礼物信息

@property (nonatomic, strong) NSMutableArray<NTESMicConnector *> *connectors; //连麦队列

@end

@implementation NTESLiveManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chatrooms = [[NSMutableDictionary alloc] init];
        _myInfo = [[NSMutableDictionary alloc] init];
        _anchorInfo = [[NSMutableDictionary alloc] init];
        _connectors = [[NSMutableArray alloc] init];
        [self unarchivePresentBox];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [self archivePresentBox];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}


- (NIMChatroomMember *)myInfo:(NSString *)roomId
{
    NIMChatroomMember *member = _myInfo[roomId];
    return member;
}

- (void)anchorInfo:(NSString *)roomId handler:(void(^)(NSError *,NIMChatroomMember *))handler
{
    if (!handler) {
        return;
    }
    NIMChatroomMember *member = _anchorInfo[roomId];
    if (member) {
        handler(nil,member);
        return;
    }
    NIMChatroom *chatroom = self.chatrooms[roomId];
    if (chatroom) {
        NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
        requst.roomId = roomId;
        requst.userIds = @[chatroom.creator];
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError *error, NSArray *members) {
            handler(error,members.firstObject);
        }];
    }
}


- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId
{
    [_myInfo setObject:info forKey:roomId];
}

- (void)cacheChatroom:(NIMChatroom *)chatroom{
    [_chatrooms setObject:chatroom forKey:chatroom.roomId];
}

- (NIMChatroom *)roomInfo:(NSString *)roomId
{
    return _chatrooms[roomId];
}

- (NSArray<NTESPresentItem *> *)myPresentBox
{
    return self.presentBox;
}

- (void)savePresent:(NSInteger)presentType
              count:(NSInteger)count
{
    NTESPresentItem *presentItem;
    for (NTESPresentItem *item in self.presentBox) {
        if (item.type == presentType) {
            presentItem = item;
            break;
        }
    }
    if (!presentItem) {
        presentItem = [[NTESPresentItem alloc] init];
        presentItem.type  = presentType;
        [self.presentBox addObject:presentItem];
    }
    presentItem.count++;
}

- (void)unarchivePresentBox
{
    NSString *filepath = self.presentBoxDataPath;
    NSArray *array= @[];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        array = [object isKindOfClass:[NSArray class]] ? object : @[];
    }
    self.presentBox = [array mutableCopy];
}

- (void)archivePresentBox
{
    NSData *data = [NSData data];
    if (self.presentBox)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:self.presentBox];
    }
    [data writeToFile:[self presentBoxDataPath] atomically:YES];
}

- (NSString *)presentBoxDataPath
{
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSString *path = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:[@"present_box_data_" stringByAppendingString:currentUserId]];
    return path;
}

- (NSDictionary *)presents
{
    static NSMutableDictionary *presents;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        presents = [[NSMutableDictionary alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Presents" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        for (NSString *key in dict) {
            NSDictionary *p = dict[key];
            NTESPresent *present = [[NTESPresent alloc] init];
            present.type = key.integerValue;
            present.name = p[@"name"];
            present.icon = p[@"icon"];
            [presents setObject:present forKey:key];
        }
    });
    return presents;
}

- (void)onEnterBackground
{
    [self archivePresentBox];
}
- (void)onAppWillTerminate
{
    [self archivePresentBox];
}


- (void)updateConnectors:(NTESMicConnector *)connector
{
    NTESMicConnector *localCon = [self findConnector:connector.uid];
    if (!localCon)
    {
        [self.connectors addObject:connector];
    }
    else
    {
        localCon.state = connector.state;
    }
}

- (void)removeConnectors:(NSString *)uid
{
    NTESMicConnector *connector = [self findConnector:uid];
    if (connector) {
        [self.connectors removeObject:connector];
    }
}

- (void)removeAllConnectors
{
    [self.connectors removeAllObjects];
}

- (NTESMicConnector *)findConnector:(NSString *)uid
{
    for (NTESMicConnector *connector in self.connectors) {
        if ([connector.uid isEqualToString:uid]) {
            return connector;
        }
    }
    return nil;
}

- (NSArray<NTESMicConnector *> *)connectors:(NTESLiveMicState)state
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NTESMicConnector *connector in self.connectors) {
        if (connector.state == state) {
            [result addObject:connector];
        }
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray *)messages
{
    for (NIMMessage *message in messages) {
        NSString *room = message.session.sessionId;
        NIMChatroomMember *member = [self myInfo:room];
        NIMCustomObject *object = message.messageObject;
        if (member.type == NIMChatroomMemberTypeCreator && [object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[NTESPresentAttachment class]]) {
            NTESPresentAttachment *attach = object.attachment;
            [self savePresent:attach.presentType count:attach.count];
        }
    }
}


#pragma mark - Private
- (void)setConnectorOnMic:(NTESMicConnector *)connectorOnMic
{
    if (![_connectorOnMic.uid isEqualToString:connectorOnMic.uid]) {
        DDLogInfo(@"connector on mic changed %@ -> %@",_connectorOnMic.uid,connectorOnMic.uid);
    }
    _connectorOnMic = connectorOnMic;
}

@end

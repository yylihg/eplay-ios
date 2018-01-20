//
//  NTESDemoService.m
//  NIM
//
//  Created by amao on 1/20/16.
//  Copyright © 2016 Netease. All rights reserved.
//

#import "NTESDemoService.h"

@interface NTESDemoService ()
@property (nonatomic,strong)    NSURLSession    *session;
@end

@implementation NTESDemoService

+ (instancetype)sharedService
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}


- (void)registerUser:(NTESRegisterData *)data
          completion:(NTESRegisterHandler)completion
{
    NTESDemoRegisterTask *task = [[NTESDemoRegisterTask alloc] init];
    task.data = data;
    task.handler = completion;
    [self runTask:task];
}

- (void)fetchDemoChatrooms:(NTESChatroomListHandler)completion
{
    NTESDemoFetchChatroomTask *task = [[NTESDemoFetchChatroomTask alloc] init];
    task.handler = completion;
    [self runTask:task];
}


- (void)runTask:(id<NTESDemoServiceTask>)task
{
    if ([[NIMSDK sharedSDK] isUsingDemoAppKey])
    {
        NSURLRequest *request = [task taskRequest];
    
        NSURLSessionTask *sessionTask = [_session dataTaskWithRequest:request
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
                                                        id jsonObject = nil;
                                                        NSError *error = connectionError;
                                                        if (connectionError == nil &&
                                                            [response isKindOfClass:[NSHTTPURLResponse class]] &&
                                                            [(NSHTTPURLResponse *)response statusCode] == 200)
                                                        {
                                                            if (data)
                                                            {
                                                                jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:0
                                                                                                               error:&error];
                                                            }
                                                            else
                                                            {
                                                                error = [NSError errorWithDomain:@"ntes domain"
                                                                                            code:-1
                                                                                        userInfo:@{@"description" : @"invalid data"}];
                                                                
                                                            }
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [task onGetResponse:jsonObject
                                                                          error:error];
                                                        });
                                                        
                     
                                              }];
        [sessionTask resume];
    }
    else
    {
        //Demo Service中我们模拟了APP服务器所应该实现的部分功能，上层开发需要构建相应的APP服务器，而不是直接使用我们的DEMO服务器
        [task onGetResponse:nil
                      error:[NSError errorWithDomain:@"ntes domain"
                                                code:-1
                                            userInfo:@{@"description" : @"use your own app server"}]];
    }
}




- (void)requestLiveStream:(NSString *)identity
               completion:(NTESChatroomStreamUrlHandler)completion
{
    NTESDemoLiveroomTask *task = [[NTESDemoLiveroomTask alloc] init];
    task.identity = identity;
    task.handler = completion;
    [self runTask:task];
}


- (void)requestPlayStream:(NSString *)roomId
               completion:(NTESPlayStreamQueryHandler)completion
{
    NTESDemoPlayStreamQueryTask *task = [[NTESDemoPlayStreamQueryTask alloc] init];
    task.roomId  = roomId;
    task.handler = completion;
    [self runTask:task];
}

- (void)requestMicQueuePush:(NTESQueuePushData *)data
                 completion:(NTESDemoLiveMicQueuePushHandler)completion
{
    NTESDemoLiveMicQueuePushTask *task = [[NTESDemoLiveMicQueuePushTask alloc] init];
    task.roomId = data.roomId;
    task.ext = data.ext;
    task.uid = data.uid;
    task.handler = completion;
    [self runTask:task];
}

- (void)requestMicQueuePop:(NTESQueuePopData *)data
                completion:(NTESDemoLiveMicQueuePopHandler)completion
{
    if (!data.uid) {
        return;
    }
    NTESDemoLiveMicQueuePopTask *task = [[NTESDemoLiveMicQueuePopTask alloc] init];
    task.roomId = data.roomId;
    task.uid = data.uid;
    task.handler = completion;
    [self runTask:task];
}

@end

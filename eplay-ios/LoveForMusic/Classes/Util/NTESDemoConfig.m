//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"

@interface NTESDemoConfig ()

@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appKey = @"12ccc6179640608b6afad5d625d5a3c8";
        _apiURL = @"https://app.netease.im/appdemo";
        _apnsCername = @"ENTERPRISE";
        _pkCername = @"DEMO_PUSH_KIT";
        _shortVideoAppKey = @"d49345914660a3af65e7fa287ec90e6b";
        
        _redPacketConfig = [[NTESRedPacketConfig alloc] init];        
    }
    return self;
}

- (NSString *)appKey
{
    return _appKey;
}


- (NSString *)cerName
{
    return nil;
}

- (NSString *)apiURL
{
//    NSAssert([[NIMSDK sharedSDK] isUsingDemoAppKey], @"只有 demo appKey 才能够使用这个API接口");
    return _apiURL;
}

- (void)registerConfig:(NSDictionary *)config
{
    if (config[@"red_packet_online"])
    {
        _redPacketConfig.useOnlineEnv = [config[@"red_packet_online"] boolValue];
    }
}


@end



@implementation NTESRedPacketConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _useOnlineEnv = YES;
        _aliPaySchemeUrl = @"alipay052969";
        _weChatSchemeUrl = @"wx2a5538052969956e";
    }
    return self;
}

@end

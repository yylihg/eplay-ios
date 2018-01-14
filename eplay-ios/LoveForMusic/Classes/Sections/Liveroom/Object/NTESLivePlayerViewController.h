//
//  NTESLivePlayerViewController.h
//  NIMLiveDemo
//
//  Created by chris on 16/3/2.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NELivePlayer.h"

typedef void(^NTESLivePlayerShutdownHandler)(void);

@protocol NTESLivePlayerViewControllerDelegate <NSObject>

- (void)onToggleScaleMode:(BOOL)fullScreen;

@end

@interface NTESLivePlayerViewController : UIViewController

@property (nonatomic,readonly) id<NELivePlayer> player;

@property (nonatomic,weak) id<NTESLivePlayerViewControllerDelegate> delegate;

- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view;

- (void)shutdown:(NTESLivePlayerShutdownHandler)handler;

@end


///播放器第一帧视频显示时的消息通知
extern NSString *const NTESLivePlayerFirstVideoDisplayedNotification;
///播放器第一帧音频播放时的消息通知
extern NSString *const NTESLivePlayerFirstAudioDisplayedNotification;
///播放器准备播放通知
extern NSString *const NTESLivePlayerDidPreparedToPlayNotification;
///播放器加载状态发生改变时的消息通知
extern NSString *const NTESLivePlayerLoadStateChangedNotification;
///播放器播放完成或播放发生错误时的消息通知
extern NSString *const NTESLivePlayerPlaybackFinishedNotification;
///播放器播放状态发生改变时的消息通知
extern NSString *const NTESLivePlayerPlaybackStateChangedNotification;

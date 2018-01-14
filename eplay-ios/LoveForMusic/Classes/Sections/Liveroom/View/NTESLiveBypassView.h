//
//  NTESLiveBypassView.h
//  NIMLiveDemo
//
//  Created by chris on 16/7/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTESMicConnector;

typedef NS_ENUM(NSInteger, NTESLiveBypassViewStatus){
    NTESLiveBypassViewStatusNone,
    NTESLiveBypassViewStatusPlaying,
    NTESLiveBypassViewStatusPlayingAndBypassingAudio,
    NTESLiveBypassViewStatusLoading,
    NTESLiveBypassViewStatusStreamingVideo,
    NTESLiveBypassViewStatusStreamingAudio,
    NTESLiveBypassViewStatusLocalVideo,
    NTESLiveBypassViewStatusLocalAudio,
    NTESLiveBypassViewStatusExitConfirm,
};

@protocol NTESLiveBypassViewDelegate <NSObject>

- (void)didConfirmExitBypass;

@end

@interface NTESLiveBypassView : UIView

@property (nonatomic,weak) id<NTESLiveBypassViewDelegate> delegate;

- (void)refresh:(NTESMicConnector *)connector status:(NTESLiveBypassViewStatus)status;

- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height;

@end

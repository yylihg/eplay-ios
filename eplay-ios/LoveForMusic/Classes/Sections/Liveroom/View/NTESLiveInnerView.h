//
//  NTESLiveInnerView.h
//  NIMLiveDemo
//
//  Created by chris on 16/4/4.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NELivePlayer.h"
#import "NTESLiveViewDefine.h"

@class NTESMicConnector;

@protocol NTESLiveInnerViewDelegate <NSObject>

@optional

- (void)onCloseLiving;
- (void)onClosePlaying;
- (void)onCloseBypassing;
- (void)onActionType:(NTESLiveActionType)type sender:(id)sender; //点击InnerView上的按钮
- (void)didSendText:(NSString *)text;
- (void)onTapChatView:(CGPoint)point;

@end

@protocol NTESLiveInnerViewDataSource <NSObject>

- (id<NELivePlayer>)currentPlayer;

@end

@interface NTESLiveInnerView : UIView

@property (nonatomic,weak) id<NTESLiveInnerViewDelegate> delegate;

@property (nonatomic,weak) id<NTESLiveInnerViewDataSource> dataSource;

- (instancetype)initWithChatroom:(NSString *)chatroomId
                           frame:(CGRect)frame;

- (void)refreshChatroom:(NIMChatroom *)chatroom;

- (void)addMessages:(NSArray<NIMMessage *> *)messages;

- (void)addPresentMessages:(NSArray<NIMMessage *> *)messages;

- (void)fireLike;

- (void)resetZoomSlider;

- (CGFloat)getActionViewHeight;

- (void)updateNetStatus:(NIMNetCallNetStatus)status;

- (void)updateUserOnMic;

- (void)updateBeautify:(BOOL)isBeautify;

- (void)updateQualityButton:(BOOL)isHigh;

- (void)updateWaterMarkButton:(BOOL)isOn;

- (void)updateflashButton:(BOOL)isOn;

- (void)updateFocusButton:(BOOL)isOn;

- (void)updateMirrorButton:(BOOL)isOn;

- (void)updateConnectorCount:(NSInteger)count;

- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height;

- (void)switchToWaitingUI;

- (void)switchToPlayingUI;

- (void)switchToLinkingUI;

- (void)switchToEndUI;

- (void)switchToBypassStreamingUI:(NTESMicConnector *)connector;

- (void)switchToBypassingUI:(NTESMicConnector *)connector;

- (void)switchToBypassLoadingUI:(NTESMicConnector *)connector;

- (void)switchToBypassExitConfirmUI;

@end

//
//  NTESLiveAnchorHandler.h
//  NIMLiveDemo
//
//  Created by chris on 16/8/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESLiveAnchorHandlerDelegate <NSObject>

- (void)didUpdateConnectors;

@end

@interface NTESLiveAnchorHandler : NSObject

@property (nonatomic,weak) id<NTESLiveAnchorHandlerDelegate> delegate;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;

- (void)dealWithBypassCustomNotification:(NIMCustomSystemNotification *)notification;

@end

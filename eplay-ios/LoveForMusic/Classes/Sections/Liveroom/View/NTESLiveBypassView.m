//
//  NTESLiveBypassView.m
//  NIMLiveDemo
//
//  Created by chris on 16/7/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveBypassView.h"
#import "NTESGLView.h"
#import "UIView+NTES.h"
#import "NIMAvatarImageView.h"
#import "NTESMicConnector.h"
#import "NTESLiveManager.h"
static const CGSize  NTESLiveByPassDefaultSize  = { 100, 170 };
static const CGSize  NTESLiveByPassOrientationRightSize  = { 170, 100 };


@interface NTESLiveBypassLoadingView : UIView
@property (nonatomic,strong) NIMAvatarImageView *avatar;
@property (nonatomic,strong) UILabel *nickLabel;
@property (nonatomic,strong) UILabel *statusLabel;

- (void)refresh:(NTESMicConnector *)connector;

@end

@interface NTESLiveBypassExitConfirmView : UIView
@property (nonatomic,strong) UILabel   *titleLabel;
@property (nonatomic,strong) UIView    *topSeperator;
@property (nonatomic,strong) UIView    *bottomSeperator;
@property (nonatomic,strong) UIButton  *confirmButton;
@property (nonatomic,strong) UIButton  *cancelButton;
@end

@interface NTESLiveBypassEndView : UIView
@property (nonatomic,strong) NIMAvatarImageView *avatar;
@property (nonatomic,strong) UILabel *nickLabel;
@property (nonatomic,strong) UILabel *statusLabel;

- (void)refresh:(NTESMicConnector *)connector;

@end

@interface NTESLiveBypassView()<NIMNetCallManagerDelegate>
{
    UIView * localPreView;
}

@property (nonatomic, assign) NTESLiveBypassViewStatus status;
@property (nonatomic, assign) NTESLiveBypassViewStatus lastStatus; //上一次的状态，用来转到confirm cancel后的恢复

@property (nonatomic, strong) UIView       *localVideoView;

@property (nonatomic, strong) UIImageView *localAudioView;
@property (nonatomic, strong) NTESGLView  *glView;
@property (nonatomic, strong) NTESLiveBypassExitConfirmView *exitConfirmView;
@property (nonatomic, strong) NTESLiveBypassLoadingView *loadingView;
@property (nonatomic, strong) NTESLiveBypassEndView *endView;
@property (nonatomic, strong) UIButton    *stopBypassButton; //结束互动直播按钮

@end

@implementation NTESLiveBypassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
        for (UIView *subView in self.subviews) {
            subView.hidden = YES;
        }
        
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];

        [_localAudioView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setup
{
    _localVideoView = [[UIView alloc] initWithFrame:CGRectZero];
    _localVideoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_glview_background"]];
    _localVideoView.contentMode = UIViewContentModeScaleAspectFill;
    
    _localAudioView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *image1 = [UIImage imageNamed:@"icon_mic_audience_1"];
    UIImage *image2 = [UIImage imageNamed:@"icon_mic_audience_2"];
    UIImage *image3 = [UIImage imageNamed:@"icon_mic_audience_3"];
    _localAudioView = [[UIImageView alloc] initWithImage:image1];
    [_localAudioView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_mic_audience_bkg"]]];
    _localAudioView.contentMode = UIViewContentModeCenter;
    _localAudioView.animationDuration = 1.2f;
    _localAudioView.animationImages = @[image1,image2,image3];
    
    _glView = [[NTESGLView alloc] initWithFrame:CGRectZero];
    _glView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_glview_background"]];
    _glView.contentMode = UIViewContentModeScaleAspectFill;
    _exitConfirmView = [[NTESLiveBypassExitConfirmView alloc] initWithFrame:CGRectMake(0,0,[self getSize].width,[self getSize].height)];
    [_exitConfirmView.confirmButton addTarget:self action:@selector(confirmExit:) forControlEvents:UIControlEventTouchUpInside];
    [_exitConfirmView.cancelButton addTarget:self action:@selector(cancelExit:) forControlEvents:UIControlEventTouchUpInside];
    
    _loadingView = [[NTESLiveBypassLoadingView alloc] initWithFrame:CGRectZero];
    
    _endView = [[NTESLiveBypassEndView alloc] initWithFrame:CGRectZero];
    
    _stopBypassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stopBypassButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
    [_stopBypassButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    _stopBypassButton.size = CGSizeMake(44, 44);
    [_stopBypassButton addTarget:self action:@selector(stopBypassingConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self addSubview:_localVideoView];
    [self addSubview:_localAudioView];
    [self addSubview:_glView];
    [self addSubview:_exitConfirmView];
    [self addSubview:_loadingView];
    [self addSubview:_endView];
    [self addSubview:_stopBypassButton];
}

- (void)dealloc
{
    [_localAudioView removeObserver:self forKeyPath:@"hidden"];
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];

}

-(void)onLocalDisplayviewReady:(UIView *)displayView
{
    if (localPreView) {
        [localPreView removeFromSuperview];
    }
    localPreView = displayView;
    displayView.frame = _localVideoView.bounds;
    [self.localVideoView addSubview:displayView];
}

- (CGSize)getSize
{
    //使用设备角度
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (orientation == UIInterfaceOrientationLandscapeRight) {
        [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationLandscapeRight;
        return NTESLiveByPassOrientationRightSize;
    }
    else
        return NTESLiveByPassDefaultSize;

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hidden"]) {
        BOOL hidden = [change[@"new"] boolValue];
        if (hidden)
        {
            [self.localAudioView stopAnimating];
        }
        else
        {
            [self.localAudioView startAnimating];
        }
    }
}


- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
{
    self.backgroundColor = UIColorFromRGBA(0x0,.2);
    [self.glView render:yuvData width:width height:height];
}

- (void)refresh:(NTESMicConnector *)connector status:(NTESLiveBypassViewStatus)status
{
    self.status = status;
    [self.loadingView refresh:connector];
    [self.endView refresh:connector];
}

- (void)setStatus:(NTESLiveBypassViewStatus)status
{
    if (_status == status) {
        return;
    }
    _lastStatus = _status;
    _status = status;
    
    //清空并重置画面
    [_glView render:nil width:0 height:0];
    _glView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_glview_background"]];

    for (UIView *subView in self.subviews) {
        subView.hidden = YES;
    }
    
    self.size = [self getSize];

    switch (status) {
        case NTESLiveBypassViewStatusNone:
        case NTESLiveBypassViewStatusPlaying:
            self.hidden = YES;
            return;
        case NTESLiveBypassViewStatusPlayingAndBypassingAudio:
            self.localAudioView.hidden = NO;
            break;
        case NTESLiveBypassViewStatusLoading:
            self.loadingView.hidden = NO;
            self.stopBypassButton.hidden = NO;
            break;
        case NTESLiveBypassViewStatusStreamingVideo:
            self.glView.hidden = NO;
            self.stopBypassButton.hidden = NO;
            self.exitConfirmView.titleLabel.text = @"确定结束当前语音互动？";
            break;
        case NTESLiveBypassViewStatusStreamingAudio:
        case NTESLiveBypassViewStatusLocalAudio:
            self.localAudioView.hidden = NO;
            self.stopBypassButton.hidden = NO;
            
            break;
        case NTESLiveBypassViewStatusLocalVideo:
            self.localVideoView.hidden = NO;
            self.stopBypassButton.hidden = NO;
            break;
        case NTESLiveBypassViewStatusExitConfirm:
            self.exitConfirmView.hidden = NO;
            self.glView.hidden = YES;
            return;
        default:
            break;
    }
    self.hidden = NO;
}

- (void)stopBypassingConfirm:(id)sender
{
    [self setStatus:NTESLiveBypassViewStatusExitConfirm];
}

- (void)confirmExit:(id)sender
{
    [self setStatus:_lastStatus];
    if ([self.delegate respondsToSelector:@selector(didConfirmExitBypass)]) {
        [self.delegate didConfirmExitBypass];
    }
}

- (void)cancelExit:(id)sender
{
    [self setStatus:_lastStatus];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat maxWidth  = 100;
    CGFloat maxHeight = 170;
    CGFloat scaleW = size.width / maxWidth;
    CGFloat scaleH = size.height / maxHeight;
    CGFloat scale = scaleW > scaleH? scaleW : scaleH;
    
    return scale? CGSizeMake(size.width/scale, size.height/scale) : CGSizeMake(maxWidth, maxHeight);
}

- (void)injected
{
    [self setNeedsLayout];
}


- (void)layoutSubviews
{

    [super layoutSubviews];
    self.size = [self getSize];
    self.localVideoView.frame = self.bounds;
    self.localAudioView.frame = self.bounds;
    self.glView.frame = self.bounds;
    
    if (localPreView) {
        localPreView.frame = self.bounds;
    }
    
    self.exitConfirmView.width = self.width;
    self.exitConfirmView.height = self.height;
    self.exitConfirmView.bottom = self.height;
    self.exitConfirmView.right = self.width;
    self.loadingView.frame = self.bounds;
    self.endView.frame = self.bounds;
    
    self.stopBypassButton.right = self.width;
}


@end


@implementation NTESLiveBypassExitConfirmView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"确定结束当前视频互动？";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:UIColorFromRGB(0xff4055) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:_confirmButton];
        
        _cancelButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:UIColorFromRGB(0xff4055) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
        _topSeperator = [[UIView alloc] initWithFrame:CGRectZero];
        _topSeperator.backgroundColor = UIColorFromRGB(0xafa493);
        [self addSubview:_topSeperator];
        
        _bottomSeperator = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomSeperator.backgroundColor = UIColorFromRGB(0xafa493);
        [self addSubview:_bottomSeperator];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _topSeperator.size    = CGSizeMake(self.width, 0.5f);
    _bottomSeperator.size = CGSizeMake(self.width, 0.5f);
    
    CGFloat top = 22.f;
    if ([NTESLiveManager sharedInstance].orientation==NIMVideoOrientationLandscapeRight&&[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo) {
        
        _titleLabel.top = 0;
        _titleLabel.width = self.width;
        _titleLabel.height = self.height/3;
        _titleLabel.centerX = self.width * .5f;

        _cancelButton.width = self.width;
        _cancelButton.height = self.height/3;
        _cancelButton.bottom  = self.height;

        _confirmButton.width = self.width;
        _confirmButton.height = self.height/3;
        _confirmButton.bottom = _cancelButton.top;

        _topSeperator.bottom  = _confirmButton.top;
        _bottomSeperator.bottom = _cancelButton.top;

    }
    else
    {
        _titleLabel.size = CGSizeMake(78, 32);
        _titleLabel.top = top;
        _titleLabel.centerX = self.width * .5f;
        _cancelButton.size = CGSizeMake(100, 41);
        _cancelButton.bottom  = self.height;
        _confirmButton.size = CGSizeMake(100, 41);
        _confirmButton.bottom = _cancelButton.top;
        _topSeperator.bottom  = _confirmButton.top;
        _bottomSeperator.bottom = _cancelButton.top;
    }
    
    
    
}

@end


@implementation NTESLiveBypassLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:_avatar];
        
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickLabel.font = [UIFont systemFontOfSize:9];
        _nickLabel.textColor = UIColorFromRGB(0x999999);
        [self addSubview:_nickLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont systemFontOfSize:13.f];
        _statusLabel.text = @"正在连接中...";
        _statusLabel.textColor = UIColorFromRGB(0x333333);
        [_statusLabel sizeToFit];
        [self addSubview:_statusLabel];
        
    }
    return self;
}

- (void)refresh:(NTESMicConnector *)connector
{
    _nickLabel.text= connector.nick;
    [_nickLabel sizeToFit];
    
    [_avatar nim_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat avatarTop = 35.f;
    CGFloat nickAndAvatarSpacing = 2.f;
    CGFloat nickAndStatusSpacing = 24.f;
    self.avatar.top = avatarTop;
    self.avatar.centerX = self.width * .5f;
    self.nickLabel.top = self.avatar.bottom + nickAndAvatarSpacing;
    self.nickLabel.centerX = self.width * .5f;
    self.statusLabel.top = self.nickLabel.bottom + nickAndStatusSpacing;
    self.statusLabel.centerX = self.width * .5f;
}

@end

@implementation NTESLiveBypassEndView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:_avatar];
        
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickLabel.font = [UIFont systemFontOfSize:9];
        _nickLabel.textColor = UIColorFromRGB(0x999999);
        [self addSubview:_nickLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont systemFontOfSize:13.f];
        _statusLabel.text = @"视频连线结束";
        _statusLabel.textColor = UIColorFromRGB(0x333333);
        [_statusLabel sizeToFit];
        [self addSubview:_statusLabel];
        
        
    }
    return self;
}

- (void)refresh:(NTESMicConnector *)connector
{
    _nickLabel.text= connector.nick;
    [_nickLabel sizeToFit];
    
    [_avatar nim_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat avatarTop = 35.f;
    CGFloat nickAndAvatarSpacing = 2.f;
    CGFloat nickAndStatusSpacing = 24.f;
    self.avatar.top = avatarTop;
    self.avatar.centerX = self.width * .5f;
    self.nickLabel.top  = self.avatar.bottom + nickAndAvatarSpacing;
    self.nickLabel.centerX = self.width * .5f;
    self.statusLabel.top = self.nickLabel.bottom + nickAndStatusSpacing;
    self.statusLabel.centerX = self.width * .5f;
}
@end

//
//  NTESLiveActionView.m
//  NIM
//
//  Created by chris on 16/1/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveActionView.h"
#import "UIView+NTES.h"
#import "UIImage+NTESColor.h"
#import "NTESLiveManager.h"
#import "NTESLiveSelectButton.h"


#define numPerRowPortrait 5
#define numPerRowLandscapeRight 9


@interface NTESChatroomSegmentedItem : NSObject

@property (nonatomic, copy) NSString *showName;

@end


@interface NTESLiveActionView()<NTESPageViewDelegate,NTESPageViewDataSource>
{
    NSArray *_subviewsCache;
    NSMutableArray * _firstRowSubview;
    NSMutableArray * _secondRowSubview;
    NSMutableDictionary *_subviewIndexCache;
}

@property (nonatomic,assign) CGFloat padding;

@property (nonatomic,assign) CGFloat spacing;

@property (nonatomic,strong) UIButton *sharedButton;

@property (nonatomic,strong) UIButton *presentButton;

@property (nonatomic,strong) UIButton *likeButton;

@property (nonatomic,strong) UIButton *cameraButton;

@property (nonatomic,strong) UIButton *interactButton;

@property (nonatomic,strong) UIButton *beautifyButton;

@property (nonatomic,strong) UIButton *mixAudioButton;

@property (nonatomic,strong) UIButton *snapshotButton;

@property (nonatomic,strong) UIButton *actionViewUpButton;

@property (nonatomic,strong) UIButton *chatButton;

@property (nonatomic,strong) UIButton *flashButton;

@property (nonatomic,strong) UIButton *mirrorButton;

@property (nonatomic,strong) UIButton *waterMarkButton;

@property (nonatomic,strong) UIButton *cameraZoomButton;

@property (nonatomic,strong) UIButton *qualityButton;

@property (nonatomic,strong) UIButton *focusButton;

@property (nonatomic) NSInteger numPerRow;

@property (nonatomic) BOOL isViewMoveUp;

@property (nonatomic) BOOL isShowAnimation;

@property (nonatomic, copy)   NSArray<NTESChatroomSegmentedItem *> *segmentedItems;

@end




@implementation NTESLiveActionView

- (instancetype)initWithDataSource:(id<NTESLiveActionViewDataSource>)datasource
{
    self = [super init];
    if (self) {
        _datasource = datasource;
        [self addSubview:self.segmentedControl];
        [self addSubview:self.pageView];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)reloadData
{
    [self.pageView reloadData];
}


#pragma mark - Action Delegate

- (void)onSegmentControlChanged:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onSegmentControlChanged:)]) {
        [self.delegate onSegmentControlChanged:sender];
    }
}

- (void)onTap:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(onTouchActionBackground)]) {
        [self.delegate onTouchActionBackground];
    }
}


- (NSInteger)numberOfPages:(NTESPageView *)pageView
{
    return [self.datasource numberOfPages];
}

- (UIView *)pageView:(NTESPageView *)pageView viewInPage: (NSInteger)index
{
    return [self.datasource viewInPage:index];
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.segmentedControl.height = self.segmentedControlHeight;
//    CGFloat liveViewHeight       = [self.datasource liveViewHeight];
//    self.segmentedControl.top    = liveViewHeight;
//    CGFloat pageViewHeight       = self.height - liveViewHeight - self.segmentedControl.height;
//    self.pageView.height         = pageViewHeight;
//    self.pageView.bottom         = self.height;
//}



#pragma mark - Get

#define SegmentDefaultHeight   40.f

- (CGFloat)segmentedControlHeight
{
    return SegmentDefaultHeight;
}

- (NTESPageView *)pageView{
    if (!_pageView) {
        _pageView = [[NTESPageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _pageView.dataSource = self;
        _pageView.pageViewDelegate = self;
        _pageView.scrollView.scrollEnabled = NO;
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _pageView;
}

- (NTESChatroomSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[NTESChatroomSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.width,0)];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIImage *imageSelected = [[UIImage imageNamed:@"icon_chatroom_seg_bkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
        UIImage *imageNormal   = [[UIImage imageWithColor:[UIColor whiteColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
        for (NSInteger index = 0; index < self.segmentedItems.count; index++) {
            NTESChatroomSegmentedItem *item = self.segmentedItems[index];
            [_segmentedControl insertSegmentWithTitle:item.showName];
            [_segmentedControl setBackgroundImage:imageNormal forState:UIControlStateNormal atIndex:index];
            [_segmentedControl setBackgroundImage:imageNormal forState:UIControlStateHighlighted atIndex:index];
            [_segmentedControl setBackgroundImage:imageSelected forState:UIControlStateSelected atIndex:index];
            [_segmentedControl setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal atIndex:index];
            [_segmentedControl setTitleColor:UIColorFromRGB(0x238efa) forState:UIControlStateSelected atIndex:index];
            [_segmentedControl setFont:[UIFont systemFontOfSize:17.f] atIndex:index];
        }
        [_segmentedControl addTarget:self action:@selector(onSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


- (NSArray<NTESChatroomSegmentedItem *> *)segmentedItems{
    if (!_segmentedItems) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSString *showNameKey = @"showName";
        NSArray *vcs = @[
                         @{
                             showNameKey : @"直播互动"
                             },
                         @{
                             showNameKey : @"主播"
                             },
                         @{
                             showNameKey : @"在线成员"
                             },
                         ];
        for (NSDictionary *dict in vcs) {
            NTESChatroomSegmentedItem *item = [[NTESChatroomSegmentedItem alloc] init];
            item.showName = dict[showNameKey];
            [items addObject:item];
        }
        _segmentedItems = [NSArray arrayWithArray:items];
    }
    return _segmentedItems;
}




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _padding = 10.f;
        _spacing = 15.f;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor)
    {
        if ([NTESLiveManager sharedInstance].type == NTESLiveTypeAudio) {
            [self addSubview:self.chatButton];
            [self addSubview:self.presentButton];
            [self addSubview:self.interactButton];
            [self addSubview:self.cameraButton];
            [self addSubview:self.beautifyButton];
            [self addSubview:self.qualityButton];
            [self addSubview:self.mixAudioButton];
            [self addSubview:self.snapshotButton];
            [self addSubview:self.sharedButton];
            
        }
        else if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight)
        {
            [self addSubview:self.mirrorButton];
            [self addSubview:self.flashButton];
            [self addSubview:self.qualityButton];
            [self addSubview:self.cameraZoomButton];
            [self addSubview:self.beautifyButton];
            [self addSubview:self.cameraButton];
            [self addSubview:self.interactButton];
            [self addSubview:self.presentButton];
            [self addSubview:self.chatButton];
            
            //第一排
            [self addSubview:self.sharedButton];
            [self addSubview:self.snapshotButton];
            [self addSubview:self.mixAudioButton];
            [self addSubview:self.waterMarkButton];
            [self addSubview:self.focusButton];
            
            [self addSubview:self.actionViewUpButton];
        }
        else if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationPortrait)
        {
            //第三排
            [self addSubview:self.beautifyButton];
            [self addSubview:self.cameraButton];
            [self addSubview:self.interactButton];
            [self addSubview:self.presentButton];
            [self addSubview:self.chatButton];
            
            //第二排
            [self addSubview:self.focusButton];
            [self addSubview:self.mirrorButton];
            [self addSubview:self.flashButton];
            [self addSubview:self.qualityButton];
            [self addSubview:self.cameraZoomButton];
            
            //第一排
            [self addSubview:self.sharedButton];
            [self addSubview:self.snapshotButton];
            [self addSubview:self.mixAudioButton];
            [self addSubview:self.waterMarkButton];
            
            
            //最左边button 动画按钮
            [self addSubview:self.actionViewUpButton];
            
        }
        
    }
    else
    {
        
        [self addSubview:self.chatButton];
        [self addSubview:self.presentButton];
        [self addSubview:self.interactButton];
        [self addSubview:self.cameraButton];
        [self addSubview:self.sharedButton];
        [self addSubview:self.likeButton];
    }
    
    _subviewsCache = [NSArray arrayWithArray:self.subviews];
    _subviewIndexCache = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0;i < self.subviews.count;i++) {
        UIView *subview = self.subviews[i];
        _subviewIndexCache[@(subview.tag)] = @(i);
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, self.subviews.firstObject.height);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //音频模式or观众
    if ([NTESLiveManager sharedInstance].type == NTESLiveTypeAudio||[NTESLiveManager sharedInstance].role == NTESLiveRoleAudience)
    {
        [self layoutSubviewsWithAudioTypeOrAudience];
    }
    //横屏
    else  if([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight)
    {
        [self layoutSubviewsWithOrientatin:NIMVideoOrientationLandscapeRight];
    }
    //竖屏
    else
    {
        [self layoutSubviewsWithOrientatin:NIMVideoOrientationPortrait];
    }
}


- (void)layoutSubviewsWithOrientatin:(NIMVideoOrientation)orientation
{
    //基准View
    UIView * baseSubView ;
    if (orientation == NIMVideoOrientationPortrait) {
        _numPerRow = numPerRowPortrait;
        baseSubView = self.beautifyButton;
    }
    else
    {
        _numPerRow = numPerRowLandscapeRight;
        baseSubView = self.mirrorButton;
    }
    
    //行数
    NSInteger rowNum = [self calculateRowNum:_numPerRow];
    //第一行的个数
    NSInteger firstRowNum = [self calculateFirstRowNum:_numPerRow];
    
    CGFloat width = self.subviews.firstObject.width;
    CGFloat height = self.subviews.firstObject.height;
    CGFloat right = self.width - self.padding;
    
    //self frame
    if (_isViewMoveUp) {
        self.height = rowNum * width + (rowNum -1) * self.padding;
    }
    else
    {
        self.height = height;
    }
    self.bottom = self.superview.height - 10.f;
    
    //subviews frame
    for (NSInteger j = 0; j < rowNum; j++) {
        NSInteger numOfRow = j < rowNum - 1 ? _numPerRow : firstRowNum;
        for (NSInteger k = 0; k < numOfRow; k++) {
            NSInteger i = j * _numPerRow + k;
            UIView *subview = self.subviews[i];
            if (j == 0) {
                if (subview == baseSubView) {
                    subview.right = self.width - self.padding;
                    subview.bottom = self.height;
                }
                else
                {
                    right -= width + self.padding;
                    subview.right = right;
                    subview.bottom = self.height;
                }
            }
            else
            {
                //前一行的view
                UIView *preSubview = self.subviews[i - numOfRow];
                if (_isViewMoveUp) {
                    subview.centerX = preSubview.centerX;
                    subview.bottom = preSubview.top - self.padding;
                    subview.hidden = NO;
                }
                else
                {
                    subview.centerX = preSubview.centerX;
                    subview.centerY = preSubview.centerY;
                    //动画期间不要执行hidden
                    if (!_isShowAnimation) {
                        subview.hidden  = YES;
                    }
                }
            }
        }
    }
    
    //动画按钮 另行布局
    UIView *subview = self.subviews.lastObject;
    if (subview == self.actionViewUpButton) {
        subview.left = self.padding;
        subview.bottom = self.height;
    }
}

//返回行数
- (NSInteger)calculateRowNum:(NSInteger)numPerRow
{
    //动画按钮另行布局 这里减1
    NSInteger remainder = (self.subviews.count - 1) % numPerRow;
    NSInteger integer = (self.subviews.count - 1) / numPerRow;
    
    NSInteger row = integer;
    
    if (remainder > 0) {
        row ++ ;
    }
    return row;
}

//返回第一行个数
- (NSInteger)calculateFirstRowNum:(NSInteger)numPerRow
{
    NSInteger remainder = (self.subviews.count - 1) % numPerRow;
    NSInteger firstRowNum = remainder ? : numPerRow;
    
    return firstRowNum;
}

- (void)layoutSubviewsWithAudioTypeOrAudience
{
    CGFloat width = self.subviews.firstObject.width;
    CGFloat left = self.padding;
    
    for (NSInteger i = 0;i < self.subviews.count;i++) {
        
        UIView *subview = self.subviews[i];
        if (subview == self.likeButton) {
            subview.right = self.width - self.padding;
            subview.bottom = self.height;
        }
        else
        {
            subview.left = left;
            left += (width + self.padding);
            subview.bottom = self.height;
        }
    }
}

- (void)showAnimation
{
    _isShowAnimation = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _isShowAnimation = NO;
        
        //下拉动画结束隐藏 按钮
        if (!_isViewMoveUp) {
            for (NSInteger i = 0; i < self.subviews.count; i++) {
                UIView *view = self.subviews[i];
                //最底层 不需要隐藏
                if (i >= _numPerRow ) {
                    if (view != self.actionViewUpButton) {
                        view.hidden = YES;
                    }
                }
            }
        }
    }];
}


#pragma mark - Public

- (void)setActionType:(NTESLiveActionType)type disable:(BOOL)disable
{
    UIView *view;
    for (UIView *subView in _subviewsCache) {
        if (subView.tag == type) {
            view = subView;
            break;
        }
    }
    if (view) {
        if (disable) {
            [view removeFromSuperview];
        }
        else
        {
            [self addSubview:view];
            NSArray *subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSInteger index1 = [_subviewsCache indexOfObject:obj1];
                NSInteger index2 = [_subviewsCache indexOfObject:obj2];
                return index1>index2? NSOrderedDescending : NSOrderedAscending;
            }];
            
            for (UIView *view in subviews) {
                [self insertSubview:view atIndex:self.subviews.count];
            }
        }
        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)firstLineViewMoveToggle:(BOOL)isMoveUp;
{
    _isViewMoveUp = isMoveUp;
    if (_isViewMoveUp) {
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_down_n"] forState:UIControlStateNormal];
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_down_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_n"] forState:UIControlStateNormal];
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_p"] forState:UIControlStateHighlighted];
    }
    
    //开始动画
    [self showAnimation];
    
}

- (void)updateInteractButton:(NSInteger)count
{
    if (!count)
    {
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_n"] forState:UIControlStateNormal];
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_p"] forState:UIControlStateHighlighted];
        [self.interactButton setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_count_n"] forState:UIControlStateNormal];
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_count_p"] forState:UIControlStateHighlighted];
        [self.interactButton setTitle:@(count).stringValue forState:UIControlStateNormal];
    }
}

- (void)updateBeautify:(BOOL)isBeautify
{
    if (isBeautify) {
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_on_n"] forState:UIControlStateNormal];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_off_n"] forState:UIControlStateNormal];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_p"] forState:UIControlStateHighlighted];
    }
    
}
- (void)updateQualityButton:(BOOL)isHigh
{
    if (isHigh) {
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_high_n"] forState:UIControlStateNormal];
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_high_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_n"] forState:UIControlStateNormal];
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_p"] forState:UIControlStateHighlighted];
    }
    
}

- (void)updateWaterMarkButton:(BOOL)isOn
{
    if (isOn) {
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_on_n"] forState:UIControlStateNormal];
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_n"] forState:UIControlStateNormal];
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_p"] forState:UIControlStateHighlighted];
    }
}

- (void)updateflashButton:(BOOL)isOn
{
    if (isOn) {
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_on_n"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_n"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_p"] forState:UIControlStateHighlighted];
    }
}

- (void)updateFocusButton:(BOOL)isOn
{
    if (isOn) {
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_on_n"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_n"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_p"] forState:UIControlStateHighlighted];
    }
}

- (void)updateMirrorButton:(BOOL)isOn
{
    if (isOn) {
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_n"] forState:UIControlStateNormal];
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_n"] forState:UIControlStateNormal];
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_p"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - Action
- (void)onAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        NTESLiveActionType type = button.tag;
        [self.delegate onActionType:type sender:button];
    }
}

#pragma mark - Get

- (UIButton *)actionViewUpButton
{
    if (!_actionViewUpButton) {
        _actionViewUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionViewUpButton.tag = NTESLiveActionTypeMoveUp;
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_n"] forState:UIControlStateNormal];
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_p"] forState:UIControlStateHighlighted];
        [_actionViewUpButton sizeToFit];
        [_actionViewUpButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionViewUpButton;
}

- (UIButton *)sharedButton
{
    if (!_sharedButton) {
        _sharedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sharedButton.tag = NTESLiveActionTypeShare;
        [_sharedButton setImage:[UIImage imageNamed:@"icon_share_n"] forState:UIControlStateNormal];
        [_sharedButton setImage:[UIImage imageNamed:@"icon_share_p"] forState:UIControlStateHighlighted];
        [_sharedButton sizeToFit];
        [_sharedButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharedButton;
}

- (UIButton *)presentButton
{
    if (!_presentButton) {
        _presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _presentButton.tag = NTESLiveActionTypePresent;
        [_presentButton setImage:[UIImage imageNamed:@"icon_present_n"] forState:UIControlStateNormal];
        [_presentButton setImage:[UIImage imageNamed:@"icon_present_p"] forState:UIControlStateHighlighted];
        [_presentButton sizeToFit];
        [_presentButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentButton;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.tag = NTESLiveActionTypeLike;
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_n"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_p"] forState:UIControlStateHighlighted];
        [_likeButton sizeToFit];
        [_likeButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)qualityButton
{
    if (!_qualityButton) {
        _qualityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _qualityButton.tag = NTESLiveActionTypeQuality;
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_n"] forState:UIControlStateNormal];
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_p"] forState:UIControlStateHighlighted];
        [_qualityButton sizeToFit];
        [_qualityButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _qualityButton;
}

- (UIButton *)interactButton
{
    if (!_interactButton) {
        _interactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _interactButton.tag = NTESLiveActionTypeInteract;
        [_interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_n"] forState:UIControlStateNormal];
        [_interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_p"] forState:UIControlStateHighlighted];
        _interactButton.size = [UIImage imageNamed:@"icon_interact_n"].size;
        [_interactButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interactButton;
}

- (UIButton *)beautifyButton
{
    if (!_beautifyButton) {
        _beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beautifyButton.tag = NTESLiveActionTypeBeautify;
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_off_n"] forState:UIControlStateNormal];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_p"] forState:UIControlStateHighlighted];
        _beautifyButton.size = [UIImage imageNamed:@"icon_beautify_on_normal"].size;
        [_beautifyButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautifyButton;
}

- (UIButton *)mixAudioButton
{
    if (!_mixAudioButton) {
        _mixAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mixAudioButton.tag = NTESLiveActionTypeMixAudio;
        [_mixAudioButton setBackgroundImage:[UIImage imageNamed:@"icon_mix_audio_normal"] forState:UIControlStateNormal];
        [_mixAudioButton setBackgroundImage:[UIImage imageNamed:@"icon_mix_audio_pressed"] forState:UIControlStateHighlighted];
        _mixAudioButton.size = [UIImage imageNamed:@"icon_mix_audio_normal"].size;
        [_mixAudioButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mixAudioButton;
}

- (UIButton *)snapshotButton
{
    if (!_snapshotButton) {
        _snapshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _snapshotButton.tag = NTESLiveActionTypeSnapshot;
        [_snapshotButton setBackgroundImage:[UIImage imageNamed:@"icon_snapshot_n"] forState:UIControlStateNormal];
        [_snapshotButton setBackgroundImage:[UIImage imageNamed:@"icon_snapshot_p"] forState:UIControlStateHighlighted];
        _snapshotButton.size = [UIImage imageNamed:@"icon_mix_audio_normal"].size;
        [_snapshotButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapshotButton;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.tag = NTESLiveActionTypeCamera;
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_n"] forState:UIControlStateNormal];
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_p"] forState:UIControlStateHighlighted];
        [_cameraButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.size = [UIImage imageNamed:@"icon_camera_n"].size;
        
    }
    return _cameraButton;
}

-(UIButton *)chatButton
{
    
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatButton.tag = NTESLiveActionTypeChat;
        [_chatButton setImage:[UIImage imageNamed:@"icon_chat_n"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"icon_chat_p"] forState:UIControlStateHighlighted];
        [_chatButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.size = [UIImage imageNamed:@"icon_chat_n"].size;
    }
    return _chatButton;
    
}

-(UIButton *)flashButton
{
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.tag = NTESLiveActionTypeFlash;
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_n"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_p"] forState:UIControlStateHighlighted];
        [_flashButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _flashButton.size = [UIImage imageNamed:@"icon_flash_off_n"].size;
    }
    return _flashButton;
}

-(UIButton *)mirrorButton
{
    if (!_mirrorButton) {
        _mirrorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mirrorButton.tag = NTESLiveActionTypeMirror;
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_n"] forState:UIControlStateNormal];
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_p"] forState:UIControlStateHighlighted];
        [_mirrorButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _mirrorButton.size = [UIImage imageNamed:@"icon_mirror_n"].size;
    }
    return _mirrorButton;
}

-(UIButton *)waterMarkButton
{
    if (!_waterMarkButton) {
        _waterMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _waterMarkButton.tag = NTESLiveActionTypeWaterMark;
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_n"] forState:UIControlStateNormal];
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_p"] forState:UIControlStateHighlighted];
        [_waterMarkButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _waterMarkButton.size = [UIImage imageNamed:@"icon_watermark_n"].size;
    }
    return _waterMarkButton;
}

- (UIButton *)focusButton
{
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _focusButton.tag = NTESLiveActionTypeFocus;
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_n"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_p"] forState:UIControlStateHighlighted];
        [_focusButton sizeToFit];
        [_focusButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusButton;
}

-(UIButton *)cameraZoomButton
{
    
    if (!_cameraZoomButton) {
        _cameraZoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraZoomButton.tag = NTESLiveActionTypeZoom;
        [_cameraZoomButton setImage:[UIImage imageNamed:@"icon_camera_zoom_n"] forState:UIControlStateNormal];
        [_cameraZoomButton setImage:[UIImage imageNamed:@"icon_camera_zoom_n"] forState:UIControlStateHighlighted];
        [_cameraZoomButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _cameraZoomButton.size = [UIImage imageNamed:@"icon_camera_zoom_n"].size;
    }
    return _cameraZoomButton;
}

@end


@implementation NTESChatroomSegmentedItem
@end


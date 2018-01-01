//
//  NTESTextInputView.m
//  NIMLiveDemo
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESTextInputView.h"
#import "UIView+NTES.h"

@interface NTESTextInputView()<NTESGrowingTextViewDelegate>

@property (nonatomic,strong) NTESGrowingTextView *textView;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *line;

@end

@implementation NTESTextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self customInit];
    }
    return self;
}

- (void)myFirstResponder
{
    [self.textView myFirstResponder];
}


- (void)myResignFirstResponder
{
    [self.textView myResignFirstResponder];
}


- (void)customInit
{
    [self addSubview:self.textView];
    [self addSubview:self.sendButton];
    [self addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat sendbuttonWidth = 70.f;
    
    self.sendButton.frame= CGRectMake(self.width - sendbuttonWidth,
                                      0,
                                      sendbuttonWidth,
                                      self.height);
    self.line.frame = CGRectMake(self.sendButton.left - 1.0, 0, 1.0, self.height);
    self.textView.frame = CGRectMake(0, 0, self.line.left, self.height);
}

#pragma mark - <NTESGrowingTextViewDelegate>
- (void)willChangeHeight:(CGFloat)height
{
    //do nothing
}

- (void)didChangeHeight:(CGFloat)height
{
    if ([self.delegate respondsToSelector:@selector(inputView:didChangeHeight:)]) {
        [self.delegate inputView:self didChangeHeight:height];
    }
}

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    if ([replacementText isEqualToString:@"\n"]) {
        [self onSend:self.textView.text];
        return NO;
    }
    return YES;
}

#pragma mark -- Action
- (void)onSend:(id)sender
{
    NSString *text = self.textView.text;
    
    //清空
    self.textView.text = @"";
    
    //发送
    if ([self.delegate respondsToSelector:@selector(inputView:didSendText:)]) {
        [self.delegate inputView:self didSendText:text];
    }
}

#pragma mark - Get
- (NTESGrowingTextView *)textView
{
    if (!_textView) {
        _textView = [[NTESGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 36.f)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.bounces = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.textViewDelegate  = self;
    }
    return _textView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundColor:[UIColor whiteColor]];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(onSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

@end

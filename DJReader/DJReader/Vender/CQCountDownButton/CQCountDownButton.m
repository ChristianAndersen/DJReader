//
//  CQCountDownButton.m
//  CQCountDownButton
//
//  Created by CaiQiang on 2017/9/8.
//  Copyright © 2017年 caiqiang. All rights reserved.
//
//  Repo Detail: https://github.com/CaiWanFeng/CQCountDownButton
//  About Author: https://www.jianshu.com/u/4212f351f6b5
//

#import "CQCountDownButton.h"
#import "NSTimer+CQBlockSupport.h"

@interface CQCountDownButton ()

/** 控制倒计时的timer */
@property (nonatomic, strong) NSTimer *timer;
/** 倒计时按钮点击回调 */
@property (nonatomic, copy) dispatch_block_t buttonClickedBlock;
/** 倒计时开始时的回调 */
@property (nonatomic, copy) dispatch_block_t countDownStartBlock;
/** 倒计时进行中的回调 */
@property (nonatomic, copy) void (^countDownUnderwayBlock)(NSInteger restCountDownNum);
/** 倒计时结束时的回调 */
@property (nonatomic, copy) dispatch_block_t countDownCompletionBlock;

@end

@implementation CQCountDownButton {
    /** 倒计时开始值 */
    NSInteger _startCountDownNum;
    /** 剩余倒计时的值 */
    NSInteger _restCountDownNum;
    
    // 使用block（若使用block则不能再使用delegate，反之亦然）
    BOOL _useBlock;
    
    // 数据源响应的方法
    struct {
        BOOL startCountDownNumOfCountDownButton:TRUE;
    } _dataSourceRespondsTo;
    
    // 代理响应的方法
    struct {
        BOOL countDownButtonDidClick:TRUE;
        BOOL countDownButtonDidStartCountDown:TRUE;
        BOOL countDownButtonDidInCountDown:TRUE;
        BOOL countDownButtonDidEndCountDown:TRUE;
    } _delegateRespondsTo;
}

#pragma mark - init

// 纯代码init和initWithFrame方法调用
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(p_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

// xib和storyboard调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(p_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - dealloc
// 检验是否释放
- (void)dealloc {

}

#pragma mark - block版本

/**
 所有回调通过block配置
 
 @param duration            设置起始倒计时秒数
 @param buttonClicked       倒计时按钮点击回调
 @param countDownStart      倒计时开始时的回调
 @param countDownUnderway   倒计时进行中的回调
 @param countDownCompletion 倒计时结束时的回调
 */
- (void)configDuration:(NSUInteger)duration
         buttonClicked:(nullable dispatch_block_t)buttonClicked
        countDownStart:(nullable dispatch_block_t)countDownStart
     countDownUnderway:(void (^)(NSInteger restCountDownNum))countDownUnderway
   countDownCompletion:(dispatch_block_t)countDownCompletion {
    if (_dataSource || _delegate) {
        [self p_showError];
        return;
    }
    _useBlock = YES;
    _startCountDownNum = duration;
    self.buttonClickedBlock       = buttonClicked;
    self.countDownStartBlock      = countDownStart;
    self.countDownUnderwayBlock   = countDownUnderway;
    self.countDownCompletionBlock = countDownCompletion;
}

#pragma mark - delegate版本

- (void)setDataSource:(id<CQCountDownButtonDataSource>)dataSource {
    if (_useBlock) {
        [self p_showError];
        return;
    }
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        // 缓存数据源方法是否可以调用
        _dataSourceRespondsTo.startCountDownNumOfCountDownButton = [_dataSource respondsToSelector:@selector(startCountDownNumOfCountDownButton:)];
    }
    _startCountDownNum = [_dataSource startCountDownNumOfCountDownButton:self];
}

- (void)setDelegate:(id<CQCountDownButtonDelegate>)delegate {
    if (_useBlock) {
        [self p_showError];
        return;
    }
    
    if (_delegate != delegate) {
        _delegate = delegate;
        // 缓存代理方法是否可以调用
        _delegateRespondsTo.countDownButtonDidClick = [_delegate respondsToSelector:@selector(countDownButtonDidClick:)];
        _delegateRespondsTo.countDownButtonDidStartCountDown = [_delegate respondsToSelector:@selector(countDownButtonDidStartCountDown:)];
        _delegateRespondsTo.countDownButtonDidInCountDown = [_delegate respondsToSelector:@selector(countDownButtonDidInCountDown:withRestCountDownNum:)];
        _delegateRespondsTo.countDownButtonDidEndCountDown = [_delegate respondsToSelector:@selector(countDownButtonDidEndCountDown:)];
    }
}

#pragma mark - 开始/结束 倒计时

/** 开始倒计时 */
- (void)startCountDown {
    // 因为可以主动调用此方法开启倒计时，不需要点击按钮，所以此处需要将enabled设为no
    self.enabled = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _restCountDownNum = _startCountDownNum;
    // 倒计时开始的回调
    !self.countDownStartBlock ?: self.countDownStartBlock();
    if (_delegateRespondsTo.countDownButtonDidStartCountDown) {
        [_delegate countDownButtonDidStartCountDown:self];
    }
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer cq_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf p_handleCountDown];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timer.fireDate = [NSDate distantPast];
}

/** 结束倒计时 */
- (void)endCountDown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    // 重置剩余倒计时
    _restCountDownNum = _startCountDownNum;
    // 倒计时结束的回调
    !self.countDownCompletionBlock ?: self.countDownCompletionBlock();
    if (_delegateRespondsTo.countDownButtonDidEndCountDown) {
        [_delegate countDownButtonDidEndCountDown:self];
    }
    // 恢复按钮的enabled状态
    self.enabled = YES;
}

#pragma mark - 事件处理

/** 按钮点击 */
- (void)p_buttonClicked:(CQCountDownButton *)sender {
  //  sender.enabled = NO;
    !self.buttonClickedBlock ?: self.buttonClickedBlock();
    if (_delegateRespondsTo.countDownButtonDidClick) {
        [_delegate countDownButtonDidClick:self];
    }
}

/** 处理倒计时进行中的事件 */
- (void)p_handleCountDown {
    // 调用倒计时进行中的回调
    !self.countDownUnderwayBlock ?: self.countDownUnderwayBlock(_restCountDownNum);
    if (_delegateRespondsTo.countDownButtonDidInCountDown) {
        [_delegate countDownButtonDidInCountDown:self withRestCountDownNum:_restCountDownNum];
    }
    if (_restCountDownNum == 0) { // 倒计时完成
        [self endCountDown];
        return;
    }
    _restCountDownNum --;
}

#pragma mark - 提示错误

- (void)p_showError {
    NSAssert(nil, @"不能同时使用block和delegate");
}

@end

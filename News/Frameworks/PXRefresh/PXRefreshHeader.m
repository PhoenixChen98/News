//
//  PXRefreshHeader.m
//  News
//
//  Created by Futu on 2018/8/13.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXRefreshHeader.h"
CGFloat TopRefreshViewHeight = 80;
@interface PXRefreshHeader ()

/** 显示刷新状态的label */
@property (strong, nonatomic) UILabel *stateLabel;
@end
@implementation PXRefreshHeader
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.stateLabel = [UILabel new];
		self.stateLabel.textColor = [UIColor blackColor];
		self.stateLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:self.stateLabel];
		
		// 默认是普通状态
		self.state = PXRefreshStateNormal;
	}
	return self;
}
+ (instancetype)headerWithRefreshigBlock:(void(^)(void))block {
	PXRefreshHeader *header = [PXRefreshHeader new];
	header.refreshingBlock = block;
	return header;
}
- (void)layoutSubviews {
	[super layoutSubviews];
	self.stateLabel.frame = self.bounds;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	// 如果不是UIScrollView，不做任何事情
	if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
	
	// 旧的父控件移除监听
	[self removeObservers];
	
	if (newSuperview) { // 新的父控件
		// 记录UIScrollView
		_scrollView = (UIScrollView *)newSuperview;
		
		self.frame = CGRectMake(0, -TopRefreshViewHeight, self.scrollView.PX_width, TopRefreshViewHeight);
		
		// 设置永远支持垂直弹簧效果
		_scrollView.alwaysBounceVertical = YES;

		// 添加监听
		[self addObservers];
	}
}
#pragma mark - 刷新状态
- (void)beginRefreshing {
	self.state = PXRefreshStateWillRefresh;
}
- (void)endRefreshing {
	self.state = PXRefreshStateNormal;
}
- (void)setState:(PXRefreshState)state {
	if (_state == state) {
		return;
	}
	PXRefreshState oldState = _state;
	_state = state;//要先设置，否则在设置inset时再次触发contendOffset改变的KVO引起死循环
	if (state == PXRefreshStateWillRefresh) {
		CGPoint offset = CGPointMake(0, - self.scrollViewTopInset - TopRefreshViewHeight);
		[self.scrollView setContentOffset:offset animated:YES];
	} else if (state == PXRefreshStateRefreshing) {
		UIEdgeInsets inset = self.scrollView.contentInset;
		inset.top += TopRefreshViewHeight;
		CGPoint offset = self.scrollView.contentOffset;
		self.scrollView.contentInset = inset;//contentOffset有跳变，通过重新设置offset避免
		self.scrollView.contentOffset = offset;
		self.stateLabel.text = @"正在刷新";
		dispatch_async(dispatch_get_main_queue(), ^{
			if (self.refreshingBlock) {
				self.refreshingBlock();
			}
			
		});
	} else if (state == PXRefreshStatePulling) {
		self.stateLabel.text = @"松开立即刷新";
	} else if (state == PXRefreshStateNormal) {
		self.stateLabel.text = @"下滑刷新";
		if (oldState == PXRefreshStateRefreshing) {
			[UIView animateWithDuration:0.25 animations:^{
				UIEdgeInsets inset = self.scrollView.contentInset;
				inset.top -= TopRefreshViewHeight;
			
				self.scrollView.contentInset = inset;
			
			}];
		}
	}
	
}
#pragma mark - KVO监听
- (void)addObservers {
	NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
	[self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)removeObservers {
	[self.scrollView removeObserver:self forKeyPath:@"contentOffset"];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"contentOffset"]) {
		[self scrollViewContentOffsetDidChange:change];
	}
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
	// 当前的contentOffset
	CGFloat offsetY = self.scrollView.contentOffset.y;
	// 头部控件刚好出现的offsetY
	CGFloat happenOffsetY = - self.scrollViewTopInset;
	// 普通 和 即将刷新 的临界点
	CGFloat normal2pullingOffsetY = - self.scrollViewTopInset - TopRefreshViewHeight;
	switch (self.state) {
		case PXRefreshStateWillRefresh:
			self.state = PXRefreshStateNormal;
			break;
		case PXRefreshStateNormal:
			if (offsetY <= normal2pullingOffsetY) {
				if (!self.scrollView.isDragging) {
					self.state = PXRefreshStateRefreshing;
				} else {
					self.state = PXRefreshStatePulling;
				}
			} else if (offsetY <= happenOffsetY) {
				self.hidden = NO;
				CGFloat pullingPercent = (happenOffsetY - offsetY) / self.PX_height;
				self.alpha = pullingPercent;
			} else {
				self.hidden = YES;
			}
			break;
		case PXRefreshStatePulling:
			if (!self.scrollView.isDragging) {
				self.state = PXRefreshStateRefreshing;
				return;
			}
			if (offsetY > normal2pullingOffsetY) {
				self.state = PXRefreshStateNormal;
			}
			break;
		case PXRefreshStateRefreshing:
			break;
	}
}

- (CGFloat)scrollViewTopInset {
#ifdef __IPHONE_11_0
	return self.scrollView.adjustedContentInset.top;
#endif
	return self.scrollView.contentInset.top;
}
@end

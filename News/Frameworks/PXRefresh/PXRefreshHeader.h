//
//  PXRefreshHeader.h
//  News
//
//  Created by Futu on 2018/8/13.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, PXRefreshState) {
	/** 普通状态 */
	PXRefreshStateNormal = 1,
	/** 松开就可以进行刷新的状态 */
	PXRefreshStatePulling,
	/** 正在刷新中的状态 */
	PXRefreshStateRefreshing,
	/** 向上滚动即将刷新的状态 */
	PXRefreshStateWillRefresh
};
@interface PXRefreshHeader : UIView {
	__weak UIScrollView *_scrollView;
	UILabel *_stateLabel;
}
/** 设置刷新回调 */
@property (copy, nonatomic) void (^refreshingBlock)(void);
/** 刷新状态 */
@property (assign, nonatomic) PXRefreshState state;
/** 父视图 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;
/** 父视图的上方 Inset */
@property (assign, nonatomic, readonly) CGFloat scrollViewTopInset;
/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;
/** 是否正在刷新 */
//- (BOOL)isRefreshing;

/** 创建header */
+ (instancetype)headerWithRefreshigBlock:(void(^)(void))block;
@end

//
//  UITableView+PXRefresh.m
//  News
//
//  Created by Futu on 2018/8/13.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "UIScrollView+PXRefresh.h"
#import "PXRefreshHeader.h"
#import <objc/runtime.h>
@implementation UIScrollView (PXRefresh)

#pragma mark - header
static const char PXRefreshHeaderKey = '\0';

- (void)setPx_header:(PXRefreshHeader *)px_header {
	if (px_header != self.px_header) {
		// 删除旧的，添加新的
		[self.px_header removeFromSuperview];
		[self insertSubview:px_header atIndex:0];
		
		// 存储新的
//		[self willChangeValueForKey:@"px_header"]; // KVO
		objc_setAssociatedObject(self, &PXRefreshHeaderKey,
								 px_header, OBJC_ASSOCIATION_ASSIGN);
//		[self didChangeValueForKey:@"px_header"]; // KVO
	}
}
- (PXRefreshHeader *)px_header {
	return objc_getAssociatedObject(self, &PXRefreshHeaderKey);
}
@end

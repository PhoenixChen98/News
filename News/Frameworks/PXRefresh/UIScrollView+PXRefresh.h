//
//  UITableView+PXRefresh.h
//  News
//
//  Created by Futu on 2018/8/13.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PXRefreshHeader;
@interface UIScrollView (PXRefresh)
@property (strong, nonatomic) PXRefreshHeader *px_header;
@end

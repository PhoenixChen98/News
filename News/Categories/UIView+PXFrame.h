//
//  UIView+PXFrame.h
//  BaiSi
//
//  Created by Phoenix on 2017/7/10.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PXFrame)

@property CGFloat PX_x;
@property CGFloat PX_y;
/** 相对于父视图 */
@property CGFloat PX_right;
/** 相对于父视图 */
@property CGFloat PX_bottom;
@property CGFloat PX_width;
@property CGFloat PX_height;
/** 相对于父视图 */
@property CGFloat PX_centerX;
/** 相对于父视图 */
@property CGFloat PX_centerY;
@property CGSize PX_size;
@end

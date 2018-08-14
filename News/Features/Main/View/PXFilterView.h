//
//  PXFilterView.h
//  News
//
//  Created by Futu on 2018/8/3.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXFilterView : UIView
/** 确定关键词的回调 */
@property (strong, nonatomic) void(^keyWordEnterBlock)(void);

/** 选择日期的回调 */
@property (strong, nonatomic) void(^selectDate)(void);

/** 获取关键词 */
@property (copy, nonatomic, readonly) NSString *keyWord;

/** 设置显示的日期 */
@property (strong, nonatomic) NSDate *filterDate;
@end

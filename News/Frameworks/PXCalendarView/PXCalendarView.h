//
//  PXCalendarView.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXCalendarView : UIView
/** 当前选中的日期(未选中时为nil) */
@property (copy, nonatomic) NSDate *date;
/** 一周的名称 */
@property (copy, nonatomic) NSArray<NSString *> *stringsOfWeekday;
/** 工作日头的颜色 */
@property (copy, nonatomic) UIColor *weekdayHeaderTextColor;
/** 周末头的颜色 */
@property (copy, nonatomic) UIColor *weekendHeaderTextColor;
/** 数字的颜色 */
@property (copy, nonatomic) UIColor *componentTextColor;
@property (copy, nonatomic) UIColor *highlightedComponentTextColor;
@property (copy, nonatomic) UIColor *selectedIndicatorColor;
@property (copy, nonatomic) UIColor *todayIndicatorColor;
@property (assign, nonatomic) CGFloat indicatorRadius;
/** 跳转到显示某一月 */
- (void)displayMonth:(NSDate *)date;

@end

//
//  PXCalendarView.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXCalendarView : UIView

@property (copy, nonatomic) NSDate *date;

@property (copy, nonatomic) NSArray<NSString *> *localizedStringsOfWeekday;

// Appearance settings:
@property (copy, nonatomic) UIColor *weekdayHeaderTextColor;
@property (copy, nonatomic) UIColor *weekdayHeaderWeekendTextColor;
@property (copy, nonatomic) UIColor *componentTextColor;
@property (copy, nonatomic) UIColor *highlightedComponentTextColor;
@property (copy, nonatomic) UIColor *selectedIndicatorColor;
@property (copy, nonatomic) UIColor *todayIndicatorColor;
@property (assign, nonatomic) CGFloat indicatorRadius;

- (void)jumpToMonth:(NSDate *)date;

@end

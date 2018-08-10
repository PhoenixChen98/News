//
//  NSDate+Helper.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
- (NSDateComponents *)components;
+ (NSDate *)dateFromComponents:(NSDateComponents *)comps;
- (BOOL)isSameDay:(NSDate *)date;
- (BOOL)isToday;
- (BOOL)isSameMonth:(NSDate *)date;
+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year;
+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year;
- (NSUInteger)daysInMonth;
- (NSDate *)firstDayInMonth;
/**
 返回当月第一天是一周中的第几天，如周日为1，周一为2

 @return 当月第一天在一周中的第几天
 */
- (NSUInteger)dayNumberInWeek;
- (BOOL)isEarlierToDate:(NSDate *)date;

- (BOOL)isLaterToDate:(NSDate *)date;
- (NSDate *)lastMonth;
- (NSDate *)nextMonth;
@end

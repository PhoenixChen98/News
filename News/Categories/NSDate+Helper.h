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
- (NSUInteger)firstWeekdayInMonth;
- (BOOL)isEarlierToDate:(NSDate *)date;

- (BOOL)isLaterToDate:(NSDate *)date;
- (NSDate *)lastMonth;
- (NSDate *)nextMonth;
@end

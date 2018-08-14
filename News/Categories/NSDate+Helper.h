//
//  NSDate+Helper.h
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
/**
 获取NSDate实例的年月日Components

 @return NSDate实例的年月日Components
 */
- (NSDateComponents *)components;
/**
 根据NSDateComponents生成NSDate

 @param comps 源NSDateComponents
 @return NSDate实例
 */
+ (NSDate *)dateFromComponents:(NSDateComponents *)comps;
/**
 判断NSDate实例和传入的NSDate实例是否在同一天

 @param date 被比较的NSDate实例
 @return 是否在同一天
 */
- (BOOL)isSameDay:(NSDate *)date;
/**
 判断NSDate实例是否和今天是同一天

 @return 是否和今天是同一天
 */
- (BOOL)isToday;
/**
 判断NSDate实例和传入的NSDate实例是否在同一月
 
 @param date 被比较的NSDate实例
 @return 是否在同一月
 */
- (BOOL)isSameMonth:(NSDate *)date;
/**
 根据年月日生成NSDate实例

 @param month 月
 @param day 日
 @param year 年
 @return 生成的NSDate实例
 */
+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year;
/**
 根据年月生成NSDate实例

 @param month 月
 @param year 年
 @return 生成的NSDate实例
 */
+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year;
/**
 获取NSDate实例所在月的天数

 @return NSDate实例所在月的天数
 */
- (NSUInteger)daysInMonth;
/**
 获取NSDate实例所在月的第一天

 @return 生成的第一天的NSDate实例
 */
- (NSDate *)firstDayInMonth;
/**
 返回当月第一天是一周中的第几天，如周日为1，周一为2

 @return 当月第一天在一周中的第几天
 */
- (NSUInteger)dayNumberInWeek;
/**
 判断NSDate实例是否早于传入的NSDate实例

 @param date 传入的NSDate实例
 @return 是否早于
 */
- (BOOL)isEarlierToDate:(NSDate *)date;
/**
 判断NSDate实例是否晚于传入的NSDate实例
 
 @param date 传入的NSDate实例
 @return 是否晚于
 */
- (BOOL)isLaterToDate:(NSDate *)date;
/**
 获取NSDate实例所在月的前一个月的第一天

 @return NSDate实例所在月的前一个月的第一天
 */
- (NSDate *)lastMonth;
/**
 获取NSDate实例所在月的后一个月的第一天
 
 @return NSDate实例所在月的后一个月的第一天
 */
- (NSDate *)nextMonth;
@end

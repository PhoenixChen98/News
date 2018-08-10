//
//  NSDate+Helper.m
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)
- (NSDateComponents *)components {
	return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
}
+ (NSDate *)dateFromComponents:(NSDateComponents *)comps {
	return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
- (BOOL)isSameDay:(NSDate *)date {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	return [calendar isDate:self inSameDayAsDate:date];
}
- (BOOL)isToday {
	return [self isSameDay:[NSDate date]];
}
- (BOOL)isSameMonth:(NSDate *)date {
	NSDateComponents *selfComps = [self components];
	NSDateComponents *comps = [date components];
	return selfComps.month == comps.month && selfComps.year == comps.year;
}
+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	comps.year = year;
	comps.month = month;
	comps.day = day;
	return [self dateFromComponents:comps];
}
+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year {
	return [self dateWithMonth:month day:1 year:year];
}
- (NSUInteger)daysInMonth {
	return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}
- (NSDate *)firstDayInMonth {
	NSDateComponents *comps = [self components];
	comps.day = 1;
	return [NSDate dateFromComponents:comps];
}
- (NSUInteger)dayNumberInWeek {
	return [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:self];
}
- (BOOL)isEarlierToDate:(NSDate *)date {
	return [self earlierDate:date] == self;
}
- (BOOL)isLaterToDate:(NSDate *)date {
	return [self laterDate:date] == self;
}
- (NSDate *)lastMonth {
	NSUInteger lastMonth;
	NSUInteger lastYear;
	NSDateComponents *comps = [self components];
	if (comps.month <= 1) {
		lastMonth = 12;
		lastYear = comps.year - 1;
	}
	else {
		lastMonth = comps.month - 1;
		lastYear = comps.year;
	}
	return [NSDate dateWithMonth:lastMonth year:lastYear];
}

- (NSDate *)nextMonth {
	NSUInteger nextMonth;
	NSUInteger nextYear;
	NSDateComponents *comps = [self components];
	if (comps.month >= 12) {
		nextMonth = 1;
		nextYear = comps.year + 1;
	}
	else {
		nextMonth = comps.month + 1;
		nextYear = comps.year;
	}
	return [NSDate dateWithMonth:nextMonth year:nextYear];
}
@end

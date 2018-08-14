//
//  PXCalendarView.m
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXCalendarView.h"
#import "NSDate+Helper.h"
#import "PXIndicatorView.h"
#import "PXDayView.h"
#import "PXTitleBar.h"

@interface PXCalendarView ()<UIScrollViewDelegate>
@property (strong, nonatomic) NSDate *visibleDate;//当前显示的年月
@property (strong, nonatomic) PXTitleBar *titleBar;
@property (strong, nonatomic) UIStackView *weekHeaderView;
@property (strong, nonatomic) UIScrollView *contentWrapperView;
@property (strong, nonatomic) UIStackView *contentView;
//@property (strong, nonatomic) PXIndicatorView *selectedIndicatorView;
//@property (strong, nonatomic) PXIndicatorView *todayIndicatorView;
@property (strong, nonatomic) NSMutableArray<PXDayView *> *dayViews;

@property (readonly, copy) NSString *navigationBarTitle;
@end
@implementation PXCalendarView
#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}
- (void)layoutSubviews {
	[super layoutSubviews];
	self.titleBar.frame = CGRectMake(0, 0, self.PX_width, 40);
	self.weekHeaderView.frame = CGRectMake(0, self.titleBar.PX_bottom, self.PX_width, 20);
	self.contentWrapperView.frame = CGRectMake(0, self.weekHeaderView.PX_bottom, self.PX_width, self.PX_height - self.weekHeaderView.PX_bottom);
	self.contentView.frame = CGRectMake(0, 0, self.contentWrapperView.PX_width * 3, self.contentWrapperView.PX_height);
	self.contentWrapperView.contentSize = CGSizeMake(self.contentView.PX_width, 0);
	self.contentWrapperView.contentOffset = CGPointMake(self.contentWrapperView.PX_width, 0);
}

- (void)commonInit {
	self.stringsOfWeekday = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	self.visibleDate = [NSDate date];

	self.weekdayHeaderTextColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1];
	self.weekendHeaderTextColor = [UIColor colorWithRed:0.75 green:0.25 blue:0.25 alpha:1];
	self.componentTextColor = [UIColor blackColor];
	self.highlightedComponentTextColor = [UIColor whiteColor];
	self.selectedIndicatorColor = [UIColor colorWithRed:0.74 green:0.18 blue:0.06 alpha:1];
	self.todayIndicatorColor = [UIColor lightGrayColor];
	self.indicatorRadius = 20;
	
	__weak typeof (self) weakSelf = self;
	self.titleBar = [[PXTitleBar alloc] init];
	self.titleBar.title = self.navigationBarTitle;
	self.titleBar.lastMonth = ^{
		[weakSelf scrollToLastMonth];
	};
	self.titleBar.nextMonth = ^{
		[weakSelf scrollToNextMonth];
	};
	
	[self addSubview:self.titleBar];

	
	self.weekHeaderView = [[UIStackView alloc] init];
	self.weekHeaderView.axis = UILayoutConstraintAxisHorizontal;
	self.weekHeaderView.distribution = UIStackViewDistributionFillEqually;
	self.weekHeaderView.alignment = UIStackViewAlignmentCenter;
	
	[self addSubview:self.weekHeaderView];

	
	self.contentWrapperView = [[UIScrollView alloc] init];
	self.contentWrapperView.delegate = self;
	self.contentWrapperView.pagingEnabled = YES;
	self.contentWrapperView.showsHorizontalScrollIndicator = NO;
	[self addSubview:self.contentWrapperView];

	self.contentView = [[UIStackView alloc] init];
	self.contentView.axis = UILayoutConstraintAxisHorizontal;
	self.contentView.distribution = UIStackViewDistributionFillEqually;
	self.contentView.alignment = UIStackViewAlignmentFill;
	
	[self.contentWrapperView addSubview:self.contentView];

	self.dayViews = [NSMutableArray array];
	[self setupView];
	[self configureWeekdayHeaderView];
	[self configureContentViewAnimated:NO];
	
//	[self reloadViewAnimated:NO];
}
#pragma mark - config view
- (void)setupView {
	__weak typeof (self) weakSelf = self;
	// Make weekday header view.
	for (int i = 1; i <= 7; i++) {
		UILabel *weekdayLabel = [[UILabel alloc] init];
		[self.weekHeaderView addArrangedSubview:weekdayLabel];
	}
	UIStackView *weekView;
	UIStackView *monthView;
	PXDayView *dayView;
	for (int i = 0; i < 3; i++) {
		monthView = [[UIStackView alloc] init];
		monthView.axis = UILayoutConstraintAxisVertical;
		monthView.distribution = UIStackViewDistributionFillEqually;
		monthView.alignment = UIStackViewAlignmentFill;
		[self.contentView addArrangedSubview:monthView];
		for (int j = 0; j < 6; j++) {
			weekView = [[UIStackView alloc] init];
			weekView.axis = UILayoutConstraintAxisHorizontal;
			weekView.distribution = UIStackViewDistributionFillEqually;
			weekView.alignment = UIStackViewAlignmentFill;
			[monthView addArrangedSubview:weekView];
			for (int k = 0; k < 7; k++) {
				dayView = [[PXDayView alloc] init];
				dayView.textLabel.textAlignment = NSTextAlignmentCenter;
				dayView.dayDidTap = ^(PXDayView *sender) {
					[weakSelf dayDidTap:sender];
				};
				[weekView addArrangedSubview:dayView];
				[self.dayViews addObject:dayView];
			}
		}
	}
}

- (void)configureWeekdayHeaderView {
	[self.weekHeaderView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UILabel *weekdayLabel = (id) obj;
		weekdayLabel.textAlignment = NSTextAlignmentCenter;
		weekdayLabel.font = [UIFont systemFontOfSize:12];
		weekdayLabel.textColor = (idx == 0 || idx == 6) ? self.weekendHeaderTextColor : self.weekdayHeaderTextColor;
		weekdayLabel.text = self.stringsOfWeekday[idx];
		
	}];
}



- (void)configureContentViewAnimated:(BOOL)animated {
	[self configureMonth:[self.visibleDate lastMonth] index:0 animated:animated];
	[self configureMonth:self.visibleDate index:1 animated:animated];
	[self configureMonth:[self.visibleDate nextMonth] index:2 animated:animated];
}
- (void)configureMonth:(NSDate *)date index:(NSUInteger)index animated:(BOOL)animated {
	date = [date firstDayInMonth];
	NSUInteger pointer = index * 42;
	NSUInteger totalDays = [date daysInMonth];
	NSUInteger paddingDays = [date dayNumberInWeek] - 1;
	
	NSDateComponents *comps = [date components];
	
	// Make padding days.
	NSUInteger paddingYear = comps.month == 1 ? comps.year - 1 : comps.year;
	NSUInteger paddingMonth = comps.month == 1 ? 12 : comps.month - 1;
	NSDate *lastMonth = [NSDate dateWithMonth:paddingMonth year:paddingYear];
	NSUInteger totalDaysInLastMonth = [lastMonth daysInMonth];
	
	NSDate *day;
	for (int j = (int) paddingDays - 1; j >= 0; j--) {
		day = [NSDate dateWithMonth:paddingMonth day:totalDaysInLastMonth - j  year:paddingYear];
		[self configureDayView:self.dayViews[pointer++] withDate:day bold:NO animated:animated];
	}
	
	// Make days in current month.
	for (int j = 0; j < totalDays; j++) {
		day = [NSDate dateWithMonth:comps.month day:j + 1 year:comps.year];
		[self configureDayView:self.dayViews[pointer++] withDate:day bold:YES animated:animated];
	}
	
	// Make days in next month to fill the remain cells.
	NSUInteger reserveYear = comps.month == 12 ? comps.year + 1 : comps.year;
	NSUInteger reserveMonth = comps.month == 12 ? 1 : comps.month + 1;
	
	for (int j = 0; 42 * (index + 1) - pointer > 0; j++) {
		day = [NSDate dateWithMonth:reserveMonth day:j + 1 year:reserveYear];
		[self configureDayView:self.dayViews[pointer++] withDate:day bold:NO animated:animated];
	}
}
- (void)configureDayView:(PXDayView *)view withDate:(NSDate *)date bold:(BOOL)bold animated:(BOOL)animated{
	view.date = date;
	view.textColor = self.componentTextColor;
	view.highlightTextColor = self.highlightedComponentTextColor;
	view.selectedColor = self.selectedIndicatorColor;
	view.todayColor = self.todayIndicatorColor;
	view.indicatorRadius = self.indicatorRadius;
	view.bold = bold;
	[view setSelected:[self.date isSameDay:date] && bold animated:animated];
}
#pragma mark - methods


- (void)setDate:(NSDate *)date {
	_date = date;
	if (![self.visibleDate isSameMonth:date]) {
		[self displayMonth:date];
	}
	[self dayDidTap:[self componentViewForDate:date]];
	
}
- (PXDayView *)componentViewForDate:(NSDate *)date {
	__block PXDayView *view = nil;
	[self.dayViews enumerateObjectsUsingBlock:^(PXDayView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj.date isEqualToDate:date]) {
			view = obj;
			*stop = YES;
		}
	}];
	return view;
}


- (NSString *)navigationBarTitle {
	NSDateComponents *comps = [self.visibleDate components];
	return [NSString stringWithFormat:@"%ld年 %ld月", (long)comps.year, (long)comps.month];
}
#pragma mark - Actions

- (void)dayDidTap:(PXDayView *)sender {
	NSDate *date = sender.date;
	_date = date;
	if (![self.visibleDate isSameMonth:date]) {
		[self configureContentViewAnimated:NO];
		if ([self.visibleDate isEarlierToDate:date]) {
			[self scrollToNextMonth];
		} else {
			[self scrollToLastMonth];
		}
		return;
	}
	[self configureContentViewAnimated:YES];
}
- (void)scrollToNextMonth {
	__weak typeof (self) weakSelf = self;
	[UIView animateWithDuration:0.25 animations:^{
		weakSelf.contentWrapperView.contentOffset = CGPointMake(self.contentWrapperView.PX_width * 2, 0);
	} completion:^(BOOL finished) {
		[weakSelf resetWrapperView];
	}];
}

- (void)scrollToLastMonth {
	__weak typeof (self) weakSelf = self;
	[UIView animateWithDuration:0.25 animations:^{
		weakSelf.contentWrapperView.contentOffset = CGPointMake(0, 0);
	} completion:^(BOOL finished) {
		[weakSelf resetWrapperView];
	}];
}

- (void)resetWrapperView {
	NSUInteger index = (int)(self.contentWrapperView.contentOffset.x / self.contentWrapperView.PX_width);
	if (index == 0) {
		[self displayMonth:[self.visibleDate lastMonth]];
	} else if (index == 2) {
		[self displayMonth:[self.visibleDate nextMonth]];
	}
	self.contentWrapperView.contentOffset = CGPointMake(self.contentWrapperView.PX_width, 0);
}

- (void)displayMonth:(NSDate *)date {
	self.visibleDate = date;
	self.titleBar.title = self.navigationBarTitle;
	[self configureContentViewAnimated:NO];
}

#pragma mark - uiscrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self resetWrapperView];
}
@end









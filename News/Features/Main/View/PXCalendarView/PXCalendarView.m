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
#import "PXComponentView.h"
#import "PXTitleBar.h"

@interface PXCalendarView ()
@property (strong, nonatomic) NSDate *visibleDate;//当前显示的年月
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) PXTitleBar *titleBar;
@property (strong, nonatomic) UIStackView *weekHeaderView;
@property (strong, nonatomic) UIView *contentWrapperView;
@property (strong, nonatomic) UIStackView *contentView;
@property (strong, nonatomic) PXIndicatorView *selectedIndicatorView;
@property (strong, nonatomic) PXIndicatorView *todayIndicatorView;
@property (strong, nonatomic) NSMutableArray<PXComponentView *> *componentViews;

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
-(void)layoutSubviews {
	[super layoutSubviews];
	self.titleBar.frame = CGRectMake(0, 0, self.PX_width, 40);
	self.weekHeaderView.frame = CGRectMake(0, self.titleBar.PX_bottom, self.PX_width, 20);
	self.contentWrapperView.frame = CGRectMake(0, self.weekHeaderView.PX_bottom, self.PX_width, self.PX_height - self.weekHeaderView.PX_bottom);
	self.contentView.frame = self.contentWrapperView.bounds;
	
//	UIView *
	if (self.todayIndicatorView.attachingView) {
		
	}
}

- (void)commonInit {
	self.localizedStringsOfWeekday = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
	self.visibleDate = [NSDate date];
	
	// Initialize default appearance settings.
	self.weekdayHeaderTextColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1];
	self.weekdayHeaderWeekendTextColor = [UIColor colorWithRed:0.75 green:0.25 blue:0.25 alpha:1];
	self.componentTextColor = [UIColor darkGrayColor];
	self.highlightedComponentTextColor = [UIColor whiteColor];
	self.selectedIndicatorColor = [UIColor colorWithRed:0.74 green:0.18 blue:0.06 alpha:1];
	self.todayIndicatorColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
	self.indicatorRadius = 20;
	self.boldPrimaryComponentText = YES;
	
	__weak typeof (self) weakSelf = self;
	self.titleBar = [[PXTitleBar alloc] init];
	self.titleBar.title = self.navigationBarTitle;
	self.titleBar.lastMonth = ^{
		[weakSelf jumpToMonth:[weakSelf.visibleDate lastMonth]];
	};
	self.titleBar.nextMonth = ^{
		[weakSelf jumpToMonth:[weakSelf.visibleDate nextMonth]];
	};
	
	[self addSubview:self.titleBar];

	
	self.weekHeaderView = [[UIStackView alloc] init];
	self.weekHeaderView.axis = UILayoutConstraintAxisHorizontal;
	self.weekHeaderView.distribution = UIStackViewDistributionFillEqually;
	self.weekHeaderView.alignment = UIStackViewAlignmentCenter;
	
	[self addSubview:self.weekHeaderView];

	
	self.contentWrapperView = [[UIView alloc] init];
	
	[self addSubview:self.contentWrapperView];

	
	self.contentView = [[UIStackView alloc] init];
	self.contentView.axis = UILayoutConstraintAxisVertical;
	self.contentView.distribution = UIStackViewDistributionFillEqually;
	self.contentView.alignment = UIStackViewAlignmentFill;
	
	[self.contentWrapperView addSubview:self.contentView];

	
	self.componentViews = [NSMutableArray array];
	[self makeUIElements];
	[self reloadViewAnimated:NO];
}
#pragma mark - methods
- (void)makeUIElements {
	__weak typeof (self) weakSelf = self;
	// Make indicator views;
	self.selectedIndicatorView = [[PXIndicatorView alloc] init];
	self.selectedIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
	self.selectedIndicatorView.hidden = YES;
	self.todayIndicatorView = [[PXIndicatorView alloc] init];
	self.todayIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
	self.todayIndicatorView.hidden = YES;
	
	[self.contentWrapperView insertSubview:self.todayIndicatorView belowSubview:self.contentView];
	[self.contentWrapperView insertSubview:self.selectedIndicatorView belowSubview:self.contentView];
	
	// Make weekday header view.
	for (int i = 1; i <= 7; i++) {
		UILabel *weekdayLabel = [[UILabel alloc] init];
		[self.weekHeaderView addArrangedSubview:weekdayLabel];
	}
	
	// Make content view.
	__block int currentColumn = 0;
	__block UIStackView *currentRowView;
	
	void (^makeRow)(void) = ^{
		currentRowView = [[UIStackView alloc] init];
		currentRowView.axis = UILayoutConstraintAxisHorizontal;
		currentRowView.distribution = UIStackViewDistributionFillEqually;
		currentRowView.alignment = UIStackViewAlignmentFill;
	};
	
	void (^submitRowIfNecessary)(void) = ^{
		if (currentColumn >= 7) {
			[self.contentView addArrangedSubview:currentRowView];
			currentColumn = 0;
			makeRow();
		}
	};
	
	void (^submitCell)(UIView *) = ^(UIView *cellView) {
		[currentRowView addArrangedSubview:cellView];
		[self.componentViews addObject:(id) cellView];
		currentColumn++;
		submitRowIfNecessary();
	};
	
	makeRow();
	
	for (int i = 0; i < 42; i++) {
		PXComponentView *componentView = [[PXComponentView alloc] init];
		componentView.textLabel.textAlignment = NSTextAlignmentCenter;
		componentView.componentDidTap = ^(PXComponentView *sender) {
			[weakSelf componentDidTap:sender];
		};
		submitCell(componentView);
	}
}
- (void)reloadViewAnimated:(BOOL)animated {
	[self configureIndicatorViews];
	[self configureWeekdayHeaderView];
	[self configureContentView];
	
	if (animated) {
		[UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
	}
}
- (void)componentDidTap:(PXComponentView *)sender {
	NSDate *date = sender.date;
	if (![self.visibleDate isSameMonth:date]) {
		[self jumpToMonth:date];
		return;
	}
	
	// by Rakuyo. Solves the problem that switch error in single line mode
	if (self.selectedIndicatorView.hidden || self.selectedIndicatorView.alpha == 0) {
		
		if (self.selectedIndicatorView.hidden) {
			self.selectedIndicatorView.hidden = NO;
		}
		if (self.selectedIndicatorView.alpha == 0) {
			self.selectedIndicatorView.alpha = 1;
		}
		
		self.selectedIndicatorView.transform = CGAffineTransformMakeScale(0, 0);
		self.selectedIndicatorView.attachingView = sender;
		[self addConstraintToCenterIndicatorView:self.selectedIndicatorView toView:sender];
		
		[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:kNilOptions animations:^{
			self.selectedIndicatorView.transform = CGAffineTransformIdentity;
			[sender setSelected:YES];
		} completion:nil];
	}
	else {
		[self addConstraintToCenterIndicatorView:self.selectedIndicatorView toView:sender];
		
		[UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:kNilOptions animations:^{
			[self.contentWrapperView layoutIfNeeded];
			
			[((PXComponentView *) self.selectedIndicatorView.attachingView) setSelected:NO];
			[sender setSelected:YES];
		} completion:nil];
		
		self.selectedIndicatorView.attachingView = sender;
	}
	
	_date = date;
}
- (void)setDate:(NSDate *)date {
	_date = date;
	int64_t delayTime = 0;
	if (![self.visibleDate isSameMonth:date]) {
		[self jumpToMonth:date];
		delayTime = 400;
	}
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
		[self componentDidTap:[self componentViewForDate:date]];
	});
}
- (PXComponentView *)componentViewForDate:(NSDate *)date {
	__block PXComponentView *view = nil;
	[self.componentViews enumerateObjectsUsingBlock:^(PXComponentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj.date isEqualToDate:date]) {
			view = obj;
			*stop = YES;
		}
	}];
	return view;
}

- (void)configureIndicatorViews {
	self.selectedIndicatorView.color = self.selectedIndicatorColor;
	self.todayIndicatorView.color = self.todayIndicatorColor;
}

- (void)configureWeekdayHeaderView {
	[self.weekHeaderView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UILabel *weekdayLabel = (id) obj;
		weekdayLabel.textAlignment = NSTextAlignmentCenter;
		weekdayLabel.font = [UIFont systemFontOfSize:12];
		weekdayLabel.textColor = (idx == 0 || idx == 6) ? self.weekdayHeaderWeekendTextColor : self.weekdayHeaderTextColor;
		
		weekdayLabel.text = self.localizedStringsOfWeekday[idx];
		
	}];
}

- (void)configureComponentView:(PXComponentView *)view withDate:(NSDate *)date {
	if ([date isToday]) {
		if (self.todayIndicatorView.hidden) {
			self.todayIndicatorView.hidden = NO;
			self.todayIndicatorView.transform = CGAffineTransformMakeScale(0, 0);
			[UIView animateWithDuration:0.3 animations:^{
				self.todayIndicatorView.transform = CGAffineTransformIdentity;
			}];
		}
		self.todayIndicatorView.attachingView = view;
		[self addConstraintToCenterIndicatorView:self.todayIndicatorView toView:view];
		

	}
	
	NSDateComponents *dateComps = [date components];
	NSDateComponents *visibleComps = [self.visibleDate components];
	view.date = date;
	
	if (self.selectedIndicatorView && self.selectedIndicatorView.attachingView == view) {
		[view setSelected:YES];
	}
	else {
		[view setSelected:NO];
	}
	view.textColor = self.componentTextColor;
	view.highlightTextColor = self.highlightedComponentTextColor;
	view.textLabel.alpha = visibleComps.month == dateComps.month ? 1.0 : 0.5;
	if (visibleComps.month == dateComps.month && self.boldPrimaryComponentText) {
		view.textLabel.font = [UIFont boldSystemFontOfSize:16];
	}
	else {
		view.textLabel.font = [UIFont systemFontOfSize:16];
	}
	view.textLabel.text = [NSString stringWithFormat:@"%ld", (long)dateComps.day];
}

- (void)configureContentView {
	NSUInteger pointer = 0;
	
	NSUInteger totalDays = [self.visibleDate daysInMonth];
	NSUInteger paddingDays = [self.visibleDate firstWeekdayInMonth] - 1;
	
	NSDateComponents *visibleComps = [self.visibleDate components];
	
	// Make padding days.
	NSUInteger paddingYear = visibleComps.month == 1 ? visibleComps.year - 1 : visibleComps.year;
	NSUInteger paddingMonth = visibleComps.month == 1 ? 12 : visibleComps.month - 1;
	NSDate *lastMonth = [NSDate dateWithMonth:paddingMonth year:paddingYear];
	NSUInteger totalDaysInLastMonth = [lastMonth daysInMonth];
	
	for (int j = (int) paddingDays - 1; j >= 0; j--) {
		[self configureComponentView:self.componentViews[pointer++] withDate:[NSDate dateWithMonth:paddingMonth day:totalDaysInLastMonth - j  year:paddingYear]];
	}
	
	// Make days in current month.
	for (int j = 0; j < totalDays; j++) {
		[self configureComponentView:self.componentViews[pointer++] withDate:[NSDate dateWithMonth:visibleComps.month day:j + 1 year:visibleComps.year]];
	}
	
	// Make days in next month to fill the remain cells.
	NSUInteger reserveYear = visibleComps.month == 12 ? visibleComps.year + 1 : visibleComps.year;
	NSUInteger reserveMonth = visibleComps.month == 12 ? 1 : visibleComps.month + 1;

	for (int j = 0; self.componentViews.count - pointer > 0; j++) {
		[self configureComponentView:self.componentViews[pointer++] withDate:[NSDate dateWithMonth:reserveMonth day:j + 1 year:reserveYear]];
	}
}
- (void)addConstraintToCenterIndicatorView:(UIView *)view toView:(UIView *)toView {
	[[self.contentWrapperView.constraints copy] enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.firstItem == view) {
			[self.contentWrapperView removeConstraint:obj];
		}
	}];
	
	[self.contentWrapperView addConstraint:[NSLayoutConstraint constraintWithItem:view
																		attribute:NSLayoutAttributeCenterX
																		relatedBy:NSLayoutRelationEqual
																		   toItem:toView
																		attribute:NSLayoutAttributeCenterX
																	   multiplier:1.0
																		 constant:0]];
	[self.contentWrapperView addConstraint:[NSLayoutConstraint constraintWithItem:view
																		attribute:NSLayoutAttributeCenterY
																		relatedBy:NSLayoutRelationEqual
																		   toItem:toView
																		attribute:NSLayoutAttributeCenterY
																	   multiplier:1.0
																		 constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:view
													 attribute:NSLayoutAttributeWidth
													 relatedBy:NSLayoutRelationEqual
														toItem:nil
													 attribute:NSLayoutAttributeNotAnAttribute
													multiplier:1.0
													  constant:self.indicatorRadius * 2]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:view
													 attribute:NSLayoutAttributeHeight
													 relatedBy:NSLayoutRelationEqual
														toItem:nil
													 attribute:NSLayoutAttributeNotAnAttribute
													multiplier:1.0
													  constant:self.indicatorRadius * 2]];
}
- (NSString *)navigationBarTitle {
	NSDateComponents *comps = [self.visibleDate components];
	return [NSString stringWithFormat:@"%ld年 %ld月", (long)comps.year, (long)comps.month];
}
#pragma mark - Actions


- (void)jumpToMonth:(NSDate *)date {
	BOOL direction;//yes往后,no往前
	direction = [date isLaterToDate:self.visibleDate];
	self.visibleDate = date;
	
	// Deal with indicator views.
	self.todayIndicatorView.hidden = YES;
	self.todayIndicatorView.attachingView = nil;
	self.selectedIndicatorView.attachingView = nil;
	
	self.titleBar.title = self.navigationBarTitle;
	
	
	__block UIView *snapshotView = [self.contentWrapperView snapshotViewAfterScreenUpdates:NO];
	snapshotView.frame = self.contentWrapperView.frame;
	[self addSubview:snapshotView];
	
	[self configureContentView];
	
	self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.frame) / 3 * (direction ? 1 : -1));
	self.contentView.alpha = 0;
	
	[UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.72 initialSpringVelocity:0 options:kNilOptions animations:^{
		snapshotView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.contentView.frame) / 2 * (direction ? 1 : -1));
		snapshotView.alpha = 0;
		
		self.selectedIndicatorView.transform = CGAffineTransformMakeScale(0, 0);
		
		self.contentView.transform = CGAffineTransformIdentity;
		self.contentView.alpha = 1;
	} completion:^(BOOL finished) {
		[snapshotView removeFromSuperview];
		
//		if (!self.date) {
			self.selectedIndicatorView.hidden = YES;
//		}
	}];
}
@end









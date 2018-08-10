//
//  PXDayView.m
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXDayView.h"
#import "PXIndicatorView.h"
@implementation PXDayView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self commonInit];
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self commonInit];
	}
	return self;
}
- (void)layoutSubviews {
	[super layoutSubviews];
	self.indicatorView.bounds = CGRectMake(0, 0, self.indicatorRadius * 2, self.indicatorRadius * 2);//用frame影响缩放
	self.indicatorView.PX_centerX = self.PX_width / 2;
	self.indicatorView.PX_centerY = self.PX_height / 2;
	self.textLabel.frame = self.bounds;
}
- (void)commonInit {
	_selected = NO;
	self.indicatorView = [PXIndicatorView new];
	self.indicatorView.hidden = YES;
	self.indicatorView.transform = CGAffineTransformMakeScale(0, 0);
	[self addSubview:self.indicatorView];
	self.textLabel = [[UILabel alloc] init];
	[self addSubview:self.textLabel];
	UITapGestureRecognizer *aRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
	[self addGestureRecognizer:aRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	_selected = selected;
	if (selected) {
		self.textLabel.textColor = self.highlightTextColor;
		self.indicatorView.color = self.selectedColor;
		self.indicatorView.hidden = NO;
		if (animated) {
			self.indicatorView.transform = CGAffineTransformMakeScale(0, 0);
			self.userInteractionEnabled = NO;
			[UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:kNilOptions animations:^{
				self.indicatorView.transform = CGAffineTransformIdentity;
			} completion:^(BOOL finished){
				if (!finished) {
					NSLog(@"%d",finished);
				}
				self.userInteractionEnabled = YES;
				self.indicatorView.hidden = NO;
			}];
		} else {
			self.indicatorView.transform = CGAffineTransformIdentity;
		}
	} else {
		self.textLabel.textColor = self.textColor;
		if (self.isToday && self.bold) {
			self.indicatorView.color = self.todayColor;
			self.indicatorView.transform = CGAffineTransformIdentity;
			self.indicatorView.hidden = NO;
		} else {
			if (animated) {
				self.userInteractionEnabled = NO;
				self.indicatorView.transform = CGAffineTransformIdentity;
				[UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:kNilOptions animations:^{
					self.indicatorView.transform = CGAffineTransformMakeScale(0, 0);
				} completion:^(BOOL finished) {
					if (!finished) {
						NSLog(@"%d",finished);
					}
					self.userInteractionEnabled = YES;
					self.indicatorView.hidden = YES;
				}];
			} else {
				self.indicatorView.hidden = YES;
			}
		}
	}
}
- (void)setSelected:(BOOL)selected {
	[self setSelected:selected animated:NO];
}
- (void)setTextColor:(UIColor *)textColor {
	_textColor = textColor;
//	self.selected = self.selected;
}
- (void)setTodayColor:(UIColor *)todayColor {
	_todayColor = todayColor;
//	self.selected = self.selected;
}
- (void)setBold:(BOOL)bold {
	_bold = bold;
	if (bold) {
		self.textLabel.font = [UIFont boldSystemFontOfSize:16];
		self.textLabel.alpha = 1.0;
	} else {
		self.textLabel.font = [UIFont systemFontOfSize:16];
		self.textLabel.alpha = 0.5;
	}
//	self.selected = self.selected;
}
- (void)setDate:(NSDate *)date {
	_date = date;
	self.isToday = [date isToday];
	NSDateComponents *dateComps = [date components];
	self.textLabel.text = [NSString stringWithFormat:@"%ld", (long)dateComps.day];
}
- (void)viewDidTap:(id)sender {
	self.dayDidTap(self);
}

@end

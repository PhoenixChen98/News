//
//  PXCalendarNavigationBar.m
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXTitleBar.h"

@implementation PXTitleBar

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
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
	[self.textLabel sizeToFit];
	self.textLabel.PX_centerX = self.PX_width / 2;
	self.textLabel.PX_centerY = self.PX_height / 2;
	self.lastButton.PX_size = CGSizeMake(30, 30);
	self.lastButton.PX_x = 16;
	self.lastButton.PX_centerY = self.PX_height / 2;
	self.nextButton.PX_size = CGSizeMake(30, 30);
	self.nextButton.PX_right = self.PX_width - 16;
	self.nextButton.PX_centerY = self.PX_height / 2;
	
}
- (void)commonInit {
	self.textLabel = [[UILabel alloc] init];

	self.textLabel.textColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
	self.textLabel.font = [UIFont systemFontOfSize:16];
	
	[self addSubview:self.textLabel];
	
	self.lastButton = [UIButton buttonWithType:UIButtonTypeCustom];

	self.lastButton.tintColor = [UIColor grayColor];
	[self.lastButton setBackgroundImage:[[UIImage imageNamed:@"last"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	[self.lastButton addTarget:self action:@selector(lastButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:self.lastButton];

	
	self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];

	self.nextButton.tintColor = [UIColor grayColor];
	[self.nextButton setBackgroundImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	[self.nextButton addTarget:self action:@selector(nextButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:self.nextButton];

}
- (void)setTitle:(NSString *)title {
	[UIView transitionWithView:self.textLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		self.textLabel.text = title;
		[self setNeedsLayout];
		[self layoutIfNeeded];
	} completion:nil];
}
-(NSString *)title {
	return self.textLabel.text;
}
- (void)lastButtonDidTap:(id)sender {
	self.lastMonth();
}

- (void)nextButtonDidTap:(id)sender {
	self.nextMonth();
}
@end

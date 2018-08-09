//
//  PXComponentView.m
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXComponentView.h"

@implementation PXComponentView

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
	self.textLabel.frame = self.bounds;
}
- (void)commonInit {
	self.textLabel = [[UILabel alloc] init];
	[self addSubview:self.textLabel];
	
	UITapGestureRecognizer *aRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
	[self addGestureRecognizer:aRecognizer];
}

- (void)setSelected:(BOOL)selected {
	_selected = selected;
	if (selected) {
		self.textLabel.textColor = self.highlightTextColor;
	}
	else {
		self.textLabel.textColor = self.textColor;
	}
}

- (void)viewDidTap:(id)sender {
	self.componentDidTap(self);
}

@end

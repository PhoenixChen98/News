//
//  PXIndicatorView.m
//  News
//
//  Created by Futu on 2018/8/8.
//  Copyright © 2018年 Futu. All rights reserved.
//

#import "PXIndicatorView.h"

@implementation PXIndicatorView
- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
	self.ellipseLayer = [CAShapeLayer layer];
	self.ellipseLayer.fillColor = self.color.CGColor;
	[self.layer addSublayer:self.ellipseLayer];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.ellipseLayer.path = CGPathCreateWithEllipseInRect(self.bounds, nil);
	self.ellipseLayer.frame = self.bounds;
}

- (void)setColor:(UIColor *)color {
	_color = color;
	self.ellipseLayer.fillColor = color.CGColor;
}
@end

//
//  UIView+Frame.m
//  BaiSi
//
//  Created by Phoenix on 2017/7/10.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setPX_x:(CGFloat)PX_x {
    CGRect rect = self.frame;
    rect.origin.x = PX_x;
    self.frame = rect;
}
- (CGFloat)PX_x {
    return self.frame.origin.x;
}

- (void)setPX_y:(CGFloat)PX_y {
    CGRect rect = self.frame;
    rect.origin.y = PX_y;
    self.frame = rect;
}
- (CGFloat)PX_y {
    return self.frame.origin.y;
}

- (void)setPX_width:(CGFloat)PX_width {
    CGRect rect = self.frame;
    rect.size.width = PX_width;
    self.frame = rect;
}
- (CGFloat)PX_width {
    return self.frame.size.width;
}

- (void)setPX_height:(CGFloat)PX_height {
    CGRect rect = self.frame;
    rect.size.height = PX_height;
    self.frame = rect;
}
- (CGFloat)PX_height {
    return self.frame.size.height;
}

- (void)setPX_centerX:(CGFloat)PX_centerX {
    CGPoint center = self.center;
    center.x = PX_centerX;
    self.center = center;
}
- (CGFloat)PX_centerX {
    return self.center.x;
}

- (void)setPX_centerY:(CGFloat)PX_centerY {
    CGPoint center = self.center;
    center.y = PX_centerY;
    self.center = center;
}
- (CGFloat)PX_centerY {
    return self.center.y;
}

- (CGFloat)PX_right
{
	return self.frame.origin.x + self.frame.size.width;
}
- (void)setPX_right:(CGFloat)PX_right
{
	CGRect frame = self.frame;
	frame.origin.x = PX_right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)PX_bottom
{
	return self.frame.origin.y + self.frame.size.height;
}
- (void)setPX_bottom:(CGFloat)PX_bottom
{
	CGRect frame = self.frame;
	frame.origin.y = PX_bottom - frame.size.height;
	self.frame = frame;
}
- (CGSize)PX_size {
	return self.frame.size;
}
- (void)setPX_size:(CGSize)PX_size {
	CGRect frame = self.frame;
	frame.size = PX_size;
	self.frame = frame;
}
@end
